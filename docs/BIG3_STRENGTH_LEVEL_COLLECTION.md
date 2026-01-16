# 빅3 운동 Strength Level 기준 데이터 수동 수집 가이드

> **목적**: 벤치프레스, 스쿼트, 데드리프트의 Strength Level 기준 데이터를 수동으로 수집

---

## 📋 빅3 운동 목록

1. **벤치프레스** (Bench Press - Powerlifting)
2. **스쿼트** (Barbell Squat)
3. **데드리프트** (Barbell Deadlift)

**주의**: 데이터베이스에 저장된 실제 영문명을 사용합니다.

---

## 🔍 1단계: strengthlevel.com에서 데이터 찾기

### 벤치프레스 (Bench Press - Powerlifting)

1. **사이트 접속**: https://strengthlevel.com/strength-standards/bench-press
2. **테이블 확인**: 페이지 중앙의 "Strength Standards" 테이블 확인
3. **데이터베이스 영문명**: `Bench Press - Powerlifting`
4. **데이터 구조**:
   - **체중 범위**: Bodyweight 컬럼 (예: 50-60kg, 60-70kg 등)
   - **성별**: Gender 컬럼 (Male / Female)
   - **레벨**: Beginner, Novice, Intermediate, Advanced, Elite 컬럼
   - **기준 무게**: 각 레벨별 무게 (kg)

### 스쿼트 (Barbell Squat)

1. **사이트 접속**: https://strengthlevel.com/strength-standards/squat
2. **데이터베이스 영문명**: `Barbell Squat`
3. 동일한 방식으로 데이터 수집

### 데드리프트 (Barbell Deadlift)

1. **사이트 접속**: https://strengthlevel.com/strength-standards/deadlift
2. **데이터베이스 영문명**: `Barbell Deadlift`
3. 동일한 방식으로 데이터 수집

---

## 📊 2단계: 데이터 수집 형식

각 운동마다 다음 정보를 수집합니다:

### 데이터 구조

| 체중 범위 | 성별 | Beginner | Novice | Intermediate | Advanced | Elite |
|----------|------|----------|--------|--------------|----------|-------|
| 50-60kg  | Male | 35.0kg   | 45.0kg | 60.0kg       | 80.0kg   | 100.0kg |
| 50-60kg  | Female | 20.0kg | 30.0kg | 40.0kg       | 55.0kg   | 70.0kg |
| 60-70kg  | Male | ...      | ...    | ...          | ...      | ... |

### 체중 범위 파싱 규칙

- **범위 형식**: `50-60kg` → `bodyweight_min: 50.0`, `bodyweight_max: 60.0`
- **이상 형식**: `100kg+` → `bodyweight_min: 100.0`, `bodyweight_max: 999.0`
- **단일 값**: `50kg` → `bodyweight_min: 50.0`, `bodyweight_max: 50.0`

### 성별 변환

- `Male` → `MALE`
- `Female` → `FEMALE`

### 레벨 변환

- `Beginner` → `BEGINNER`
- `Novice` → `NOVICE`
- `Intermediate` → `INTERMEDIATE`
- `Advanced` → `ADVANCED`
- `Elite` → `ELITE`

---

## 📝 3단계: SQL 파일에 추가

### 파일 위치
`database/addExercise.sql`

### SQL 형식

각 운동별로 다음 형식으로 추가:

```sql
-- ============================================
-- 벤치프레스 (Bench Press) Strength Standards
-- ============================================

-- 남성, 50-60kg 체중, BEGINNER
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    e.id,
    50.0,
    60.0,
    'MALE',
    'BEGINNER',
    35.0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM exercises e 
WHERE e.name_en = 'Bench Press'
ON CONFLICT DO NOTHING;

-- 남성, 50-60kg 체중, NOVICE
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    e.id,
    50.0,
    60.0,
    'MALE',
    'NOVICE',
    45.0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM exercises e 
WHERE e.name_en = 'Bench Press'
ON CONFLICT DO NOTHING;

-- ... (나머지 레벨들도 동일한 형식으로 추가)

-- 여성 데이터도 동일한 형식으로 추가
-- ... (Female → 'FEMALE'로 변환)

-- 다른 체중 범위도 동일한 형식으로 추가
-- ... (60-70kg, 70-80kg 등)
```

---

## 🎯 빅3 운동별 수집 체크리스트

### 벤치프레스 (Bench Press)

- [ ] 남성 데이터 수집
  - [ ] 모든 체중 범위
  - [ ] 모든 레벨 (BEGINNER ~ ELITE)
- [ ] 여성 데이터 수집
  - [ ] 모든 체중 범위
  - [ ] 모든 레벨 (BEGINNER ~ ELITE)
- [ ] SQL 파일에 추가
- [ ] 데이터 검증

### 스쿼트 (Squat)

- [ ] 남성 데이터 수집
  - [ ] 모든 체중 범위
  - [ ] 모든 레벨 (BEGINNER ~ ELITE)
- [ ] 여성 데이터 수집
  - [ ] 모든 체중 범위
  - [ ] 모든 레벨 (BEGINNER ~ ELITE)
- [ ] SQL 파일에 추가
- [ ] 데이터 검증

### 데드리프트 (Deadlift)

