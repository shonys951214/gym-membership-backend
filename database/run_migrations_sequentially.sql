-- ============================================
-- 데이터베이스 마이그레이션 순차 실행 스크립트
-- create_full_schema.sql 실행 후 이 스크립트를 실행하세요
-- ============================================

-- ============================================
-- 1단계: exercises 테이블에 body_part 컬럼 추가
-- ============================================
\echo '1단계: body_part 컬럼 추가 중...'
\i database/migrations/add_body_part_to_exercises.sql

-- ============================================
-- 1-2단계: exercises 테이블의 name 컬럼을 nullable로 변경
-- ============================================
\echo '1-2단계: name 컬럼을 nullable로 변경 중...'
\i database/migrations/make_exercises_name_nullable.sql

-- ============================================
-- 2단계: exercises 테이블에 name_en UNIQUE 제약조건 추가
-- ============================================
\echo '2단계: name_en UNIQUE 제약조건 추가 중...'
\i database/migrations/add_unique_name_en_to_exercises.sql

-- ============================================
-- 3단계: exercises 테이블에 데이터 삽입
-- ============================================
\echo '3단계: exercises 데이터 삽입 중... (약 1-2분 소요)'
\i database/seeds/free_exercise_db_seed.sql

-- ============================================
-- 4단계: 데이터 검증
-- ============================================
\echo '4단계: 데이터 검증 중...'

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

\echo '✅ 모든 마이그레이션이 완료되었습니다!'
