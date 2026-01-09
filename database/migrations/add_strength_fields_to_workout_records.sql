-- workout_records 테이블에 Strength Level 관련 필드 추가

-- strength_level enum 타입이 없으면 생성
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'strength_level') THEN
        CREATE TYPE strength_level AS ENUM ('BEGINNER', 'NOVICE', 'INTERMEDIATE', 'ADVANCED', 'ELITE');
    END IF;
END $$;

-- 필드 추가 (이미 존재하면 무시)
DO $$ 
BEGIN
    -- one_rep_max 필드 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_records' AND column_name = 'one_rep_max'
    ) THEN
        ALTER TABLE workout_records 
        ADD COLUMN one_rep_max FLOAT;
    END IF;

    -- relative_strength 필드 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_records' AND column_name = 'relative_strength'
    ) THEN
        ALTER TABLE workout_records 
        ADD COLUMN relative_strength FLOAT;
    END IF;

    -- strength_level 필드 추가
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_records' AND column_name = 'strength_level'
    ) THEN
        ALTER TABLE workout_records 
        ADD COLUMN strength_level strength_level;
    END IF;
END $$;

-- 코멘트 추가
COMMENT ON COLUMN workout_records.one_rep_max IS '1RM (One Rep Max) 계산값 (kg)';
COMMENT ON COLUMN workout_records.relative_strength IS '상대적 강도 (체중 대비 무게 비율, %)';
COMMENT ON COLUMN workout_records.strength_level IS 'Strength Level 판정 결과 (BEGINNER, NOVICE, INTERMEDIATE, ADVANCED, ELITE)';
