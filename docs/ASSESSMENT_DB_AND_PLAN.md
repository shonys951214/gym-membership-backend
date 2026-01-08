# 초기평가/정기평가 DB 구조 및 상세 계획

> **이 문서는 계속 수정하면서 최종 계획을 세우는 문서입니다.**  
> 고정적인 영역과 수정/추가해야 될 영역을 구분하여 작성했습니다.

---

## 📋 목차

1. [고정 영역](#고정-영역)
   - [DB 구조](#db-구조)
   - [현재 구현 상태](#현재-구현-상태)
   - [핵심 원칙](#핵심-원칙)
2. [수정/추가 영역](#수정추가-영역)
   - [초기 평가 세부항목 정의](#초기-평가-세부항목-정의)
   - [정기 평가 세부항목 정의](#정기-평가-세부항목-정의)
   - [점수 환산 메커니즘](#점수-환산-메커니즘)
   - [개발 우선순위](#개발-우선순위)
   - [환산 테이블 구조](#환산-테이블-구조)

---

## 🔒 고정 영역

### DB 구조

#### 1. `assessments` 테이블 (평가)

**목적**: 회원의 평가 정보를 저장 (초기 평가, 정기 평가)

| 컬럼명               | 타입      | 설명                   | 제약조건                                 |
| -------------------- | --------- | ---------------------- | ---------------------------------------- |
| `id`                 | UUID      | 기본키                 | PK                                       |
| `member_id`          | UUID      | 회원 ID                | FK → members.id                          |
| `assessment_type`   | ENUM      | 평가 유형              | INITIAL, PERIODIC                        |
| `evaluation_type`   | ENUM      | 평가 위계              | STATIC, DYNAMIC (nullable)               |
| `static_evaluation`  | JSONB     | 정적 평가 데이터       | nullable                                 |
| `dynamic_evaluation`| JSONB     | 동적 평가 데이터       | nullable                                 |
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

#### 2. `assessment_items` 테이블 (평가 항목)

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
| `details`       | JSONB        | 상세 정보| nullable (추가 메타데이터)                               |
| `created_at`    | TIMESTAMP    | 생성일시 |                                                           |

**인덱스:**
- `idx_assessment_items_assessment_id` (assessment_id)
- `idx_assessment_items_category` (category)

**관계:**
- `assessments` 테이블과 Many-to-One 관계

---

#### 3. `ability_snapshots` 테이블 (능력치 스냅샷) ⭐

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

### 현재 구현 상태

#### ✅ 완료된 기능

1. **기본 평가 시스템**
   - 초기 평가 생성 (INITIAL)
   - 정기 평가 생성 (PERIODIC)
   - 평가 항목 저장 (AssessmentItem)
   - 능력치 스냅샷 생성 (AbilitySnapshot)
   - 레이더 차트 데이터 API (`GET /api/members/:id/abilities/hexagon`)

2. **레이더 차트 (현재 구현)**
   - 6개 축 고정 (하체 근력, 심폐 지구력, 근지구력, 유연성, 체성분 밸런스, 부상 안정성)
   - 점수 표시 (0-100점)
   - 최신 스냅샷 기준 레이더 차트 표시
   - 초기 vs 현재 비교 기능 (`?compare=true`)

3. **가중치 시스템**
   - 현재 가중치 (코드 기준):
     - 부상 안정성: 20% (최우선)
     - 심폐 지구력: 20%
     - 근지구력: 20%
     - 하체 근력: 15%
     - 체성분 밸런스: 15%
     - 유연성: 10%

4. **점수 계산**
   - `ScoreCalculator` 서비스를 통한 카테고리별 점수 계산
   - 종합 점수 계산 (가중치 적용)
   - 부상 제한 영역 제외 처리

---

### 핵심 원칙

#### 1. 평가의 본질

**평가 종목은 '정확한 수치'보다 회원에게 운동을 시켜도 되는지를 판단하는 도구**

- ❌ "누가 제일 세냐?"
- ✅ "이 사람이 지금 뭘 해도 되는 상태인가?"
- ✅ "어떻게 움직이고, 무엇을 시켜야 하는가?"

**현장은 안전 → 기능 → 체력 → 결과 순으로 테스트를 고른다**

#### 2. 2단계 평가 레이어 구조

**초기 평가 레이더 차트는 '요약 지표'로 고정하고, 정기 평가의 상세 데이터들을 '초기 평가 항목으로 환산'해 누적 반영한다**

- 초기 평가 = 공통 언어 (6개 축 고정)
- 정기 평가 = 데이터 원천 (상세 지표 확장 가능)
- 초기 평가도 1회차 정기 평가로 취급

#### 3. Layer 1: 상위 평가 축 (고정) - 레이더 차트용

**6대 영역 (절대 변경 불가)**:
1. 하체 근력 (STRENGTH)
2. 심폐 지구력 (CARDIO)
3. 근지구력 (ENDURANCE)
4. 유연성 (FLEXIBILITY)
5. 체성분 밸런스 (BODY)
6. 부상 안정성 (STABILITY)

**특징**:
- 레이더 차트 전용
- 서비스의 "공용 언어"
- 초기 평가에서 정의, 이후 변경 없음
- 모든 평가에서 동일한 기준으로 계산

#### 4. Layer 2: 하위 상세 지표 (가변) - 그래프 차트용

**정기 평가에서 늘어나는 항목들**:
- 하체 근력: 레그프레스 10RM, 스쿼트 5RM, 데드리프트 3RM, 점프 파워, 좌/우 밸런스
- 심폐 지구력: VO2max, 러닝머신 테스트, 자전거 테스트
- 근지구력: 플랭크 시간, 푸쉬업 횟수, 버피 테스트
- 유연성: 좌전굴, 어깨 가동, 고관절 가동
- 체성분: 인바디 세부 지표
- 안정성: OHSA, Y-Balance, 한 발 서기

**특징**:
- 그래프 차트용
- 비교 분석용
- AI 분석 재료
- 확장 가능

---

## ✏️ 수정/추가 영역

> **이 영역은 계속 수정하면서 최종 계획을 세우는 영역입니다.**

### 초기 평가 세부항목 정의

**목적**: 초기 평가에서 측정할 필수 항목들을 정의

**현재 상태**: ⚠️ 미정의 (추후 추가 예정)

**제안 항목** (수정 가능):

```typescript
// src/common/constants/initial-assessment-items.ts (신규 생성 예정)
export const INITIAL_ASSESSMENT_ITEMS = {
  [Category.STRENGTH]: [
    '스쿼트 패턴',      // 기능적 움직임 평가
    '체어 스탠드',      // 하체 근력 기본 평가
  ],
  [Category.CARDIO]: [
    '스텝 테스트',      // 심폐 지구력 기본 평가
  ],
  [Category.ENDURANCE]: [
    '플랭크',          // 코어 지구력
    '푸쉬업',          // 상체 지구력
  ],
  [Category.FLEXIBILITY]: [
    '좌전굴',          // 하체 유연성
    '어깨 가동',        // 상체 유연성
    '고관절 가동',      // 고관절 유연성
  ],
  [Category.BODY]: [
    '인바디',          // 체성분 평가
  ],
  [Category.STABILITY]: [
    'OHSA',           // Overhead Squat Assessment (기능적 움직임 평가)
  ],
};
```

**검토 사항**:
- [ ] 각 카테고리별 필수 항목이 적절한가?
- [ ] 항목명이 명확한가?
- [ ] 추가/삭제할 항목이 있는가?

---

### 정기 평가 세부항목 정의

**목적**: 정기 평가에서 측정할 상세 항목들을 정의

**현재 상태**: ⚠️ 미정의 (추후 추가 예정)

**제안 항목** (수정 가능):

```typescript
// src/common/constants/periodic-assessment-items.ts (신규 생성 예정)
export const PERIODIC_ASSESSMENT_ITEMS = {
  [Category.STRENGTH]: [
    '레그프레스 10RM',  // 하체 근력 상세 평가
    '스쿼트 5RM',      // 하체 근력 상세 평가
    '데드리프트 3RM',   // 전신 근력 평가
    '점프 파워',        // 폭발력 평가
    '좌/우 밸런스',     // 좌우 균형 평가
  ],
  [Category.CARDIO]: [
    'VO2max',          // 최대 산소 섭취량
    '러닝머신 테스트',   // 유산소 능력
    '자전거 테스트',     // 유산소 능력
  ],
  [Category.ENDURANCE]: [
    '플랭크 시간',      // 코어 지구력 (초기 평가보다 상세)
    '푸쉬업 횟수',      // 상체 지구력 (초기 평가보다 상세)
    '버피 테스트',      // 전신 지구력
  ],
  [Category.FLEXIBILITY]: [
    '좌전굴',          // 하체 유연성 (초기 평가와 동일)
    '어깨 가동',        // 상체 유연성 (초기 평가와 동일)
    '고관절 가동',      // 고관절 유연성 (초기 평가와 동일)
  ],
  [Category.BODY]: [
    '인바디',          // 체성분 평가 (초기 평가와 동일)
  ],
  [Category.STABILITY]: [
    'OHSA',           // 기능적 움직임 평가 (초기 평가와 동일)
    'Y-Balance',      // 동적 균형 평가
    '한 발 서기',      // 정적 균형 평가
  ],
};
```

**검토 사항**:
- [ ] 각 카테고리별 상세 항목이 적절한가?
- [ ] 초기 평가 항목과의 차별점이 명확한가?
- [ ] 추가/삭제할 항목이 있는가?

---

### 점수 환산 메커니즘

**목적**: 정기 평가의 상세 항목들을 Layer 1 (6개 축) 점수로 환산하는 메커니즘

**현재 상태**: ⚠️ 설계 단계 (추후 구현 예정)

**제안 구조** (수정 가능):

#### 1. 환산 프로세스

```
정기 평가 상세 항목 (Layer 2)
    ↓
항목별 점수 계산 (0-100점)
    ↓
카테고리별 가중 평균
    ↓
Layer 1 점수 (6개 축)
    ↓
레이더 차트 표시
```

#### 2. 환산 예시

**하체 근력 카테고리 예시**:

```
정기 평가 항목:
- 레그프레스 10RM: 80kg → 75점
- 스쿼트 5RM: 60kg → 70점
- 데드리프트 3RM: 100kg → 80점

가중치:
- 레그프레스: 30%
- 스쿼트: 40%
- 데드리프트: 30%

계산:
하체 근력 점수 = (75 × 0.3) + (70 × 0.4) + (80 × 0.3) = 74.5점
```

**검토 사항**:
- [ ] 환산 프로세스가 적절한가?
- [ ] 가중치가 적절한가?
- [ ] 추가 고려사항이 있는가?

---

### 환산 테이블 구조

**목적**: 정기 평가 항목을 Layer 1 점수로 환산하는 규칙을 저장

**현재 상태**: ⚠️ 미구현 (추후 추가 예정)

**제안 테이블 구조** (수정 가능):

```sql
-- assessment_conversion_rules 테이블 (신규 생성 예정)
CREATE TABLE assessment_conversion_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  
  -- Layer 2 정보
  source_category VARCHAR(50) NOT NULL,  -- STRENGTH, CARDIO 등
  source_item_name VARCHAR(255) NOT NULL, -- "레그프레스 10RM"
  
  -- Layer 1 정보
  target_category VARCHAR(50) NOT NULL,  -- STRENGTH, CARDIO 등 (보통 동일)
  
  -- 환산 규칙
  weight DECIMAL(5,2) NOT NULL,          -- 가중치 (0.00 ~ 1.00)
  formula_type VARCHAR(50),               -- "linear", "logarithmic" 등
  formula_params JSONB,                  -- 공식 파라미터
  
  -- 메타데이터
  is_active BOOLEAN DEFAULT true,
  version VARCHAR(50) DEFAULT 'v1',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_conversion_rules_source 
ON assessment_conversion_rules(source_category, source_item_name);

CREATE INDEX idx_conversion_rules_target 
ON assessment_conversion_rules(target_category);
```

**예시 데이터**:

```sql
INSERT INTO assessment_conversion_rules (
  source_category, source_item_name, target_category, weight, formula_type
) VALUES
  ('STRENGTH', '레그프레스 10RM', 'STRENGTH', 0.3, 'linear'),
  ('STRENGTH', '스쿼트 5RM', 'STRENGTH', 0.4, 'linear'),
  ('STRENGTH', '데드리프트 3RM', 'STRENGTH', 0.3, 'linear');
```

**검토 사항**:
- [ ] 테이블 구조가 적절한가?
- [ ] 필요한 필드가 모두 포함되어 있는가?
- [ ] 추가 필드가 필요한가?

---

### 개발 우선순위

**현재 상태**: Phase 1 완료, Phase 2부터 진행 예정

**제안 우선순위** (수정 가능):

#### Phase 2: 초기 평가 세부항목 정의 (중요) ⭐⭐

**예상 작업 시간**: 2-3주  
**영향도**: 중간 (새로운 기능 추가)

**작업 내용**:
1. 초기 평가 항목 정의 (상수 파일)
2. 평가 항목별 점수 계산 기준 정의
3. 초기 평가 검증 로직
4. 연령/성별 기준표 테이블 생성 (DB 마이그레이션)

**파일**:
- `src/common/constants/initial-assessment-items.ts` (신규)
- `src/common/utils/assessment-item-scorer.ts` (신규)
- `database/migrations/create_assessment_standards.sql` (신규)

---

#### Phase 3: 정기 평가 세부항목 및 환산 메커니즘 (중요) ⭐⭐⭐

**예상 작업 시간**: 3-4주  
**영향도**: 높음 (핵심 기능)

**작업 내용**:
1. 정기 평가 항목 정의 (상수 파일)
2. 환산 테이블 생성 (DB 마이그레이션)
3. 환산 로직 구현
4. 정기 평가 항목별 점수 계산 기준 정의

**파일**:
- `src/common/constants/periodic-assessment-items.ts` (신규)
- `src/common/utils/assessment-converter.ts` (신규)
- `database/migrations/create_assessment_conversion_rules.sql` (신규)

---

#### Phase 4: 그래프 차트 및 상세 시각화 (중간) ⭐

**예상 작업 시간**: 2-3주  
**영향도**: 중간 (UI 개선)

**작업 내용**:
1. 정기 평가 항목별 라인 차트 API
2. 상세 항목 비교 API
3. 프론트엔드 그래프 차트 컴포넌트

**API**:
- `GET /api/members/:id/abilities/history/detailed` (신규)
- `GET /api/members/:id/assessments/:id/items` (신규)

---

#### Phase 5: 평가 기준표 및 등급 체계 (낮음) 

**예상 작업 시간**: 2-3주  
**영향도**: 낮음 (추가 기능)

**작업 내용**:
1. 평가 기준표 데이터 입력
2. 등급 체계 정의 (상/중/하 등)
3. 등급 표시 API

---

**검토 사항**:
- [ ] 우선순위가 적절한가?
- [ ] 작업 시간 추정이 적절한가?
- [ ] 추가 Phase가 필요한가?

---

## 📝 검토 체크리스트

### 초기 평가 세부항목
- [ ] 각 카테고리별 필수 항목이 적절한가?
- [ ] 항목명이 명확한가?
- [ ] 추가/삭제할 항목이 있는가?

### 정기 평가 세부항목
- [ ] 각 카테고리별 상세 항목이 적절한가?
- [ ] 초기 평가 항목과의 차별점이 명확한가?
- [ ] 추가/삭제할 항목이 있는가?

### 점수 환산 메커니즘
- [ ] 환산 프로세스가 적절한가?
- [ ] 가중치가 적절한가?
- [ ] 추가 고려사항이 있는가?

### 환산 테이블 구조
- [ ] 테이블 구조가 적절한가?
- [ ] 필요한 필드가 모두 포함되어 있는가?
- [ ] 추가 필드가 필요한가?

### 개발 우선순위
- [ ] 우선순위가 적절한가?
- [ ] 작업 시간 추정이 적절한가?
- [ ] 추가 Phase가 필요한가?

---

## 🔗 관련 문서

- [ASSESSMENT_GUIDE.md](ASSESSMENT_GUIDE.md) - 평가 가이드 (상세)
- [2차개발방향.md](2차개발방향.md) - 개발 방향
- [BACKEND_FUTURE_DEVELOPMENT.md](BACKEND_FUTURE_DEVELOPMENT.md) - 이후 개발 사항
- [ABILITY_DB_STRUCTURE.md](ABILITY_DB_STRUCTURE.md) - DB 구조 상세

---

**작성일**: 2024-01-XX  
**최종 수정일**: 2024-01-XX  
**상태**: 검토 중

