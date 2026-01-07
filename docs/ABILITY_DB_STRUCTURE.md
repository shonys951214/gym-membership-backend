# 능력치(Ability) 데이터베이스 구조 및 저장 방식

## 📊 데이터 흐름 개요

```
평가 생성 (Assessment)
    ↓
평가 항목 생성 (AssessmentItem) - 여러 개
    ↓
점수 계산 (ScoreCalculator)
    ↓
능력치 스냅샷 생성 (AbilitySnapshot) - 1:1 관계
```

---

## 🗄️ 데이터베이스 테이블 구조

### 1. `assessments` 테이블 (평가)

**목적**: 회원의 평가 정보를 저장 (초기 평가, 정기 평가)

| 컬럼명               | 타입      | 설명                   | 제약조건                                 |
| -------------------- | --------- | ---------------------- | ---------------------------------------- |
| `id`                 | UUID      | 기본키                 | PK                                       |
| `member_id`          | UUID      | 회원 ID                | FK → members.id                          |
| `assessment_type`    | ENUM      | 평가 유형              | INITIAL, PERIODIC, FLEXIBILITY           |
| `evaluation_type`    | ENUM      | 평가 위계              | STATIC, DYNAMIC (nullable)               |
| `static_evaluation`  | JSONB     | 정적 평가 데이터       | nullable                                 |
| `dynamic_evaluation` | JSONB     | 동적 평가 데이터       | nullable                                 |
| `is_initial`         | BOOLEAN   | 초기 평가 여부         | default: false                           |
| `assessed_at`        | DATE      | 평가 날짜              |                                          |
| `trainer_comment`    | TEXT      | 트레이너 코멘트        | nullable                                 |
| `body_weight`        | FLOAT     | 체중 (kg)              | nullable                                 |
| `condition`          | ENUM      | 컨디션                 | EXCELLENT, GOOD, NORMAL, POOR (nullable) |
| `created_at`         | TIMESTAMP | 생성일시               |                                          |
| `updated_at`         | TIMESTAMP | 수정일시               |                                          |
| `deleted_at`         | TIMESTAMP | 삭제일시 (Soft Delete) | nullable                                 |

**인덱스:**

- `idx_assessments_member_id` (member_id)
- `idx_assessments_assessed_at` (assessed_at)
- `idx_assessments_is_initial` (is_initial)
- `idx_assessments_deleted_at` (deleted_at)

**관계:**

- `members` 테이블과 Many-to-One 관계
- `assessment_items` 테이블과 One-to-Many 관계
- `ability_snapshots` 테이블과 One-to-One 관계

---

### 2. `assessment_items` 테이블 (평가 항목)

**목적**: 평가의 세부 항목들을 저장 (예: 스쿼트 10회, 벤치프레스 50kg 등)

| 컬럼명          | 타입         | 설명     | 제약조건                                                  |
| --------------- | ------------ | -------- | --------------------------------------------------------- |
| `id`            | UUID         | 기본키   | PK                                                        |
| `assessment_id` | UUID         | 평가 ID  | FK → assessments.id (CASCADE)                             |
| `category`      | ENUM         | 카테고리 | STRENGTH, CARDIO, ENDURANCE, FLEXIBILITY, BODY, STABILITY |
| `name`          | VARCHAR(255) | 항목명   | 예: "스쿼트", "벤치프레스"                                |
| `value`         | FLOAT        | 측정값   | 예: 10 (회), 50 (kg)                                      |
| `unit`          | VARCHAR(50)  | 단위     | 예: "회", "kg", "분"                                      |
| `score`         | FLOAT        | 점수     | 계산된 점수                                               |
| `created_at`    | TIMESTAMP    | 생성일시 |                                                           |

**인덱스:**

- `idx_assessment_items_assessment_id` (assessment_id)
- `idx_assessment_items_category` (category)

**관계:**

- `assessments` 테이블과 Many-to-One 관계

**예시 데이터:**

```json
{
	"category": "STRENGTH",
	"name": "스쿼트",
	"value": 10,
	"unit": "회",
	"score": 75.5
}
```

---

### 3. `ability_snapshots` 테이블 (능력치 스냅샷) ⭐

**목적**: 평가 항목들을 종합하여 계산된 능력치 점수를 저장

