-- ============================================
-- 스쿼트 (Barbell Squat) Strength Standards
-- 여성 데이터 (체중별 + 나이별)
-- ============================================
-- 데이터 수집: https://strengthlevel.com/strength-standards/barbell-squat
--
-- 주의: 데이터베이스에 'Barbell Squat'로 저장되어 있습니다.
-- 한글명 '스쿼트' 또는 영문명 'Barbell Squat'로 찾습니다.

-- ============================================
-- 체중별 데이터 (여성, 나이 NULL)
-- ============================================
-- 체중 40kg → 0.0kg ~ 44.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'BEGINNER', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'NOVICE', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'ADVANCED', 75.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 0.0, 44.99, NULL, NULL, 'FEMALE', 'ELITE', 101.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 45kg → 45.0kg ~ 49.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 49.99, NULL, NULL, 'FEMALE', 'BEGINNER', 20.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 49.99, NULL, NULL, 'FEMALE', 'NOVICE', 36.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 49.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 56.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 49.99, NULL, NULL, 'FEMALE', 'ADVANCED', 81.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 45.0, 49.99, NULL, NULL, 'FEMALE', 'ELITE', 109.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 50kg → 50.0kg ~ 54.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 54.99, NULL, NULL, 'FEMALE', 'BEGINNER', 23.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 54.99, NULL, NULL, 'FEMALE', 'NOVICE', 39.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 54.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 61.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 54.99, NULL, NULL, 'FEMALE', 'ADVANCED', 87.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 50.0, 54.99, NULL, NULL, 'FEMALE', 'ELITE', 115.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 55kg → 55.0kg ~ 59.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'FEMALE', 'BEGINNER', 26.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'FEMALE', 'NOVICE', 43.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 65.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'FEMALE', 'ADVANCED', 92.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'FEMALE', 'ELITE', 122.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 60kg → 60.0kg ~ 64.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'FEMALE', 'BEGINNER', 29.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'FEMALE', 'NOVICE', 47.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'FEMALE', 'ADVANCED', 97.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'FEMALE', 'ELITE', 128.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 65kg → 65.0kg ~ 69.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'FEMALE', 'BEGINNER', 32.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'FEMALE', 'NOVICE', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'FEMALE', 'ADVANCED', 102.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'FEMALE', 'ELITE', 133.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 70kg → 70.0kg ~ 74.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'FEMALE', 'BEGINNER', 34.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'FEMALE', 'NOVICE', 53.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 78.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'FEMALE', 'ADVANCED', 106.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'FEMALE', 'ELITE', 138.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 75kg → 75.0kg ~ 79.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'FEMALE', 'BEGINNER', 37.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'FEMALE', 'NOVICE', 56.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 81.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'FEMALE', 'ADVANCED', 111.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'FEMALE', 'ELITE', 143.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 80kg → 80.0kg ~ 84.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'FEMALE', 'BEGINNER', 39.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'FEMALE', 'NOVICE', 59.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 85.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'FEMALE', 'ADVANCED', 115.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'FEMALE', 'ELITE', 148.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 85kg → 85.0kg ~ 89.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'FEMALE', 'BEGINNER', 41.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'FEMALE', 'NOVICE', 62.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 88.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'FEMALE', 'ADVANCED', 119.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'FEMALE', 'ELITE', 152.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 90kg → 90.0kg ~ 94.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'FEMALE', 'BEGINNER', 44.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'FEMALE', 'NOVICE', 65.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 91.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'FEMALE', 'ADVANCED', 123.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'FEMALE', 'ELITE', 157.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 95kg → 95.0kg ~ 99.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'FEMALE', 'BEGINNER', 46.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'FEMALE', 'NOVICE', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'FEMALE', 'ADVANCED', 126.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'FEMALE', 'ELITE', 161.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 100kg → 100.0kg ~ 104.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'FEMALE', 'BEGINNER', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'FEMALE', 'NOVICE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'FEMALE', 'ADVANCED', 130.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'FEMALE', 'ELITE', 165.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 105kg → 105.0kg ~ 109.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'FEMALE', 'BEGINNER', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'FEMALE', 'NOVICE', 73.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 101.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'FEMALE', 'ADVANCED', 133.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'FEMALE', 'ELITE', 169.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 110kg → 110.0kg ~ 114.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'FEMALE', 'BEGINNER', 52.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'FEMALE', 'NOVICE', 75.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'FEMALE', 'ADVANCED', 136.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'FEMALE', 'ELITE', 172.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 115kg → 115.0kg ~ 119.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'FEMALE', 'BEGINNER', 54.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'FEMALE', 'NOVICE', 77.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 106.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'FEMALE', 'ADVANCED', 140.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'FEMALE', 'ELITE', 176.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 120kg → 120.0kg ~ 999.0kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 999.0, NULL, NULL, 'FEMALE', 'BEGINNER', 56.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 999.0, NULL, NULL, 'FEMALE', 'NOVICE', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 999.0, NULL, NULL, 'FEMALE', 'INTERMEDIATE', 109.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 999.0, NULL, NULL, 'FEMALE', 'ADVANCED', 143.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 999.0, NULL, NULL, 'FEMALE', 'ELITE', 179.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- ============================================
-- 나이별 데이터 (여성, 체중 범위 NULL)
-- ============================================
-- 나이 15세 → 15세 ~ 19세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'BEGINNER', 25.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'NOVICE', 41.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'INTERMEDIATE', 62.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'ADVANCED', 88.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'FEMALE', 'ELITE', 116.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 20세 → 20세 ~ 24세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'BEGINNER', 28.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'NOVICE', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'INTERMEDIATE', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'ADVANCED', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'FEMALE', 'ELITE', 125.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 25세 → 25세 ~ 29세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'BEGINNER', 30.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'NOVICE', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'INTERMEDIATE', 73.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'ADVANCED', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'FEMALE', 'ELITE', 136.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 30세 → 30세 ~ 34세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'BEGINNER', 30.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'NOVICE', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'INTERMEDIATE', 73.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'ADVANCED', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'FEMALE', 'ELITE', 136.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 35세 → 35세 ~ 39세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'BEGINNER', 30.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'NOVICE', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'INTERMEDIATE', 73.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'ADVANCED', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'FEMALE', 'ELITE', 136.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 40세 → 40세 ~ 44세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'BEGINNER', 30.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'NOVICE', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'INTERMEDIATE', 73.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'ADVANCED', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'FEMALE', 'ELITE', 136.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 45세 → 45세 ~ 49세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'BEGINNER', 28.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'NOVICE', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'INTERMEDIATE', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'ADVANCED', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'FEMALE', 'ELITE', 125.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 50세 → 50세 ~ 54세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'BEGINNER', 26.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'NOVICE', 42.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'INTERMEDIATE', 63.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'ADVANCED', 88.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'FEMALE', 'ELITE', 116.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 55세 → 55세 ~ 59세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'BEGINNER', 24.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'NOVICE', 38.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'INTERMEDIATE', 57.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'ADVANCED', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'FEMALE', 'ELITE', 105.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 60세 → 60세 ~ 64세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'BEGINNER', 21.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'NOVICE', 34.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'INTERMEDIATE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'ADVANCED', 71.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'FEMALE', 'ELITE', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 65세 → 65세 ~ 69세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'BEGINNER', 19.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'NOVICE', 30.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'INTERMEDIATE', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'ADVANCED', 63.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'FEMALE', 'ELITE', 82.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 70세 → 70세 ~ 74세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'BEGINNER', 17.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'NOVICE', 27.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'INTERMEDIATE', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'ADVANCED', 56.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'FEMALE', 'ELITE', 73.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 75세 → 75세 ~ 79세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'BEGINNER', 15.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'NOVICE', 24.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'INTERMEDIATE', 35.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'ADVANCED', 49.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'FEMALE', 'ELITE', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 80세 → 80세 ~ 84세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'BEGINNER', 13.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'NOVICE', 21.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'INTERMEDIATE', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'ADVANCED', 43.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'FEMALE', 'ELITE', 56.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 85세 → 85세 ~ 89세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'BEGINNER', 12.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'NOVICE', 19.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'INTERMEDIATE', 29.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'ADVANCED', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'FEMALE', 'ELITE', 52.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 90세 → 90세 ~ 999세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'BEGINNER', 12.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'NOVICE', 19.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'INTERMEDIATE', 29.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'ADVANCED', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'FEMALE', 'ELITE', 53.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;
