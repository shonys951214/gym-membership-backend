-- 운동 기록 테이블에 새 필드 추가 (프론트엔드 요청사항 반영)
-- 이미 테이블이 존재하는 경우에만 실행

-- duration 필드 추가
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_records' 
        AND column_name = 'duration'
    ) THEN
        ALTER TABLE workout_records
        ADD COLUMN duration INT NULL;
    END IF;
END $$;

-- pt_session_id 필드 추가
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_records' 
        AND column_name = 'pt_session_id'
    ) THEN
        ALTER TABLE workout_records
        ADD COLUMN pt_session_id UUID NULL;
    END IF;
END $$;

-- trainer_comment 필드 추가
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_records' 
        AND column_name = 'trainer_comment'
    ) THEN
        ALTER TABLE workout_records
        ADD COLUMN trainer_comment TEXT NULL;
    END IF;
END $$;

-- 변경사항 확인
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'workout_records'
    AND column_name IN ('duration', 'pt_session_id', 'trainer_comment')
ORDER BY column_name;

