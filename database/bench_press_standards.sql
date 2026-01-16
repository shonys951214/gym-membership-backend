-- ============================================
-- 벤치프레스 (Bench Press - Powerlifting) Strength Standards
-- 체중별 + 나이별 데이터
-- ============================================

-- ============================================
-- 체중별 데이터 (나이 NULL)
-- ============================================
-- 체중 50kg → 40.0kg ~ 54.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 40.0, 54.99, NULL, NULL, 'MALE', 'BEGINNER', 24.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 40.0, 54.99, NULL, NULL, 'MALE', 'NOVICE', 38.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 40.0, 54.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 57.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 40.0, 54.99, NULL, NULL, 'MALE', 'ADVANCED', 79.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 40.0, 54.99, NULL, NULL, 'MALE', 'ELITE', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 55kg → 50.0kg ~ 54.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 54.99, NULL, NULL, 'MALE', 'BEGINNER', 29.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 54.99, NULL, NULL, 'MALE', 'NOVICE', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 54.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 54.99, NULL, NULL, 'MALE', 'ADVANCED', 87.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 54.99, NULL, NULL, 'MALE', 'ELITE', 113.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 60kg → 55.0kg ~ 59.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 55.0, 59.99, NULL, NULL, 'MALE', 'BEGINNER', 34.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 55.0, 59.99, NULL, NULL, 'MALE', 'NOVICE', 51.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 55.0, 59.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 72.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 55.0, 59.99, NULL, NULL, 'MALE', 'ADVANCED', 96.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 55.0, 59.99, NULL, NULL, 'MALE', 'ELITE', 123.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 65kg → 60.0kg ~ 64.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 64.99, NULL, NULL, 'MALE', 'BEGINNER', 39.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 64.99, NULL, NULL, 'MALE', 'NOVICE', 57.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 64.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 79.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 64.99, NULL, NULL, 'MALE', 'ADVANCED', 104.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 64.99, NULL, NULL, 'MALE', 'ELITE', 132.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 70kg → 65.0kg ~ 69.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 65.0, 69.99, NULL, NULL, 'MALE', 'BEGINNER', 44.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 65.0, 69.99, NULL, NULL, 'MALE', 'NOVICE', 62.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 65.0, 69.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 85.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 65.0, 69.99, NULL, NULL, 'MALE', 'ADVANCED', 112.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 65.0, 69.99, NULL, NULL, 'MALE', 'ELITE', 141.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 75kg → 70.0kg ~ 74.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 70.0, 74.99, NULL, NULL, 'MALE', 'BEGINNER', 49.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 70.0, 74.99, NULL, NULL, 'MALE', 'NOVICE', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 70.0, 74.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 92.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 70.0, 74.99, NULL, NULL, 'MALE', 'ADVANCED', 119.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 70.0, 74.99, NULL, NULL, 'MALE', 'ELITE', 149.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 80kg → 75.0kg ~ 79.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 75.0, 79.99, NULL, NULL, 'MALE', 'BEGINNER', 53.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 75.0, 79.99, NULL, NULL, 'MALE', 'NOVICE', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 75.0, 79.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 75.0, 79.99, NULL, NULL, 'MALE', 'ADVANCED', 127.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 75.0, 79.99, NULL, NULL, 'MALE', 'ELITE', 157.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 85kg → 80.0kg ~ 84.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 80.0, 84.99, NULL, NULL, 'MALE', 'BEGINNER', 58.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 80.0, 84.99, NULL, NULL, 'MALE', 'NOVICE', 79.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 80.0, 84.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 105.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 80.0, 84.99, NULL, NULL, 'MALE', 'ADVANCED', 134.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 80.0, 84.99, NULL, NULL, 'MALE', 'ELITE', 165.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 90kg → 85.0kg ~ 89.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 85.0, 89.99, NULL, NULL, 'MALE', 'BEGINNER', 62.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 85.0, 89.99, NULL, NULL, 'MALE', 'NOVICE', 84.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 85.0, 89.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 111.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 85.0, 89.99, NULL, NULL, 'MALE', 'ADVANCED', 141.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 85.0, 89.99, NULL, NULL, 'MALE', 'ELITE', 172.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 95kg → 90.0kg ~ 94.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 90.0, 94.99, NULL, NULL, 'MALE', 'BEGINNER', 67.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 90.0, 94.99, NULL, NULL, 'MALE', 'NOVICE', 89.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 90.0, 94.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 116.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 90.0, 94.99, NULL, NULL, 'MALE', 'ADVANCED', 147.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 90.0, 94.99, NULL, NULL, 'MALE', 'ELITE', 180.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 100kg → 95.0kg ~ 99.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 95.0, 99.99, NULL, NULL, 'MALE', 'BEGINNER', 71.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 95.0, 99.99, NULL, NULL, 'MALE', 'NOVICE', 94.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 95.0, 99.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 122.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 95.0, 99.99, NULL, NULL, 'MALE', 'ADVANCED', 153.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 95.0, 99.99, NULL, NULL, 'MALE', 'ELITE', 187.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 105kg → 100.0kg ~ 104.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 100.0, 104.99, NULL, NULL, 'MALE', 'BEGINNER', 75.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 100.0, 104.99, NULL, NULL, 'MALE', 'NOVICE', 99.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 100.0, 104.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 128.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 100.0, 104.99, NULL, NULL, 'MALE', 'ADVANCED', 160.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 100.0, 104.99, NULL, NULL, 'MALE', 'ELITE', 194.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 110kg → 105.0kg ~ 109.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 105.0, 109.99, NULL, NULL, 'MALE', 'BEGINNER', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 105.0, 109.99, NULL, NULL, 'MALE', 'NOVICE', 104.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 105.0, 109.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 133.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 105.0, 109.99, NULL, NULL, 'MALE', 'ADVANCED', 166.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 105.0, 109.99, NULL, NULL, 'MALE', 'ELITE', 200.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 115kg → 110.0kg ~ 114.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 110.0, 114.99, NULL, NULL, 'MALE', 'BEGINNER', 84.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 110.0, 114.99, NULL, NULL, 'MALE', 'NOVICE', 109.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 110.0, 114.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 138.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 110.0, 114.99, NULL, NULL, 'MALE', 'ADVANCED', 172.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 110.0, 114.99, NULL, NULL, 'MALE', 'ELITE', 207.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 120kg → 115.0kg ~ 119.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 115.0, 119.99, NULL, NULL, 'MALE', 'BEGINNER', 88.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 115.0, 119.99, NULL, NULL, 'MALE', 'NOVICE', 113.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 115.0, 119.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 143.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 115.0, 119.99, NULL, NULL, 'MALE', 'ADVANCED', 177.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 115.0, 119.99, NULL, NULL, 'MALE', 'ELITE', 213.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 125kg → 120.0kg ~ 124.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 120.0, 124.99, NULL, NULL, 'MALE', 'BEGINNER', 92.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 120.0, 124.99, NULL, NULL, 'MALE', 'NOVICE', 118.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 120.0, 124.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 148.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 120.0, 124.99, NULL, NULL, 'MALE', 'ADVANCED', 183.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 120.0, 124.99, NULL, NULL, 'MALE', 'ELITE', 219.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 130kg → 125.0kg ~ 129.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 125.0, 129.99, NULL, NULL, 'MALE', 'BEGINNER', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 125.0, 129.99, NULL, NULL, 'MALE', 'NOVICE', 122.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 125.0, 129.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 153.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 125.0, 129.99, NULL, NULL, 'MALE', 'ADVANCED', 188.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 125.0, 129.99, NULL, NULL, 'MALE', 'ELITE', 225.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 135kg → 130.0kg ~ 134.99kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 130.0, 134.99, NULL, NULL, 'MALE', 'BEGINNER', 99.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 130.0, 134.99, NULL, NULL, 'MALE', 'NOVICE', 126.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 130.0, 134.99, NULL, NULL, 'MALE', 'INTERMEDIATE', 158.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 130.0, 134.99, NULL, NULL, 'MALE', 'ADVANCED', 194.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 130.0, 134.99, NULL, NULL, 'MALE', 'ELITE', 231.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 체중 140kg → 135.0kg ~ 999.0kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 135.0, 999.0, NULL, NULL, 'MALE', 'BEGINNER', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 135.0, 999.0, NULL, NULL, 'MALE', 'NOVICE', 130.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 135.0, 999.0, NULL, NULL, 'MALE', 'INTERMEDIATE', 163.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 135.0, 999.0, NULL, NULL, 'MALE', 'ADVANCED', 199.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 135.0, 999.0, NULL, NULL, 'MALE', 'ELITE', 236.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- ============================================
-- 나이별 데이터 (체중 범위 0.0 ~ 999.0)
-- ============================================
-- 나이 15세 → 15세 ~ 19세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 15, 19, 'MALE', 'BEGINNER', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 15, 19, 'MALE', 'NOVICE', 59.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 15, 19, 'MALE', 'INTERMEDIATE', 84.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 15, 19, 'MALE', 'ADVANCED', 113.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 15, 19, 'MALE', 'ELITE', 144.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 20세 → 20세 ~ 24세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 20, 24, 'MALE', 'BEGINNER', 46.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 20, 24, 'MALE', 'NOVICE', 68.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 20, 24, 'MALE', 'INTERMEDIATE', 96.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 20, 24, 'MALE', 'ADVANCED', 129.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 20, 24, 'MALE', 'ELITE', 164.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 25세 → 25세 ~ 29세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 25, 29, 'MALE', 'BEGINNER', 47.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 25, 29, 'MALE', 'NOVICE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 25, 29, 'MALE', 'INTERMEDIATE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 25, 29, 'MALE', 'ADVANCED', 132.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 25, 29, 'MALE', 'ELITE', 169.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 30세 → 30세 ~ 34세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 30, 34, 'MALE', 'BEGINNER', 47.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 30, 34, 'MALE', 'NOVICE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 30, 34, 'MALE', 'INTERMEDIATE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 30, 34, 'MALE', 'ADVANCED', 132.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 30, 34, 'MALE', 'ELITE', 169.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 35세 → 35세 ~ 39세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 35, 39, 'MALE', 'BEGINNER', 47.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 35, 39, 'MALE', 'NOVICE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 35, 39, 'MALE', 'INTERMEDIATE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 35, 39, 'MALE', 'ADVANCED', 132.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 35, 39, 'MALE', 'ELITE', 169.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 40세 → 40세 ~ 44세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 40, 44, 'MALE', 'BEGINNER', 47.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 40, 44, 'MALE', 'NOVICE', 70.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 40, 44, 'MALE', 'INTERMEDIATE', 98.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 40, 44, 'MALE', 'ADVANCED', 132.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 40, 44, 'MALE', 'ELITE', 169.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 45세 → 45세 ~ 49세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 45, 49, 'MALE', 'BEGINNER', 44.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 45, 49, 'MALE', 'NOVICE', 66.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 45, 49, 'MALE', 'INTERMEDIATE', 93.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 45, 49, 'MALE', 'ADVANCED', 125.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 45, 49, 'MALE', 'ELITE', 160.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 50세 → 50세 ~ 54세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 50, 54, 'MALE', 'BEGINNER', 42.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 50, 54, 'MALE', 'NOVICE', 62.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 50, 54, 'MALE', 'INTERMEDIATE', 87.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 50, 54, 'MALE', 'ADVANCED', 117.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 50, 54, 'MALE', 'ELITE', 149.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 55세 → 55세 ~ 59세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 55, 59, 'MALE', 'BEGINNER', 38.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 55, 59, 'MALE', 'NOVICE', 57.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 55, 59, 'MALE', 'INTERMEDIATE', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 55, 59, 'MALE', 'ADVANCED', 108.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 55, 59, 'MALE', 'ELITE', 138.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 60세 → 60세 ~ 64세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 60, 64, 'MALE', 'BEGINNER', 35.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 60, 64, 'MALE', 'NOVICE', 52.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 60, 64, 'MALE', 'INTERMEDIATE', 73.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 60, 64, 'MALE', 'ADVANCED', 99.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 60, 64, 'MALE', 'ELITE', 126.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 65세 → 65세 ~ 69세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 65, 69, 'MALE', 'BEGINNER', 32.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 65, 69, 'MALE', 'NOVICE', 47.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 65, 69, 'MALE', 'INTERMEDIATE', 66.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 65, 69, 'MALE', 'ADVANCED', 89.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 65, 69, 'MALE', 'ELITE', 114.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 70세 → 70세 ~ 74세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 70, 74, 'MALE', 'BEGINNER', 29.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 70, 74, 'MALE', 'NOVICE', 42.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 70, 74, 'MALE', 'INTERMEDIATE', 60.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 70, 74, 'MALE', 'ADVANCED', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 70, 74, 'MALE', 'ELITE', 103.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 75세 → 75세 ~ 79세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 75, 79, 'MALE', 'BEGINNER', 26.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 75, 79, 'MALE', 'NOVICE', 38.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 75, 79, 'MALE', 'INTERMEDIATE', 54.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 75, 79, 'MALE', 'ADVANCED', 72.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 75, 79, 'MALE', 'ELITE', 92.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 80세 → 80세 ~ 84세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 80, 84, 'MALE', 'BEGINNER', 23.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 80, 84, 'MALE', 'NOVICE', 34.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 80, 84, 'MALE', 'INTERMEDIATE', 48.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 80, 84, 'MALE', 'ADVANCED', 64.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 80, 84, 'MALE', 'ELITE', 82.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 85세 → 85세 ~ 89세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 85, 89, 'MALE', 'BEGINNER', 20.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 85, 89, 'MALE', 'NOVICE', 30.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 85, 89, 'MALE', 'INTERMEDIATE', 43.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 85, 89, 'MALE', 'ADVANCED', 58.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 85, 89, 'MALE', 'ELITE', 74.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

-- 나이 90세 → 90세 ~ 999세
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 90, 999, 'MALE', 'BEGINNER', 18.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 90, 999, 'MALE', 'NOVICE', 27.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 90, 999, 'MALE', 'INTERMEDIATE', 39.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 90, 999, 'MALE', 'ADVANCED', 52.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, age_min, age_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 0.0, 999.0, 90, 999, 'MALE', 'ELITE', 66.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스' OR e.name_en = 'Bench Press - Powerlifting' ON CONFLICT DO NOTHING;
