-- exercises 테이블 생성
-- 운동 마스터 데이터 관리

CREATE TYPE exercise_category AS ENUM ('UPPER', 'LOWER', 'FULL_BODY');

CREATE TABLE IF NOT EXISTS exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    category exercise_category NOT NULL DEFAULT 'FULL_BODY',
    unit VARCHAR(50) NOT NULL DEFAULT 'kg',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX idx_exercises_name ON exercises(name);
CREATE INDEX idx_exercises_name_en ON exercises(name_en);
CREATE INDEX idx_exercises_category ON exercises(category);
CREATE INDEX idx_exercises_is_active ON exercises(is_active);

-- 코멘트 추가
COMMENT ON TABLE exercises IS '운동 마스터 데이터 테이블';
COMMENT ON COLUMN exercises.name IS '운동명 (한글)';
COMMENT ON COLUMN exercises.name_en IS '운동명 (영문)';
COMMENT ON COLUMN exercises.category IS '운동 카테고리 (UPPER: 상체, LOWER: 하체, FULL_BODY: 전신)';
COMMENT ON COLUMN exercises.unit IS '단위 (kg, lb 등)';
COMMENT ON COLUMN exercises.is_active IS '활성화 여부';
