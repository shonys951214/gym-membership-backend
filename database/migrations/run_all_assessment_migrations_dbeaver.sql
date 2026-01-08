-- =====================================================
-- 평가 시스템 DB 마이그레이션 통합 실행 스크립트 (DBeaver용)
-- =====================================================
-- 목적: 모든 평가 관련 마이그레이션을 순서대로 실행
-- 사용법: DBeaver에서 이 파일을 열고 전체 실행 (Ctrl+Alt+X 또는 F5)
-- 작성일: 2024-01-XX
-- =====================================================

-- =====================================================
-- 1. assessment_items.details 필드 추가
-- =====================================================

-- 1-1. assessment_items 테이블에 details 필드 추가
ALTER TABLE assessment_items
ADD COLUMN IF NOT EXISTS details JSONB DEFAULT NULL;

-- 1-2. details 필드에 대한 인덱스 추가 (GIN 인덱스 - JSONB 검색 최적화)
CREATE INDEX IF NOT EXISTS idx_assessment_items_details 
ON assessment_items USING GIN (details);

-- 1-3. 코멘트 추가
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

-- =====================================================
-- 2. assessment_items 필드 nullable 처리
-- =====================================================

-- 2-1. value 필드를 nullable로 변경
ALTER TABLE assessment_items
ALTER COLUMN value DROP NOT NULL;

-- 2-2. unit 필드를 nullable로 변경
ALTER TABLE assessment_items
ALTER COLUMN unit DROP NOT NULL;

-- 2-3. score 필드를 nullable로 변경 (계산 전에는 null일 수 있음)
ALTER TABLE assessment_items
ALTER COLUMN score DROP NOT NULL;

-- 2-4. 코멘트 추가
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

-- =====================================================
-- 3. 체성분 평가 기준표 생성
-- =====================================================

-- 3-1. 체성분 평가 기준표 테이블 생성
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

-- 3-2. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_body_composition_standards_gender_age 
ON body_composition_standards(gender, age_min, age_max);

CREATE INDEX IF NOT EXISTS idx_body_composition_standards_active 
ON body_composition_standards(is_active) WHERE is_active = true;

-- 3-3. 코멘트 추가
COMMENT ON TABLE body_composition_standards IS 
'체성분 평가 기준표
연령대별, 성별별 체지방률 적정 범위 및 골격근량 최소 기준을 저장';

COMMENT ON COLUMN body_composition_standards.gender IS '성별 (MALE, FEMALE)';
COMMENT ON COLUMN body_composition_standards.age_min IS '연령대 최소값 (포함)';
COMMENT ON COLUMN body_composition_standards.age_max IS '연령대 최대값 (포함)';
COMMENT ON COLUMN body_composition_standards.body_fat_percentage_min IS '체지방률 적정 범위 최소값 (%)';
COMMENT ON COLUMN body_composition_standards.body_fat_percentage_max IS '체지방률 적정 범위 최대값 (%)';
COMMENT ON COLUMN body_composition_standards.muscle_mass_percentage_min IS '골격근량 최소 기준 (%)';

-- 3-4. 초기 데이터 삽입 (문서 기준)
-- 남성 기준
INSERT INTO body_composition_standards (gender, age_min, age_max, body_fat_percentage_min, body_fat_percentage_max, muscle_mass_percentage_min) VALUES
('MALE', 20, 30, 10.00, 18.00, 42.00),
('MALE', 31, 40, 12.00, 20.00, 40.00),
('MALE', 41, 50, 15.00, 22.00, 38.00),
('MALE', 51, 999, 18.00, 25.00, 35.00)
ON CONFLICT (gender, age_min, age_max) DO NOTHING;

