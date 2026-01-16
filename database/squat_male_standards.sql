-- ============================================
-- 스쿼트 (Barbell Squat) Strength Standards
-- 남성 데이터 (체중별 + 나이별)
-- ============================================
-- 데이터 수집: https://strengthlevel.com/strength-standards/barbell-squat
--
-- 주의: 데이터베이스에 'Barbell Squat'로 저장되어 있습니다.
-- 한글명 '스쿼트' 또는 영문명 'Barbell Squat'로 찾습니다.

-- ============================================
-- 체중별 데이터 (남성, 나이 NULL)
-- ============================================
-- 체중 50kg → 40.0kg ~ 54.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'BEGINNER', 33.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'NOVICE', 52.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 76.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'ADVANCED', 104.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 40.0, 54.99, NULL, NULL, 'MALE', 'ELITE', 136.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 55kg → 55.0kg ~ 59.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'BEGINNER', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'NOVICE', 60.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 86.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'ADVANCED', 116.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 55.0, 59.99, NULL, NULL, 'MALE', 'ELITE', 149.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 60kg → 60.0kg ~ 64.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'BEGINNER', 47.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'NOVICE', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'ADVANCED', 127.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 60.0, 64.99, NULL, NULL, 'MALE', 'ELITE', 161.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 65kg → 65.0kg ~ 69.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'BEGINNER', 53.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'NOVICE', 76.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 104.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'ADVANCED', 137.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 65.0, 69.99, NULL, NULL, 'MALE', 'ELITE', 173.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 70kg → 70.0kg ~ 74.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'BEGINNER', 59.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'NOVICE', 83.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 113.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'ADVANCED', 147.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 70.0, 74.99, NULL, NULL, 'MALE', 'ELITE', 184.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 75kg → 75.0kg ~ 79.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'BEGINNER', 66.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'NOVICE', 91.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 122.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'ADVANCED', 157.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 75.0, 79.99, NULL, NULL, 'MALE', 'ELITE', 195.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 80kg → 80.0kg ~ 84.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'BEGINNER', 72.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'NOVICE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 130.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'ADVANCED', 166.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 80.0, 84.99, NULL, NULL, 'MALE', 'ELITE', 205.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 85kg → 85.0kg ~ 89.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'BEGINNER', 78.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'NOVICE', 105.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 138.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'ADVANCED', 175.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 85.0, 89.99, NULL, NULL, 'MALE', 'ELITE', 215.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 90kg → 90.0kg ~ 94.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'BEGINNER', 83.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'NOVICE', 112.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 146.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'ADVANCED', 184.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 90.0, 94.99, NULL, NULL, 'MALE', 'ELITE', 225.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 95kg → 95.0kg ~ 99.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'BEGINNER', 89.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'NOVICE', 118.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 153.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'ADVANCED', 192.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 95.0, 99.99, NULL, NULL, 'MALE', 'ELITE', 234.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 100kg → 100.0kg ~ 104.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'BEGINNER', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'NOVICE', 125.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 160.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'ADVANCED', 201.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 100.0, 104.99, NULL, NULL, 'MALE', 'ELITE', 243.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 105kg → 105.0kg ~ 109.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'BEGINNER', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'NOVICE', 131.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 168.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'ADVANCED', 209.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 105.0, 109.99, NULL, NULL, 'MALE', 'ELITE', 252.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 110kg → 110.0kg ~ 114.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'BEGINNER', 106.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'NOVICE', 137.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 174.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'ADVANCED', 216.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 110.0, 114.99, NULL, NULL, 'MALE', 'ELITE', 260.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 115kg → 115.0kg ~ 119.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'BEGINNER', 111.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'NOVICE', 143.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 181.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'ADVANCED', 224.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 115.0, 119.99, NULL, NULL, 'MALE', 'ELITE', 269.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 120kg → 120.0kg ~ 124.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'BEGINNER', 116.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'NOVICE', 149.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 188.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'ADVANCED', 231.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 120.0, 124.99, NULL, NULL, 'MALE', 'ELITE', 277.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 125kg → 125.0kg ~ 129.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'BEGINNER', 121.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'NOVICE', 155.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 194.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'ADVANCED', 238.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 125.0, 129.99, NULL, NULL, 'MALE', 'ELITE', 284.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 130kg → 130.0kg ~ 134.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'BEGINNER', 126.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'NOVICE', 160.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 201.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'ADVANCED', 245.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 130.0, 134.99, NULL, NULL, 'MALE', 'ELITE', 292.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 135kg → 135.0kg ~ 139.99kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'BEGINNER', 131.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'NOVICE', 166.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 207.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'ADVANCED', 252.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 135.0, 139.99, NULL, NULL, 'MALE', 'ELITE', 299.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 체중 140kg → 140.0kg ~ 999.0kg
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'BEGINNER', 136.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'NOVICE', 171.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'INTERMEDIATE', 213.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'ADVANCED', 259.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'BODYWEIGHT', 140.0, 999.0, NULL, NULL, 'MALE', 'ELITE', 307.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- ============================================
-- 나이별 데이터 (남성, 체중 범위 NULL)
-- ============================================
-- 나이 15세 → 15세 ~ 19세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'BEGINNER', 55.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'NOVICE', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'INTERMEDIATE', 111.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'ADVANCED', 147.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 15, 19, 'MALE', 'ELITE', 187.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 20세 → 20세 ~ 24세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'BEGINNER', 62.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'NOVICE', 91.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'INTERMEDIATE', 127.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'ADVANCED', 168.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 20, 24, 'MALE', 'ELITE', 213.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 25세 → 25세 ~ 29세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'BEGINNER', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'NOVICE', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'INTERMEDIATE', 130.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'ADVANCED', 173.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 25, 29, 'MALE', 'ELITE', 219.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 30세 → 30세 ~ 34세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'BEGINNER', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'NOVICE', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'INTERMEDIATE', 130.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'ADVANCED', 173.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 30, 34, 'MALE', 'ELITE', 219.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 35세 → 35세 ~ 39세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'BEGINNER', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'NOVICE', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'INTERMEDIATE', 130.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'ADVANCED', 173.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 35, 39, 'MALE', 'ELITE', 219.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 40세 → 40세 ~ 44세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'BEGINNER', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'NOVICE', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'INTERMEDIATE', 130.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'ADVANCED', 173.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 40, 44, 'MALE', 'ELITE', 219.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 45세 → 45세 ~ 49세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'BEGINNER', 61.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'NOVICE', 89.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'INTERMEDIATE', 123.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'ADVANCED', 164.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 45, 49, 'MALE', 'ELITE', 208.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 50세 → 50세 ~ 54세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'BEGINNER', 57.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'NOVICE', 83.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'INTERMEDIATE', 115.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'ADVANCED', 153.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 50, 54, 'MALE', 'ELITE', 194.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 55세 → 55세 ~ 59세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'BEGINNER', 52.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'NOVICE', 76.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'INTERMEDIATE', 106.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'ADVANCED', 141.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 55, 59, 'MALE', 'ELITE', 179.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 60세 → 60세 ~ 64세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'BEGINNER', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'NOVICE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'INTERMEDIATE', 97.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'ADVANCED', 129.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 60, 64, 'MALE', 'ELITE', 164.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 65세 → 65세 ~ 69세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'BEGINNER', 43.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'NOVICE', 63.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'INTERMEDIATE', 88.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'ADVANCED', 117.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 65, 69, 'MALE', 'ELITE', 148.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 70세 → 70세 ~ 74세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'BEGINNER', 39.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'NOVICE', 57.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'INTERMEDIATE', 79.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'ADVANCED', 105.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 70, 74, 'MALE', 'ELITE', 133.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 75세 → 75세 ~ 79세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'BEGINNER', 35.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'NOVICE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'INTERMEDIATE', 71.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'ADVANCED', 94.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 75, 79, 'MALE', 'ELITE', 119.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 80세 → 80세 ~ 84세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'BEGINNER', 31.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'NOVICE', 46.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'INTERMEDIATE', 63.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'ADVANCED', 84.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 80, 84, 'MALE', 'ELITE', 107.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 85세 → 85세 ~ 89세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'BEGINNER', 28.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'NOVICE', 41.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'INTERMEDIATE', 57.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'ADVANCED', 76.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 85, 89, 'MALE', 'ELITE', 96.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

-- 나이 90세 → 90세 ~ 999세
INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'BEGINNER', 25.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'NOVICE', 37.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'INTERMEDIATE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'ADVANCED', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, standard_type, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 'AGE', NULL, NULL, 90, 999, 'MALE', 'ELITE', 86.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '스쿼트' OR e.name_en = 'Barbell Squat' ON CONFLICT DO NOTHING;
