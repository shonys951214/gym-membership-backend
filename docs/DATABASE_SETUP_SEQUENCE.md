# 데이터베이스 설정 순차 가이드

> **목적**: `create_full_schema.sql` 실행 후 데이터 추가를 위한 SQL 실행 순서

---

## 📋 실행 순서

### 1단계: 기본 스키마 생성 (이미 완료)

```sql
-- 전체 데이터베이스 스키마 생성
\i database/create_full_schema.sql
```

**확인 사항**:
- 모든 테이블이 생성되었는지 확인
- exercises 테이블이 생성되었는지 확인

---

### 2단계: exercises 테이블에 body_part 컬럼 추가

**파일**: `database/migrations/add_body_part_to_exercises.sql`

**실행**:
```sql
\i database/migrations/add_body_part_to_exercises.sql
```

**또는 psql**:
```bash
psql -U your_username -d your_database -f database/migrations/add_body_part_to_exercises.sql
```

**확인**:
```sql
-- body_part 컬럼이 추가되었는지 확인
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'exercises' AND column_name = 'body_part';
```

**결과 예시**:
```
 column_name | data_type | is_nullable
-------------+-----------+-------------
 body_part   | character varying(50) | YES
```

---

### 2-2단계: exercises 테이블의 name 컬럼을 nullable로 변경

**파일**: `database/migrations/make_exercises_name_nullable.sql`

**실행**:
```sql
\i database/migrations/make_exercises_name_nullable.sql
```

**또는 psql**:
```bash
psql -U your_username -d your_database -f database/migrations/make_exercises_name_nullable.sql
```

**확인**:
```sql
-- name 컬럼이 nullable인지 확인
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'exercises' AND column_name = 'name';
```

**결과 예시**:
```
 column_name | data_type | is_nullable
-------------+-----------+-------------
 name        | character varying(255) | YES
```

**주의**: 한글명이 없는 운동은 NULL로 저장되며, 나중에 수동으로 추가할 수 있습니다.

---

### 3단계: exercises 테이블에 name_en UNIQUE 제약조건 추가

**파일**: `database/migrations/add_unique_name_en_to_exercises.sql`

**실행**:
```sql
\i database/migrations/add_unique_name_en_to_exercises.sql
```

**또는 psql**:
```bash
psql -U your_username -d your_database -f database/migrations/add_unique_name_en_to_exercises.sql
```

**확인**:
```sql
-- UNIQUE 제약조건이 추가되었는지 확인
SELECT 
    conname AS constraint_name,
    contype AS constraint_type
FROM pg_constraint
WHERE conrelid = 'exercises'::regclass
    AND conname = 'unique_exercises_name_en';
```

**결과 예시**:
```
    constraint_name      | constraint_type
-------------------------+-----------------
 unique_exercises_name_en | u
```

**주의**: 
- 기존 데이터에 중복된 `name_en`이 있으면 오류 발생
- 중복 확인 쿼리:
  ```sql
  SELECT name_en, COUNT(*) 
  FROM exercises 
  GROUP BY name_en 
  HAVING COUNT(*) > 1;
  ```

---

### 4단계: exercises 테이블에 데이터 삽입

**파일**: `database/seeds/free_exercise_db_seed.sql`

**실행**:
```sql
\i database/seeds/free_exercise_db_seed.sql
```

**또는 psql**:
```bash
psql -U your_username -d your_database -f database/seeds/free_exercise_db_seed.sql
```

**예상 실행 시간**: 1-2분 (873개 운동)

**확인**:
```sql
-- 전체 운동 개수 확인
SELECT COUNT(*) as total_exercises FROM exercises;

-- 카테고리별 개수
SELECT category, COUNT(*) as count 
FROM exercises 
GROUP BY category 
ORDER BY category;

-- 부위별 개수
SELECT body_part, COUNT(*) as count 
FROM exercises 
WHERE body_part IS NOT NULL 
GROUP BY body_part 
ORDER BY body_part;

-- 활성화된 운동 개수
SELECT COUNT(*) as active_exercises 
FROM exercises 
WHERE is_active = true;

-- 샘플 데이터 확인
SELECT id, name, name_en, category, body_part, is_active
FROM exercises 
ORDER BY name_en
LIMIT 20;
```