| 컬럼명              | 타입        | 설명               | 제약조건                              |
| ------------------- | ----------- | ------------------ | ------------------------------------- |
| `id`                | UUID        | 기본키             | PK                                    |
| `assessment_id`     | UUID        | 평가 ID            | FK → assessments.id (UNIQUE, CASCADE) |
| `member_id`         | UUID        | 회원 ID            | FK → members.id (CASCADE)             |
| `assessed_at`       | TIMESTAMP   | 평가 시점          |                                       |
| `version`           | VARCHAR(50) | 점수 계산 버전     | 예: "v1"                              |
| `strength_score`    | FLOAT       | 하체 근력 점수     | nullable                              |
| `cardio_score`      | FLOAT       | 심폐 지구력 점수   | nullable                              |
| `endurance_score`   | FLOAT       | 근지구력 점수      | nullable                              |
| `flexibility_score` | FLOAT       | 유연성 점수        | nullable                              |
| `body_score`        | FLOAT       | 체성분 밸런스 점수 | nullable                              |
| `stability_score`   | FLOAT       | 부상 안정성 점수   | nullable                              |
| `total_score`       | FLOAT       | 종합 점수          | **필수**                              |
| `created_at`        | TIMESTAMP   | 생성일시           |                                       |

**인덱스:**

- `idx_ability_snapshots_assessment_id` (assessment_id) - UNIQUE
- `idx_ability_snapshots_member_id` (member_id)
- `idx_ability_snapshots_assessed_at` (assessed_at)

**관계:**

- `assessments` 테이블과 One-to-One 관계 (assessment_id가 UNIQUE)
- `members` 테이블과 Many-to-One 관계

**특징:**

- **1개 평가 = 1개 스냅샷** (1:1 관계)
- 평가가 생성/수정될 때마다 자동으로 스냅샷이 생성/재계산됨
- 부상으로 인해 평가가 제한된 영역은 `null`로 저장됨

---

## 🔄 능력치 점수 계산 프로세스

### 1단계: 평가 항목 생성

```typescript
// 평가 생성 시 여러 개의 평가 항목이 생성됨
AssessmentItem {
  category: "STRENGTH",
  name: "스쿼트",
  value: 10,
  unit: "회",
  score: 75.5  // 계산된 점수
}
```

⚠️ **현재 미구현**: 실제 점수 계산 로직 (표준화 함수)

- 현재는 `value`를 그대로 `score`로 사용
- TODO: 표준화 함수를 통한 실제 점수 계산 필요
- 위치: `src/modules/assessments/assessments.service.ts:149`

### 2단계: 카테고리별 평균 점수 계산

```typescript
// ScoreCalculator.calculateCategoryScores()
// 같은 카테고리의 항목들의 평균 점수를 계산

예시:
- STRENGTH 카테고리: [스쿼트: 75.5, 레그프레스: 80.0] → 평균: 77.75
- CARDIO 카테고리: [러닝머신: 65.0] → 평균: 65.0
```

✅ **구현 완료**: `FLEXIBILITY` 카테고리 계산 로직 포함

- DB 컬럼(`flexibility_score`) 존재
- `calculateCategoryScores()`에서 FLEXIBILITY 케이스 처리
- 카테고리별 평균 점수 계산에 포함

### 3단계: 부상 제한 영역 제외

```typescript
// ScoreCalculator.excludeRestrictedCategories()
// 부상이 있는 영역은 null로 처리

예시:
- 무릎 부상 → STRENGTH 카테고리 → strengthScore = null
- 어깨 부상 → STRENGTH 카테고리 → strengthScore = null
```

✅ **구현 완료**: `FLEXIBILITY` 카테고리 부상 제한 처리 포함

- `excludeRestrictedCategories()`에서 FLEXIBILITY 케이스 처리
- 부상으로 인한 평가 제한 시 null로 처리

### 4단계: 종합 점수 계산 (가중 평균)

```typescript
// ScoreCalculator.calculateTotalScore()
// 가중치:
// - 근력(STRENGTH): 30%
// - 심폐(CARDIO): 25%
// - 지구력(ENDURANCE): 20%
// - 체성분(BODY): 15%
// - 안정성(STABILITY): 10%
// - 유연성(FLEXIBILITY): ⚠️ 현재 가중치 없음 (추후 추가 예정)

// null 값은 제외하고 계산
totalScore = (strengthScore * 0.3 + cardioScore * 0.25 + ...) / totalWeight
```

✅ **구현 완료**: `FLEXIBILITY` 카테고리 종합 점수 계산 포함

- `flexibility_score`는 DB에 저장되고 종합 점수 계산에 포함됨
- 가중치: 유연성 15% (1차피드백 제안 가중치 반영)
- 가중치가 하드코딩되어 있음 (트레이너별 커스터마이징 불가 - 추후 구현 예정)