-- 여성 기준
INSERT INTO body_composition_standards (gender, age_min, age_max, body_fat_percentage_min, body_fat_percentage_max, muscle_mass_percentage_min) VALUES
('FEMALE', 20, 30, 18.00, 25.00, 32.00),
('FEMALE', 31, 40, 20.00, 28.00, 30.00),
('FEMALE', 41, 50, 23.00, 30.00, 28.00),
('FEMALE', 51, 999, 25.00, 33.00, 26.00)
ON CONFLICT (gender, age_min, age_max) DO NOTHING;

-- 3-5. updated_at 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_body_composition_standards_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 3-6. 트리거 생성
DROP TRIGGER IF EXISTS trigger_update_body_composition_standards_updated_at ON body_composition_standards;
CREATE TRIGGER trigger_update_body_composition_standards_updated_at
BEFORE UPDATE ON body_composition_standards
FOR EACH ROW
EXECUTE FUNCTION update_body_composition_standards_updated_at();

-- =====================================================
-- 4. 평가 등급 상수 테이블 생성
-- =====================================================

-- 4-1. 평가 등급 상수 테이블 생성
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

-- 4-2. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_assessment_grade_constants_code 
ON assessment_grade_constants(grade_code);

CREATE INDEX IF NOT EXISTS idx_assessment_grade_constants_active 
ON assessment_grade_constants(is_active) WHERE is_active = true;

-- 4-3. 코멘트 추가
COMMENT ON TABLE assessment_grade_constants IS 
'평가 등급 상수 테이블
초기 평가 등급 체계 정의 (안정적, 무난함, 제한 있음, 준비 필요)';

COMMENT ON COLUMN assessment_grade_constants.grade_code IS '등급 코드 (STABLE, NORMAL, LIMITED, PREPARE)';
COMMENT ON COLUMN assessment_grade_constants.grade_name_kr IS '등급명 (한국어)';
COMMENT ON COLUMN assessment_grade_constants.grade_name_en IS '등급명 (영어)';
COMMENT ON COLUMN assessment_grade_constants.internal_score IS '내부 점수 (0-100, UI 비노출, DB 계산용)';

-- 4-4. 초기 데이터 삽입 (문서 기준)
INSERT INTO assessment_grade_constants (grade_code, grade_name_kr, grade_name_en, internal_score, description) VALUES
('STABLE', '안정적', 'Stable', 80, '현재 강도로 문제 없음'),
('NORMAL', '무난함', 'Normal', 60, '시작 가능, 관리 필요'),
('LIMITED', '제한 있음', 'Limited', 40, '강도·볼륨 제한 필요'),
('PREPARE', '준비 필요', 'Prepare', 20, '접근 전략 우선')
ON CONFLICT (grade_code) DO NOTHING;

-- 4-5. updated_at 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_assessment_grade_constants_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 4-6. 트리거 생성
DROP TRIGGER IF EXISTS trigger_update_assessment_grade_constants_updated_at ON assessment_grade_constants;
CREATE TRIGGER trigger_update_assessment_grade_constants_updated_at
BEFORE UPDATE ON assessment_grade_constants
FOR EACH ROW
EXECUTE FUNCTION update_assessment_grade_constants_updated_at();

-- =====================================================
-- 5. 카테고리별 등급-점수 매핑 테이블 생성
-- =====================================================

-- 5-1. 카테고리별 등급-점수 매핑 테이블 생성
CREATE TABLE IF NOT EXISTS assessment_category_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 카테고리 정보
  category VARCHAR(50) NOT NULL CHECK (category IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'FLEXIBILITY', 'BODY', 'STABILITY')),
  
  -- 입력 등급 (UI에서 선택한 값)
  input_grade VARCHAR(20) NOT NULL, -- 'A', 'B', 'C', 'D', 'D-1', 'D-2', 'B+fast', 'B+slow' 등
  
  -- 추가 조건 (JSONB)
  conditions JSONB DEFAULT NULL, -- recoverySpeed, flexibilityItems, ohsa, pain 등
  
  -- 내부 점수
  internal_score INTEGER NOT NULL CHECK (internal_score >= 0 AND internal_score <= 100),
  
  -- 최종 등급 코드 (assessment_grade_constants 참조)
  final_grade_code VARCHAR(20) NOT NULL,
  
  -- 설명
  description TEXT,
  
  -- 메타데이터
  version VARCHAR(50) DEFAULT 'v1',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- 제약조건
  CONSTRAINT fk_final_grade_code 
    FOREIGN KEY (final_grade_code) 
    REFERENCES assessment_grade_constants(grade_code)
);

