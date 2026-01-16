-- ============================================
-- strength_standards 테이블에 standard_type, age_min, age_max 필드 추가
-- ============================================
-- 생성일: 2026-01-16
-- 설명: 
-- 1. standard_type: 기준 타입 구분 ('BODYWEIGHT' | 'AGE')
-- 2. age_min, age_max: 나이별 Strength Level 기준 데이터를 저장하기 위한 필드

-- 표준 타입 컬럼 추가
ALTER TABLE strength_standards 
ADD COLUMN IF NOT EXISTS standard_type VARCHAR(20) NOT NULL DEFAULT 'BODYWEIGHT';

-- 나이 최소값, 최대값 컬럼 추가 (nullable - 체중별 데이터는 NULL)
ALTER TABLE strength_standards 
ADD COLUMN IF NOT EXISTS age_min INTEGER,
ADD COLUMN IF NOT EXISTS age_max INTEGER;

-- 표준 타입 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_strength_standards_standard_type ON strength_standards(standard_type);

-- 나이 관련 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_strength_standards_age ON strength_standards(age_min, age_max);

-- 복합 인덱스 업데이트 (standard_type, 나이 포함)
DROP INDEX IF EXISTS idx_strength_standards_lookup;
CREATE INDEX IF NOT EXISTS idx_strength_standards_lookup 
ON strength_standards(exercise_id, gender, level, standard_type, bodyweight_min, bodyweight_max, age_min, age_max);

-- 주석 추가
COMMENT ON COLUMN strength_standards.standard_type IS '기준 타입: BODYWEIGHT(체중별), AGE(나이별)';
COMMENT ON COLUMN strength_standards.age_min IS '나이 최소값 (예: 15)';
COMMENT ON COLUMN strength_standards.age_max IS '나이 최대값 (예: 19)';