### 5단계: 스냅샷 저장

```typescript
// ScoreCalculator.calculateAssessmentScore()
AbilitySnapshot {
  assessmentId: "uuid",
  memberId: "uuid",
  assessedAt: new Date(),
  version: "v1",
  strengthScore: 77.75,
  cardioScore: 65.0,
  enduranceScore: null,  // 부상으로 제외
  flexibilityScore: 70.0,
  bodyScore: 80.0,
  stabilityScore: 75.0,
  totalScore: 73.4  // 가중 평균
}
```

---

## 📈 데이터 저장 시점

### 평가 생성 시 (`POST /api/members/:id/assessments`)

1. **Assessment 생성** → `assessments` 테이블에 저장
2. **AssessmentItem 생성** (여러 개) → `assessment_items` 테이블에 저장
3. **ScoreCalculator 호출** → 점수 계산
4. **AbilitySnapshot 생성** → `ability_snapshots` 테이블에 저장

### 평가 수정 시 (`PUT /api/members/:id/assessments/:id`)

1. **Assessment 수정** → `assessments` 테이블 업데이트
2. **기존 AssessmentItem 삭제** → `assessment_items` 테이블에서 삭제
3. **새 AssessmentItem 생성** → `assessment_items` 테이블에 저장
4. **ScoreCalculator 호출** → 점수 재계산
5. **AbilitySnapshot 업데이트** → `ability_snapshots` 테이블 업데이트 (또는 재생성)

---

## 🔗 테이블 간 관계도

```
members (회원)
  ├── assessments (평가) - One-to-Many
  │     ├── assessment_items (평가 항목) - One-to-Many
  │     └── ability_snapshots (능력치 스냅샷) - One-to-One
  │
  ├── ability_snapshots (능력치 스냅샷) - One-to-Many
  │
  └── injury_histories (부상 이력) - One-to-Many
        └── injury_restrictions (부상 제한) - One-to-Many
              └── (능력치 계산 시 제외)
```

---

## 💾 실제 DB 저장 예시

### 예시 1: 초기 평가 생성

**1. Assessment 저장:**

```sql
INSERT INTO assessments (
  id, member_id, assessment_type, is_initial, assessed_at, created_at
) VALUES (
  'assessment-uuid-1',
  'member-uuid-1',
  'INITIAL',
  true,
  '2024-01-15',
  '2024-01-15 10:00:00'
);
```

**2. AssessmentItem 저장 (여러 개):**

```sql
INSERT INTO assessment_items (
  id, assessment_id, category, name, value, unit, score, created_at
) VALUES
  ('item-uuid-1', 'assessment-uuid-1', 'STRENGTH', '스쿼트', 10, '회', 75.5, '2024-01-15 10:00:00'),
  ('item-uuid-2', 'assessment-uuid-1', 'STRENGTH', '레그프레스', 80, 'kg', 80.0, '2024-01-15 10:00:00'),
  ('item-uuid-3', 'assessment-uuid-1', 'CARDIO', '러닝머신', 20, '분', 65.0, '2024-01-15 10:00:00');
```

**3. AbilitySnapshot 저장 (자동 생성):**

```sql
INSERT INTO ability_snapshots (
  id, assessment_id, member_id, assessed_at, version,
  strength_score, cardio_score, endurance_score, flexibility_score,
  body_score, stability_score, total_score, created_at
) VALUES (
  'snapshot-uuid-1',
  'assessment-uuid-1',
  'member-uuid-1',
  '2024-01-15 10:00:00',
  'v1',
  77.75,  -- STRENGTH 평균: (75.5 + 80.0) / 2
  65.0,   -- CARDIO 평균
  NULL,   -- ENDURANCE 항목 없음
  70.0,   -- FLEXIBILITY 항목
  80.0,   -- BODY 항목
  75.0,   -- STABILITY 항목
  73.4,   -- 가중 평균: (77.75 * 0.3 + 65.0 * 0.25 + ...) / totalWeight
  '2024-01-15 10:00:00'
);
```

---

## 🎯 주요 특징

### 1. 1:1 관계 (Assessment ↔ AbilitySnapshot)

- **1개 평가 = 1개 스냅샷**
- `assessment_id`가 UNIQUE 제약조건
- 평가가 생성/수정될 때마다 스냅샷이 자동 생성/업데이트

### 2. 부상 제한 처리

