-- 기본 운동 목록 시딩
-- 3대 운동 + 대체 운동 포함

-- 벤치프레스 관련
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '벤치프레스', 'Bench Press', 'UPPER', '가슴', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '인클라인 벤치프레스', 'Incline Bench Press', 'UPPER', '가슴', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '덤벨 프레스', 'Dumbbell Press', 'UPPER', '가슴', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 스쿼트 관련
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '스쿼트', 'Squat', 'LOWER', '하체', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '레그프레스', 'Leg Press', 'LOWER', '하체', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '스플릿 스쿼트', 'Split Squat', 'LOWER', '하체', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 데드리프트 관련
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '데드리프트', 'Deadlift', 'FULL_BODY', '하체', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '루마니안 데드리프트', 'Romanian Deadlift', 'FULL_BODY', '하체', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '스모 데드리프트', 'Sumo Deadlift', 'FULL_BODY', '하체', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 기타 상체 운동
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '오버헤드 프레스', 'Overhead Press', 'UPPER', '어깨', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '랫풀다운', 'Lat Pulldown', 'UPPER', '등', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '벤트오버 로우', 'Bent Over Row', 'UPPER', '등', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '바벨 컬', 'Barbell Curl', 'UPPER', '팔', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;
