# free-exercise-db 통합 가이드

> **목적**: free-exercise-db 데이터를 현재 프로젝트 exercises 테이블에 통합하는 방법

---

## 📋 개요

[free-exercise-db](https://github.com/yuhonas/free-exercise-db)는 800+ 운동 데이터를 제공하는 Public Domain 데이터셋입니다. 이 가이드는 이 데이터를 현재 프로젝트 구조에 맞게 변환하고 삽입하는 방법을 설명합니다.

---

## 🚀 빠른 시작

### 1단계: 데이터 다운로드

**방법 1: 저장소 클론 (권장)**
```bash
cd ..
git clone https://github.com/yuhonas/free-exercise-db.git
```

**방법 2: JSON 파일 직접 다운로드**
```bash
curl -o exercises.json https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json
```

### 2단계: 변환 스크립트 실행

```bash
# TypeScript 실행 환경 확인
npm install -g ts-node typescript

# 스크립트 실행
ts-node scripts/convert-free-exercise-db.ts ../free-exercise-db/dist/exercises.json database/seeds/free_exercise_db_seed.sql
```

### 3단계: 데이터베이스에 삽입

```sql
\i database/seeds/free_exercise_db_seed.sql
```

---

## 📊 데이터 매핑

### free-exercise-db → 현재 프로젝트

| free-exercise-db | 현재 프로젝트 | 변환 방법 |
|-----------------|-------------|---------|
| `name` | `nameEn` | 그대로 사용 |
| - | `name` | 영문명 → 한글명 매핑 (주요 운동만) |
| `primaryMuscles` | `category` | 근육 기반 판단 (UPPER/LOWER/FULL_BODY) |
| `primaryMuscles` | `bodyPart` | 근육 → 부위 매핑 (가슴/등/어깨/팔/하체) |
| - | `unit` | 고정값: 'kg' |
| - | `isActive` | 고정값: true |

### 카테고리 매핑 로직

```typescript
// 상체 근육
upperBodyMuscles = ['pectorals', 'lats', 'deltoids', 'biceps', 'triceps', ...]

// 하체 근육
lowerBodyMuscles = ['quadriceps', 'hamstrings', 'glutes', 'calves', ...]

// 판단 로직
if (hasUpper && hasLower) → 'FULL_BODY'
else if (hasUpper) → 'UPPER'
else if (hasLower) → 'LOWER'
else → 'FULL_BODY' (기본값)
```

### 부위 매핑

```typescript
muscleToBodyPart = {
  'pectorals': '가슴',
  'lats': '등',
  'deltoids': '어깨',
  'biceps': '팔',
  'triceps': '팔',
  'quadriceps': '하체',
  'hamstrings': '하체',
  'glutes': '하체',
  'calves': '하체',
  ...
}
```

---

## 🔧 수동 조정

### 한글명 추가

스크립트는 주요 운동만 한글명을 매핑합니다. 추가 한글명이 필요하면:

1. `scripts/convert-free-exercise-db.ts`의 `nameEnToName` 객체에 추가
2. 또는 생성된 SQL 파일에서 수동으로 수정

### 부위 매핑 수정

특정 운동의 부위가 잘못 매핑된 경우:

1. `scripts/convert-free-exercise-db.ts`의 `muscleToBodyPart` 객체 수정
2. 또는 생성된 SQL 파일에서 수동으로 수정

---

## ✅ 검증

### 데이터 확인

```sql
-- 전체 운동 개수 확인
SELECT COUNT(*) FROM exercises;

-- 카테고리별 개수
SELECT category, COUNT(*) 
FROM exercises 
GROUP BY category;

-- 부위별 개수
SELECT body_part, COUNT(*) 
FROM exercises 
WHERE body_part IS NOT NULL
GROUP BY body_part;

-- 한글명이 없는 운동 확인
SELECT name_en 
FROM exercises 
WHERE name = name_en;
```

### 예상 결과

- **전체 운동**: 약 800개
- **카테고리 분포**: UPPER, LOWER, FULL_BODY
- **부위 분포**: 가슴, 등, 어깨, 팔, 하체

---

## 🔄 업데이트

free-exercise-db가 업데이트되면:

1. 저장소 최신 버전으로 업데이트
2. 변환 스크립트 재실행
3. 기존 데이터와 병합 또는 교체

**병합 방법:**
```sql
-- 기존 데이터는 유지하고 새 데이터만 추가
-- ON CONFLICT DO NOTHING으로 중복 방지
```

---

## ⚠️ 주의사항

1. **한글명 부족**: 대부분의 운동은 영문명만 있습니다. 필요시 수동으로 추가하세요.

2. **부위 매핑 오류**: 근육 기반 자동 매핑이 완벽하지 않을 수 있습니다. 검증 후 수정하세요.

3. **카테고리 판단**: primaryMuscles 기반으로 판단하므로 일부 운동이 잘못 분류될 수 있습니다.

4. **Strength Level 데이터**: 이 데이터는 Strength Level 기준 데이터를 포함하지 않습니다. 별도로 strengthlevel.com에서 수집해야 합니다.

---

## 📚 참고 자료

- **free-exercise-db**: https://github.com/yuhonas/free-exercise-db
- **프론트엔드**: https://yuhonas.github.io/free-exercise-db/
- **데이터 탐색**: https://lite.datasette.io/

---

## 🎯 다음 단계

1. ✅ free-exercise-db 데이터 통합
2. ⏳ Strength Level 기준 데이터 수집 (strengthlevel.com)
3. ⏳ 운동 이미지 통합 (선택적)
