# Phase 0 구현 가이드: 운동 기본 데이터 준비

## ✅ 완료된 작업

### 작업 0-1: free-exercise-db 데이터 다운로드 ✅
- **파일**: `exercises.json` (978KB, 873개 운동)
- **다운로드 위치**: 프로젝트 루트 디렉토리

### 작업 0-2: 필요한 운동만 필터링하여 변환 ✅
- **변환 스크립트**: `scripts/convert-free-exercise-db.ts`
- **생성된 SQL 파일**: `database/seeds/free_exercise_db_seed.sql`
- **변환된 운동 개수**: 873개
- **SQL 파일 크기**: 4,384줄

## ⏳ 다음 단계: 데이터베이스에 삽입

### 작업 0-3: exercises 테이블에 데이터 삽입

#### 1단계: UNIQUE 제약조건 추가 (필수)

`name_en`에 UNIQUE 제약조건을 추가해야 `ON CONFLICT`가 작동합니다.

**마이그레이션 파일**: `database/migrations/add_unique_name_en_to_exercises.sql`

**실행 방법**:
```sql
-- PostgreSQL에 연결 후
\i database/migrations/add_unique_name_en_to_exercises.sql
```

또는 psql 명령어:
```bash
psql -U your_username -d your_database -f database/migrations/add_unique_name_en_to_exercises.sql
```

#### 2단계: 데이터 삽입

**SQL 파일 실행**:
```sql
-- PostgreSQL에 연결 후
\i database/seeds/free_exercise_db_seed.sql
```

또는 psql 명령어:
```bash
psql -U your_username -d your_database -f database/seeds/free_exercise_db_seed.sql
```

#### 3단계: 데이터 검증

**검증 쿼리**:
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
SELECT id, name, name_en, category, body_part 
FROM exercises 
LIMIT 10;
```

**예상 결과**:
- 전체 운동 개수: 약 873개
- 카테고리별 분포:
  - UPPER: 상체 운동
  - LOWER: 하체 운동
  - FULL_BODY: 전신 운동
- 부위별 분포:
  - 가슴, 등, 어깨, 팔, 하체 등

## 주의사항

### 1. 중복 데이터 처리
- `ON CONFLICT (name_en) DO NOTHING`을 사용하여 중복 삽입 방지
- 이미 존재하는 운동은 건너뜀

### 2. 한글명 부재
- 일부 운동은 한글명이 없어 영문명을 그대로 사용
- 필요시 수동으로 한글명 추가 가능

### 3. body_part NULL 값
- 일부 운동은 `body_part`가 NULL일 수 있음
- 필요시 수동으로 부위 추가 가능

## 문제 해결

### UNIQUE 제약조건 오류
만약 `ON CONFLICT`가 작동하지 않는다면:
1. UNIQUE 제약조건이 추가되었는지 확인
2. 기존 데이터에 중복이 있는지 확인:
   ```sql
   SELECT name_en, COUNT(*) 
   FROM exercises 
   GROUP BY name_en 
   HAVING COUNT(*) > 1;
   ```

### 데이터 삽입 실패
- PostgreSQL 연결 확인
- 테이블이 존재하는지 확인
- 권한 확인

## 다음 Phase

Phase 0 완료 후:
- **Phase 6**: Strength Level 기준 데이터 수집 (strengthlevel.com)
- **Phase 2**: 초기 평가 세부항목 정의

---

**작성일**: 2026-01-16  
**상태**: 작업 0-1, 0-2 완료, 작업 0-3 대기 중
