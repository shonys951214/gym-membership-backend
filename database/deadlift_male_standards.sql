-- ============================================
-- 데드리프트 (Barbell Deadlift) Strength Standards
-- 남성 데이터 (체중별 + 나이별)
-- ============================================
-- 데이터 수집: https://strengthlevel.com/strength-standards/barbell-deadlift
--
-- 주의: 데이터베이스에 'Barbell Deadlift'로 저장되어 있습니다.
-- 한글명 '데드리프트' 또는 영문명 'Barbell Deadlift'로 찾습니다.

-- ============================================
-- 체중별 데이터 (남성, 나이 NULL)
-- ============================================
-- 체중 50kg → 40.0kg ~ 54.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'BEGINNER', 44.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'NOVICE', 65.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'ADVANCED', 125.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'ELITE', 160.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 55kg → 55.0kg ~ 59.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'BEGINNER', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'NOVICE', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'ADVANCED', 137.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'ELITE', 174.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 60kg → 60.0kg ~ 64.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'BEGINNER', 58.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'NOVICE', 83.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 114.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'ADVANCED', 149.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'ELITE', 187.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 65kg → 65.0kg ~ 69.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'BEGINNER', 66.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'NOVICE', 92.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 124.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'ADVANCED', 160.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'ELITE', 200.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 70kg → 70.0kg ~ 74.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'BEGINNER', 73.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'NOVICE', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 133.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'ADVANCED', 171.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'ELITE', 212.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 75kg → 75.0kg ~ 79.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'BEGINNER', 79.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'NOVICE', 108.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 142.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'ADVANCED', 182.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'ELITE', 224.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 80kg → 80.0kg ~ 84.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'BEGINNER', 86.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'NOVICE', 116.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 151.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'ADVANCED', 192.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'ELITE', 235.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 85kg → 85.0kg ~ 89.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'BEGINNER', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'NOVICE', 123.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 160.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'ADVANCED', 201.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'ELITE', 245.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 90kg → 90.0kg ~ 94.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'BEGINNER', 99.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'NOVICE', 131.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 168.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'ADVANCED', 211.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'ELITE', 256.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 95kg → 95.0kg ~ 99.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'BEGINNER', 105.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'NOVICE', 138.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 176.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'ADVANCED', 220.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'ELITE', 266.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 100kg → 100.0kg ~ 104.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'BEGINNER', 111.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'NOVICE', 145.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 184.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'ADVANCED', 228.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'ELITE', 275.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 105kg → 105.0kg ~ 109.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'BEGINNER', 117.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'NOVICE', 151.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 192.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'ADVANCED', 237.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'ELITE', 284.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 110kg → 110.0kg ~ 114.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'BEGINNER', 123.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'NOVICE', 158.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 199.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'ADVANCED', 245.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'ELITE', 293.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 115kg → 115.0kg ~ 119.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'BEGINNER', 129.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'NOVICE', 164.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 206.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'ADVANCED', 253.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'ELITE', 302.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 120kg → 120.0kg ~ 124.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'BEGINNER', 134.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'NOVICE', 171.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 213.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'ADVANCED', 261.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'ELITE', 311.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 125kg → 125.0kg ~ 129.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'BEGINNER', 140.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'NOVICE', 177.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 220.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'ADVANCED', 268.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'ELITE', 319.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 130kg → 130.0kg ~ 134.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'BEGINNER', 145.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'NOVICE', 183.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 227.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'ADVANCED', 276.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'ELITE', 327.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 135kg → 135.0kg ~ 139.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'BEGINNER', 150.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'NOVICE', 188.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 233.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'ADVANCED', 283.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'ELITE', 335.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 체중 140kg → 140.0kg ~ 999.0kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'BEGINNER', 155.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'NOVICE', 194.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'INTERMEDIATE', 240.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'ADVANCED', 290.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'ELITE', 342.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- ============================================
-- 나이별 데이터 (남성, 체중 범위 NULL)
-- ============================================
-- 나이 15세 → 15세 ~ 19세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'BEGINNER', 67.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'NOVICE', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'INTERMEDIATE', 130.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'ADVANCED', 170.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'ELITE', 214.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 20세 → 20세 ~ 24세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'BEGINNER', 76.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'NOVICE', 109.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'INTERMEDIATE', 148.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'ADVANCED', 194.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'ELITE', 244.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 25세 → 25세 ~ 29세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'BEGINNER', 78.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'NOVICE', 112.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'INTERMEDIATE', 152.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'ADVANCED', 200.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'ELITE', 250.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 30세 → 30세 ~ 34세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'BEGINNER', 78.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'NOVICE', 112.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'INTERMEDIATE', 152.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'ADVANCED', 200.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'ELITE', 250.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 35세 → 35세 ~ 39세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'BEGINNER', 78.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'NOVICE', 112.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'INTERMEDIATE', 152.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'ADVANCED', 200.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'ELITE', 250.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 40세 → 40세 ~ 44세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'BEGINNER', 78.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'NOVICE', 112.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'INTERMEDIATE', 152.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'ADVANCED', 200.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'ELITE', 250.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 45세 → 45세 ~ 49세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'BEGINNER', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'NOVICE', 106.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'INTERMEDIATE', 144.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'ADVANCED', 189.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'ELITE', 237.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 50세 → 50세 ~ 54세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'BEGINNER', 69.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'NOVICE', 99.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'INTERMEDIATE', 135.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'ADVANCED', 177.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'ELITE', 222.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 55세 → 55세 ~ 59세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'BEGINNER', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'NOVICE', 91.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'INTERMEDIATE', 124.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'ADVANCED', 163.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'ELITE', 205.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 60세 → 60세 ~ 64세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'BEGINNER', 59.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'NOVICE', 83.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'INTERMEDIATE', 114.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'ADVANCED', 149.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'ELITE', 187.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 65세 → 65세 ~ 69세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'BEGINNER', 53.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'NOVICE', 75.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'INTERMEDIATE', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'ADVANCED', 135.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'ELITE', 169.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 70세 → 70세 ~ 74세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'BEGINNER', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'NOVICE', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'INTERMEDIATE', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'ADVANCED', 121.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'ELITE', 152.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 75세 → 75세 ~ 79세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'BEGINNER', 43.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'NOVICE', 61.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'INTERMEDIATE', 83.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'ADVANCED', 109.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'ELITE', 136.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 80세 → 80세 ~ 84세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'BEGINNER', 38.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'NOVICE', 54.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'INTERMEDIATE', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'ADVANCED', 97.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'ELITE', 122.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 85세 → 85세 ~ 89세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'BEGINNER', 34.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'NOVICE', 49.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'INTERMEDIATE', 67.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'ADVANCED', 87.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'ELITE', 109.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

-- 나이 90세 → 90세 ~ 999세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'BEGINNER', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'NOVICE', 44.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'INTERMEDIATE', 60.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'ADVANCED', 78.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'ELITE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '데드리프트' OR e.name_en = 'Barbell Deadlift' ON CONFLICT DO NOTHING;
