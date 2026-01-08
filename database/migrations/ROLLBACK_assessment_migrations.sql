-- =====================================================
-- 평가 시스템 DB 마이그레이션 롤백 스크립트
-- =====================================================
-- 목적: 모든 평가 관련 마이그레이션을 역순으로 롤백
-- 주의: 데이터 손실 가능성이 있으므로 신중하게 실행
-- 작성일: 2024-01-XX
-- =====================================================

\echo '====================================================='
\echo '평가 시스템 DB 마이그레이션 롤백 시작'
\echo '⚠️ 주의: 데이터 손실 가능성이 있습니다.'
\echo '====================================================='

-- 롤백 순서 (생성 순서의 역순):
-- 6. 유연성 항목별 가중치 테이블 삭제
-- 5. 카테고리별 등급-점수 매핑 테이블 삭제
-- 4. 평가 등급 상수 테이블 삭제
-- 3. 체성분 평가 기준표 삭제
-- 2. assessment_items 필드 nullable 복원 (선택적)
-- 1. assessment_items.details 필드 제거 (선택적)

\echo ''
\echo '6. 유연성 항목별 가중치 테이블 삭제 중...'
DROP TRIGGER IF EXISTS trigger_update_flexibility_grade_thresholds_updated_at ON flexibility_grade_thresholds;
DROP TRIGGER IF EXISTS trigger_update_flexibility_item_weights_updated_at ON flexibility_item_weights;
DROP FUNCTION IF EXISTS update_flexibility_weights_updated_at();
DROP TABLE IF EXISTS flexibility_grade_thresholds CASCADE;
DROP TABLE IF EXISTS flexibility_item_weights CASCADE;

\echo ''
\echo '5. 카테고리별 등급-점수 매핑 테이블 삭제 중...'
DROP TRIGGER IF EXISTS trigger_update_assessment_category_scores_updated_at ON assessment_category_scores;
DROP FUNCTION IF EXISTS update_assessment_category_scores_updated_at();
DROP TABLE IF EXISTS assessment_category_scores CASCADE;

\echo ''
\echo '4. 평가 등급 상수 테이블 삭제 중...'
DROP TRIGGER IF EXISTS trigger_update_assessment_grade_constants_updated_at ON assessment_grade_constants;
DROP FUNCTION IF EXISTS update_assessment_grade_constants_updated_at();
DROP TABLE IF EXISTS assessment_grade_constants CASCADE;

\echo ''
\echo '3. 체성분 평가 기준표 삭제 중...'
DROP TRIGGER IF EXISTS trigger_update_body_composition_standards_updated_at ON body_composition_standards;
DROP FUNCTION IF EXISTS update_body_composition_standards_updated_at();
DROP TABLE IF EXISTS body_composition_standards CASCADE;

\echo ''
\echo '2. assessment_items 필드 nullable 복원 중... (선택적)'
-- 주의: 기존 데이터에 null이 있을 수 있으므로 신중하게 실행
-- ALTER TABLE assessment_items ALTER COLUMN value SET NOT NULL;
-- ALTER TABLE assessment_items ALTER COLUMN unit SET NOT NULL;
-- ALTER TABLE assessment_items ALTER COLUMN score SET NOT NULL;

\echo ''
\echo '1. assessment_items.details 필드 제거 중... (선택적)'
-- 주의: details 필드에 저장된 데이터가 손실됩니다.
-- DROP INDEX IF EXISTS idx_assessment_items_details;
-- ALTER TABLE assessment_items DROP COLUMN IF EXISTS details;

\echo ''
\echo '====================================================='
\echo '평가 시스템 DB 마이그레이션 롤백 완료'
\echo '====================================================='

