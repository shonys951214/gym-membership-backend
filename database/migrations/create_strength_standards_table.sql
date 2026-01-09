-- strength_standards 테이블 생성
-- StrengthLevel.com 기준 운동별 상대적 강도 기준 데이터

CREATE TYPE strength_level AS ENUM ('BEGINNER', 'NOVICE', 'INTERMEDIATE', 'ADVANCED', 'ELITE');

CREATE TABLE IF NOT EXISTS strength_standards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exercise_id UUID NOT NULL,
    bodyweight_min FLOAT NOT NULL,
    bodyweight_max FLOAT NOT NULL,
    gender gender NOT NULL,
    level strength_level NOT NULL,
    weight_kg FLOAT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_strength_standards_exercise 
        FOREIGN KEY (exercise_id) 
        REFERENCES exercises(id) 
        ON DELETE CASCADE
);

-- 인덱스 생성
CREATE INDEX idx_strength_standards_exercise_id ON strength_standards(exercise_id);
CREATE INDEX idx_strength_standards_gender ON strength_standards(gender);
CREATE INDEX idx_strength_standards_level ON strength_standards(level);
CREATE INDEX idx_strength_standards_bodyweight ON strength_standards(bodyweight_min, bodyweight_max);
CREATE INDEX idx_strength_standards_lookup ON strength_standards(exercise_id, gender, level, bodyweight_min, bodyweight_max);

-- 코멘트 추가
COMMENT ON TABLE strength_standards IS 'StrengthLevel.com 기준 운동별 상대적 강도 기준 데이터';
COMMENT ON COLUMN strength_standards.exercise_id IS '운동 ID (FK → exercises.id)';
COMMENT ON COLUMN strength_standards.bodyweight_min IS '체중 최소값 (kg)';
COMMENT ON COLUMN strength_standards.bodyweight_max IS '체중 최대값 (kg)';
COMMENT ON COLUMN strength_standards.gender IS '성별 (MALE, FEMALE)';
COMMENT ON COLUMN strength_standards.level IS 'Strength Level (BEGINNER, NOVICE, INTERMEDIATE, ADVANCED, ELITE)';
COMMENT ON COLUMN strength_standards.weight_kg IS '기준 무게 (kg)';
