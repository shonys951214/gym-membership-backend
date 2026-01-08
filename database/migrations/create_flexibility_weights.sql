-- =====================================================
-- 유연성 항목별 가중치 테이블 생성
-- =====================================================
-- 목적: 유연성 평가 항목별 중요도 가중치 정의
--      유연성 점수 계산 시 사용
-- 작성일: 2024-01-XX
-- =====================================================

-- 1. 유연성 항목별 가중치 테이블 생성
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

-- 2. 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_flexibility_item_weights_item_name 
ON flexibility_item_weights(item_name);

CREATE INDEX IF NOT EXISTS idx_flexibility_item_weights_active 
ON flexibility_item_weights(is_active) WHERE is_active = true;

-- 3. 코멘트 추가
COMMENT ON TABLE flexibility_item_weights IS 
'유연성 항목별 가중치 테이블
유연성 평가 항목별 중요도 가중치 정의';

COMMENT ON COLUMN flexibility_item_weights.item_name IS '항목명 (영어)';
COMMENT ON COLUMN flexibility_item_weights.item_name_kr IS '항목명 (한국어)';
COMMENT ON COLUMN flexibility_item_weights.weight IS '가중치 (어깨 1.3, 고관절 1.2, 좌전굴 1.0, 햄스트링 0.8)';
COMMENT ON COLUMN flexibility_item_weights.importance IS '중요도 (중요, 기준, 보조)';

-- 4. 초기 데이터 삽입 (문서 기준)
INSERT INTO flexibility_item_weights (item_name, item_name_kr, weight, importance) VALUES
('shoulder', '어깨 가동성', 1.30, '중요'),
('hip', '고관절 가동성', 1.20, '중요'),
('sitAndReach', '좌전굴', 1.00, '기준'),
('hamstring', '햄스트링', 0.80, '보조');

-- 5. 유연성 등급 판정 기준 테이블 생성
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

-- 6. 유연성 등급 판정 기준 인덱스
CREATE INDEX IF NOT EXISTS idx_flexibility_grade_thresholds_active 
ON flexibility_grade_thresholds(is_active) WHERE is_active = true;

-- 7. 유연성 등급 판정 기준 코멘트
COMMENT ON TABLE flexibility_grade_thresholds IS 
'유연성 등급 판정 기준 테이블
가중치 합에 따른 최종 등급 및 내부 점수 정의';

COMMENT ON COLUMN flexibility_grade_thresholds.weight_sum_min IS '가중치 합 최소값';
COMMENT ON COLUMN flexibility_grade_thresholds.weight_sum_max IS '가중치 합 최대값';
COMMENT ON COLUMN flexibility_grade_thresholds.final_grade_code IS '최종 등급 코드 (STABLE, NORMAL, LIMITED, PREPARE)';
COMMENT ON COLUMN flexibility_grade_thresholds.internal_score IS '내부 점수 (0-100)';

-- 8. 유연성 등급 판정 기준 초기 데이터 삽입 (문서 기준)
INSERT INTO flexibility_grade_thresholds (weight_sum_min, weight_sum_max, final_grade_code, internal_score) VALUES
(0.00, 0.00, 'STABLE', 80),      -- 가중치 합 0 (C 없음)
(1.00, 1.50, 'NORMAL', 60),      -- 가중치 합 1.0~1.5
(1.60, 2.50, 'LIMITED', 40),    -- 가중치 합 1.6~2.5
(2.60, 999.99, 'PREPARE', 20);   -- 가중치 합 2.6 이상

-- 9. updated_at 자동 업데이트 트리거 함수 생성
CREATE OR REPLACE FUNCTION update_flexibility_weights_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 10. 트리거 생성
CREATE TRIGGER trigger_update_flexibility_item_weights_updated_at
BEFORE UPDATE ON flexibility_item_weights
FOR EACH ROW
EXECUTE FUNCTION update_flexibility_weights_updated_at();

CREATE TRIGGER trigger_update_flexibility_grade_thresholds_updated_at
BEFORE UPDATE ON flexibility_grade_thresholds
FOR EACH ROW
EXECUTE FUNCTION update_flexibility_weights_updated_at();

