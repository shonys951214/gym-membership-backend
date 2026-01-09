-- Strength Standards 데이터 시드
-- StrengthLevel.com에서 수집한 기준 데이터
-- 주의: 실제 데이터는 strengthlevel.com에서 수집하여 업데이트해야 합니다.
-- 아래는 예시 데이터 구조입니다.

-- 벤치프레스 기준 데이터 예시 (남성, 70kg 체중, 각 레벨별 기준)
-- 실제로는 모든 체중 구간과 성별, 레벨에 대한 데이터가 필요합니다.

-- 예시: 벤치프레스 남성 70kg 체중 기준
-- 실제 데이터는 strengthlevel.com에서 수집하여 아래 형식으로 추가해야 합니다.

/*
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    e.id,
    65.0,  -- 체중 최소값
    75.0,  -- 체중 최대값
    'MALE',
    'BEGINNER',
    50.0,  -- 기준 무게 (kg)
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM exercises e
WHERE e.name_en = 'Bench Press'
ON CONFLICT DO NOTHING;
*/

-- 실제 데이터 수집 가이드:
-- 1. strengthlevel.com에서 각 운동별, 체중별, 성별, 레벨별 기준 무게를 수집
-- 2. 위 형식에 맞춰 INSERT 문 작성
-- 3. 모든 조합에 대해 데이터 삽입

-- 예시 데이터 삽입 스크립트 (벤치프레스 남성 70kg 체중 구간)
DO $$
DECLARE
    bench_press_id UUID;
BEGIN
    -- 벤치프레스 운동 ID 조회
    SELECT id INTO bench_press_id FROM exercises WHERE name_en = 'Bench Press' LIMIT 1;
    
    IF bench_press_id IS NOT NULL THEN
        -- 남성 70kg 체중 구간 (65-75kg) 기준 데이터
        INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
        VALUES
            (gen_random_uuid(), bench_press_id, 65.0, 75.0, 'MALE', 'BEGINNER', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
            (gen_random_uuid(), bench_press_id, 65.0, 75.0, 'MALE', 'NOVICE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
            (gen_random_uuid(), bench_press_id, 65.0, 75.0, 'MALE', 'INTERMEDIATE', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
            (gen_random_uuid(), bench_press_id, 65.0, 75.0, 'MALE', 'ADVANCED', 120.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
            (gen_random_uuid(), bench_press_id, 65.0, 75.0, 'MALE', 'ELITE', 150.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
        ON CONFLICT DO NOTHING;
    END IF;
END $$;

-- 코멘트
COMMENT ON TABLE strength_standards IS 'StrengthLevel.com 기준 운동별 상대적 강도 기준 데이터';
COMMENT ON COLUMN strength_standards.weight_kg IS '해당 체중 구간, 성별, 레벨에서의 기준 무게 (kg)';

-- 참고: 실제 프로덕션 환경에서는 strengthlevel.com에서 모든 데이터를 수집하여
-- 완전한 데이터셋을 구축해야 합니다. 위 예시는 구조만 보여줍니다.
