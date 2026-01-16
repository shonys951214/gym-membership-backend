# 한글명 추가 가이드

> **목적**: exercises 테이블에서 한글명이 NULL인 운동에 한글명을 추가하는 방법

---

## 한글명이 NULL인 운동 찾기

### 쿼리 1: 전체 목록 조회

```sql
-- 한글명이 NULL인 모든 운동 조회
SELECT 
    id,
    name,           -- NULL
    name_en,        -- 영문명
    category,
    body_part
FROM exercises 
WHERE name IS NULL
ORDER BY name_en
LIMIT 50;
```

### 쿼리 2: 카테고리별 개수 확인

```sql
-- 카테고리별 한글명이 없는 운동 개수
SELECT 
    category,
    COUNT(*) as missing_korean_name_count
FROM exercises 
WHERE name IS NULL
GROUP BY category
ORDER BY category;
```

### 쿼리 3: 부위별 개수 확인

```sql
-- 부위별 한글명이 없는 운동 개수
SELECT 
    body_part,
    COUNT(*) as missing_korean_name_count
FROM exercises 
WHERE name IS NULL
    AND body_part IS NOT NULL
GROUP BY body_part
ORDER BY body_part;
```

---

## 한글명 추가 방법

### 방법 1: 개별 업데이트

```sql
-- 특정 운동의 한글명 추가
UPDATE exercises
SET name = '벤치프레스'
WHERE name_en = 'Bench Press' AND name IS NULL;

-- 여러 운동 한 번에 업데이트
UPDATE exercises
SET name = '스쿼트'
WHERE name_en = 'Squat' AND name IS NULL;

UPDATE exercises
SET name = '데드리프트'
WHERE name_en = 'Deadlift' AND name IS NULL;
```

### 방법 2: 일괄 업데이트 (CASE 문 사용)

```sql
-- 주요 운동들의 한글명 일괄 추가
UPDATE exercises
SET name = CASE name_en
    WHEN 'Bench Press' THEN '벤치프레스'
    WHEN 'Squat' THEN '스쿼트'
    WHEN 'Deadlift' THEN '데드리프트'
    WHEN 'Overhead Press' THEN '오버헤드 프레스'
    WHEN 'Shoulder Press' THEN '숄더 프레스'
    WHEN 'Barbell Curl' THEN '바벨 컬'
    WHEN 'Dumbbell Curl' THEN '덤벨 컬'
    WHEN 'Lat Pulldown' THEN '랫풀다운'
    WHEN 'Bent Over Row' THEN '벤트오버 로우'
    WHEN 'Pull Up' THEN '풀업'
    WHEN 'Push Up' THEN '푸시업'
    WHEN 'Dip' THEN '딥스'
    WHEN 'Leg Press' THEN '레그프레스'
    WHEN 'Leg Curl' THEN '레그 컬'
    WHEN 'Leg Extension' THEN '레그 익스텐션'
    WHEN 'Calf Raise' THEN '카프 레이즈'
    WHEN 'Incline Bench Press' THEN '인클라인 벤치프레스'
    WHEN 'Decline Bench Press' THEN '딥라인 벤치프레스'
    WHEN 'Dumbbell Press' THEN '덤벨 프레스'
    WHEN 'Romanian Deadlift' THEN '루마니안 데드리프트'
    WHEN 'Sumo Deadlift' THEN '스모 데드리프트'
    WHEN 'Front Squat' THEN '프론트 스쿼트'
    WHEN 'Bulgarian Split Squat' THEN '불가리안 스플릿 스쿼트'
    WHEN 'Lunge' THEN '런지'
    ELSE name  -- 이미 한글명이 있으면 유지
END
WHERE name IS NULL
    AND name_en IN (
        'Bench Press', 'Squat', 'Deadlift', 'Overhead Press',
        'Shoulder Press', 'Barbell Curl', 'Dumbbell Curl',
        'Lat Pulldown', 'Bent Over Row', 'Pull Up', 'Push Up',
        'Dip', 'Leg Press', 'Leg Curl', 'Leg Extension',
        'Calf Raise', 'Incline Bench Press', 'Decline Bench Press',
        'Dumbbell Press', 'Romanian Deadlift', 'Sumo Deadlift',
        'Front Squat', 'Bulgarian Split Squat', 'Lunge'
    );
```

### 방법 3: Excel/Google Sheets 활용

1. **데이터 추출**:
   ```sql
   -- CSV로 내보내기
   COPY (
       SELECT id, name, name_en, category, body_part
       FROM exercises
       WHERE name IS NULL
       ORDER BY name_en
   ) TO '/tmp/exercises_missing_korean.csv' WITH CSV HEADER;
   ```

