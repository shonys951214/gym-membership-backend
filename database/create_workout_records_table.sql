-- 1차피드백: 운동 기록 테이블 생성
-- 운동 기록 기능 구현을 위한 테이블 생성

-- workout_records 테이블 생성
CREATE TABLE IF NOT EXISTS workout_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL,
    workout_date DATE NOT NULL,
    body_part VARCHAR(50) NOT NULL,
    exercise_name VARCHAR(100) NOT NULL,
    weight FLOAT NOT NULL,
    reps INT NOT NULL,
    sets INT NOT NULL,
    volume FLOAT NOT NULL, -- 자동 계산: weight * reps * sets
    duration INT NULL, -- 운동 시간 (분)
    workout_type VARCHAR(20) NOT NULL DEFAULT 'PERSONAL', -- 'PT' | 'PERSONAL'
    pt_session_id UUID NULL, -- PT 세션 ID (workout_type이 'PT'인 경우)
    trainer_comment TEXT NULL, -- 트레이너 코멘트
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_workout_records_member 
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_workout_records_member_id ON workout_records(member_id);
CREATE INDEX IF NOT EXISTS idx_workout_records_workout_date ON workout_records(workout_date);
CREATE INDEX IF NOT EXISTS idx_workout_records_workout_type ON workout_records(workout_type);

-- workout_type 체크 제약조건 (이미 존재하면 추가하지 않음)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'chk_workout_type' 
        AND conrelid = 'workout_records'::regclass
    ) THEN
        ALTER TABLE workout_records
        ADD CONSTRAINT chk_workout_type 
        CHECK (workout_type IN ('PT', 'PERSONAL'));
    END IF;
END $$;

-- 테이블 생성 확인
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'workout_records'
ORDER BY ordinal_position;

