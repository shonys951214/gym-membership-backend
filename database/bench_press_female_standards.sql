-- ============================================
-- 벤치프레스 (Bench Press - Powerlifting) Strength Standards
-- 여성 데이터 (체중별 + 나이별)
-- ============================================
-- 데이터 수집: https://strengthlevel.com/strength-standards/bench-press
--
-- 주의: 데이터베이스에 'Bench Press - Powerlifting'로 저장되어 있습니다.
-- 한글명 '벤치프레스' 또는 영문명 'Bench Press - Powerlifting'로 찾습니다.

-- ============================================
-- 체중별 데이터 (여성, 나이 NULL)
-- ============================================
-- 체중 40kg → 0.0kg ~ 44.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'BEGINNER', 8.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'NOVICE', 18.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 32.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'ADVANCED', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'ELITE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 45kg → 40.0kg ~ 49.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 49.99, NULL, NULL, 'FEMALE', 'BEGINNER', 10.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 49.99, NULL, NULL, 'FEMALE', 'NOVICE', 21.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 49.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 36.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 49.99, NULL, NULL, 'FEMALE', 'ADVANCED', 55.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 49.99, NULL, NULL, 'FEMALE', 'ELITE', 76.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 50kg → 45.0kg ~ 54.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 54.99, NULL, NULL, 'FEMALE', 'BEGINNER', 12.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 54.99, NULL, NULL, 'FEMALE', 'NOVICE', 24.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 54.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 54.99, NULL, NULL, 'FEMALE', 'ADVANCED', 59.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 54.99, NULL, NULL, 'FEMALE', 'ELITE', 82.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 55kg → 50.0kg ~ 59.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 59.99, NULL, NULL, 'FEMALE', 'BEGINNER', 15.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 59.99, NULL, NULL, 'FEMALE', 'NOVICE', 27.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 59.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 43.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 59.99, NULL, NULL, 'FEMALE', 'ADVANCED', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 59.99, NULL, NULL, 'FEMALE', 'ELITE', 87.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 60kg → 55.0kg ~ 64.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 64.99, NULL, NULL, 'FEMALE', 'BEGINNER', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 64.99, NULL, NULL, 'FEMALE', 'NOVICE', 29.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 64.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 47.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 64.99, NULL, NULL, 'FEMALE', 'ADVANCED', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 64.99, NULL, NULL, 'FEMALE', 'ELITE', 92.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 65kg → 60.0kg ~ 69.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 69.99, NULL, NULL, 'FEMALE', 'BEGINNER', 19.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 69.99, NULL, NULL, 'FEMALE', 'NOVICE', 32.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 69.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 69.99, NULL, NULL, 'FEMALE', 'ADVANCED', 72.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 69.99, NULL, NULL, 'FEMALE', 'ELITE', 96.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 70kg → 65.0kg ~ 74.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 74.99, NULL, NULL, 'FEMALE', 'BEGINNER', 20.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 74.99, NULL, NULL, 'FEMALE', 'NOVICE', 34.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 74.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 53.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 74.99, NULL, NULL, 'FEMALE', 'ADVANCED', 75.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 74.99, NULL, NULL, 'FEMALE', 'ELITE', 101.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 75kg → 70.0kg ~ 79.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 79.99, NULL, NULL, 'FEMALE', 'BEGINNER', 22.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 79.99, NULL, NULL, 'FEMALE', 'NOVICE', 37.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 79.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 56.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 79.99, NULL, NULL, 'FEMALE', 'ADVANCED', 79.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 79.99, NULL, NULL, 'FEMALE', 'ELITE', 105.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 80kg → 75.0kg ~ 84.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 84.99, NULL, NULL, 'FEMALE', 'BEGINNER', 24.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 84.99, NULL, NULL, 'FEMALE', 'NOVICE', 39.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 84.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 59.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 84.99, NULL, NULL, 'FEMALE', 'ADVANCED', 82.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 84.99, NULL, NULL, 'FEMALE', 'ELITE', 109.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 85kg → 80.0kg ~ 89.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 89.99, NULL, NULL, 'FEMALE', 'BEGINNER', 26.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 89.99, NULL, NULL, 'FEMALE', 'NOVICE', 41.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 89.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 62.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 89.99, NULL, NULL, 'FEMALE', 'ADVANCED', 86.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 89.99, NULL, NULL, 'FEMALE', 'ELITE', 112.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 90kg → 85.0kg ~ 94.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 94.99, NULL, NULL, 'FEMALE', 'BEGINNER', 28.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 94.99, NULL, NULL, 'FEMALE', 'NOVICE', 44.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 94.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 94.99, NULL, NULL, 'FEMALE', 'ADVANCED', 89.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 94.99, NULL, NULL, 'FEMALE', 'ELITE', 116.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 95kg → 90.0kg ~ 99.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 99.99, NULL, NULL, 'FEMALE', 'BEGINNER', 29.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 99.99, NULL, NULL, 'FEMALE', 'NOVICE', 46.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 99.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 67.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 99.99, NULL, NULL, 'FEMALE', 'ADVANCED', 92.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 99.99, NULL, NULL, 'FEMALE', 'ELITE', 119.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 100kg → 95.0kg ~ 104.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 104.99, NULL, NULL, 'FEMALE', 'BEGINNER', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 104.99, NULL, NULL, 'FEMALE', 'NOVICE', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 104.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 69.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 104.99, NULL, NULL, 'FEMALE', 'ADVANCED', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 104.99, NULL, NULL, 'FEMALE', 'ELITE', 123.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 105kg → 100.0kg ~ 109.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 109.99, NULL, NULL, 'FEMALE', 'BEGINNER', 33.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 109.99, NULL, NULL, 'FEMALE', 'NOVICE', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 109.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 72.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 109.99, NULL, NULL, 'FEMALE', 'ADVANCED', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 109.99, NULL, NULL, 'FEMALE', 'ELITE', 126.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 110kg → 105.0kg ~ 114.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 114.99, NULL, NULL, 'FEMALE', 'BEGINNER', 34.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 114.99, NULL, NULL, 'FEMALE', 'NOVICE', 52.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 114.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 114.99, NULL, NULL, 'FEMALE', 'ADVANCED', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 114.99, NULL, NULL, 'FEMALE', 'ELITE', 129.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 115kg → 110.0kg ~ 119.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 119.99, NULL, NULL, 'FEMALE', 'BEGINNER', 36.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 119.99, NULL, NULL, 'FEMALE', 'NOVICE', 54.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 119.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 76.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 119.99, NULL, NULL, 'FEMALE', 'ADVANCED', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 119.99, NULL, NULL, 'FEMALE', 'ELITE', 132.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 120kg → 115.0kg ~ 999.0kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 999.0, NULL, NULL, 'FEMALE', 'BEGINNER', 37.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 999.0, NULL, NULL, 'FEMALE', 'NOVICE', 56.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 999.0, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 79.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 999.0, NULL, NULL, 'FEMALE', 'ADVANCED', 106.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 999.0, NULL, NULL, 'FEMALE', 'ELITE', 135.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- ============================================
-- 나이별 데이터 (여성, 체중 범위 NULL)
-- ============================================
-- 나이 15세 → 15세 ~ 19세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'BEGINNER', 15.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'NOVICE', 27.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'INTERMEDIATE', 43.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'ADVANCED', 63.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'ELITE', 86.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 20세 → 20세 ~ 24세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'BEGINNER', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'NOVICE', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'INTERMEDIATE', 49.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'ADVANCED', 72.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'ELITE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 25세 → 25세 ~ 29세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'BEGINNER', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'NOVICE', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'INTERMEDIATE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'ADVANCED', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'ELITE', 101.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 30세 → 30세 ~ 34세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'BEGINNER', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'NOVICE', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'INTERMEDIATE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'ADVANCED', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'ELITE', 101.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 35세 → 35세 ~ 39세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'BEGINNER', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'NOVICE', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'INTERMEDIATE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'ADVANCED', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'ELITE', 101.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 40세 → 40세 ~ 44세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'BEGINNER', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'NOVICE', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'INTERMEDIATE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'ADVANCED', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'ELITE', 101.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 45세 → 45세 ~ 49세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'BEGINNER', 16.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'NOVICE', 30.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'INTERMEDIATE', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'ADVANCED', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'ELITE', 96.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 50세 → 50세 ~ 54세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'BEGINNER', 15.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'NOVICE', 28.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'INTERMEDIATE', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'ADVANCED', 66.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'ELITE', 89.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 55세 → 55세 ~ 59세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'BEGINNER', 14.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'NOVICE', 26.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'INTERMEDIATE', 41.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'ADVANCED', 61.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'ELITE', 83.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 60세 → 60세 ~ 64세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'BEGINNER', 13.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'NOVICE', 23.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'INTERMEDIATE', 38.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'ADVANCED', 55.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'ELITE', 75.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 65세 → 65세 ~ 69세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'BEGINNER', 12.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'NOVICE', 21.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'INTERMEDIATE', 34.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'ADVANCED', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'ELITE', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 70세 → 70세 ~ 74세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'BEGINNER', 11.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'NOVICE', 19.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'INTERMEDIATE', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'ADVANCED', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'ELITE', 61.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 75세 → 75세 ~ 79세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'BEGINNER', 9.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'NOVICE', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'INTERMEDIATE', 28.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'ADVANCED', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'ELITE', 55.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 80세 → 80세 ~ 84세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'BEGINNER', 8.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'NOVICE', 15.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'INTERMEDIATE', 25.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'ADVANCED', 36.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'ELITE', 49.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 85세 → 85세 ~ 89세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'BEGINNER', 8.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'NOVICE', 14.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'INTERMEDIATE', 22.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'ADVANCED', 32.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'ELITE', 44.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 90세 → 90세 ~ 999세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'BEGINNER', 7.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'NOVICE', 12.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'INTERMEDIATE', 20.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'ADVANCED', 29.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'ELITE', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;
