# free-exercise-db 선택적 필터링 가이드

> **목적**: 필요한 운동만 선택적으로 변환하여 데이터베이스에 삽입하는 방법

---

## 🎯 개요

free-exercise-db의 800+ 운동 중에서 필요한 것만 선택적으로 가져올 수 있습니다. 카테고리, 장비, 레벨, 부위 등으로 필터링할 수 있습니다.

---

## 📋 필터링 옵션

### 1. 카테고리 필터

```bash
# 상체 운동만
ts-node scripts/convert-free-exercise-db.ts --category=UPPER

# 하체 운동만
ts-node scripts/convert-free-exercise-db.ts --category=LOWER

# 전신 운동만
ts-node scripts/convert-free-exercise-db.ts --category=FULL_BODY

# 여러 카테고리
ts-node scripts/convert-free-exercise-db.ts --category=UPPER,LOWER
```

### 2. 장비 필터

```bash
# 바벨 운동만
ts-node scripts/convert-free-exercise-db.ts --equipment=barbell

# 덤벨 운동만
ts-node scripts/convert-free-exercise-db.ts --equipment=dumbbell

# 맨몸 운동만
ts-node scripts/convert-free-exercise-db.ts --equipment=bodyweight

# 여러 장비
ts-node scripts/convert-free-exercise-db.ts --equipment=barbell,dumbbell
```

**사용 가능한 장비:**
- `barbell` - 바벨
- `dumbbell` - 덤벨
- `bodyweight` - 맨몸
- `cable` - 케이블
- `machine` - 머신
- `kettlebell` -ettlebell
- `bands` - 밴드
- `medicine ball` - 메디신볼
- `other` - 기타

### 3. 레벨 필터

```bash
# 초보자용 운동만
ts-node scripts/convert-free-exercise-db.ts --level=beginner

# 중급자용 운동만
ts-node scripts/convert-free-exercise-db.ts --level=intermediate

# 전문가용 운동만
ts-node scripts/convert-free-exercise-db.ts --level=expert

# 여러 레벨
ts-node scripts/convert-free-exercise-db.ts --level=beginner,intermediate
```

### 4. 부위 필터

```bash
# 가슴 운동만
ts-node scripts/convert-free-exercise-db.ts --body-part=가슴

# 등 운동만
ts-node scripts/convert-free-exercise-db.ts --body-part=등

# 여러 부위
ts-node scripts/convert-free-exercise-db.ts --body-part=가슴,등,어깨
```

**사용 가능한 부위:**
- `가슴`
- `등`
- `어깨`
- `팔`
- `하체`
- `복부`

### 5. 최소 근육 개수 필터

```bash
# primaryMuscles가 2개 이상인 운동만
ts-node scripts/convert-free-exercise-db.ts --min-muscles=2
```

### 6. 복합 필터

여러 필터를 조합하여 사용할 수 있습니다:

```bash
# 초보자용 상체 바벨 운동만
ts-node scripts/convert-free-exercise-db.ts \
  --category=UPPER \
  --equipment=barbell \
  --level=beginner

# 가슴과 등 운동 중 덤벨 운동만
ts-node scripts/convert-free-exercise-db.ts \
  --body-part=가슴,등 \
  --equipment=dumbbell
```

---

## 💡 실전 예시

### 예시 1: 헬스장 기본 운동만 (바벨 + 덤벨)

```bash
ts-node scripts/convert-free-exercise-db.ts \
  --equipment=barbell,dumbbell \
  --output=database/seeds/gym_basic_exercises.sql
```

**결과**: 헬스장에서 주로 사용하는 바벨/덤벨 운동만 추출

### 예시 2: 초보자용 맨몸 운동

```bash
ts-node scripts/convert-free-exercise-db.ts \
  --equipment=bodyweight \
  --level=beginner \
  --output=database/seeds/beginner_bodyweight.sql
```

**결과**: 초보자가 집에서 할 수 있는 맨몸 운동만 추출

### 예시 3: 상체 근력 운동 (가슴, 등, 어깨)

```bash
ts-node scripts/convert-free-exercise-db.ts \
  --category=UPPER \
  --body-part=가슴,등,어깨 \
  --output=database/seeds/upper_body_strength.sql
```

**결과**: 상체 근력 운동만 추출

### 예시 4: 하체 운동 (바벨 + 머신)

```bash
ts-node scripts/convert-free-exercise-db.ts \
  --category=LOWER \
  --equipment=barbell,machine \
  --output=database/seeds/lower_body.sql
```

**결과**: 하체 운동만 추출 (바벨과 머신 사용)