-- 5-2. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_assessment_category_scores_category 
ON assessment_category_scores(category);

CREATE INDEX IF NOT EXISTS idx_assessment_category_scores_input_grade 
ON assessment_category_scores(input_grade);

CREATE INDEX IF NOT EXISTS idx_assessment_category_scores_conditions 
ON assessment_category_scores USING GIN (conditions);

CREATE INDEX IF NOT EXISTS idx_assessment_category_scores_active 
ON assessment_category_scores(is_active) WHERE is_active = true;

-- 5-3. 코멘트 추가
COMMENT ON TABLE assessment_category_scores IS 
'카테고리별 등급-점수 매핑 테이블
각 카테고리(하체 근력, 심폐 지구력 등)별 입력 등급에 대한 내부 점수 정의';

COMMENT ON COLUMN assessment_category_scores.category IS '카테고리 (STRENGTH, CARDIO, ENDURANCE, FLEXIBILITY, BODY, STABILITY)';
COMMENT ON COLUMN assessment_category_scores.input_grade IS '입력 등급 (UI에서 선택한 값: A, B, C, D, D-1, D-2 등)';
COMMENT ON COLUMN assessment_category_scores.conditions IS '추가 조건 (JSONB)
예: {"recoverySpeed": ["fast"]}, {"ohsa": "B", "pain": "present"} 등';
COMMENT ON COLUMN assessment_category_scores.internal_score IS '내부 점수 (0-100, UI 비노출)';
COMMENT ON COLUMN assessment_category_scores.final_grade_code IS '최종 등급 코드 (STABLE, NORMAL, LIMITED, PREPARE)';

-- 5-4. 초기 데이터 삽입 (문서 기준)

-- 하체 근력 (STRENGTH)
INSERT INTO assessment_category_scores (category, input_grade, conditions, internal_score, final_grade_code, description) VALUES
('STRENGTH', 'A', NULL, 80, 'STABLE', '안정적으로 반복 수행'),
('STRENGTH', 'B', NULL, 60, 'NORMAL', '수행 가능, 깊이·정렬 일부 제한'),
('STRENGTH', 'C', NULL, 45, 'LIMITED', '수행 가능하나 불안정 / 연속 어려움'),
('STRENGTH', 'D-1', NULL, 30, 'LIMITED', '체어/박스 스쿼트 가능'),
('STRENGTH', 'D-2', NULL, 20, 'PREPARE', '보조 있어도 어려움')
ON CONFLICT DO NOTHING;

-- 심폐 지구력 (CARDIO)
INSERT INTO assessment_category_scores (category, input_grade, conditions, internal_score, final_grade_code, description) VALUES
('CARDIO', 'A', NULL, 80, 'STABLE', '리듬 유지 + 완주'),
('CARDIO', 'B', '{"recoverySpeed": ["fast"]}', 65, 'NORMAL', '리듬 유지 + 회복 빠름'),
('CARDIO', 'B', '{"recoverySpeed": ["slow"]}', 55, 'NORMAL', '리듬 유지 + 회복 느림'),
('CARDIO', 'C', NULL, 40, 'LIMITED', '조기 중단 / 리듬 붕괴'),
('CARDIO', 'IMPOSSIBLE', NULL, 20, 'PREPARE', '테스트 거의 불가')
ON CONFLICT DO NOTHING;