2. **Excel에서 한글명 추가**:
   - `name_en` 컬럼을 참고하여 `name` 컬럼에 한글명 입력
   - 번역 도구 활용 가능

3. **데이터 다시 가져오기**:
   ```sql
   -- CSV에서 읽어서 업데이트
   CREATE TEMP TABLE temp_exercises (
       id UUID,
       name VARCHAR(255),
       name_en VARCHAR(255)
   );

   COPY temp_exercises(id, name, name_en, category, body_part)
   FROM '/tmp/exercises_missing_korean.csv' WITH CSV HEADER;

   UPDATE exercises e
   SET name = t.name
   FROM temp_exercises t
   WHERE e.id = t.id AND e.name IS NULL;
   ```

---

## 진행 상황 확인

### 한글명 추가 전/후 비교

```sql
-- 추가 전: 한글명이 없는 운동 개수
SELECT COUNT(*) as before_count
FROM exercises
WHERE name IS NULL;

-- 한글명 추가 후: 한글명이 없는 운동 개수
SELECT COUNT(*) as after_count
FROM exercises
WHERE name IS NULL;

-- 한글명이 있는 운동 개수
SELECT COUNT(*) as with_korean_name
FROM exercises
WHERE name IS NOT NULL;
```

### 카테고리별 한글명 완성도

```sql
SELECT 
    category,
    COUNT(*) as total,
    COUNT(name) as with_korean_name,
    COUNT(*) - COUNT(name) as missing_korean_name,
    ROUND(COUNT(name)::numeric / COUNT(*)::numeric * 100, 2) as completion_percentage
FROM exercises
GROUP BY category
ORDER BY category;
```

---

## 팁

### 1. 우선순위 설정

주요 운동부터 한글명을 추가하는 것을 권장합니다:

1. **빅3 운동**: 벤치프레스, 스쿼트, 데드리프트
2. **상체 주요 운동**: 오버헤드 프레스, 풀업, 딥스 등
3. **하체 주요 운동**: 레그프레스, 레그 컬, 런지 등
4. **기타 운동**: 나머지 운동들

### 2. 번역 도구 활용

- Google Translate API
- Papago API
- 수동 번역 (정확도 높음)

### 3. 일관성 유지

- 운동명은 일반적으로 사용되는 용어로 통일
- 예: "Bench Press" → "벤치프레스" (띄어쓰기 없음)
- 예: "Pull Up" → "풀업" (하이픈 없음)

---

## 예시: 주요 운동 한글명 추가 스크립트

```sql
-- 주요 운동 한글명 일괄 추가
BEGIN;

UPDATE exercises SET name = '벤치프레스' WHERE name_en = 'Bench Press' AND name IS NULL;
UPDATE exercises SET name = '스쿼트' WHERE name_en = 'Squat' AND name IS NULL;
UPDATE exercises SET name = '데드리프트' WHERE name_en = 'Deadlift' AND name IS NULL;
UPDATE exercises SET name = '오버헤드 프레스' WHERE name_en = 'Overhead Press' AND name IS NULL;
UPDATE exercises SET name = '숄더 프레스' WHERE name_en = 'Shoulder Press' AND name IS NULL;
UPDATE exercises SET name = '바벨 컬' WHERE name_en = 'Barbell Curl' AND name IS NULL;
UPDATE exercises SET name = '덤벨 컬' WHERE name_en = 'Dumbbell Curl' AND name IS NULL;
UPDATE exercises SET name = '랫풀다운' WHERE name_en = 'Lat Pulldown' AND name IS NULL;
UPDATE exercises SET name = '벤트오버 로우' WHERE name_en = 'Bent Over Row' AND name IS NULL;
UPDATE exercises SET name = '풀업' WHERE name_en = 'Pull Up' AND name IS NULL;
UPDATE exercises SET name = '푸시업' WHERE name_en = 'Push Up' AND name IS NULL;
UPDATE exercises SET name = '딥스' WHERE name_en = 'Dip' AND name IS NULL;
UPDATE exercises SET name = '레그프레스' WHERE name_en = 'Leg Press' AND name IS NULL;
UPDATE exercises SET name = '레그 컬' WHERE name_en = 'Leg Curl' AND name IS NULL;
UPDATE exercises SET name = '레그 익스텐션' WHERE name_en = 'Leg Extension' AND name IS NULL;
UPDATE exercises SET name = '카프 레이즈' WHERE name_en = 'Calf Raise' AND name IS NULL;

COMMIT;

-- 결과 확인
SELECT name, name_en, category 
FROM exercises 
WHERE name IS NOT NULL 
ORDER BY name_en 
LIMIT 20;
```

---

**작성일**: 2026-01-16  
**상태**: Phase 0 작업 중
