-- 운동 루틴 테이블에 새 필드 추가 (프론트엔드 요청사항 반영)
-- 이미 테이블이 존재하는 경우에만 실행

-- routine_name 필드 추가
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_routines' 
        AND column_name = 'routine_name'
    ) THEN
        ALTER TABLE workout_routines
        ADD COLUMN routine_name VARCHAR(255) NOT NULL DEFAULT '운동 루틴';
    END IF;
END $$;

-- estimated_duration 필드 추가
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_routines' 
        AND column_name = 'estimated_duration'
    ) THEN
        ALTER TABLE workout_routines
        ADD COLUMN estimated_duration INT NOT NULL DEFAULT 60;
    END IF;
END $$;

-- difficulty 필드 추가
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_routines' 
        AND column_name = 'difficulty'
    ) THEN
        ALTER TABLE workout_routines
        ADD COLUMN difficulty VARCHAR(20) NOT NULL DEFAULT 'MEDIUM';
    END IF;
END $$;

-- member_id를 nullable로 변경 (공통 루틴 지원)
DO $$
BEGIN
    -- member_id가 NOT NULL인 경우에만 변경
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_routines' 
        AND column_name = 'member_id'
        AND is_nullable = 'NO'
    ) THEN
        ALTER TABLE workout_routines
        ALTER COLUMN member_id DROP NOT NULL;
    END IF;
END $$;

-- routine_date를 nullable로 변경 (공통 루틴은 날짜 없음)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'workout_routines' 
        AND column_name = 'routine_date'
        AND is_nullable = 'NO'
    ) THEN
        ALTER TABLE workout_routines
        ALTER COLUMN routine_date DROP NOT NULL;
    END IF;
END $$;

-- difficulty 체크 제약조건 추가
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'chk_workout_routines_difficulty' 
        AND conrelid = 'workout_routines'::regclass
    ) THEN
        ALTER TABLE workout_routines
        ADD CONSTRAINT chk_workout_routines_difficulty 
        CHECK (difficulty IN ('EASY', 'MEDIUM', 'HARD'));
    END IF;
END $$;

-- 변경사항 확인
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'workout_routines'
    AND column_name IN ('routine_name', 'estimated_duration', 'difficulty', 'member_id', 'routine_date')
ORDER BY column_name;

