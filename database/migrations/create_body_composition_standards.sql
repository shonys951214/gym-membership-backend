-- =====================================================
-- 체성분 평가 기준표 테이블 생성
-- =====================================================
-- 목적: 연령대별, 성별별 체성분 평가 기준 저장
--      체성분 점수 계산 시 참조
-- 작성일: 2024-01-XX
-- =====================================================

-- 1. 체성분 평가 기준표 테이블 생성
CREATE TABLE IF NOT EXISTS body_composition_standards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 기준 정보
  gender VARCHAR(10) NOT NULL CHECK (gender IN ('MALE', 'FEMALE')),
  age_min INTEGER NOT NULL CHECK (age_min >= 0),
  age_max INTEGER NOT NULL CHECK (age_max >= age_min),
  
  -- 체지방률 기준 (적정 범위)
  body_fat_percentage_min DECIMAL(5, 2) NOT NULL,
  body_fat_percentage_max DECIMAL(5, 2) NOT NULL CHECK (body_fat_percentage_max >= body_fat_percentage_min),
  
  -- 골격근량 기준 (최소값)
  muscle_mass_percentage_min DECIMAL(5, 2) NOT NULL,
  
  -- 메타데이터
  version VARCHAR(50) DEFAULT 'v1',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- 제약조건
  CONSTRAINT unique_gender_age_range UNIQUE (gender, age_min, age_max)
);

-- 2. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_body_composition_standards_gender_age 
ON body_composition_standards(gender, age_min, age_max);

CREATE INDEX IF NOT EXISTS idx_body_composition_standards_active 
ON body_composition_standards(is_active) WHERE is_active = true;

-- 3. 코멘트 추가
COMMENT ON TABLE body_composition_standards IS 
'체성분 평가 기준표
연령대별, 성별별 체지방률 적정 범위 및 골격근량 최소 기준을 저장';

COMMENT ON COLUMN body_composition_standards.gender IS '성별 (MALE, FEMALE)';
COMMENT ON COLUMN body_composition_standards.age_min IS '연령대 최소값 (포함)';
COMMENT ON COLUMN body_composition_standards.age_max IS '연령대 최대값 (포함)';
COMMENT ON COLUMN body_composition_standards.body_fat_percentage_min IS '체지방률 적정 범위 최소값 (%)';
COMMENT ON COLUMN body_composition_standards.body_fat_percentage_max IS '체지방률 적정 범위 최대값 (%)';
COMMENT ON COLUMN body_composition_standards.muscle_mass_percentage_min IS '골격근량 최소 기준 (%)';

-- 4. 초기 데이터 삽입 (문서 기준)
-- 남성 기준
INSERT INTO body_composition_standards (gender, age_min, age_max, body_fat_percentage_min, body_fat_percentage_max, muscle_mass_percentage_min) VALUES
('MALE', 20, 30, 10.00, 18.00, 42.00),
('MALE', 31, 40, 12.00, 20.00, 40.00),
('MALE', 41, 50, 15.00, 22.00, 38.00),
('MALE', 51, 999, 18.00, 25.00, 35.00);

-- 여성 기준
INSERT INTO body_composition_standards (gender, age_min, age_max, body_fat_percentage_min, body_fat_percentage_max, muscle_mass_percentage_min) VALUES
('FEMALE', 20, 30, 18.00, 25.00, 32.00),
('FEMALE', 31, 40, 20.00, 28.00, 30.00),
('FEMALE', 41, 50, 23.00, 30.00, 28.00),
('FEMALE', 51, 999, 25.00, 33.00, 26.00);

-- 5. updated_at 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_body_composition_standards_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 6. 트리거 생성
CREATE TRIGGER trigger_update_body_composition_standards_updated_at
BEFORE UPDATE ON body_composition_standards
FOR EACH ROW
EXECUTE FUNCTION update_body_composition_standards_updated_at();