**예상 결과**:
- 전체 운동 개수: 약 873개
- 카테고리별 분포:
  - UPPER: 상체 운동
  - LOWER: 하체 운동
  - FULL_BODY: 전신 운동
- 부위별 분포: 가슴, 등, 어깨, 팔, 하체 등

---

## 🔄 전체 실행 스크립트 (한 번에 실행)

모든 SQL을 한 번에 실행하려면:

```bash
# PostgreSQL에 연결
psql -U your_username -d your_database

# 또는 psql 프롬프트에서
```

```sql
-- 1. body_part 컬럼 추가
\i database/migrations/add_body_part_to_exercises.sql

-- 2. name_en UNIQUE 제약조건 추가
\i database/migrations/add_unique_name_en_to_exercises.sql

-- 3. 데이터 삽입
\i database/seeds/free_exercise_db_seed.sql

-- 4. 검증
SELECT COUNT(*) as total_exercises FROM exercises;
SELECT category, COUNT(*) FROM exercises GROUP BY category;
```

---

## ⚠️ 문제 해결

### 오류 1: "column body_part already exists"

**원인**: `body_part` 컬럼이 이미 존재함

**해결**: 
- 2단계를 건너뛰고 3단계로 진행
- 또는 마이그레이션 파일의 `IF NOT EXISTS` 구문이 작동했는지 확인

### 오류 2: "duplicate key value violates unique constraint"

**원인**: `name_en`에 중복된 값이 있음

**해결**:
1. 중복 확인:
   ```sql
   SELECT name_en, COUNT(*) 
   FROM exercises 
   GROUP BY name_en 
   HAVING COUNT(*) > 1;
   ```

2. 중복 제거 (선택적):
   ```sql
   -- 중복된 항목 중 하나만 남기고 나머지 삭제
   DELETE FROM exercises
   WHERE id NOT IN (
       SELECT MIN(id)
       FROM exercises
       GROUP BY name_en
   );
   ```

3. UNIQUE 제약조건 다시 추가:
   ```sql
   \i database/migrations/add_unique_name_en_to_exercises.sql
   ```

### 오류 3: "relation exercises does not exist"

**원인**: `exercises` 테이블이 생성되지 않음

**해결**:
1. `create_full_schema.sql`이 실행되었는지 확인
2. 테이블 목록 확인:
   ```sql
   SELECT table_name 
   FROM information_schema.tables 
   WHERE table_schema = 'public' 
   AND table_name = 'exercises';
   ```

### 오류 4: "syntax error at or near ON CONFLICT"

**원인**: PostgreSQL 버전이 낮거나 UNIQUE 제약조건이 없음

**해결**:
1. PostgreSQL 버전 확인:
   ```sql
   SELECT version();
   ```
   (PostgreSQL 9.5 이상 필요)

2. UNIQUE 제약조건 확인:
   ```sql
   SELECT conname 
   FROM pg_constraint 
   WHERE conrelid = 'exercises'::regclass 
   AND conname = 'unique_exercises_name_en';
   ```

---

## ✅ 완료 체크리스트

- [ ] `create_full_schema.sql` 실행 완료
- [ ] `add_body_part_to_exercises.sql` 실행 완료
- [ ] `add_unique_name_en_to_exercises.sql` 실행 완료
- [ ] `free_exercise_db_seed.sql` 실행 완료
- [ ] 데이터 검증 쿼리 실행 및 결과 확인
- [ ] 운동 개수 확인 (약 873개)
- [ ] 카테고리별 분포 확인
- [ ] 부위별 분포 확인

---

## 📝 다음 단계

Phase 0 완료 후:
- **Phase 6**: Strength Level 기준 데이터 수집 (strengthlevel.com)
- **Phase 2**: 초기 평가 세부항목 정의

---

**작성일**: 2026-01-16  
**상태**: Phase 0 작업 0-1, 0-2 완료, 작업 0-3 대기 중
