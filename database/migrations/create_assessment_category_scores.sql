-- =====================================================
-- 카테고리별 등급-점수 매핑 테이블 생성
-- =====================================================
-- 목적: 각 카테고리별 등급에 대한 내부 점수 정의
--      하체 근력, 심폐 지구력 등 카테고리별 세부 점수 저장
-- 작성일: 2024-01-XX
-- =====================================================

-- 1. 카테고리별 등급-점수 매핑 테이블 생성
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

-- 2. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_assessment_category_scores_category 
ON assessment_category_scores(category);

CREATE INDEX IF NOT EXISTS idx_assessment_category_scores_input_grade 
ON assessment_category_scores(input_grade);

CREATE INDEX IF NOT EXISTS idx_assessment_category_scores_conditions 
ON assessment_category_scores USING GIN (conditions);

CREATE INDEX IF NOT EXISTS idx_assessment_category_scores_active 
ON assessment_category_scores(is_active) WHERE is_active = true;

-- 3. 코멘트 추가
COMMENT ON TABLE assessment_category_scores IS 
'카테고리별 등급-점수 매핑 테이블
각 카테고리(하체 근력, 심폐 지구력 등)별 입력 등급에 대한 내부 점수 정의';

COMMENT ON COLUMN assessment_category_scores.category IS '카테고리 (STRENGTH, CARDIO, ENDURANCE, FLEXIBILITY, BODY, STABILITY)';
COMMENT ON COLUMN assessment_category_scores.input_grade IS '입력 등급 (UI에서 선택한 값: A, B, C, D, D-1, D-2 등)';
COMMENT ON COLUMN assessment_category_scores.conditions IS '추가 조건 (JSONB)
예: {"recoverySpeed": ["fast"]}, {"ohsa": "B", "pain": "present"} 등';
COMMENT ON COLUMN assessment_category_scores.internal_score IS '내부 점수 (0-100, UI 비노출)';
COMMENT ON COLUMN assessment_category_scores.final_grade_code IS '최종 등급 코드 (STABLE, NORMAL, LIMITED, PREPARE)';

-- 4. 초기 데이터 삽입 (문서 기준)

-- 하체 근력 (STRENGTH)
INSERT INTO assessment_category_scores (category, input_grade, conditions, internal_score, final_grade_code, description) VALUES
('STRENGTH', 'A', NULL, 80, 'STABLE', '안정적으로 반복 수행'),
('STRENGTH', 'B', NULL, 60, 'NORMAL', '수행 가능, 깊이·정렬 일부 제한'),
('STRENGTH', 'C', NULL, 45, 'LIMITED', '수행 가능하나 불안정 / 연속 어려움'),
('STRENGTH', 'D-1', NULL, 30, 'LIMITED', '체어/박스 스쿼트 가능'),
('STRENGTH', 'D-2', NULL, 20, 'PREPARE', '보조 있어도 어려움');

-- 심폐 지구력 (CARDIO)
INSERT INTO assessment_category_scores (category, input_grade, conditions, internal_score, final_grade_code, description) VALUES
('CARDIO', 'A', NULL, 80, 'STABLE', '리듬 유지 + 완주'),
('CARDIO', 'B', '{"recoverySpeed": ["fast"]}', 65, 'NORMAL', '리듬 유지 + 회복 빠름'),
('CARDIO', 'B', '{"recoverySpeed": ["slow"]}', 55, 'NORMAL', '리듬 유지 + 회복 느림'),
('CARDIO', 'C', NULL, 40, 'LIMITED', '조기 중단 / 리듬 붕괴'),
('CARDIO', 'IMPOSSIBLE', NULL, 20, 'PREPARE', '테스트 거의 불가');

-- 근지구력 (ENDURANCE)
INSERT INTO assessment_category_scores (category, input_grade, conditions, internal_score, final_grade_code, description) VALUES
('ENDURANCE', 'A', NULL, 80, 'STABLE', '자세 안정, 흔들림 거의 없음'),
('ENDURANCE', 'B', NULL, 60, 'NORMAL', '유지 가능하나 흔들림 있음'),
('ENDURANCE', 'C', NULL, 40, 'LIMITED', '빠른 붕괴 / 중단'),
('ENDURANCE', 'IMPOSSIBLE', NULL, 20, 'PREPARE', '거의 유지 불가');

-- 안정성 (STABILITY)
INSERT INTO assessment_category_scores (category, input_grade, conditions, internal_score, final_grade_code, description) VALUES
('STABILITY', 'A', '{"pain": "none"}', 80, 'STABLE', 'OHSA A + 통증 없음'),
('STABILITY', 'B', '{"pain": "none"}', 60, 'NORMAL', 'OHSA B + 통증 없음'),
('STABILITY', 'C', '{"pain": "none"}', 40, 'LIMITED', 'OHSA C + 통증 없음'),
('STABILITY', 'A', '{"pain": "present"}', 50, 'LIMITED', 'OHSA A + 통증 있음'),
('STABILITY', 'B', '{"pain": "present"}', 45, 'LIMITED', 'OHSA B + 통증 있음'),
('STABILITY', 'C', '{"pain": "present"}', 20, 'PREPARE', 'OHSA C + 통증 있음');

-- 5. updated_at 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_assessment_category_scores_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 6. 트리거 생성
CREATE TRIGGER trigger_update_assessment_category_scores_updated_at
BEFORE UPDATE ON assessment_category_scores
FOR EACH ROW
EXECUTE FUNCTION update_assessment_category_scores_updated_at();

