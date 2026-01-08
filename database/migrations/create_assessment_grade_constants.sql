-- =====================================================
-- 평가 등급 상수 테이블 생성
-- =====================================================
-- 목적: 초기 평가 등급 체계 정의 (안정적, 무난함, 제한 있음, 준비 필요)
--      내부 점수 기준 저장
-- 작성일: 2024-01-XX
-- =====================================================

-- 1. 평가 등급 상수 테이블 생성
CREATE TABLE IF NOT EXISTS assessment_grade_constants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 등급 정보
  grade_code VARCHAR(20) NOT NULL UNIQUE, -- 'STABLE', 'NORMAL', 'LIMITED', 'PREPARE'
  grade_name_kr VARCHAR(50) NOT NULL, -- '안정적', '무난함', '제한 있음', '준비 필요'
  grade_name_en VARCHAR(50) NOT NULL, -- 'Stable', 'Normal', 'Limited', 'Prepare'
  
  -- 내부 점수
  internal_score INTEGER NOT NULL CHECK (internal_score >= 0 AND internal_score <= 100),
  
  -- 설명
  description TEXT,
  
  -- 메타데이터
  version VARCHAR(50) DEFAULT 'v1',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_assessment_grade_constants_code 
ON assessment_grade_constants(grade_code);

CREATE INDEX IF NOT EXISTS idx_assessment_grade_constants_active 
ON assessment_grade_constants(is_active) WHERE is_active = true;

-- 3. 코멘트 추가
COMMENT ON TABLE assessment_grade_constants IS 
'평가 등급 상수 테이블
초기 평가 등급 체계 정의 (안정적, 무난함, 제한 있음, 준비 필요)';

COMMENT ON COLUMN assessment_grade_constants.grade_code IS '등급 코드 (STABLE, NORMAL, LIMITED, PREPARE)';
COMMENT ON COLUMN assessment_grade_constants.grade_name_kr IS '등급명 (한국어)';
COMMENT ON COLUMN assessment_grade_constants.grade_name_en IS '등급명 (영어)';
COMMENT ON COLUMN assessment_grade_constants.internal_score IS '내부 점수 (0-100, UI 비노출, DB 계산용)';

-- 4. 초기 데이터 삽입 (문서 기준)
INSERT INTO assessment_grade_constants (grade_code, grade_name_kr, grade_name_en, internal_score, description) VALUES
('STABLE', '안정적', 'Stable', 80, '현재 강도로 문제 없음'),
('NORMAL', '무난함', 'Normal', 60, '시작 가능, 관리 필요'),
('LIMITED', '제한 있음', 'Limited', 40, '강도·볼륨 제한 필요'),
('PREPARE', '준비 필요', 'Prepare', 20, '접근 전략 우선');

-- 5. updated_at 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_assessment_grade_constants_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 6. 트리거 생성
CREATE TRIGGER trigger_update_assessment_grade_constants_updated_at
BEFORE UPDATE ON assessment_grade_constants
FOR EACH ROW
EXECUTE FUNCTION update_assessment_grade_constants_updated_at();