- [ ] 남성 데이터 수집
  - [ ] 모든 체중 범위
  - [ ] 모든 레벨 (BEGINNER ~ ELITE)
- [ ] 여성 데이터 수집
  - [ ] 모든 체중 범위
  - [ ] 모든 레벨 (BEGINNER ~ ELITE)
- [ ] SQL 파일에 추가
- [ ] 데이터 검증

---

## 📋 Excel 템플릿 (선택적)

데이터를 Excel에서 정리한 후 SQL로 변환할 수 있습니다:

| 운동명(영문) | 체중Min | 체중Max | 성별 | 레벨 | 무게(kg) |
|-------------|---------|---------|------|------|----------|
| Bench Press | 50.0    | 60.0    | MALE | BEGINNER | 35.0 |
| Bench Press | 50.0    | 60.0    | MALE | NOVICE | 45.0 |
| Bench Press | 50.0    | 60.0    | MALE | INTERMEDIATE | 60.0 |
| ... | ... | ... | ... | ... | ... |

---

## ✅ 4단계: 데이터 검증

### SQL 실행 후 검증 쿼리

```sql
-- 빅3 운동별 기준 데이터 개수 확인
SELECT 
    e.name_en,
    s.gender,
    COUNT(*) as standard_count
FROM strength_standards s
JOIN exercises e ON s.exercise_id = e.id
WHERE e.name_en IN ('Bench Press', 'Squat', 'Deadlift')
GROUP BY e.name_en, s.gender
ORDER BY e.name_en, s.gender;

-- 벤치프레스 상세 데이터 확인
SELECT 
    s.bodyweight_min,
    s.bodyweight_max,
    s.gender,
    s.level,
    s.weight_kg
FROM strength_standards s
JOIN exercises e ON s.exercise_id = e.id
WHERE e.name_en = 'Bench Press'
ORDER BY s.gender, s.bodyweight_min, s.level;

-- 예상 결과:
-- 각 운동당 약 50-100개의 기준 데이터 (체중 범위 × 성별 × 레벨)
```

---

## 💡 팁

### 1. 효율적인 수집 방법

1. **Excel 사용**: 
   - 테이블 데이터를 Excel에 복사
   - 필요한 컬럼만 추출
   - SQL 생성 수식 사용

2. **단계별 수집**:
   - 먼저 한 운동(벤치프레스) 완전히 수집
   - SQL 형식 확인 후 나머지 운동 수집

### 2. 데이터 정확성

- strengthlevel.com의 정확한 값을 사용
- 체중 범위와 무게 단위 확인 (kg)
- 성별과 레벨 대소문자 확인

### 3. SQL 생성 자동화

Excel에서 다음 수식을 사용하여 SQL 자동 생성:

```
="INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, "&B2&", "&C2&", '"&D2&"', '"&E2&"', "&F2&", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name_en = '"&A2&"' ON CONFLICT DO NOTHING;"
```

---

## 📝 예시: 벤치프레스 데이터 샘플

```sql
-- ============================================
-- 벤치프레스 (Bench Press) Strength Standards
-- ============================================

-- 남성, 50-60kg, BEGINNER
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'BEGINNER', 35.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name_en = 'Bench Press' ON CONFLICT DO NOTHING;

-- 남성, 50-60kg, NOVICE
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'NOVICE', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name_en = 'Bench Press' ON CONFLICT DO NOTHING;

-- 남성, 50-60kg, INTERMEDIATE
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'INTERMEDIATE', 60.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name_en = 'Bench Press' ON CONFLICT DO NOTHING;

-- 남성, 50-60kg, ADVANCED
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'ADVANCED', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name_en = 'Bench Press' ON CONFLICT DO NOTHING;

-- 남성, 50-60kg, ELITE
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'ELITE', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name_en = 'Bench Press' ON CONFLICT DO NOTHING;

-- 여성, 50-60kg, BEGINNER
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'FEMALE', 'BEGINNER', 20.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name_en = 'Bench Press' ON CONFLICT DO NOTHING;

-- ... (나머지 체중 범위와 레벨도 동일한 형식으로 추가)
```

**주의**: 위 숫자는 예시입니다. strengthlevel.com에서 실제 값을 확인하세요.

---

## 🔗 빠른 링크

- **벤치프레스**: https://strengthlevel.com/strength-standards/bench-press
- **스쿼트**: https://strengthlevel.com/strength-standards/squat
- **데드리프트**: https://strengthlevel.com/strength-standards/deadlift

---

## ✅ 완료 후 확인

빅3 운동 데이터 수집 완료 후:

```sql
-- 빅3 운동 기준 데이터 확인
SELECT 
    e.name_en,
    s.gender,
    COUNT(DISTINCT CONCAT(s.bodyweight_min, '-', s.bodyweight_max)) as weight_ranges,
    COUNT(*) as total_standards
FROM strength_standards s
JOIN exercises e ON s.exercise_id = e.id
WHERE e.name_en IN ('Bench Press', 'Squat', 'Deadlift')
GROUP BY e.name_en, s.gender
ORDER BY e.name_en, s.gender;
```

**예상 결과**: 각 운동당 성별별로 약 10-20개의 체중 범위 × 5개 레벨 = 50-100개의 기준 데이터

---

**작성일**: 2026-01-16  
**상태**: 빅3 운동 수동 수집 가이드 준비 완료
