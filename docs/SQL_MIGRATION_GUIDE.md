# SQL 마이그레이션 실행 가이드

## 📋 실행할 SQL 파일 목록

다음 SQL 파일들을 순서대로 실행하세요:

1. `database/create_workout_records_table.sql` - 운동 기록 테이블
2. `database/create_pt_sessions_table.sql` - PT 세션 테이블
3. `database/create_workout_routines_table.sql` - 추천 운동 루틴 테이블

---

## 실행 방법

### 방법 1: PostgreSQL CLI 사용

```bash
# 데이터베이스에 연결
psql -h localhost -U postgres -d gym_membership_db

# SQL 파일 실행
\i database/create_workout_records_table.sql
\i database/create_pt_sessions_table.sql
\i database/create_workout_routines_table.sql
```

### 방법 2: pgAdmin 또는 DBeaver 사용

1. 데이터베이스에 연결
2. 각 SQL 파일을 열어서 실행
3. 테이블 생성 확인

### 방법 3: Render 데이터베이스 (프로덕션)

1. Render 대시보드에서 데이터베이스 접속
2. SQL Editor에서 각 파일 내용 복사하여 실행
3. 또는 `psql` 명령어로 원격 접속하여 실행

---

## 테이블 생성 확인

각 SQL 파일 실행 후 다음 쿼리로 확인:

```sql
-- 테이블 목록 확인
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('workout_records', 'pt_sessions', 'workout_routines');

-- 각 테이블 구조 확인
\d workout_records
\d pt_sessions
\d workout_routines
```

---

## 예상 결과

### workout_records 테이블

- `id` (UUID, PK)
- `member_id` (UUID, FK)
- `workout_date` (DATE)
- `body_part` (VARCHAR)
- `exercise_name` (VARCHAR)
- `weight` (FLOAT)
- `reps` (INT)
- `sets` (INT)
- `volume` (FLOAT) - 자동 계산
- `workout_type` (ENUM: 'PT' | 'PERSONAL')
- `created_at`, `updated_at`

### pt_sessions 테이블

- `id` (UUID, PK)
- `member_id` (UUID, FK)
- `session_number` (INT) - 자동 계산
- `session_date` (DATE)
- `main_content` (TEXT)
- `trainer_comment` (TEXT, nullable)
- `created_at`, `updated_at`

### workout_routines 테이블

- `id` (UUID, PK)
- `member_id` (UUID, FK)
- `routine_date` (DATE)
- `exercises` (JSONB) - 운동 목록 배열
- `is_completed` (BOOLEAN)
- `created_at`, `updated_at`

---

## 주의사항

1. **외래키 제약조건**: `members` 테이블이 먼저 존재해야 합니다.
2. **인덱스**: 성능을 위해 인덱스가 자동 생성됩니다.
3. **JSONB 필드**: `workout_routines.exercises`는 JSONB 타입입니다.

---

## 문제 해결

### 오류: "relation 'members' does not exist"

- `members` 테이블이 먼저 생성되어 있어야 합니다.
- 기존 마이그레이션을 먼저 실행하세요.

### 오류: "column already exists"

- 테이블이 이미 생성되어 있을 수 있습니다.
- `DROP TABLE IF EXISTS` 후 재실행하거나, 기존 테이블 사용

---

**작성일**: 2026-01-07

