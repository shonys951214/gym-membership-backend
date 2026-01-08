-- =====================================================
-- assessment_items 필드 nullable 처리
-- =====================================================
-- 목적: value, unit, score 필드를 nullable로 변경
--      등급 기반 평가의 경우 수치값이 없을 수 있음
-- 작성일: 2024-01-XX
-- =====================================================

-- 1. value 필드를 nullable로 변경
ALTER TABLE assessment_items
ALTER COLUMN value DROP NOT NULL;

-- 2. unit 필드를 nullable로 변경
ALTER TABLE assessment_items
ALTER COLUMN unit DROP NOT NULL;

-- 3. score 필드를 nullable로 변경 (계산 전에는 null일 수 있음)
ALTER TABLE assessment_items
ALTER COLUMN score DROP NOT NULL;

-- 4. 코멘트 추가
COMMENT ON COLUMN assessment_items.value IS 
'측정값 (등급 기반 평가의 경우 null 가능)
예: 10 (회), 50 (kg), null (등급만 있는 경우)';

COMMENT ON COLUMN assessment_items.unit IS 
'단위 (value가 null이면 unit도 null)
예: "회", "kg", "분", null';

COMMENT ON COLUMN assessment_items.score IS 
'계산된 점수 (0-100)
등급 기반 평가의 경우 details.grade로부터 계산됨
계산 전에는 null일 수 있음';

