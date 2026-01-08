-- =====================================================
-- 평가 시스템 DB 마이그레이션 통합 실행 스크립트
-- =====================================================
-- 목적: 모든 평가 관련 마이그레이션을 순서대로 실행
-- 작성일: 2024-01-XX
-- =====================================================

-- 실행 순서:
-- 1. assessment_items.details 필드 추가
-- 2. assessment_items 필드 nullable 처리
-- 3. 체성분 평가 기준표 생성
-- 4. 평가 등급 상수 테이블 생성
-- 5. 카테고리별 등급-점수 매핑 테이블 생성
-- 6. 유연성 항목별 가중치 테이블 생성

\echo '====================================================='
\echo '평가 시스템 DB 마이그레이션 시작'
\echo '====================================================='

\echo ''
\echo '1. assessment_items.details 필드 추가 중...'
\i database/migrations/add_assessment_items_details.sql

\echo ''
\echo '2. assessment_items 필드 nullable 처리 중...'
\i database/migrations/make_assessment_items_fields_nullable.sql

\echo ''
\echo '3. 체성분 평가 기준표 생성 중...'
\i database/migrations/create_body_composition_standards.sql

\echo ''
\echo '4. 평가 등급 상수 테이블 생성 중...'
\i database/migrations/create_assessment_grade_constants.sql

\echo ''
\echo '5. 카테고리별 등급-점수 매핑 테이블 생성 중...'
\i database/migrations/create_assessment_category_scores.sql

\echo ''
\echo '6. 유연성 항목별 가중치 테이블 생성 중...'
\i database/migrations/create_flexibility_weights.sql

\echo ''
\echo '====================================================='
\echo '평가 시스템 DB 마이그레이션 완료'
\echo '====================================================='

