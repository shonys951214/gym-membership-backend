# 운동 데이터베이스 비교 분석

> **목적**: free-exercise-db vs exercisedb-api 비교 및 현재 프로젝트 구조에 적합한 선택

---

## 📊 두 데이터베이스 비교

### 1. free-exercise-db (yuhonas/free-exercise-db)

**GitHub**: https://github.com/yuhonas/free-exercise-db

#### 특징
- **운동 개수**: 800+ exercises
- **형식**: JSON 파일 (개별 파일 또는 통합 파일)
- **라이선스**: Unlicense (Public Domain) - 완전 자유 사용
- **접근 방식**: GitHub에서 직접 다운로드
- **프론트엔드**: 검색 가능한 웹 인터페이스 제공

#### 데이터 구조
```json
{
  "id": "Alternate_Incline_Dumbbell_Curl",
  "name": "Alternate Incline Dumbbell Curl",
  "force": "pull",
  "level": "beginner",
  "mechanic": "isolation",
  "equipment": "dumbbell",
  "primaryMuscles": ["biceps"],
  "secondaryMuscles": ["forearms"],
  "instructions": ["..."],
  "category": "strength",
  "images": ["Alternate_Incline_Dumbbell_Curl/0.jpg"]
}
```

#### 장점
- ✅ **완전 무료 및 자유 사용** (Public Domain)
- ✅ **간단한 구조** - 필요한 정보만 포함
- ✅ **직접 다운로드 가능** - API 의존성 없음
- ✅ **오프라인 사용 가능**
- ✅ **GitHub에서 직접 접근** - 버전 관리 용이
- ✅ **이미지 포함** - 운동 이미지 제공

#### 단점
- ❌ 운동 개수가 상대적으로 적음 (800개)
- ❌ Strength Level 기준 데이터 없음
- ❌ 일부 필드가 null일 수 있음 (force, mechanic, equipment)

---

### 2. exercisedb-api (ExerciseDB/exercisedb-api)

**GitHub**: https://github.com/ExerciseDB/exercisedb-api

#### 특징
- **운동 개수**: 11,000+ exercises
- **형식**: REST API
- **라이선스**: AGPL-3.0 (오픈소스이지만 제약 있음)
- **접근 방식**: API 호출 필요
- **문서**: https://exercisedb.dev

#### 데이터 구조
```json
{
  "id": "exr_41n2hp76bAhGHCxj",
  "name": "Bench Press",
  "targetMuscles": ["pectorals"],
  "synergistMuscles": ["anterior deltoids", "triceps"],
  "stabilizerMuscles": ["serratus anterior"],
  "equipment": "barbell",
  "instructions": ["..."],
  "exerciseTips": ["..."],
  "variations": ["..."],
  "relatedExerciseIds": ["..."],
  "images": ["..."],
  "video": "...",
  "gif": "..."
}
```

#### 장점
- ✅ **많은 운동 개수** (11,000+)
- ✅ **상세한 정보** - targetMuscles, synergistMuscles, stabilizerMuscles
- ✅ **추가 정보** - exerciseTips, variations, relatedExerciseIds
- ✅ **멀티미디어** - video, gif, images
- ✅ **API 제공** - 실시간 데이터 접근

#### 단점
- ❌ **API 의존성** - 네트워크 필요, API 다운 시 사용 불가
- ❌ **라이선스 제약** - AGPL-3.0 (상업적 사용 시 주의)
- ❌ **API 키 필요할 수 있음** (무료/유료 플랜 확인 필요)
- ❌ **오프라인 사용 불가**
- ❌ **Strength Level 기준 데이터 없음**

---

## 🎯 현재 프로젝트 구조 분석

### 현재 exercises 테이블 구조

```typescript
{
  id: UUID
  name: string              // 한글명: "벤치프레스"
  nameEn: string            // 영문명: "Bench Press"
  category: enum            // UPPER, LOWER, FULL_BODY
  bodyPart: string          // "가슴", "등", "어깨", "팔", "하체"
  unit: string              // "kg"
  isActive: boolean
}
```

### 필요한 데이터

1. **운동 기본 정보**:
   - 한글명, 영문명
   - 카테고리 (UPPER/LOWER/FULL_BODY)
   - 부위 (가슴, 등, 어깨, 팔, 하체)

2. **Strength Level 기준 데이터**:
   - 별도로 strengthlevel.com에서 수집
   - 체중 범위별, 성별, 레벨별 기준 무게

### 현재 사용 방식

- `workout_records`: 운동명으로 참조 (exercise_name 필드)
- `workout_routines`: JSONB에 운동명 포함
- `exercises` 테이블: 운동 마스터 데이터 (선택적 참조)

---

## 💡 추천: free-exercise-db

### 추천 이유

#### 1. **프로젝트 구조와 완벽히 일치**

