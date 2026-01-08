-- =====================================================
-- 평가 항목 상세 정보 필드 추가
-- =====================================================
-- 목적: assessment_items 테이블에 details JSONB 필드 추가
--      등급, 관찰 포인트, 대체 항목 정보 등을 저장
-- 작성일: 2024-01-XX
-- =====================================================

-- 1. assessment_items 테이블에 details 필드 추가
ALTER TABLE assessment_items
ADD COLUMN IF NOT EXISTS details JSONB DEFAULT NULL;

-- 2. details 필드에 대한 인덱스 추가 (GIN 인덱스 - JSONB 검색 최적화)
CREATE INDEX IF NOT EXISTS idx_assessment_items_details 
ON assessment_items USING GIN (details);

-- 3. 기존 데이터에 대한 기본값 설정 (필요시)
-- UPDATE assessment_items SET details = '{}'::jsonb WHERE details IS NULL;

-- 4. 코멘트 추가
COMMENT ON COLUMN assessment_items.details IS 
'평가 항목 상세 정보 (JSONB)
예시 구조:
{
  "grade": "A" | "B" | "C" | "D" | "D-1" | "D-2",
  "internalScore": 80,
  "isReplacement": false,
  "isImpossible": false,
  "weight": 0.4,
  "recoverySpeed": ["fast", "slow"],
  "flexibilityItems": {
    "sitAndReach": "A",
    "shoulder": "B",
    "hip": "C",
    "hamstring": "A"
  },
  "ohsa": "A" | "B" | "C",
  "pain": "none" | "present",
  "muscleMass": 45.2,
  "fatMass": 15.8,
  "bodyFatPercentage": 22.4,
  "observations": {
    "hipHinge": "good",
    "kneeTracking": "poor",
    "depth": "partial"
  },
  "leftRightDifference": {
    "left": 45,
    "right": 50
  }
}';

