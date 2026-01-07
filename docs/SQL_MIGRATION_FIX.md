# SQL 마이그레이션 오류 해결 가이드

## 문제 상황

```
SQL Error [42710]: ERROR: constraint "chk_workout_type" for relation "workout_records" already exists
```

이 오류는 제약조건이 이미 존재하는데 다시 추가하려고 할 때 발생합니다.

---

## 해결 방법

### 방법 1: 수정된 SQL 파일 사용 (권장)

이미 수정된 SQL 파일들이 있습니다:

1. **`database/create_workout_records_table.sql`** - 제약조건 중복 추가 방지 로직 포함
2. **`database/add_workout_records_fields.sql`** - 기존 테이블에 새 필드 추가 (안전)
3. **`database/add_workout_routines_fields.sql`** - 기존 테이블에 새 필드 추가 (안전)

### 방법 2: 기존 테이블이 있는 경우

기존 테이블이 이미 생성되어 있다면, 다음 순서로 실행하세요:

#### 1단계: 운동 기록 테이블 필드 추가

```sql
-- database/add_workout_records_fields.sql 실행
\i database/add_workout_records_fields.sql
```

#### 2단계: 운동 루틴 테이블 필드 추가

```sql
-- database/add_workout_routines_fields.sql 실행
\i database/add_workout_routines_fields.sql
```

### 방법 3: 제약조건 수동 제거 후 재실행

제약조건을 제거하고 다시 추가하려면:

```sql
-- 제약조건 제거
ALTER TABLE workout_records 
DROP CONSTRAINT IF EXISTS chk_workout_type;

-- 다시 추가
ALTER TABLE workout_records
ADD CONSTRAINT chk_workout_type 
CHECK (workout_type IN ('PT', 'PERSONAL'));
```

---

## 실행 순서 (권장)

### 처음부터 시작하는 경우

1. `database/create_workout_records_table.sql`
2. `database/create_pt_sessions_table.sql`
3. `database/create_workout_routines_table.sql`

### 기존 테이블이 있는 경우

1. `database/add_workout_records_fields.sql` (새 필드만 추가)
2. `database/add_workout_routines_fields.sql` (새 필드만 추가)

---

## 확인 쿼리

### 제약조건 확인

```sql
SELECT 
    conname AS constraint_name,
    contype AS constraint_type
FROM pg_constraint
WHERE conrelid = 'workout_records'::regclass
    AND conname = 'chk_workout_type';
```

### 컬럼 확인

```sql
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'workout_records'
ORDER BY ordinal_position;
```

---

## 주의사항

1. **백업**: 마이그레이션 전에 데이터베이스 백업 권장
2. **순서**: SQL 파일을 순서대로 실행
3. **에러 처리**: `DO $$ ... END $$;` 블록을 사용하여 안전하게 처리

---

**작성일**: 2026-01-07