-- 근지구력 (ENDURANCE)
INSERT INTO assessment_category_scores (category, input_grade, conditions, internal_score, final_grade_code, description) VALUES
('ENDURANCE', 'A', NULL, 80, 'STABLE', '자세 안정, 흔들림 거의 없음'),
('ENDURANCE', 'B', NULL, 60, 'NORMAL', '유지 가능하나 흔들림 있음'),
('ENDURANCE', 'C', NULL, 40, 'LIMITED', '빠른 붕괴 / 중단'),
('ENDURANCE', 'IMPOSSIBLE', NULL, 20, 'PREPARE', '거의 유지 불가')
ON CONFLICT DO NOTHING;

-- 안정성 (STABILITY)
INSERT INTO assessment_category_scores (category, input_grade, conditions, internal_score, final_grade_code, description) VALUES
('STABILITY', 'A', '{"pain": "none"}', 80, 'STABLE', 'OHSA A + 통증 없음'),
('STABILITY', 'B', '{"pain": "none"}', 60, 'NORMAL', 'OHSA B + 통증 없음'),
('STABILITY', 'C', '{"pain": "none"}', 40, 'LIMITED', 'OHSA C + 통증 없음'),
('STABILITY', 'A', '{"pain": "present"}', 50, 'LIMITED', 'OHSA A + 통증 있음'),
('STABILITY', 'B', '{"pain": "present"}', 45, 'LIMITED', 'OHSA B + 통증 있음'),
('STABILITY', 'C', '{"pain": "present"}', 20, 'PREPARE', 'OHSA C + 통증 있음')
ON CONFLICT DO NOTHING;

-- 5-5. updated_at 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_assessment_category_scores_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 5-6. 트리거 생성
DROP TRIGGER IF EXISTS trigger_update_assessment_category_scores_updated_at ON assessment_category_scores;
CREATE TRIGGER trigger_update_assessment_category_scores_updated_at
BEFORE UPDATE ON assessment_category_scores
FOR EACH ROW
EXECUTE FUNCTION update_assessment_category_scores_updated_at();

-- =====================================================
-- 6. 유연성 항목별 가중치 테이블 생성
-- =====================================================