---

## 📊 필터링 전략

### 전략 1: 단계별 추가

1. **1단계**: 기본 운동만 (빅3 + 주요 운동)
   ```bash
   # 수동으로 주요 운동만 추가 (기존 exercises_seed.sql 사용)
   ```

2. **2단계**: 카테고리별 추가
   ```bash
   # 상체 운동 추가
   ts-node scripts/convert-free-exercise-db.ts --category=UPPER
   
   # 하체 운동 추가
   ts-node scripts/convert-free-exercise-db.ts --category=LOWER
   ```

3. **3단계**: 필요에 따라 추가
   ```bash
   # 특정 장비나 레벨의 운동 추가
   ```

### 전략 2: 한 번에 필요한 것만

```bash
# 프로젝트에 필요한 운동만 한 번에 추출
ts-node scripts/convert-free-exercise-db.ts \
  --category=UPPER,LOWER \
  --equipment=barbell,dumbbell,bodyweight \
  --level=beginner,intermediate \
  --output=database/seeds/essential_exercises.sql
```

### 전략 3: 배치 스크립트 사용

```bash
# 여러 시드 파일 한 번에 생성
bash scripts/generate-exercise-seeds.sh
```

이 스크립트는 다음 파일들을 생성합니다:
- `basic_exercises.sql` - 기본 운동 (바벨)
- `upper_body_exercises.sql` - 상체 운동
- `lower_body_exercises.sql` - 하체 운동
- `barbell_exercises.sql` - 바벨 운동
- `dumbbell_exercises.sql` - 덤벨 운동
- `bodyweight_exercises.sql` - 맨몸 운동
- `beginner_exercises.sql` - 초보자용 운동

---

## 🔍 필터링 결과 확인

변환 후 통계를 확인하세요:

```sql
-- 전체 운동 개수
SELECT COUNT(*) FROM exercises;

-- 카테고리별 개수
SELECT category, COUNT(*) 
FROM exercises 
GROUP BY category
ORDER BY category;

-- 부위별 개수
SELECT body_part, COUNT(*) 
FROM exercises 
WHERE body_part IS NOT NULL
GROUP BY body_part
ORDER BY body_part;
```

---

## 🌐 API에서도 필터링 가능

변환된 데이터를 API에서도 필터링할 수 있습니다:

```typescript
// 카테고리로 필터링
GET /api/exercises?category=UPPER

// 부위로 필터링
GET /api/exercises?bodyPart=가슴

// 검색어로 필터링
GET /api/exercises?search=bench

// 복합 필터
GET /api/exercises?category=UPPER&bodyPart=가슴&search=press

// 페이징
GET /api/exercises?page=1&limit=20

// 비활성화된 운동 포함
GET /api/exercises?isActive=false
```

---

## ⚙️ 고급 사용법

### 여러 SQL 파일 생성

필터를 다르게 하여 여러 SQL 파일을 생성할 수 있습니다:

```bash
# 상체 운동
ts-node scripts/convert-free-exercise-db.ts \
  --category=UPPER \
  --output=database/seeds/upper_body.sql

# 하체 운동
ts-node scripts/convert-free-exercise-db.ts \
  --category=LOWER \
  --output=database/seeds/lower_body.sql

# 전신 운동
ts-node scripts/convert-free-exercise-db.ts \
  --category=FULL_BODY \
  --output=database/seeds/full_body.sql
```

### 커스텀 필터 조합

프로젝트에 맞는 커스텀 필터를 만들 수 있습니다:

```bash
# 예: 헬스장에서 사용 가능한 초보자용 운동
ts-node scripts/convert-free-exercise-db.ts \
  --equipment=barbell,dumbbell,machine \
  --level=beginner,intermediate \
  --output=database/seeds/gym_beginner.sql
```

---

## ⚠️ 주의사항

1. **중복 방지**: `ON CONFLICT DO NOTHING`으로 중복 삽입 방지
2. **한글명 부족**: 대부분의 운동은 영문명만 있습니다. 필요시 수동으로 추가
3. **부위 매핑**: 자동 매핑이 완벽하지 않을 수 있으므로 검증 필요
4. **카테고리 판단**: primaryMuscles 기반으로 판단하므로 일부 오류 가능

---

## 📚 참고 자료

- **전체 통합 가이드**: `docs/FREE_EXERCISE_DB_INTEGRATION.md`
- **비교 분석**: `docs/EXERCISE_DB_COMPARISON.md`
- **free-exercise-db**: https://github.com/yuhonas/free-exercise-db
