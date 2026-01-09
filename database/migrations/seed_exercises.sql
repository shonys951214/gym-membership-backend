-- 운동 마스터 데이터 시드
-- StrengthLevel.com에서 지원하는 주요 운동 목록

-- 기존 데이터 삭제 (선택적)
-- DELETE FROM exercises;

-- 운동 데이터 삽입
INSERT INTO exercises (id, name, name_en, category, unit, is_active, created_at, updated_at)
VALUES
    -- 상체 운동
    (gen_random_uuid(), '벤치프레스', 'Bench Press', 'UPPER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '인클라인벤치프레스', 'Incline Bench Press', 'UPPER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '숄더프레스', 'Shoulder Press', 'UPPER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '밀리터리프레스', 'Military Press', 'UPPER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '바벨컬', 'Barbell Curl', 'UPPER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '벤트오버로우', 'Bent Over Row', 'UPPER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    
    -- 하체 운동
    (gen_random_uuid(), '스쿼트', 'Squat', 'LOWER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '프론트스쿼트', 'Front Squat', 'LOWER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '데드리프트', 'Deadlift', 'LOWER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '스모데드리프트', 'Sumo Deadlift', 'LOWER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '루마니안데드리프트', 'Romanian Deadlift', 'LOWER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '헥스바데드리프트', 'Hex Bar Deadlift', 'LOWER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '힙스러스트', 'Hip Thrust', 'LOWER', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    
    -- 전신 운동
    (gen_random_uuid(), '파워클린', 'Power Clean', 'FULL_BODY', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 코멘트
COMMENT ON TABLE exercises IS '운동 마스터 데이터 - StrengthLevel.com 기준 주요 운동 목록';