-- 6-1. 유연성 항목별 가중치 테이블 생성
CREATE TABLE IF NOT EXISTS flexibility_item_weights (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 항목 정보
  item_name VARCHAR(100) NOT NULL UNIQUE, -- 'shoulder', 'hip', 'sitAndReach', 'hamstring'
  item_name_kr VARCHAR(100) NOT NULL, -- '어깨 가동성', '고관절 가동성', '좌전굴', '햄스트링'
  
  -- 가중치
  weight DECIMAL(5, 2) NOT NULL CHECK (weight > 0),
  
  -- 중요도 설명
  importance VARCHAR(50), -- '중요', '기준', '보조'
  
  -- 메타데이터
  version VARCHAR(50) DEFAULT 'v1',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6-2. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_flexibility_item_weights_item_name 
ON flexibility_item_weights(item_name);

CREATE INDEX IF NOT EXISTS idx_flexibility_item_weights_active 
ON flexibility_item_weights(is_active) WHERE is_active = true;

-- 6-3. 코멘트 추가
COMMENT ON TABLE flexibility_item_weights IS 
'유연성 항목별 가중치 테이블
유연성 평가 항목별 중요도 가중치 정의';

COMMENT ON COLUMN flexibility_item_weights.item_name IS '항목명 (영어)';
COMMENT ON COLUMN flexibility_item_weights.item_name_kr IS '항목명 (한국어)';
COMMENT ON COLUMN flexibility_item_weights.weight IS '가중치 (어깨 1.3, 고관절 1.2, 좌전굴 1.0, 햄스트링 0.8)';
COMMENT ON COLUMN flexibility_item_weights.importance IS '중요도 (중요, 기준, 보조)';

-- 6-4. 초기 데이터 삽입 (문서 기준)
INSERT INTO flexibility_item_weights (item_name, item_name_kr, weight, importance) VALUES
('shoulder', '어깨 가동성', 1.30, '중요'),
('hip', '고관절 가동성', 1.20, '중요'),
('sitAndReach', '좌전굴', 1.00, '기준'),
('hamstring', '햄스트링', 0.80, '보조')
ON CONFLICT (item_name) DO NOTHING;

-- 6-5. 유연성 등급 판정 기준 테이블 생성
CREATE TABLE IF NOT EXISTS flexibility_grade_thresholds (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- 가중치 합 범위
  weight_sum_min DECIMAL(5, 2) NOT NULL,
  weight_sum_max DECIMAL(5, 2) NOT NULL CHECK (weight_sum_max >= weight_sum_min),
  
  -- 최종 등급 코드
  final_grade_code VARCHAR(20) NOT NULL,
  
  -- 내부 점수
  internal_score INTEGER NOT NULL CHECK (internal_score >= 0 AND internal_score <= 100),
  
  -- 메타데이터
  version VARCHAR(50) DEFAULT 'v1',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- 제약조건
  CONSTRAINT fk_flexibility_grade_code 
    FOREIGN KEY (final_grade_code) 
    REFERENCES assessment_grade_constants(grade_code)
);

-- 6-6. 유연성 등급 판정 기준 인덱스
CREATE INDEX IF NOT EXISTS idx_flexibility_grade_thresholds_active 
ON flexibility_grade_thresholds(is_active) WHERE is_active = true;

-- 6-7. 유연성 등급 판정 기준 코멘트
COMMENT ON TABLE flexibility_grade_thresholds IS 
'유연성 등급 판정 기준 테이블
가중치 합에 따른 최종 등급 및 내부 점수 정의';

COMMENT ON COLUMN flexibility_grade_thresholds.weight_sum_min IS '가중치 합 최소값';
COMMENT ON COLUMN flexibility_grade_thresholds.weight_sum_max IS '가중치 합 최대값';
COMMENT ON COLUMN flexibility_grade_thresholds.final_grade_code IS '최종 등급 코드 (STABLE, NORMAL, LIMITED, PREPARE)';
COMMENT ON COLUMN flexibility_grade_thresholds.internal_score IS '내부 점수 (0-100)';

-- 6-8. 유연성 등급 판정 기준 초기 데이터 삽입 (문서 기준)
INSERT INTO flexibility_grade_thresholds (weight_sum_min, weight_sum_max, final_grade_code, internal_score) VALUES
(0.00, 0.00, 'STABLE', 80),      -- 가중치 합 0 (C 없음)
(1.00, 1.50, 'NORMAL', 60),      -- 가중치 합 1.0~1.5
(1.60, 2.50, 'LIMITED', 40),    -- 가중치 합 1.6~2.5
(2.60, 999.99, 'PREPARE', 20)   -- 가중치 합 2.6 이상
ON CONFLICT DO NOTHING;

-- 6-9. updated_at 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_flexibility_weights_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 6-10. 트리거 생성
DROP TRIGGER IF EXISTS trigger_update_flexibility_item_weights_updated_at ON flexibility_item_weights;
DROP TRIGGER IF EXISTS trigger_update_flexibility_grade_thresholds_updated_at ON flexibility_grade_thresholds;

CREATE TRIGGER trigger_update_flexibility_item_weights_updated_at
BEFORE UPDATE ON flexibility_item_weights
FOR EACH ROW
EXECUTE FUNCTION update_flexibility_weights_updated_at();

CREATE TRIGGER trigger_update_flexibility_grade_thresholds_updated_at
BEFORE UPDATE ON flexibility_grade_thresholds
FOR EACH ROW
EXECUTE FUNCTION update_flexibility_weights_updated_at();

-- =====================================================
-- 마이그레이션 완료
-- =====================================================
-- 생성된 테이블:
-- 1. assessment_items (details 필드 추가됨)
-- 2. body_composition_standards
-- 3. assessment_grade_constants
-- 4. assessment_category_scores
-- 5. flexibility_item_weights
-- 6. flexibility_grade_thresholds
-- =====================================================

