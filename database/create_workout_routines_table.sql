-- 1차피드백: 추천 운동 루틴 테이블 생성
-- 추천 운동 루틴 기능 구현을 위한 테이블 생성

-- workout_routines 테이블 생성
CREATE TABLE IF NOT EXISTS workout_routines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NULL, -- NULL이면 전체 공통 루틴
    routine_name VARCHAR(255) NOT NULL, -- 루틴 이름
    routine_date DATE NULL, -- 회원별 루틴인 경우 날짜 지정
    exercises JSONB NOT NULL, -- 운동 목록 (배열)
    estimated_duration INT NOT NULL, -- 예상 소요 시간 (분)
    difficulty VARCHAR(20) NOT NULL DEFAULT 'MEDIUM', -- 'EASY' | 'MEDIUM' | 'HARD'
    is_completed BOOLEAN NOT NULL DEFAULT false, -- 회원별 루틴인 경우 완료 여부
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_workout_routines_member 
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_workout_routines_member_id ON workout_routines(member_id);
CREATE INDEX IF NOT EXISTS idx_workout_routines_routine_date ON workout_routines(routine_date);
CREATE INDEX IF NOT EXISTS idx_workout_routines_member_date ON workout_routines(member_id, routine_date);

-- 같은 날짜에 여러 루틴 생성 방지 (선택적 - 필요시 주석 해제)
-- CREATE UNIQUE INDEX IF NOT EXISTS uk_workout_routines_member_date ON workout_routines(member_id, routine_date);

-- exercises JSONB 구조 예시:
-- [
--   {
--     "bodyPart": "하체",
--     "exerciseName": "스쿼트",
--     "sets": 3,
--     "reps": 10,
--     "weight": 60,
--     "notes": "자세 주의"
--   },
--   {
--     "bodyPart": "가슴",
--     "exerciseName": "벤치프레스",
--     "sets": 3,
--     "reps": 8,
--     "weight": 50,
--     "notes": null
--   }
-- ]

-- 테이블 생성 확인
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'workout_routines'
ORDER BY ordinal_position;