- 부상이 있는 영역은 `null`로 저장
- 종합 점수 계산 시 `null` 값은 제외
- 부상 완치 시 해당 영역 재평가 가능

### 3. 버전 관리

- `version` 필드로 점수 계산 알고리즘 버전 관리
- 향후 가중치 변경 시 버전 업데이트 가능

### 4. Soft Delete

- `assessments` 테이블은 Soft Delete 사용 (`deleted_at`)
- 평가 삭제는 금지 (데이터 무결성)
- `ability_snapshots`는 CASCADE DELETE로 자동 삭제

---

## 📝 API 엔드포인트와 DB 조회

### `GET /api/members/:id/abilities/latest`

```sql
SELECT * FROM ability_snapshots
WHERE member_id = :memberId
ORDER BY assessed_at DESC
LIMIT 1;
```

### `GET /api/members/:id/abilities/snapshots`

```sql
SELECT * FROM ability_snapshots
WHERE member_id = :memberId
ORDER BY assessed_at DESC;
```

### `GET /api/members/:id/abilities/compare?prev=1`

```sql
SELECT * FROM ability_snapshots
WHERE member_id = :memberId
ORDER BY assessed_at DESC
LIMIT 2;  -- 현재 + 이전 1개
```

### `GET /api/members/:id/abilities/hexagon`

```sql
SELECT * FROM ability_snapshots
WHERE member_id = :memberId
ORDER BY assessed_at DESC
LIMIT 1;
-- 프론트엔드에서 헥사곤 차트용 데이터로 변환
```

### `GET /api/members/:id/abilities/history`

```sql
SELECT * FROM ability_snapshots
WHERE member_id = :memberId
ORDER BY assessed_at ASC;  -- 오래된 순서
```

---

## 🔍 추가 확인 사항

### ✅ 유연성(FLEXIBILITY) 점수 - 구현 완료

**DB 구조**: ✅ 구현 완료

- `ability_snapshots.flexibility_score` 컬럼 존재
- `assessment_items.category`에 FLEXIBILITY 포함

**점수 계산 로직**: ✅ 구현 완료

- `ScoreCalculator.calculateCategoryScores()`에서 FLEXIBILITY 케이스 처리
- `ScoreCalculator.excludeRestrictedCategories()`에서 FLEXIBILITY 케이스 처리
- `ScoreCalculator.calculateTotalScore()`에서 가중치 계산에 포함 (15%)
- `CategoryScores` 인터페이스에 `flexibilityScore` 필드 포함

**결과**:

- `flexibility_score`는 DB에 저장되고 자동 계산됨
- 종합 점수(`total_score`) 계산에 포함됨 (가중치 15%)
- 차트 표시 가능

**참고**:

- 평가 항목의 자세한 계산식(표준화 함수)은 추후 추가 예정 (3순위)
- 현재는 다른 카테고리와 동일하게 `value`를 `score`로 사용

---

### ⚠️ 정적/동적 평가 구분 - 저장만 구현

**DB 구조**: ✅ 구현 완료

- `assessments.evaluation_type` 컬럼 존재 (nullable)
- `assessments.static_evaluation` (JSONB) 컬럼 존재
- `assessments.dynamic_evaluation` (JSONB) 컬럼 존재

**실제 활용**: ❌ 미구현

- 점수 계산 로직에서 사용되지 않음
- 단순히 데이터 저장만 됨
- 프론트엔드에서 표시용으로만 사용 가능

**추후 작업**:

- 정적/동적 평가 데이터를 점수 계산에 활용하는 로직 추가 필요
- 예: `static_evaluation.bodyComposition` 데이터를 `body_score` 계산에 활용

---

### ⚠️ 가중치 커스터마이징 - 미구현

**현재 상태**:

- 가중치가 하드코딩되어 있음 (`ScoreCalculator.calculateTotalScore()`)
- 트레이너별로 가중치를 설정할 수 없음

**1차 피드백 요구사항**:

- 트레이너가 자신만의 가중치를 설정할 수 있어야 함
- 추후 구현 예정 (낮은 우선순위)

**추후 작업**:

- 가중치 설정 테이블 추가 필요
- 트레이너별 가중치 적용 로직 구현 필요

---

## 📚 관련 파일

- **엔티티**: `src/entities/ability-snapshot.entity.ts`
- **서비스**: `src/modules/assessments/assessments.service.ts`
- **점수 계산**: `src/common/utils/score-calculator.ts`
- **컨트롤러**: `src/modules/members/abilities.controller.ts`
