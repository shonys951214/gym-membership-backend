# 초기평가/정기평가 DB 구조 및 상세 계획

> **이 문서는 계속 수정하면서 최종 계획을 세우는 문서입니다.**  
> 고정적인 영역과 수정/추가해야 될 영역을 구분하여 작성했습니다.

## 🧭 전체 흐름 한 줄 요약 (확정본)

**초보자 PT 초기평가를 '시험·재활'에서 분리하고, 트레이너와 회원이 같은 지도를 보며 방향을 정하는 구조로 재설계했다.**

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
3. [개발 시 주의사항 및 통일 규칙](#개발-시-주의사항-및-통일-규칙) ⚠️
4. [프론트엔드 개발 가이드](#프론트엔드-개발-가이드)

---

## 🔒 고정 영역

### DB 구조

> **✅ DB 마이그레이션 완료 상태** (2024-01-XX)  
> 모든 평가 시스템 관련 DB 구조가 추가되었습니다.
>
> - `assessment_items.details` 필드 추가 완료
> - `assessment_items.value`, `unit`, `score` nullable 처리 완료
> - 체성분 평가 기준표, 등급 상수, 카테고리별 점수 매핑, 유연성 가중치 테이블 생성 완료

#### 1. `assessments` 테이블 (평가)

**목적**: 회원의 평가 정보를 저장 (초기 평가, 정기 평가)

| 컬럼명               | 타입      | 설명                   | 제약조건                                 |
| -------------------- | --------- | ---------------------- | ---------------------------------------- |
| `id`                 | UUID      | 기본키                 | PK                                       |
| `member_id`          | UUID      | 회원 ID                | FK → members.id                          |
| `assessment_type`    | ENUM      | 평가 유형              | INITIAL, PERIODIC                        |
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

#### 2. `assessment_items` 테이블 (평가 항목)

**목적**: 평가의 세부 항목들을 저장 (예: 스쿼트 10회, 벤치프레스 50kg 등)

| 컬럼명          | 타입         | 설명      | 제약조건                                                  |
| --------------- | ------------ | --------- | --------------------------------------------------------- |
| `id`            | UUID         | 기본키    | PK                                                        |
| `assessment_id` | UUID         | 평가 ID   | FK → assessments.id (CASCADE)                             |
| `category`      | ENUM         | 카테고리  | STRENGTH, CARDIO, ENDURANCE, FLEXIBILITY, BODY, STABILITY |
| `name`          | VARCHAR(255) | 항목명    | 예: "스쿼트", "벤치프레스"                                |
| `value`         | FLOAT        | 측정값    | 예: 10 (회), 50 (kg), nullable (등급 기반 평가의 경우)    |
| `unit`          | VARCHAR(50)  | 단위      | 예: "회", "kg", "분", nullable                            |
| `score`         | FLOAT        | 점수      | 계산된 점수, nullable (계산 전에는 null)                  |
| `details`       | JSONB        | 상세 정보 | ✅ **추가 완료** (등급, 관찰 포인트, 대체 항목 정보 등)   |
| `created_at`    | TIMESTAMP    | 생성일시  |                                                           |

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
    - **레이더 차트 설계 원칙**:
        - 가중치를 레이더 차트에 적용하지 않음 (가중치는 종합 점수 계산용)
        - 축 최대값 = 중요도로 표현
        - 레이더 값에 ×0.85 적용
        - 중앙 기준선 없음
        - 단일 레이더 차트

3. **가중치 시스템**
    - **종합 점수 계산용 가중치** (레이더 차트 표시용 아님):
        - 부상 안정성: 20% (최우선)
        - 심폐 지구력: 20%
        - 근지구력: 20%
        - 하체 근력: 15%
        - 체성분 밸런스: 15%
        - 유연성: 10%
    - **레이더 차트 축 최대값** (중요도 표현):
        - 부상 안정성: 20
        - 심폐 지구력: 20
        - 근지구력: 20
        - 하체 근력: 15
        - 체성분 밸런스: 15
        - 유연성: 10

4. **점수 계산**
    - `ScoreCalculator` 서비스를 통한 카테고리별 점수 계산
    - 종합 점수 계산 (가중치 적용)
    - 부상 제한 영역 제외 처리

---

### 1️⃣ 초기 상태 — 출발점 정리

**🔹 기본 전제**:

- PT를 처음 받는 회원 대상
- 재활·의학적 테스트 의도적으로 배제
- 결과는 레이더 차트 1개로 표현
- 향후 자동 운동 루틴 연계 전제

**🔹 초기 평가 영역 (변경 없음)**:

1. 하체 근력
2. 심폐 지구력
3. 근지구력
4. 유연성
5. 체성분
6. 안정성

👉 **"무엇을 볼 것인가"는 초기에 이미 명확했음**

**🔹 초기 고민 포인트**:

- 각 영역을 어떻게 점수화할 것인가
- 레이더 차트에 가중치를 적용할 것인가
- 초보자에게 '점수'가 주는 압박을 어떻게 줄일 것인가

---

### 핵심 원칙

#### 1. 평가의 본질

**초보자 PT 초기평가를 "시험·재활"에서 분리하고, 트레이너와 회원이 같은 지도를 보며 방향을 정하는 시스템**

**평가 종목은 '정확한 수치'보다 회원에게 운동을 시켜도 되는지를 판단하는 도구**

- ❌ "누가 제일 세냐?"
- ❌ "평가 = 점수"
- ❌ "잘함/못함 구분"
- ❌ "트레이너·회원 시각 분리"
- ✅ "이 사람이 지금 뭘 해도 되는 상태인가?"
- ✅ "어떻게 움직이고, 무엇을 시켜야 하는가?"
- ✅ "평가 = 현재 위치 파악"
- ✅ "비교 대상 없음"
- ✅ "형태(shape) 중심 해석"
- ✅ "하나의 차트로 공동 판단"

**현장은 안전 → 기능 → 체력 → 결과 순으로 테스트를 고른다**

#### 5️⃣ 철학적 관점의 변화 (핵심)

**❌ 제거된 관점**:

- 평가 = 점수
- 평균 기준선
- 잘함 / 못함
- 트레이너와 회원의 시각 분리

**✅ 확립된 관점**:

- 평가 = 현재 위치 파악
- 비교 대상 ❌
- shape(형태) 중심 해석
- 하나의 차트를 함께 보고 판단

#### 2. 2단계 평가 레이어 구조

**초기 평가 레이더 차트는 '요약 지표'로 고정하고, 정기 평가의 상세 데이터들을 '초기 평가 항목으로 환산'해 누적 반영한다**

- 초기 평가 = 공통 언어 (6개 축 고정)
- 정기 평가 = 데이터 원천 (상세 지표 확장 가능)
- 초기 평가도 1회차 정기 평가로 취급

#### 3. Layer 1: 상위 평가 축 (고정) - 레이더 차트용

**6대 영역 (절대 변경 불가)**:

| 평가 영역   | 축 최대값 |
| ----------- | --------- |
| 안정성      | 20        |
| 심폐 지구력 | 20        |
| 근지구력    | 20        |
| 하체 근력   | 15        |
| 체성분      | 15        |
| 유연성      | 10        |

👉 **숫자가 아니라 형태 자체가 중요도를 말해줌**

**특징**:

- 레이더 차트 전용
- 서비스의 "공용 언어"
- 초기 평가에서 정의, 이후 변경 없음
- 모든 평가에서 동일한 기준으로 계산
- **축 최대값 = 중요도 표현** (가중치와 동일한 비율)
- **레이더 값에 ×0.85 적용** (시각적 표현)
- **중앙 기준선 없음** (비교 대상 제거)
- **단일 레이더 차트** (트레이너와 회원이 함께 보는 판단 지도)

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

### 점수화 설계 공통 원칙

**목적**: 점수 계산의 일관성과 공정성 확보

**철학**:

- 잘함 / 못함 ❌
- 합불 ❌
- **"현재 위치를 수치로 표현"**
- 실패 허용, 대체 항목 인정
- 트레이너는 점수 계산 ❌ → 시스템 처리

**점수 구조 공통 규칙**:

1. **각 축 점수: 0 ~ 100**
    - 모든 카테고리 점수는 0-100 범위로 계산
    - 100점 초과 시 100점으로 제한 (또는 정규화)
    - **레이더 차트 표시 시**: 계산된 점수 × 0.85 적용

2. **축 내부 항목은 상대 비율로 환산**
    - 카테고리 내 여러 항목이 있을 경우, 항목별 비중을 적용하여 가중 평균 계산
    - 예: 체중 스쿼트 40%, 박스 스쿼트 30%, 고블릿 스쿼트 30%

3. **불가 항목 발생 시**
    - ❌ 감점 아님
    - ✅ 대체 항목으로 재계산
    - 예: 체중 스쿼트 불가 → 박스/고블릿 스쿼트로 대체, 비중 재분배

4. **레이더 차트 설계 원칙**
    - 가중치를 레이더 차트에 적용하지 않음 (가중치는 종합 점수 계산용)
    - 축 최대값 = 중요도로 표현 (안정성 20, 심폐 20, 근지구력 20, 하체 근력 15, 체성분 15, 유연성 10)
    - 레이더 값에 ×0.85 적용
    - 중앙 기준선 없음 (비교 대상 제거)
    - 단일 레이더 차트 (트레이너와 회원이 함께 보는 판단 지도)

**현재 구현 상태**: ⚠️ 기본 구조만 존재, 세부 로직 구현 필요

---

### 초기 평가 세부항목 정의

**목적**: 초기 평가에서 측정할 필수 항목들을 정의

**현재 상태**: ⚠️ 미정의 (추후 추가 예정)

**초기 평가 전체 컨셉**:

- **목적**: 운동 시작 레벨 설정 + 위험요소 배제 + 방향성 제시
- **성격**: 시험 ❌ / 합불 ❌ / "지금 위치를 지도에 찍는 것"
- **개입 수준**: 기본 자세 설명 O / 즉각적 교정 최소화 / 받아들이는 능력·가동범위·운동 감각을 관찰
- **총 소요 시간**: 약 35~40분
- **특징**: 일부 실패 허용 / 대체 항목 존재 / 점수 가중치는 DB에만 존재, 트레이너는 해석 자료로만 활용

**제안 항목** (수정 가능):

```typescript
// src/common/constants/initial-assessment-items.ts (신규 생성 예정)
export const INITIAL_ASSESSMENT_ITEMS = {
	[Category.STRENGTH]: [
		"체중 스쿼트", // 기본 (1번)
		"박스 스쿼트", // 대체 (2번) - 체중 스쿼트 불가 시
		"고블릿 스쿼트", // 대체 (3번) - 체중 스쿼트 불가 시
	],
	[Category.CARDIO]: [
		"스텝 테스트", // 단일 항목
	],
	[Category.ENDURANCE]: [
		"플랭크", // 코어 지구력 (1번)
		"수정 플랭크", // 대체 (2번) - 플랭크 실패 시
	],
	[Category.FLEXIBILITY]: [
		"좌전굴", // 하체 유연성 (1번)
		"어깨 가동", // 상체 유연성 (2번)
		"고관절 가동", // 고관절 유연성 (3번)
		"기능적 움직임 기반 유연성", // 연결 동작 (5번)
	],
	[Category.BODY]: [
		"인바디", // 체성분 평가 (B안 채택)
	],
	[Category.STABILITY]: [
		"OHSA", // Overhead Squat Assessment (1번)
		"통증 체크", // 자가 보고 (2번)
	],
};
```

**각 카테고리별 상세 내용**:

#### 1️⃣ 하체 근력 (가중치 15%)

**기본 구조**: 1 → 2 → 3 (단, 체중 스쿼트 불가 시 1번 제외 로직 적용)

**테스트 항목 구성**:

**(1) 체중 스쿼트 (기본)**

- **방법**: 발 간격 자유, 팔 위치 자유, 통제 없이 자연 동작, 5~8회 관찰
- **관찰 포인트** (JSONB `details` 필드에 저장):
    - 힙 힌지 vs 무릎 주도
    - 하강 깊이
    - 무릎 트래킹
    - 상체 기울기
- **불가 기준** (점수 계산에서 제외):
    - 통증 호소
    - 동작 자체 이해 불가
    - 1~2회도 수행 어려움
- **불가 시**: 점수 계산에서 제외 + (2), (3)으로 대체 평가

**(2) 박스 스쿼트 / 체어 스쿼트**

- **방법**: 박스 or 벤치 높이 조절, 엉덩이 터치 후 바로 일어나기
- **의미**: 하체 근력 + 패턴 이해도, 초보자 친화적
- **관찰 포인트**:
    - 체중 이동
    - 엉덩이 주도 여부
    - 반복 안정성

**(3) 고블릿 스쿼트 (가벼운 중량)**

- **방법**: 덤벨 or 케틀벨, 깊이는 자유
- **의미**: 외부 부하에 대한 반응, 코어·하체 협응
- **관찰 포인트**:
    - 상체 안정
    - 하강 시 무게 컨트롤

**다음 단계 (A 단계)**:

- A1: 스쿼트 패턴 재교육
- A2: 하체 기초 볼륨 적응
- A3: 가동범위 확장 + 안정성 병행

**🔹 관점 전환**:

- ❌ "얼마나 센가?"
- ✅ "운동을 시작할 수 있는 상태인가?"

---

#### 2️⃣ 심폐 지구력 (가중치 20%)

**채택 항목**: 스텝 테스트 단일

**테스트 방법**:

- 고정 높이 스텝
- 정해진 리듬
- 일정 시간 수행

**측정 항목** (JSONB `details` 필드에 저장):

- 심박수 변화 (수동 입력 또는 하드웨어 연동)
- 회복 속도
- 주관적 호흡 난이도(RPE)

**의미**: 심폐 능력 절대평가 ❌ / "현재 유산소 적응 상태" 파악

**🔄 보완**:

- 심박수 측정 가능/불가능 환경 모두 고려
- 심박 측정 불가 시 → 수행 지속 시간 + 호흡 회복 관찰로 대체 가능
- 👉 **측정 기술에 종속되지 않는 구조**

**다음 단계 (A 단계)**:

- A1: 호흡 패턴 적응
- A2: 저강도 지속성 운동 설계
- A3: 인터벌 도입 여부 판단

---

#### 3️⃣ 근지구력 (가중치 20%)

**채택 항목**: 1번 + 2번

**테스트 항목**:

**(1) 플랭크**

- **방법**: 정면 플랭크, 시간 측정
- **관찰 포인트**:
    - 허리 위치
    - 호흡 유지
    - 흔들림 발생 시점
- **핵심**: "몇 초까지 버텼는가"가 아니라 **자세 유지 · 흔들림 · 중단 지점 관찰**

**(2) 수정 플랭크 or 변형**

- **의미**: 기본 코어 지구력 확인, 실패 시 대체 가능
- 👉 **잘함/못함 ❌, 현재 위치 기록**

**다음 단계**:

- A1: 코어 유지 능력
- A2: 전신 운동 중 코어 개입
- A3: 볼륨 기반 지구력 향상

---

#### 4️⃣ 유연성 (가중치 10%)

**채택 항목**: 1 / 2 / 3 / 5

**테스트 구성**:

1. 좌전굴
2. 어깨 가동성
3. 고관절 가동성
4. 기능적 움직임 기반 유연성 (연결 동작)

**측정 방식**:

- 각도 or 도달 범위
- 좌우 차이

**의미**: 스트레칭 능력 ❌ / 움직임 제한 구간 파악

- 👉 **일반 동작 기반, 생활·운동 연계 해석 가능**

**다음 단계**:

- A1: 제한 구간 인지
- A2: 워밍업 반영
- A3: 가동범위 + 근력 병행

---

#### 5️⃣ 체성분 (가중치 15%)

**선택**: B안 채택

**핵심 변화**:

- ❌ 인바디 종합 점수 그대로 사용
- ✅ 골격근량 / 체지방량 / 비만도 분해하여 상대 점수화
- 체중 변화 가능성은 점수 미반영, 해석용

**사용 지표** (JSONB `details` 필드에 저장):

- 체중
- 골격근량
- 체지방량
- 비만도

**점수 산정 방식**:

- 인바디 점수 그대로 사용 ❌
- 골격근량/체지방량/비만도를 상대 점수화하여 단일 체성분 점수(0~100) 계산
- 현직 트레이너 실무 기준 반영

**목적**:

- 변화 추적 기준점
- 동기부여 시각자료

**다음 단계**:

- A1: 유지 / 개선 방향 설정
- A2: 목표 재설정 근거 자료
- A3: 정기 평가 비교

---

#### 6️⃣ 안정성 (가중치 20%)

**채택 항목**: 1 + 2 (5번은 1번에 포함된 개념으로 제외)

**테스트 구성**:

**(1) OHSA (Overhead Squat Assessment)**

- **관찰 포인트** (JSONB `details` 필드에 저장):
    - 발–무릎–골반–상체 정렬
    - 좌우 차이
    - 보상 패턴

**(2) 통증 체크 (자가 보고)**

- **방법**: 통증 부위 체크, 동작 중 불편감 확인
- **저장 위치**: `Assessment.staticEvaluation.survey` 또는 `AssessmentItem.details`
- 👉 **"위험 요소 선별"이 목적, 진단 ❌**

**❌ 제거된 항목**:

- 중복 항목
- OHSA에 포함되는 세부 검사

**다음 단계**:

- A1: 위험 동작 회피
- A2: 안정성 우선 루틴 설계
- A3: 추후 교정·강화 병행

---

**전체 흐름 요약 (트레이너 활용 관점)**:

- 평가 = 설명 자료
- 회원에게 "현재 위치" 시각화
- 낮은 축도 문제 ❌ / 방향성
- 정기평가 시 동일 항목 유지
- 근력 세부 비교는 추후 strengthlevel 기준 확장

**❌ 공통 제거 항목**:

- 재활 목적 테스트
- 고위험 최대 수행 테스트
- 의료적 해석이 필요한 지표

**검토 사항**:

- [ ] 각 카테고리별 필수 항목이 적절한가?
- [ ] 항목명이 명확한가?
- [ ] 추가/삭제할 항목이 있는가?
- [ ] 관찰 포인트 저장 방식이 적절한가? (JSONB `details` 필드 활용)

---

### 초기 평가 등급 체계 및 점수화 구조 (확정본)

**목적**: 각 카테고리별 등급 체계, 입력 UI, 점수 계산 방법 정의

**현재 상태**: ⚠️ 설계 완료, 구현 예정 (내일 DB 업데이트 + 계산 로직 구현)

**⚠️ 중요**: 내일 DB 업데이트 및 계산 로직 구현 예정 → 프론트엔드 개발 가이드 포함

---

#### 최종 등급 체계 (전 축 공통)

| 최종 등급 | 의미                  | 내부 점수 기준 |
| --------- | --------------------- | -------------- |
| 안정적    | 현재 강도로 문제 없음 | 80             |
| 무난함    | 시작 가능, 관리 필요  | 60             |
| 제한 있음 | 강도·볼륨 제한 필요   | 40             |
| 준비 필요 | 접근 전략 우선        | 20             |

**⚠️ 내부 점수는 UI 비노출**

- DB 계산용 → 축 최대값 스케일링
- 프론트엔드는 등급만 표시 (안정적/무난함/제한 있음/준비 필요)

#### 1️⃣ 하체 근력 점수화 구조 (최대 15) — ✅ 미세조정 반영

**입력 UI (체크박스/라디오 버튼 기반)**:

**체중 스쿼트 수행 상태** (단일 선택):

- ☐ A. 안정적으로 반복 수행
- ☐ B. 수행 가능, 깊이·정렬 일부 제한
- ☐ C. 수행 가능하나 불안정 / 연속 어려움
- ☐ D. 수행 불가 → 대체 항목

**대체 항목 (D 선택 시)** (단일 선택):

- ☐ D-1. 체어/박스 스쿼트 가능
- ☐ D-2. 보조 있어도 어려움

**최종 등급 & 내부 점수 (조정 완료)**:

| 입력 | 최종 등급 | 내부 점수 |
| ---- | --------- | --------- |
| A    | 안정적    | 80        |
| B    | 무난함    | 60        |
| C    | 제한 있음 | 45        |
| D-1  | 제한 있음 | 30        |
| D-2  | 준비 필요 | 20        |

**특징**:

- ✔ 체중 스쿼트 가능 vs 불가 차이 반영
- ✔ 트레이너 체감과 일치
- 체중 스쿼트가 안 된다고 낮은 점수 확정 ❌
- "운동 경험의 방향성"이 점수에 반영됨

**🔹 관점 전환**:

- ❌ "얼마나 센가?"
- ✅ "운동을 시작할 수 있는 상태인가?"

---

#### 2️⃣ 심폐 지구력 점수화 구조 (최대 20) — ✅ B 구간 세분화

**입력 UI (체크박스/라디오 버튼 기반)**:

**스텝 테스트 수행 상태** (단일 선택):

- ☐ A. 리듬 유지 + 완주
- ☐ B. 리듬 유지
- ☐ C. 조기 중단 / 리듬 붕괴

**추가 체크 (B 선택 시)** (다중 선택 가능):

- ☐ 회복 빠름
- ☐ 회복 느림

**회복 속도 판단 기준 (RPE 기반)**:

- **회복 빠름**: 테스트 종료 후 1분 이내 호흡이 편안해짐
- **회복 느림**: 테스트 종료 후 2분 이상 호흡이 거칠거나 불편함 지속

**최종 등급 & 내부 점수**:

| 입력             | 최종 등급 | 내부 점수 |
| ---------------- | --------- | --------- |
| A                | 안정적    | 80        |
| B + 회복 빠름    | 무난함    | 65        |
| B + 회복 느림    | 무난함    | 55        |
| C                | 제한 있음 | 40        |
| 테스트 거의 불가 | 준비 필요 | 20        |

**특징**:

- ✔ B 구간 몰림 현상 해결
- ✔ 심폐 능력 분산 현실화
- 유산소 "능력" ❌
- 적응 상태 & 회복 능력 중심

---

#### 3️⃣ 근지구력 점수화 구조 (최대 20) — ✅ 유지

**입력 UI (체크박스/라디오 버튼 기반)**:

**플랭크 수행 상태** (단일 선택):

- ☐ A. 자세 안정, 흔들림 거의 없음
- ☐ B. 유지 가능하나 흔들림 있음
- ☐ C. 빠른 붕괴 / 중단

**최종 등급 & 내부 점수**:

| 입력           | 최종 등급 | 내부 점수 |
| -------------- | --------- | --------- |
| A              | 안정적    | 80        |
| B              | 무난함    | 60        |
| C              | 제한 있음 | 40        |
| 거의 유지 불가 | 준비 필요 | 20        |

**특징**:

- ✔ 현장 판단과 완전 일치
- ✔ 추가 조정 불필요
- "몇 초까지 버텼는가"가 아니라 **자세 유지 · 흔들림 · 중단 지점 관찰**

---

#### 4️⃣ 유연성 점수화 구조 (최대 10) — ✅ 종합 로직 수정

**입력 UI (체크박스 기반 - 각 항목별 체크)**:

**입력 항목** (각각 체크):

- ☐ 좌전굴
- ☐ 어깨 가동
- ☐ 고관절 가동
- ☐ (선택) 햄스트링

**각 항목별 평가** (각 항목마다 단일 선택):

- ☐ A. 제한 없음
- ☐ B. 일부 제한
- ☐ C. 명확한 제한

**항목별 중요도 가중치**:

| 항목          | 가중치 | 중요도 |
| ------------- | ------ | ------ |
| 어깨 가동성   | 1.3    | 중요   |
| 고관절 가동성 | 1.2    | 중요   |
| 좌전굴        | 1.0    | 기준   |
| 햄스트링      | 0.8    | 보조   |

**최종 등급 산정 로직 (확정)**:

| 가중치 합 | 최종 등급 | 내부 점수 |
| --------- | --------- | --------- |
| 0         | 안정적    | 80        |
| 1.0 ~ 1.5 | 무난함    | 60        |
| 1.6 ~ 2.5 | 제한 있음 | 40        |
| 2.6 이상  | 준비 필요 | 20        |

**계산 예시**:

- 어깨 C(1.3) + 좌전굴 C(1.0) = 2.3 → 제한 있음 (40점)
- 고관절 C(1.2)만 = 1.2 → 무난함 (60점)
- 어깨 C(1.3) + 고관절 C(1.2) + 좌전굴 C(1.0) = 3.5 → 준비 필요 (20점)

**특징**:

- ✔ 초보자 현실 반영
- ✔ 과도한 하향 방지
- ✔ 항목별 중요도 차이 반영

---

#### 5️⃣ 체성분 점수화 구조 (최대 15) — ✅ 유지

**입력 UI**:

- 트레이너 입력 ❌
- **인바디 수치 입력만** (체중, 골격근량, 체지방량, 비만도)

**⚠️ 참고**: DB에 `members.age` 또는 `members.birth_date` 필드 추가 예정 (내일)

**연령대별 세분화 기준**:

**남성 기준**:

| 연령대    | 체지방률 적정 | 골격근량 충분 | 등급 판정   |
| --------- | ------------- | ------------- | ----------- |
| 20-30대   | 10-18%        | 42% 이상      | 안정적 (80) |
| 30-40대   | 12-20%        | 40% 이상      | 안정적 (80) |
| 40-50대   | 15-22%        | 38% 이상      | 안정적 (80) |
| 50대 이상 | 18-25%        | 35% 이상      | 안정적 (80) |

**여성 기준**:

| 연령대    | 체지방률 적정 | 골격근량 충분 | 등급 판정   |
| --------- | ------------- | ------------- | ----------- |
| 20-30대   | 18-25%        | 32% 이상      | 안정적 (80) |
| 30-40대   | 20-28%        | 30% 이상      | 안정적 (80) |
| 40-50대   | 23-30%        | 28% 이상      | 안정적 (80) |
| 50대 이상 | 25-33%        | 26% 이상      | 안정적 (80) |

**최종 등급 & 내부 점수**:

| 상태 조합                | 최종 등급 | 내부 점수 |
| ------------------------ | --------- | --------- |
| 근육 충분 + 지방 적정    | 안정적    | 80        |
| 한 요소 관리 필요        | 무난함    | 60        |
| 지방 과다 또는 근육 부족 | 제한 있음 | 40        |
| 둘 다 불리               | 준비 필요 | 20        |

**특징**:

- ✔ 실무 트레이너 기준과 일치
- ✔ 설명 문구만 부드럽게 처리
- 인바디 종합 점수 그대로 사용 ❌
- 골격근량/체지방량/비만도 분해하여 상대 점수화 ✅

---

#### 6️⃣ 안정성 점수화 구조 (최대 20) — ✅ 통증 감점 폭 조정

**입력 UI (체크박스/라디오 버튼 기반)**:

**OHSA 종합** (단일 선택):

- ☐ A. 보상 거의 없음
- ☐ B. 경미한 보상
- ☐ C. 명확한 보상

**통증 체크** (단일 선택):

- ☐ 없음
- ☐ 있음

**최종 등급 & 내부 점수 (조정 완료)**:

| OHSA | 통증 | 최종 등급 | 내부 점수 |
| ---- | ---- | --------- | --------- |
| A    | 없음 | 안정적    | 80        |
| B    | 없음 | 무난함    | 60        |
| C    | 없음 | 제한 있음 | 40        |
| A    | 있음 | 제한 있음 | 50        |
| B    | 있음 | 제한 있음 | 45        |
| C    | 있음 | 준비 필요 | 20        |

**특징**:

- ✔ "통증 = 바로 최저점" 방지
- ✔ 근육통/경미 통증 상황 현실 반영
- "위험 요소 선별"이 목적, 진단 ❌

---

### 점수화 구조 구현 필요 사항

#### 1. DB 구조 확장

**✅ 완료된 작업**:

- ✅ `assessment_items.details` 필드 추가 (JSONB)
- ✅ 세부 평가 기준 저장 구조 정의
- ✅ 체성분 평가 기준표 테이블 생성 (`body_composition_standards`)
- ✅ 평가 등급 상수 테이블 생성 (`assessment_grade_constants`)
- ✅ 카테고리별 등급-점수 매핑 테이블 생성 (`assessment_category_scores`)
- ✅ 유연성 항목별 가중치 테이블 생성 (`flexibility_item_weights`, `flexibility_grade_thresholds`)

**✅ 구현 완료된 구조**:

```json
{
	"grade": "A" | "B" | "C" | "D" | "D-1" | "D-2",
	"internalScore": 80,
	"isReplacement": false, // 대체 항목 여부
	"isImpossible": false, // 불가 항목 여부
	"weight": 0.4, // 항목별 비중
	"recoverySpeed": ["fast", "slow"], // 심폐 지구력 회복 속도
	"flexibilityItems": {
		"sitAndReach": "A",
		"shoulder": "B",
		"hip": "C",
		"hamstring": "A"
	},
	"ohsa": "A" | "B" | "C",
	"pain": "none" | "present",
	"muscleMass": 45.2,
	"fatMass": 15.8,
	"bodyFatPercentage": 22.4,
	"observations": {
		"hipHinge": "good",
		"kneeTracking": "poor",
		"depth": "partial"
	},
	"leftRightDifference": {
		"left": 45,
		"right": 50
	}
}
```

---

#### 2. 항목별 비중 분배 로직

**현재**: 단순 평균 계산만 존재

**필요**:

- 항목별 비중 정의 (상수 파일)
- 가중 평균 계산 로직
- 대체 항목 감지 및 비중 재분배

**예상 파일**:

- `src/common/constants/initial-assessment-item-weights.ts` (신규)
- `src/common/utils/weighted-score-calculator.ts` (신규)

---

#### 3. 세부 평가 기준 계산 로직

**현재**: `value`를 그대로 `score`로 사용

**필요**:

- 세부 평가 요소 합산 로직
- 항목별 점수 계산 서비스

**예상 파일**:

- `src/common/utils/assessment-item-scorer.ts` (신규)
    - `calculateItemScore()`: 세부 평가 요소 합산
    - `calculateSubScores()`: 패턴 이해도, 깊이 등 계산

---

#### 4. 대체 항목 로직

**필요**:

- 불가 항목 감지
- 비중 재분배 (체중 스쿼트 불가 → 박스/고블릿 50/50)
- 점수 계산 시 대체 항목만 사용

**예상 로직**:

```typescript
// 대체 항목 감지
if (체중스쿼트.isImpossible) {
	박스스쿼트.weight = 0.5;
	고블릿스쿼트.weight = 0.5;
	체중스쿼트.weight = 0; // 제외
}
```

---

#### 5. 카테고리별 가중 평균 계산

**현재**:

```typescript
// 단순 평균
const averageScore = sum / length;
```

**필요**:

```typescript
// 가중 평균
const weightedScore =
	items.reduce((sum, item) => {
		return sum + item.score * item.details.weight;
	}, 0) / totalWeight;
```

---

### 프로젝트 적합성 평가

**결론**: ✅ **적합**

**이유**:

1. 기본 구조가 확장 가능 (JSONB 필드 활용)
2. 서비스 레이어 분리로 로직 추가 용이
3. 기존 코드와 충돌 없음
4. 단계적 구현 가능

**구현 난이도**: 중간

- DB 구조 확장: 쉬움 (마이그레이션)
- 점수 계산 로직: 중간 (비중 분배, 대체 항목 로직)
- 세부 평가 기준: 중간 (항목별 계산 로직)

**검토 사항**:

- [ ] 항목별 비중 분배가 적절한가?
- [ ] 대체 항목 로직이 명확한가?
- [ ] 세부 평가 기준이 실용적인가?
- [ ] 점수 계산 로직이 일관성 있는가?

---

### 초기 평가 점수화 구조

**목적**: 각 카테고리별 점수 계산 방법 및 비중 분배 정의

**현재 상태**: ⚠️ 설계 단계 (추후 구현 예정)

#### 1️⃣ 하체 근력 점수화 구조 (15%)

**채택 항목**:

- (1) 체중 스쿼트
- (2) 박스/체어 스쿼트
- (3) 고블릿 스쿼트

**기본 점수 분배 로직**:

| 항목          | 기본 비중 |
| ------------- | --------- |
| 체중 스쿼트   | 40%       |
| 박스 스쿼트   | 30%       |
| 고블릿 스쿼트 | 30%       |
| **합계**      | **100%**  |

**항목별 내부 평가 기준 (예시)**:

**(1) 체중 스쿼트 (0~40점)**

- 패턴 이해도 (0~15점)
- 깊이 & 가동범위 (0~15점)
- 반복 안정성 (0~10점)
- **불가 시**: 체중 스쿼트 항목 제외, (2), (3)을 50/50 비율로 재분배

**(2) 박스 스쿼트 (0~30점)**

- 엉덩이 주도 여부 (0~10점)
- 무릎 트래킹 (0~10점)
- 반복 안정성 (0~10점)

**(3) 고블릿 스쿼트 (0~30점)**

- 외부 부하 반응 (0~10점)
- 상체 안정성 (0~10점)
- 하강 컨트롤 (0~10점)

**하체 근력 점수 특징**:

- 체중 스쿼트가 안 된다고 낮은 점수 확정 ❌
- "운동 경험의 방향성"이 점수에 반영됨
- 이후 strengthlevel 확장에 가장 자연스럽게 연결됨

**🔹 관점 전환**:

- ❌ "얼마나 센가?"
- ✅ "운동을 시작할 수 있는 상태인가?"

---

#### 2️⃣ 심폐 지구력 점수화 구조 (20%)

**채택 항목**: 스텝 테스트 단일

**평가 요소 → 점수 변환**:

| 요소        | 배점      |
| ----------- | --------- |
| 수행 지속성 | 40점      |
| 심박 반응   | 30점      |
| 회복 속도   | 30점      |
| **합계**    | **100점** |

**운영 포인트**:

- 기록 실패 ❌
- 중단 시점도 데이터
- RPE(주관적 호흡) 병행 기록 가능

**특징**:

- 유산소 "능력" ❌
- 적응 상태 & 회복 능력 중심

---

#### 3️⃣ 근지구력 점수화 구조 (20%)

**채택 항목**:

- (1) 플랭크
- (2) 수정 플랭크 / 변형

**점수 분배**:

| 항목        | 비중     |
| ----------- | -------- |
| 플랭크      | 60%      |
| 수정 플랭크 | 40%      |
| **합계**    | **100%** |

**플랭크 세부 구조**:

- 유지 시간 (0~30점)
- 자세 유지 품질 (0~20점)
- 흔들림 발생 시점 (0~10점)

**기본 플랭크 불가 시**:

- → 수정 플랭크 100% 환산

---

#### 4️⃣ 유연성 점수화 구조 (10%)

**채택 항목**:

- 좌전굴
- 어깨
- 고관절
- 기능적 유연성(5번)

**점수 분배**:

| 항목          | 비중     |
| ------------- | -------- |
| 좌전굴        | 25%      |
| 어깨          | 25%      |
| 고관절        | 25%      |
| 기능적 유연성 | 25%      |
| **합계**      | **100%** |

**평가 방식**:

- 절대 기준 ❌
- 도달 범위 + 좌우 차이
- "늘어남"보다 "제한 위치"를 점수화

---

#### 5️⃣ 체성분 점수화 구조 (15%)

**선택**: B안 채택

**점수 산정 방식**:

- 인바디 점수 그대로 ❌
- 아래 항목을 상대 점수화:

| 항목             | 반영                 |
| ---------------- | -------------------- |
| 골격근량         | +                    |
| 체지방량         | -                    |
| 비만도           | -                    |
| 체중 변화 가능성 | 해석용 (점수 미반영) |

**결과**: 단일 체성분 점수(0~100)

**목적**: 비교 기준점 + 동기부여

**핵심 변화**:

- ❌ 인바디 종합 점수 그대로 사용
- ✅ 골격근량 / 체지방량 / 비만도 분해하여 상대 점수화
- 현직 트레이너 실무 기준 반영

---

#### 6️⃣ 안정성 점수화 구조 (20%)

**채택 항목**:

- OHSA
- 통증 체크

**점수 분배**:

| 항목      | 비중     |
| --------- | -------- |
| OHSA      | 70%      |
| 통증 체크 | 30%      |
| **합계**  | **100%** |

**OHSA 세부**:

- 정렬 패턴 (0~30점)
- 좌우 차이 (0~20점)
- 보상 동작 빈도 (0~20점)

**통증 체크**:

- 통증 없음: 가산
- 불편감: 중립
- 통증 있음: 감점 (단, 실패 아님)

---

### 점수화 구조 구현 필요 사항

#### 1. DB 구조 확장

**✅ 완료된 작업**:

- ✅ `assessment_items.details` 필드 추가 (JSONB)
- ✅ 세부 평가 기준 저장 구조 정의
- ✅ 체성분 평가 기준표 테이블 생성 (`body_composition_standards`)
- ✅ 평가 등급 상수 테이블 생성 (`assessment_grade_constants`)
- ✅ 카테고리별 등급-점수 매핑 테이블 생성 (`assessment_category_scores`)
- ✅ 유연성 항목별 가중치 테이블 생성 (`flexibility_item_weights`, `flexibility_grade_thresholds`)

**✅ 구현 완료된 구조**:

```json
{
	"grade": "A" | "B" | "C" | "D" | "D-1" | "D-2",
	"internalScore": 80,
	"isReplacement": false, // 대체 항목 여부
	"isImpossible": false, // 불가 항목 여부
	"weight": 0.4, // 항목별 비중
	"recoverySpeed": ["fast", "slow"], // 심폐 지구력 회복 속도
	"flexibilityItems": {
		"sitAndReach": "A",
		"shoulder": "B",
		"hip": "C",
		"hamstring": "A"
	},
	"ohsa": "A" | "B" | "C",
	"pain": "none" | "present",
	"muscleMass": 45.2,
	"fatMass": 15.8,
	"bodyFatPercentage": 22.4,
	"observations": {
		"hipHinge": "good",
		"kneeTracking": "poor",
		"depth": "partial"
	},
	"leftRightDifference": {
		"left": 45,
		"right": 50
	}
}
```

---

#### 2. 항목별 비중 분배 로직

**현재**: 단순 평균 계산만 존재

**필요**:

- 항목별 비중 정의 (상수 파일)
- 가중 평균 계산 로직
- 대체 항목 감지 및 비중 재분배

**예상 파일**:

- `src/common/constants/initial-assessment-item-weights.ts` (신규)
- `src/common/utils/weighted-score-calculator.ts` (신규)

---

#### 3. 세부 평가 기준 계산 로직

**현재**: `value`를 그대로 `score`로 사용

**필요**:

- 세부 평가 요소 합산 로직
- 항목별 점수 계산 서비스

**예상 파일**:

- `src/common/utils/assessment-item-scorer.ts` (신규)
    - `calculateItemScore()`: 세부 평가 요소 합산
    - `calculateSubScores()`: 패턴 이해도, 깊이 등 계산

---

#### 4. 대체 항목 로직

**필요**:

- 불가 항목 감지
- 비중 재분배 (체중 스쿼트 불가 → 박스/고블릿 50/50)
- 점수 계산 시 대체 항목만 사용

**예상 로직**:

```typescript
// 대체 항목 감지
if (체중스쿼트.isImpossible) {
	박스스쿼트.weight = 0.5;
	고블릿스쿼트.weight = 0.5;
	체중스쿼트.weight = 0; // 제외
}
```

---

#### 5. 카테고리별 가중 평균 계산

**현재**:

```typescript
// 단순 평균
const averageScore = sum / length;
```

**필요**:

```typescript
// 가중 평균
const weightedScore =
	items.reduce((sum, item) => {
		return sum + item.score * item.details.weight;
	}, 0) / totalWeight;
```

---

### 프로젝트 적합성 평가

**결론**: ✅ **적합**

**이유**:

1. 기본 구조가 확장 가능 (JSONB 필드 활용)
2. 서비스 레이어 분리로 로직 추가 용이
3. 기존 코드와 충돌 없음
4. 단계적 구현 가능

**구현 난이도**: 중간

- DB 구조 확장: 쉬움 (마이그레이션)
- 점수 계산 로직: 중간 (비중 분배, 대체 항목 로직)
- 세부 평가 기준: 중간 (항목별 계산 로직)

**검토 사항**:

- [ ] 항목별 비중 분배가 적절한가?
- [ ] 대체 항목 로직이 명확한가?
- [ ] 세부 평가 기준이 실용적인가?
- [ ] 점수 계산 로직이 일관성 있는가?

---

## ⚠️ 개발 시 주의사항 및 통일 규칙

> **프론트엔드와 백엔드 개발 시 반드시 확인하고 준수해야 할 사항들입니다.**

### 1. 등급 값 통일 규칙

**입력 등급 (프론트엔드 → 백엔드)**:

- 하체 근력: `'A'`, `'B'`, `'C'`, `'D'`, `'D-1'`, `'D-2'` (정확히 이 형식)
- 심폐 지구력: `'A'`, `'B'`, `'C'`, `'IMPOSSIBLE'`
- 근지구력: `'A'`, `'B'`, `'C'`, `'IMPOSSIBLE'`
- 유연성: 각 항목별 `'A'`, `'B'`, `'C'` (null 가능)
- 안정성: OHSA `'A'`, `'B'`, `'C'` / 통증 `'none'`, `'present'`

**⚠️ 주의**:

- 대소문자 구분 (`'A'` ✅, `'a'` ❌)
- 하이픈 포함 (`'D-1'` ✅, `'D1'` ❌)
- 공백 없음 (`'D-1'` ✅, `'D - 1'` ❌)

### 2. 날짜 형식 통일

**요청 시**: ISO 8601 형식 (YYYY-MM-DD)

```typescript
assessedAt: "2024-01-15"; // ✅ 올바른 형식
assessedAt: "2024/01/15"; // ❌ 잘못된 형식
assessedAt: "01-15-2024"; // ❌ 잘못된 형식
```

**응답 시**: 백엔드에서 ISO 8601 형식으로 반환

### 3. 필수/선택 필드 구분

**필수 필드** (반드시 전송):

- `assessmentType`: "INITIAL" | "PERIODIC"
- `assessedAt`: 날짜 문자열
- `items`: 배열 (최소 1개 이상)
- 각 `item`의 `category`, `name`
- 각 카테고리별 필수 입력 (하체 근력: `details.grade`, 유연성: `details.flexibilityItems` 등)

**선택 필드** (조건부):

- `bodyWeight`: 체중 (체성분 평가 시 권장)
- `condition`: 컨디션
- `trainerComment`: 트레이너 코멘트
- `item.value`, `item.unit`: 등급 기반 평가의 경우 생략 가능
- `details.recoverySpeed`: 심폐 지구력 B 선택 시에만
- `details.alternative`: 하체 근력 D 선택 시에만

### 4. 조건부 입력 처리 규칙

**하체 근력**:

- `grade = 'D'` 선택 시 → 반드시 `alternative` 필드에 `'D-1'` 또는 `'D-2'` 전송
- `grade = 'A'`, `'B'`, `'C'` 선택 시 → `alternative` 필드 전송하지 않음

**심폐 지구력**:

- `grade = 'B'` 선택 시 → `recoverySpeed` 배열에 `'fast'` 또는 `'slow'` 포함 가능
- `grade = 'A'`, `'C'` 선택 시 → `recoverySpeed` 필드 전송하지 않음

**유연성**:

- 최소 1개 항목은 반드시 입력 (좌전굴, 어깨, 고관절 중)
- 햄스트링은 선택 사항

### 5. 점수 계산 관련 주의사항

**⚠️ 중요**: 프론트엔드는 점수를 계산하지 않습니다.

- 프론트엔드: 등급만 전송 (`details.grade`, `details.flexibilityItems` 등)
- 백엔드: 등급을 내부 점수로 변환하여 계산
- 응답: 백엔드에서 계산된 점수를 `snapshot`에 포함하여 반환

**프론트엔드에서 하지 말아야 할 것**:

```typescript
// ❌ 프론트엔드에서 점수 계산 금지
const score = calculateScore(grade); // 이렇게 하지 마세요!

// ✅ 등급만 전송
const request = {
	details: {
		grade: "B", // 등급만 전송
	},
};
```

### 6. 레이더 차트 표시 규칙

**반드시 준수해야 할 규칙**:

1. **점수에 ×0.85 적용**:

    ```typescript
    const displayScore = snapshot.strengthScore * 0.85;
    ```

2. **축 최대값 적용**:
    - 안정성: 20
    - 심폐 지구력: 20
    - 근지구력: 20
    - 하체 근력: 15
    - 체성분: 15
    - 유연성: 10

3. **중앙 기준선 없음**: 레이더 차트에 중앙 기준선을 표시하지 않음

4. **등급 표시**: 내부 점수는 비노출, 등급만 표시 (안정적/무난함/제한 있음/준비 필요)

### 7. 에러 처리 통일

**백엔드 에러 응답 형식**:

```typescript
{
  success: false,
  message: "에러 메시지",
  errorCode: "ERROR_CODE"
}
```

**프론트엔드 처리**:

- `errorCode`에 따라 적절한 메시지 표시
- 해당 입력 필드에 에러 스타일 적용
- 재시도 가능하도록 UI 제공

**주요 에러 코드**:

- `MISSING_REQUIRED_ITEM`: 필수 항목 누락
- `INVALID_GRADE`: 잘못된 등급 값
- `MISSING_CONDITIONAL_INPUT`: 조건부 입력 누락
- `INVALID_DATE_FORMAT`: 잘못된 날짜 형식

### 8. DB 테이블 참조 시 주의사항

**백엔드 개발자 주의사항**:

1. **등급-점수 매핑 조회**:
    - `assessment_category_scores` 테이블에서 조회 시
    - `category`, `input_grade`, `conditions` 모두 일치해야 함
    - `is_active = true`인 레코드만 사용

2. **유연성 가중치 계산**:
    - `flexibility_item_weights` 테이블에서 가중치 조회
    - 가중치 합 계산 후 `flexibility_grade_thresholds` 테이블에서 등급 판정

3. **체성분 기준 조회**:
    - `body_composition_standards` 테이블에서
    - `gender`, `age_min`, `age_max` 범위로 조회
    - `is_active = true`인 레코드만 사용

4. **등급 상수 참조**:
    - `assessment_grade_constants` 테이블에서
    - `grade_code`로 조회 (STABLE, NORMAL, LIMITED, PREPARE)

### 9. API 엔드포인트 통일

**평가 생성**:

- `POST /api/members/:memberId/assessments`
- 요청 본문: `CreateAssessmentDto` 형식

**평가 조회**:

- `GET /api/members/:memberId/assessments/:assessmentId`
- 응답: 평가 정보 + 스냅샷 포함

**레이더 차트 데이터**:

- `GET /api/members/:memberId/abilities/hexagon?compare=true`
- `compare=true` 시 초기 평가와 비교 데이터 포함

### 10. 데이터 검증 규칙

**프론트엔드 검증**:

- 필수 항목 선택 확인
- 조건부 입력 표시/숨김 로직
- 날짜 형식 검증
- 숫자 입력 유효성 검사 (체성분: 양수, 범위 체크)

**백엔드 검증**:

- DTO 레벨 검증 (class-validator)
- 비즈니스 로직 검증 (조건부 입력 확인)
- DB 제약조건 검증

### 11. 등급 코드 매핑

**내부 등급 코드** (DB 저장용):

- `STABLE`: 안정적 (80점)
- `NORMAL`: 무난함 (60점)
- `LIMITED`: 제한 있음 (40점)
- `PREPARE`: 준비 필요 (20점)

**입력 등급** (프론트엔드 → 백엔드):

- `A`, `B`, `C`, `D`, `'D-1'`, `'D-2'` 등

**변환 로직**:

- 백엔드에서 입력 등급을 내부 등급 코드로 변환
- `assessment_category_scores` 테이블 참조

### 12. null 처리 규칙

**프론트엔드**:

- 선택적 필드는 `null` 또는 `undefined` 전송 가능
- 조건부 입력은 해당 조건이 아닐 때 필드를 아예 전송하지 않거나 `null` 전송

**백엔드**:

- `value`, `unit`, `score`는 nullable (등급 기반 평가의 경우)
- `details`는 nullable이지만, 등급 기반 평가의 경우 반드시 포함

### 13. 버전 관리

**점수 계산 버전**:

- `ability_snapshots.version` 필드에 저장
- 현재 버전: `"v1"`
- 버전 변경 시 기존 데이터와의 호환성 고려

### 14. 카테고리별 필수 입력 체크리스트

**프론트엔드에서 반드시 확인**:

- [ ] 하체 근력: `details.grade` 필수
- [ ] 심폐 지구력: `details.grade` 필수 (B 선택 시 `recoverySpeed` 권장)
- [ ] 근지구력: `details.grade` 필수
- [ ] 유연성: `details.flexibilityItems` 최소 1개 항목 필수
- [ ] 체성분: `details.muscleMass`, `fatMass`, `bodyFatPercentage` 필수
- [ ] 안정성: `details.ohsa`, `details.pain` 필수

### 15. 백엔드 계산 로직 구현 시 주의사항

**등급-점수 변환**:

- `assessment_category_scores` 테이블에서 조회 시 `conditions` JSONB 필드 매칭 주의
- 예: 심폐 지구력 B + 회복 빠름 → `conditions: {"recoverySpeed": ["fast"]}` 매칭

**유연성 계산**:

- 각 항목별 등급을 가중치로 변환 (C 등급만 가중치 합산)
- 가중치 합 범위로 최종 등급 판정

**체성분 계산**:

- 회원의 `age`, `gender`로 연령대별 기준 조회
- 골격근량, 체지방량, 비만도를 종합하여 등급 판정

---

## 💻 프론트엔드 개발 가이드

**목적**: 백엔드 API 구조와 요청/응답 형식, UI 구현 방법 안내

**⚠️ 중요**: 위의 "개발 시 주의사항 및 통일 규칙" 섹션을 먼저 확인하세요.

---

### 1. 평가 등급 입력 UI 구조

#### 1️⃣ 하체 근력 입력 UI

**구조**: 라디오 버튼 (단일 선택) + 조건부 라디오 버튼

```typescript
// UI 구조
interface LowerBodyStrengthInput {
  // 1단계: 체중 스쿼트 수행 상태 (단일 선택)
  bodyweightSquat: 'A' | 'B' | 'C' | 'D';

  // 2단계: D 선택 시에만 표시 (단일 선택)
  alternative?: 'D-1' | 'D-2';
}

// 예시 컴포넌트 구조
<RadioGroup name="bodyweightSquat">
  <Radio value="A">안정적으로 반복 수행</Radio>
  <Radio value="B">수행 가능, 깊이·정렬 일부 제한</Radio>
  <Radio value="C">수행 가능하나 불안정 / 연속 어려움</Radio>
  <Radio value="D">수행 불가 → 대체 항목</Radio>
</RadioGroup>

{bodyweightSquat === 'D' && (
  <RadioGroup name="alternative">
    <Radio value="D-1">체어/박스 스쿼트 가능</Radio>
    <Radio value="D-2">보조 있어도 어려움</Radio>
  </RadioGroup>
)}
```

---

#### 2️⃣ 심폐 지구력 입력 UI

**구조**: 라디오 버튼 (단일 선택) + 체크박스 (다중 선택)

```typescript
interface CardioInput {
  // 1단계: 스텝 테스트 수행 상태 (단일 선택)
  stepTest: 'A' | 'B' | 'C';

  // 2단계: B 선택 시에만 표시 (다중 선택 가능)
  recoverySpeed?: ('fast' | 'slow')[];
}

// 예시 컴포넌트 구조
<RadioGroup name="stepTest">
  <Radio value="A">리듬 유지 + 완주</Radio>
  <Radio value="B">리듬 유지</Radio>
  <Radio value="C">조기 중단 / 리듬 붕괴</Radio>
</RadioGroup>

{stepTest === 'B' && (
  <CheckboxGroup>
    <Checkbox value="fast">회복 빠름 (1분 이내 호흡 편안)</Checkbox>
    <Checkbox value="slow">회복 느림 (2분 이상 호흡 불편)</Checkbox>
  </CheckboxGroup>
)}
```

---

#### 3️⃣ 근지구력 입력 UI

**구조**: 라디오 버튼 (단일 선택)

```typescript
interface EnduranceInput {
  plank: 'A' | 'B' | 'C';
}

// 예시 컴포넌트 구조
<RadioGroup name="plank">
  <Radio value="A">자세 안정, 흔들림 거의 없음</Radio>
  <Radio value="B">유지 가능하나 흔들림 있음</Radio>
  <Radio value="C">빠른 붕괴 / 중단</Radio>
</RadioGroup>
```

---

#### 4️⃣ 유연성 입력 UI

**구조**: 각 항목별 라디오 버튼 그룹 (각 항목마다 단일 선택)

```typescript
interface FlexibilityInput {
  sitAndReach: 'A' | 'B' | 'C' | null;  // 좌전굴
  shoulder: 'A' | 'B' | 'C' | null;     // 어깨 가동
  hip: 'A' | 'B' | 'C' | null;          // 고관절 가동
  hamstring?: 'A' | 'B' | 'C' | null;   // 햄스트링 (선택)
}

// 예시 컴포넌트 구조
<div>
  <h4>좌전굴</h4>
  <RadioGroup name="sitAndReach">
    <Radio value="A">제한 없음</Radio>
    <Radio value="B">일부 제한</Radio>
    <Radio value="C">명확한 제한</Radio>
  </RadioGroup>
</div>

<div>
  <h4>어깨 가동</h4>
  <RadioGroup name="shoulder">
    <Radio value="A">제한 없음</Radio>
    <Radio value="B">일부 제한</Radio>
    <Radio value="C">명확한 제한</Radio>
  </RadioGroup>
</div>

// ... 고관절, 햄스트링 동일
```

---

#### 5️⃣ 체성분 입력 UI

**구조**: 숫자 입력 필드

```typescript
interface BodyCompositionInput {
  weight: number;        // 체중 (kg)
  muscleMass: number;    // 골격근량 (kg)
  fatMass: number;      // 체지방량 (kg)
  bodyFatPercentage: number; // 체지방률 (%)
  // 나이는 members 테이블에서 가져옴 (백엔드에서 자동 처리)
}

// 예시 컴포넌트 구조
<Input type="number" name="weight" label="체중 (kg)" />
<Input type="number" name="muscleMass" label="골격근량 (kg)" />
<Input type="number" name="fatMass" label="체지방량 (kg)" />
<Input type="number" name="bodyFatPercentage" label="체지방률 (%)" />
```

---

#### 6️⃣ 안정성 입력 UI

**구조**: 라디오 버튼 (단일 선택) × 2

```typescript
interface StabilityInput {
  ohsa: 'A' | 'B' | 'C';
  pain: 'none' | 'present';
}

// 예시 컴포넌트 구조
<div>
  <h4>OHSA 종합</h4>
  <RadioGroup name="ohsa">
    <Radio value="A">보상 거의 없음</Radio>
    <Radio value="B">경미한 보상</Radio>
    <Radio value="C">명확한 보상</Radio>
  </RadioGroup>
</div>

<div>
  <h4>통증 체크</h4>
  <RadioGroup name="pain">
    <Radio value="none">없음</Radio>
    <Radio value="present">있음</Radio>
  </RadioGroup>
</div>
```

---

### 2. 백엔드 API 요청 형식

#### 평가 생성 API

**엔드포인트**: `POST /api/members/:memberId/assessments`

**요청 본문 구조**:

```typescript
interface CreateAssessmentRequest {
	assessmentType: "INITIAL" | "PERIODIC";
	assessedAt: string; // ISO 8601 형식: "2024-01-15"
	bodyWeight?: number;
	condition?: "EXCELLENT" | "GOOD" | "NORMAL" | "POOR";
	trainerComment?: string;

	// 평가 항목들
	items: AssessmentItemInput[];
}

interface AssessmentItemInput {
	category: "STRENGTH" | "CARDIO" | "ENDURANCE" | "FLEXIBILITY" | "BODY" | "STABILITY";
	name: string; // 예: "체중 스쿼트", "스텝 테스트", "플랭크" 등
	value?: number; // 체성분의 경우 필수, 나머지는 선택
	unit?: string; // 예: "kg", "%", "회" 등
	score?: number; // 백엔드에서 계산하므로 보통 생략 가능
	details: {
		// 카테고리별 입력 데이터
		grade?: string; // 'A', 'B', 'C', 'D', 'D-1', 'D-2' 등
		alternative?: string; // 대체 항목 정보
		recoverySpeed?: string[]; // ['fast', 'slow'] 등
		flexibilityItems?: {
			sitAndReach?: "A" | "B" | "C";
			shoulder?: "A" | "B" | "C";
			hip?: "A" | "B" | "C";
			hamstring?: "A" | "B" | "C";
		};
		ohsa?: "A" | "B" | "C";
		pain?: "none" | "present";
		// 체성분 데이터
		muscleMass?: number;
		fatMass?: number;
		bodyFatPercentage?: number;
	};
}
```

**요청 예시**:

```typescript
// 하체 근력 예시
{
  assessmentType: 'INITIAL',
  assessedAt: '2024-01-15',
  items: [
    {
      category: 'STRENGTH',
      name: '체중 스쿼트',
      details: {
        grade: 'B' // 또는 'D' 선택 시
      }
    },
    {
      category: 'STRENGTH',
      name: '대체 항목',
      details: {
        grade: 'D-1' // D 선택 시에만 전송
      }
    }
  ]
}

// 심폐 지구력 예시
{
  category: 'CARDIO',
  name: '스텝 테스트',
  details: {
    grade: 'B',
    recoverySpeed: ['fast'] // 또는 ['slow'], ['fast', 'slow']
  }
}

// 유연성 예시
{
  category: 'FLEXIBILITY',
  name: '유연성 종합',
  details: {
    flexibilityItems: {
      sitAndReach: 'B',
      shoulder: 'C',
      hip: 'A',
      hamstring: 'B'
    }
  }
}

// 체성분 예시
{
  category: 'BODY',
  name: '인바디',
  value: 70.5, // 체중
  unit: 'kg',
  details: {
    muscleMass: 45.2,
    fatMass: 15.8,
    bodyFatPercentage: 22.4
  }
}

// 안정성 예시
{
  category: 'STABILITY',
  name: 'OHSA',
  details: {
    ohsa: 'B',
    pain: 'none'
  }
}
```

---

### 3. 백엔드 응답 형식

#### 평가 생성 응답

**응답 구조**:

```typescript
interface AssessmentResponse {
	success: boolean;
	message: string;
	data: {
		id: string;
		memberId: string;
		assessmentType: "INITIAL" | "PERIODIC";
		assessedAt: string;
		items: AssessmentItemResponse[];
		snapshot: {
			strengthScore: number; // 0-100
			cardioScore: number; // 0-100
			enduranceScore: number; // 0-100
			flexibilityScore: number; // 0-100
			bodyScore: number; // 0-100
			stabilityScore: number; // 0-100
			totalScore: number; // 0-100
		};
	};
}

interface AssessmentItemResponse {
	id: string;
	category: string;
	name: string;
	value: number;
	unit: string;
	score: number; // 계산된 점수
	details: {
		grade?: string; // 등급 (UI 표시용)
		internalScore?: number; // 내부 점수 (UI 비노출, 디버깅용)
		// ... 기타 상세 정보
	};
}
```

**⚠️ 중요**: 프론트엔드는 `snapshot`의 점수를 레이더 차트에 표시하되, **×0.85를 적용**하여 표시해야 함.

---

### 4. 프론트엔드 구현 체크리스트

#### UI 구현

- [ ] 하체 근력: 라디오 버튼 (체중 스쿼트) + 조건부 라디오 버튼 (대체 항목)
- [ ] 심폐 지구력: 라디오 버튼 (스텝 테스트) + 조건부 체크박스 (회복 속도)
- [ ] 근지구력: 라디오 버튼 (플랭크)
- [ ] 유연성: 각 항목별 라디오 버튼 그룹 (좌전굴, 어깨, 고관절, 햄스트링)
- [ ] 체성분: 숫자 입력 필드 (체중, 골격근량, 체지방량, 체지방률)
- [ ] 안정성: 라디오 버튼 × 2 (OHSA, 통증 체크)

#### 데이터 검증

- [ ] 필수 항목 선택 확인
- [ ] 조건부 입력 표시/숨김 로직 (D 선택 시 대체 항목, B 선택 시 회복 속도)
- [ ] 체성분 숫자 입력 유효성 검사 (양수, 범위 체크)

#### API 통신

- [ ] 평가 생성 요청 형식 준수
- [ ] `details` 필드에 카테고리별 입력 데이터 포함
- [ ] 응답 받은 `snapshot` 점수를 레이더 차트에 ×0.85 적용하여 표시

#### 레이더 차트 표시

- [ ] 등급 표시 (안정적/무난함/제한 있음/준비 필요) - 내부 점수는 비노출
- [ ] 축 최대값 적용 (안정성 20, 심폐 20, 근지구력 20, 하체 근력 15, 체성분 15, 유연성 10)
- [ ] 계산된 점수 × 0.85 적용
- [ ] 중앙 기준선 없음

---

### 5. 백엔드 계산 로직 (참고용)

**⚠️ 프론트엔드는 참고만 하고, 실제 계산은 백엔드에서 수행**

#### 하체 근력 점수 계산

```typescript
// 입력: grade = 'B'
// 출력: internalScore = 60
// 최종: strengthScore = 60 (0-100 범위)

// 입력: grade = 'D-1'
// 출력: internalScore = 30
// 최종: strengthScore = 30
```

#### 심폐 지구력 점수 계산

```typescript
// 입력: grade = 'B', recoverySpeed = ['fast']
// 출력: internalScore = 65
// 최종: cardioScore = 65

// 입력: grade = 'B', recoverySpeed = ['slow']
// 출력: internalScore = 55
// 최종: cardioScore = 55
```

#### 유연성 점수 계산

```typescript
// 입력: flexibilityItems = { shoulder: 'C', sitAndReach: 'C' }
// 가중치 합: 1.3 + 1.0 = 2.3
// 출력: internalScore = 40 (가중치 합 1.6~2.5 → 제한 있음)
// 최종: flexibilityScore = 40
```

#### 체성분 점수 계산

```typescript
// 입력: muscleMass, fatMass, bodyFatPercentage, age, gender
// 연령대별 기준과 비교
// 출력: internalScore = 60 (한 요소 관리 필요)
// 최종: bodyScore = 60
```

#### 안정성 점수 계산

```typescript
// 입력: ohsa = 'B', pain = 'present'
// 출력: internalScore = 45
// 최종: stabilityScore = 45
```

---

### 6. 에러 처리

**백엔드에서 반환 가능한 에러**:

```typescript
// 필수 항목 누락
{
  success: false,
  message: "하체 근력 평가 항목이 필요합니다.",
  errorCode: "MISSING_REQUIRED_ITEM"
}

// 잘못된 등급 값
{
  success: false,
  message: "유효하지 않은 등급입니다: 'X'",
  errorCode: "INVALID_GRADE"
}

// 조건부 입력 누락
{
  success: false,
  message: "D 선택 시 대체 항목을 선택해주세요.",
  errorCode: "MISSING_CONDITIONAL_INPUT"
}
```

**프론트엔드 처리**:

- 에러 메시지를 사용자에게 표시
- 해당 입력 필드에 에러 스타일 적용
- 재시도 가능하도록 UI 제공

---

### 7. 개발 순서 제안

1. **1단계**: 입력 UI 컴포넌트 구현
    - 각 카테고리별 입력 폼 컴포넌트 생성
    - 조건부 표시/숨김 로직 구현

2. **2단계**: 데이터 검증 로직 구현
    - 필수 항목 체크
    - 조건부 입력 검증

3. **3단계**: API 통신 구현
    - 평가 생성 API 호출
    - 요청 데이터 형식 변환

4. **4단계**: 응답 처리 및 레이더 차트 표시
    - 응답 데이터 파싱
    - 레이더 차트에 점수 표시 (×0.85 적용)

5. **5단계**: 에러 처리 및 사용자 피드백
    - 에러 메시지 표시
    - 성공 메시지 표시

---

### ⚠️ 프로젝트 기준 어려운 영역 / 불가 영역

#### 1. 하드웨어 연동 필요 (선택적)

**심박수 측정**:

- 현재 상태: 수동 입력 가능 ✅
- 향후 개선: 심박수 측정 기기 연동 (선택적)
- 영향도: 낮음 (수동 입력으로 대체 가능)

**인바디 데이터**:

- 현재 상태: 수동 입력 가능 ✅
- 향후 개선: 인바디 기기 연동 (선택적)
- 영향도: 낮음 (수동 입력으로 대체 가능)

#### 2. DB 구조 추가 필요

**✅ `assessment_items.details` 필드 추가**:

- 현재 상태: ✅ 필드 추가 완료
- 필요성: 관찰 포인트, 불가 기준, 좌우 차이 등 저장
- 해결 방법: ✅ DB 마이그레이션으로 `details` JSONB 필드 추가 완료
- 영향도: ✅ 완료 (관찰 포인트 저장 가능)

**✅ 구현 완료된 구조**:

```sql
-- ✅ 마이그레이션 완료
ALTER TABLE assessment_items
ADD COLUMN details JSONB DEFAULT NULL;

CREATE INDEX idx_assessment_items_details
ON assessment_items USING GIN (details);

-- ✅ 예시 데이터 구조 (Entity 및 DTO에 반영됨)
{
  "grade": "A",
  "internalScore": 80,
  "observations": {
    "hipHinge": "good",
    "kneeTracking": "poor",
    "depth": "partial"
  },
  "leftRightDifference": {
    "left": 45,
    "right": 50
  },
  "isImpossible": false,
  "recoverySpeed": ["fast"],
  "flexibilityItems": {
    "sitAndReach": "A",
    "shoulder": "B"
  },
  "ohsa": "A",
  "pain": "none"
}
```

#### 3. 실시간 관찰 데이터 저장

**체중 스쿼트 관찰 포인트**:

- 현재 상태: `trainer_comment` 또는 `details` 필드에 텍스트로 저장 가능 ✅
- 구조화된 데이터: JSONB `details` 필드 활용 권장
- 영향도: 낮음 (현재 구조로도 가능)

**OHSA 관찰 포인트**:

- 현재 상태: `static_evaluation` JSONB 필드 활용 가능 ✅
- 또는 `assessment_items.details` 필드 활용
- 영향도: 낮음

#### 4. 통증 체크 저장

**통증 체크 (자가 보고)**:

- 현재 상태: `Assessment.static_evaluation.survey` JSONB 필드 활용 가능 ✅
- 또는 별도 `AssessmentItem`으로 저장
- 영향도: 낮음 (현재 구조로 가능)

#### 5. 대체 항목 로직

**체중 스쿼트 불가 시 대체 로직**:

- 현재 상태: 백엔드 로직으로 구현 필요
- 해결 방법:
    - `AssessmentItem`에 `isReplacement` 플래그 추가 (선택적)
    - 또는 `details.isReplacement` 필드 활용
    - 점수 계산 시 대체 항목만 사용하도록 로직 구현
- 영향도: 중간 (로직 구현 필요)

---

### 📋 구현 우선순위 (수정 가능)

#### ✅ 즉시 필요 (Phase 2) - 완료

1. **✅ `assessment_items.details` 필드 추가**
    - ✅ DB 마이그레이션 완료
    - ✅ 엔티티 수정 완료 (`AssessmentItem` 엔티티에 `details` 필드 추가)
    - ✅ DTO 수정 완료 (`CreateAssessmentItemDto`에 `details` 필드 추가, `value`, `unit` nullable 처리)
    - ✅ 서비스 로직 수정 완료 (`assessments.service.ts`에서 `details` 저장 처리)

2. **초기 평가 항목 상수 정의**
    - `src/common/constants/initial-assessment-items.ts` 생성

3. **대체 항목 로직 구현**
    - 체중 스쿼트 불가 시 박스/고블릿 스쿼트로 대체
    - 점수 계산 시 대체 항목만 사용

#### 추후 개선 (선택적)

1. **하드웨어 연동**
    - 심박수 측정 기기
    - 인바디 기기
    - 영향도: 낮음 (수동 입력으로 대체 가능)

2. **관찰 포인트 구조화**
    - 각 항목별 관찰 포인트 템플릿 정의
    - 프론트엔드 UI 개선
    - 영향도: 중간 (현재 구조로도 가능)

---

### 정기 평가 세부항목 정의

**목적**: 정기 평가에서 측정할 상세 항목들을 정의

**현재 상태**: ⚠️ 미정의 (추후 추가 예정)

**제안 항목** (수정 가능):

```typescript
// src/common/constants/periodic-assessment-items.ts (신규 생성 예정)
export const PERIODIC_ASSESSMENT_ITEMS = {
	[Category.STRENGTH]: [
		"레그프레스 10RM", // 하체 근력 상세 평가
		"스쿼트 5RM", // 하체 근력 상세 평가
		"데드리프트 3RM", // 전신 근력 평가
		"점프 파워", // 폭발력 평가
		"좌/우 밸런스", // 좌우 균형 평가
	],
	[Category.CARDIO]: [
		"VO2max", // 최대 산소 섭취량
		"러닝머신 테스트", // 유산소 능력
		"자전거 테스트", // 유산소 능력
	],
	[Category.ENDURANCE]: [
		"플랭크 시간", // 코어 지구력 (초기 평가보다 상세)
		"푸쉬업 횟수", // 상체 지구력 (초기 평가보다 상세)
		"버피 테스트", // 전신 지구력
	],
	[Category.FLEXIBILITY]: [
		"좌전굴", // 하체 유연성 (초기 평가와 동일)
		"어깨 가동", // 상체 유연성 (초기 평가와 동일)
		"고관절 가동", // 고관절 유연성 (초기 평가와 동일)
	],
	[Category.BODY]: [
		"인바디", // 체성분 평가 (초기 평가와 동일)
	],
	[Category.STABILITY]: [
		"OHSA", // 기능적 움직임 평가 (초기 평가와 동일)
		"Y-Balance", // 동적 균형 평가
		"한 발 서기", // 정적 균형 평가
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

### 레이더 차트 설계

- [ ] 축 최대값이 중요도를 적절히 표현하는가?
- [ ] ×0.85 적용이 시각적으로 적절한가?
- [ ] 중앙 기준선 제거가 사용자 경험에 적합한가?
- [ ] 단일 레이더 차트로 공동 판단이 가능한가?

### 점수 환산 메커니즘

- [ ] 환산 프로세스가 적절한가?
- [ ] 가중치가 적절한가? (종합 점수 계산용)
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

## 🔄 운영·서비스 관점 변화 요약

| 항목        | 초기   | 현재                  |
| ----------- | ------ | --------------------- |
| 레이더 용도 | 시각화 | 판단 지도             |
| 가중치      | 계산용 | 구조 자체 (축 최대값) |
| 기준선      | 고려   | 제거                  |
| 설명 난이도 | 높음   | 낮음                  |
| 확장성      | 불확실 | 명확                  |

---

## 💻 프론트엔드 개발 가이드

**목적**: 백엔드 API 구조와 요청/응답 형식, UI 구현 방법 안내

**⚠️ 중요**: 위의 "개발 시 주의사항 및 통일 규칙" 섹션을 먼저 확인하세요.

---

### 1. 평가 등급 입력 UI 구조

#### 1️⃣ 하체 근력 입력 UI

**구조**: 라디오 버튼 (단일 선택) + 조건부 라디오 버튼

```typescript
// UI 구조
interface LowerBodyStrengthInput {
  // 1단계: 체중 스쿼트 수행 상태 (단일 선택)
  bodyweightSquat: 'A' | 'B' | 'C' | 'D';

  // 2단계: D 선택 시에만 표시 (단일 선택)
  alternative?: 'D-1' | 'D-2';
}

// 예시 컴포넌트 구조
<RadioGroup name="bodyweightSquat">
  <Radio value="A">안정적으로 반복 수행</Radio>
  <Radio value="B">수행 가능, 깊이·정렬 일부 제한</Radio>
  <Radio value="C">수행 가능하나 불안정 / 연속 어려움</Radio>
  <Radio value="D">수행 불가 → 대체 항목</Radio>
</RadioGroup>

{bodyweightSquat === 'D' && (
  <RadioGroup name="alternative">
    <Radio value="D-1">체어/박스 스쿼트 가능</Radio>
    <Radio value="D-2">보조 있어도 어려움</Radio>
  </RadioGroup>
)}
```

---

#### 2️⃣ 심폐 지구력 입력 UI

**구조**: 라디오 버튼 (단일 선택) + 체크박스 (다중 선택)

```typescript
interface CardioInput {
  // 1단계: 스텝 테스트 수행 상태 (단일 선택)
  stepTest: 'A' | 'B' | 'C';

  // 2단계: B 선택 시에만 표시 (다중 선택 가능)
  recoverySpeed?: ('fast' | 'slow')[];
}

// 예시 컴포넌트 구조
<RadioGroup name="stepTest">
  <Radio value="A">리듬 유지 + 완주</Radio>
  <Radio value="B">리듬 유지</Radio>
  <Radio value="C">조기 중단 / 리듬 붕괴</Radio>
</RadioGroup>

{stepTest === 'B' && (
  <CheckboxGroup>
    <Checkbox value="fast">회복 빠름 (1분 이내 호흡 편안)</Checkbox>
    <Checkbox value="slow">회복 느림 (2분 이상 호흡 불편)</Checkbox>
  </CheckboxGroup>
)}
```

---

#### 3️⃣ 근지구력 입력 UI

**구조**: 라디오 버튼 (단일 선택)

```typescript
interface EnduranceInput {
  plank: 'A' | 'B' | 'C';
}

// 예시 컴포넌트 구조
<RadioGroup name="plank">
  <Radio value="A">자세 안정, 흔들림 거의 없음</Radio>
  <Radio value="B">유지 가능하나 흔들림 있음</Radio>
  <Radio value="C">빠른 붕괴 / 중단</Radio>
</RadioGroup>
```

---

#### 4️⃣ 유연성 입력 UI

**구조**: 각 항목별 라디오 버튼 그룹 (각 항목마다 단일 선택)

```typescript
interface FlexibilityInput {
  sitAndReach: 'A' | 'B' | 'C' | null;  // 좌전굴
  shoulder: 'A' | 'B' | 'C' | null;     // 어깨 가동
  hip: 'A' | 'B' | 'C' | null;          // 고관절 가동
  hamstring?: 'A' | 'B' | 'C' | null;   // 햄스트링 (선택)
}

// 예시 컴포넌트 구조
<div>
  <h4>좌전굴</h4>
  <RadioGroup name="sitAndReach">
    <Radio value="A">제한 없음</Radio>
    <Radio value="B">일부 제한</Radio>
    <Radio value="C">명확한 제한</Radio>
  </RadioGroup>
</div>

<div>
  <h4>어깨 가동</h4>
  <RadioGroup name="shoulder">
    <Radio value="A">제한 없음</Radio>
    <Radio value="B">일부 제한</Radio>
    <Radio value="C">명확한 제한</Radio>
  </RadioGroup>
</div>

// ... 고관절, 햄스트링 동일
```

---

#### 5️⃣ 체성분 입력 UI

**구조**: 숫자 입력 필드

```typescript
interface BodyCompositionInput {
  weight: number;        // 체중 (kg)
  muscleMass: number;    // 골격근량 (kg)
  fatMass: number;      // 체지방량 (kg)
  bodyFatPercentage: number; // 체지방률 (%)
  // 나이는 members 테이블에서 가져옴 (백엔드에서 자동 처리)
}

// 예시 컴포넌트 구조
<Input type="number" name="weight" label="체중 (kg)" />
<Input type="number" name="muscleMass" label="골격근량 (kg)" />
<Input type="number" name="fatMass" label="체지방량 (kg)" />
<Input type="number" name="bodyFatPercentage" label="체지방률 (%)" />
```

---

#### 6️⃣ 안정성 입력 UI

**구조**: 라디오 버튼 (단일 선택) × 2

```typescript
interface StabilityInput {
  ohsa: 'A' | 'B' | 'C';
  pain: 'none' | 'present';
}

// 예시 컴포넌트 구조
<div>
  <h4>OHSA 종합</h4>
  <RadioGroup name="ohsa">
    <Radio value="A">보상 거의 없음</Radio>
    <Radio value="B">경미한 보상</Radio>
    <Radio value="C">명확한 보상</Radio>
  </RadioGroup>
</div>

<div>
  <h4>통증 체크</h4>
  <RadioGroup name="pain">
    <Radio value="none">없음</Radio>
    <Radio value="present">있음</Radio>
  </RadioGroup>
</div>
```

---

### 2. 백엔드 API 요청 형식

#### 평가 생성 API

**엔드포인트**: `POST /api/members/:memberId/assessments`

**요청 본문 구조**:

```typescript
interface CreateAssessmentRequest {
	assessmentType: "INITIAL" | "PERIODIC";
	assessedAt: string; // ISO 8601 형식: "2024-01-15"
	bodyWeight?: number;
	condition?: "EXCELLENT" | "GOOD" | "NORMAL" | "POOR";
	trainerComment?: string;

	// 평가 항목들
	items: AssessmentItemInput[];
}

interface AssessmentItemInput {
	category: "STRENGTH" | "CARDIO" | "ENDURANCE" | "FLEXIBILITY" | "BODY" | "STABILITY";
	name: string; // 예: "체중 스쿼트", "스텝 테스트", "플랭크" 등
	value?: number; // 체성분의 경우 필수, 나머지는 선택
	unit?: string; // 예: "kg", "%", "회" 등
	score?: number; // 백엔드에서 계산하므로 보통 생략 가능
	details: {
		// 카테고리별 입력 데이터
		grade?: string; // 'A', 'B', 'C', 'D', 'D-1', 'D-2' 등
		alternative?: string; // 대체 항목 정보
		recoverySpeed?: string[]; // ['fast', 'slow'] 등
		flexibilityItems?: {
			sitAndReach?: "A" | "B" | "C";
			shoulder?: "A" | "B" | "C";
			hip?: "A" | "B" | "C";
			hamstring?: "A" | "B" | "C";
		};
		ohsa?: "A" | "B" | "C";
		pain?: "none" | "present";
		// 체성분 데이터
		muscleMass?: number;
		fatMass?: number;
		bodyFatPercentage?: number;
	};
}
```

**요청 예시**:

```typescript
// 하체 근력 예시
{
  assessmentType: 'INITIAL',
  assessedAt: '2024-01-15',
  items: [
    {
      category: 'STRENGTH',
      name: '체중 스쿼트',
      details: {
        grade: 'B' // 또는 'D' 선택 시
      }
    },
    {
      category: 'STRENGTH',
      name: '대체 항목',
      details: {
        grade: 'D-1' // D 선택 시에만 전송
      }
    }
  ]
}

// 심폐 지구력 예시
{
  category: 'CARDIO',
  name: '스텝 테스트',
  details: {
    grade: 'B',
    recoverySpeed: ['fast'] // 또는 ['slow'], ['fast', 'slow']
  }
}

// 유연성 예시
{
  category: 'FLEXIBILITY',
  name: '유연성 종합',
  details: {
    flexibilityItems: {
      sitAndReach: 'B',
      shoulder: 'C',
      hip: 'A',
      hamstring: 'B'
    }
  }
}

// 체성분 예시
{
  category: 'BODY',
  name: '인바디',
  value: 70.5, // 체중
  unit: 'kg',
  details: {
    muscleMass: 45.2,
    fatMass: 15.8,
    bodyFatPercentage: 22.4
  }
}

// 안정성 예시
{
  category: 'STABILITY',
  name: 'OHSA',
  details: {
    ohsa: 'B',
    pain: 'none'
  }
}
```

---

### 3. 백엔드 응답 형식

#### 평가 생성 응답

**응답 구조**:

```typescript
interface AssessmentResponse {
	success: boolean;
	message: string;
	data: {
		id: string;
		memberId: string;
		assessmentType: "INITIAL" | "PERIODIC";
		assessedAt: string;
		items: AssessmentItemResponse[];
		snapshot: {
			strengthScore: number; // 0-100
			cardioScore: number; // 0-100
			enduranceScore: number; // 0-100
			flexibilityScore: number; // 0-100
			bodyScore: number; // 0-100
			stabilityScore: number; // 0-100
			totalScore: number; // 0-100
		};
	};
}

interface AssessmentItemResponse {
	id: string;
	category: string;
	name: string;
	value: number;
	unit: string;
	score: number; // 계산된 점수
	details: {
		grade?: string; // 등급 (UI 표시용)
		internalScore?: number; // 내부 점수 (UI 비노출, 디버깅용)
		// ... 기타 상세 정보
	};
}
```

**⚠️ 중요**: 프론트엔드는 `snapshot`의 점수를 레이더 차트에 표시하되, **×0.85를 적용**하여 표시해야 함.

---

### 4. 프론트엔드 구현 체크리스트

#### UI 구현

- [ ] 하체 근력: 라디오 버튼 (체중 스쿼트) + 조건부 라디오 버튼 (대체 항목)
- [ ] 심폐 지구력: 라디오 버튼 (스텝 테스트) + 조건부 체크박스 (회복 속도)
- [ ] 근지구력: 라디오 버튼 (플랭크)
- [ ] 유연성: 각 항목별 라디오 버튼 그룹 (좌전굴, 어깨, 고관절, 햄스트링)
- [ ] 체성분: 숫자 입력 필드 (체중, 골격근량, 체지방량, 체지방률)
- [ ] 안정성: 라디오 버튼 × 2 (OHSA, 통증 체크)

#### 데이터 검증

- [ ] 필수 항목 선택 확인
- [ ] 조건부 입력 표시/숨김 로직 (D 선택 시 대체 항목, B 선택 시 회복 속도)
- [ ] 체성분 숫자 입력 유효성 검사 (양수, 범위 체크)

#### API 통신

- [ ] 평가 생성 요청 형식 준수
- [ ] `details` 필드에 카테고리별 입력 데이터 포함
- [ ] 응답 받은 `snapshot` 점수를 레이더 차트에 ×0.85 적용하여 표시

#### 레이더 차트 표시

- [ ] 등급 표시 (안정적/무난함/제한 있음/준비 필요) - 내부 점수는 비노출
- [ ] 축 최대값 적용 (안정성 20, 심폐 20, 근지구력 20, 하체 근력 15, 체성분 15, 유연성 10)
- [ ] 계산된 점수 × 0.85 적용
- [ ] 중앙 기준선 없음

---

### 5. 백엔드 계산 로직 (참고용)

**⚠️ 프론트엔드는 참고만 하고, 실제 계산은 백엔드에서 수행**

#### 하체 근력 점수 계산

```typescript
// 입력: grade = 'B'
// 출력: internalScore = 60
// 최종: strengthScore = 60 (0-100 범위)

// 입력: grade = 'D-1'
// 출력: internalScore = 30
// 최종: strengthScore = 30
```

#### 심폐 지구력 점수 계산

```typescript
// 입력: grade = 'B', recoverySpeed = ['fast']
// 출력: internalScore = 65
// 최종: cardioScore = 65

// 입력: grade = 'B', recoverySpeed = ['slow']
// 출력: internalScore = 55
// 최종: cardioScore = 55
```

#### 유연성 점수 계산

```typescript
// 입력: flexibilityItems = { shoulder: 'C', sitAndReach: 'C' }
// 가중치 합: 1.3 + 1.0 = 2.3
// 출력: internalScore = 40 (가중치 합 1.6~2.5 → 제한 있음)
// 최종: flexibilityScore = 40
```

#### 체성분 점수 계산

```typescript
// 입력: muscleMass, fatMass, bodyFatPercentage, age, gender
// 연령대별 기준과 비교
// 출력: internalScore = 60 (한 요소 관리 필요)
// 최종: bodyScore = 60
```

#### 안정성 점수 계산

```typescript
// 입력: ohsa = 'B', pain = 'present'
// 출력: internalScore = 45
// 최종: stabilityScore = 45
```

---

### 6. 에러 처리

**백엔드에서 반환 가능한 에러**:

```typescript
// 필수 항목 누락
{
  success: false,
  message: "하체 근력 평가 항목이 필요합니다.",
  errorCode: "MISSING_REQUIRED_ITEM"
}

// 잘못된 등급 값
{
  success: false,
  message: "유효하지 않은 등급입니다: 'X'",
  errorCode: "INVALID_GRADE"
}

// 조건부 입력 누락
{
  success: false,
  message: "D 선택 시 대체 항목을 선택해주세요.",
  errorCode: "MISSING_CONDITIONAL_INPUT"
}
```

**프론트엔드 처리**:

- 에러 메시지를 사용자에게 표시
- 해당 입력 필드에 에러 스타일 적용
- 재시도 가능하도록 UI 제공

---

### 7. 개발 순서 제안

1. **1단계**: 입력 UI 컴포넌트 구현
    - 각 카테고리별 입력 폼 컴포넌트 생성
    - 조건부 표시/숨김 로직 구현

2. **2단계**: 데이터 검증 로직 구현
    - 필수 항목 체크
    - 조건부 입력 검증

3. **3단계**: API 통신 구현
    - 평가 생성 API 호출
    - 요청 데이터 형식 변환

4. **4단계**: 응답 처리 및 레이더 차트 표시
    - 응답 데이터 파싱
    - 레이더 차트에 점수 표시 (×0.85 적용)

5. **5단계**: 에러 처리 및 사용자 피드백
    - 에러 메시지 표시
    - 성공 메시지 표시

---

## 🔗 관련 문서

- [ASSESSMENT_GUIDE.md](ASSESSMENT_GUIDE.md) - 평가 가이드 (상세)
- [2차개발방향.md](2차개발방향.md) - 개발 방향
- [BACKEND_FUTURE_DEVELOPMENT.md](BACKEND_FUTURE_DEVELOPMENT.md) - 이후 개발 사항
- [ABILITY_DB_STRUCTURE.md](ABILITY_DB_STRUCTURE.md) - DB 구조 상세

---

**작성일**: 2024-01-XX  
**최종 수정일**: 2024-01-XX  
**상태**: DB 구조 완료, 계산 로직 구현 예정

**✅ DB 마이그레이션 완료 상태** (2024-01-XX):

- `assessment_items.details` 필드 추가 완료
- `assessment_items.value`, `unit`, `score` nullable 처리 완료
- 체성분 평가 기준표, 등급 상수, 카테고리별 점수 매핑, 유연성 가중치 테이블 생성 완료
- Entity 및 DTO 수정 완료 (`AssessmentItem`, `CreateAssessmentItemDto`)
- Service 로직 수정 완료 (`assessments.service.ts`에서 `details` 저장 처리)