현재 프로젝트가 필요한 정보:
- ✅ 한글명/영문명 → `name`, `nameEn` 매핑 가능
- ✅ 카테고리 → `category` 필드 활용 가능
- ✅ 부위 → `primaryMuscles` → `bodyPart` 변환 가능

**매핑 예시:**
```typescript
// free-exercise-db → 현재 프로젝트
{
  name: "Bench Press" → nameEn: "Bench Press", name: "벤치프레스" (수동 변환)
  category: "strength" → category: "UPPER" (primaryMuscles 기반 판단)
  primaryMuscles: ["pectorals"] → bodyPart: "가슴"
}
```

#### 2. **라이선스 자유도**

- **free-exercise-db**: Public Domain (Unlicense) - 완전 자유 사용
- **exercisedb-api**: AGPL-3.0 - 상업적 사용 시 주의 필요

포트폴리오 프로젝트라도 향후 확장 가능성을 고려하면 Public Domain이 유리합니다.

#### 3. **간단한 통합**

- JSON 파일 직접 다운로드
- 스크립트로 변환하여 DB에 삽입
- API 의존성 없음
- 오프라인 사용 가능

#### 4. **운동 개수 충분**

- 800개는 충분한 수준
- 주요 운동 모두 포함
- Strength Level 기준 데이터는 별도 수집 예정이므로 800개면 충분

#### 5. **이미지 제공**

- 운동 이미지 포함
- GitHub에서 직접 접근 가능
- 추가 이미지 서버 불필요

---

## 🔄 데이터 변환 전략

### free-exercise-db → 현재 프로젝트 구조 변환

#### 1. 카테고리 매핑

```typescript
// primaryMuscles 기반으로 카테고리 판단
function mapCategory(primaryMuscles: string[]): ExerciseCategory {
  const upperBodyMuscles = ['pectorals', 'lats', 'deltoids', 'biceps', 'triceps', 'traps'];
  const lowerBodyMuscles = ['quadriceps', 'hamstrings', 'glutes', 'calves'];
  
  const hasUpper = primaryMuscles.some(m => upperBodyMuscles.includes(m));
  const hasLower = primaryMuscles.some(m => lowerBodyMuscles.includes(m));
  
  if (hasUpper && hasLower) return 'FULL_BODY';
  if (hasUpper) return 'UPPER';
  if (hasLower) return 'LOWER';
  return 'FULL_BODY'; // 기본값
}
```

#### 2. 부위 매핑

```typescript
// primaryMuscles → bodyPart 변환
const muscleToBodyPart: Record<string, string> = {
  'pectorals': '가슴',
  'lats': '등',
  'deltoids': '어깨',
  'biceps': '팔',
  'triceps': '팔',
  'quadriceps': '하체',
  'hamstrings': '하체',
  'glutes': '하체',
  'calves': '하체',
};
```

#### 3. 한글명 변환

- 영문명을 기반으로 한글명 매핑 테이블 생성
- 또는 수동으로 주요 운동만 한글명 추가

---

## 📝 구현 계획

### 단계 1: 데이터 다운로드

```bash
# free-exercise-db 저장소 클론 또는 JSON 파일 다운로드
git clone https://github.com/yuhonas/free-exercise-db.git
# 또는
curl https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json
```

### 단계 2: 변환 스크립트 작성

```typescript
// scripts/convert-free-exercise-db.ts
// free-exercise-db JSON → exercises 테이블 INSERT SQL 변환
```

### 단계 3: 데이터 삽입

```sql
-- 변환된 SQL 실행
\i database/seeds/free_exercise_db_seed.sql
```

---

## ⚠️ exercisedb-api를 선택해야 하는 경우

다음 경우에만 exercisedb-api를 고려:

1. **11,000개 이상의 운동이 절대적으로 필요한 경우**
2. **실시간 API 접근이 필요한 경우**
3. **상세한 근육 정보 (synergist, stabilizer)가 필요한 경우**
4. **비디오/GIF가 필요한 경우**

하지만 현재 프로젝트 구조에서는 이러한 정보가 필수적이지 않습니다.

---

## ✅ 최종 결론

**추천: free-exercise-db**

이유:
1. ✅ 프로젝트 구조와 완벽히 일치
2. ✅ 라이선스 자유도 높음 (Public Domain)
3. ✅ 간단한 통합 (JSON 파일 직접 사용)
4. ✅ 오프라인 사용 가능
5. ✅ 800개 운동으로 충분
6. ✅ 이미지 포함

**다음 단계:**
1. free-exercise-db 데이터 다운로드
2. 변환 스크립트 작성
3. exercises 테이블에 삽입
4. Strength Level 기준 데이터는 별도로 strengthlevel.com에서 수집

---

## 📚 참고 자료

- **free-exercise-db**: https://github.com/yuhonas/free-exercise-db
- **exercisedb-api**: https://github.com/ExerciseDB/exercisedb-api
- **exercisedb-api 문서**: https://exercisedb.dev
