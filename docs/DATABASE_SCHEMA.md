# 백엔드 데이터베이스 스키마 전체 구조

## 📋 테이블 목록

1. **인증 및 사용자 관리**
   - `users` - 사용자 계정 (로그인 정보)
   
2. **회원 관리**
   - `members` - 회원 기본 정보
   - `memberships` - 회원권 정보
   - `pt_usages` - PT 이용권 정보

3. **평가 및 능력치**
   - `assessments` - 평가 정보
   - `assessment_items` - 평가 세부 항목
   - `ability_snapshots` - 능력치 스냅샷

4. **부상 관리**
   - `injury_histories` - 부상 이력
   - `injury_restrictions` - 부상 제한 사항

5. **목표 및 세션 관리**
   - `pt_sessions` - PT 세션 기록
   - `workout_records` - 운동 기록
   - `workout_routines` - 운동 루틴

---

## 🔐 인증 및 사용자 관리

### `users` 테이블

**목적**: 로그인 인증을 위한 사용자 계정 정보

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `email` | VARCHAR(255) | 이메일 | UNIQUE, NOT NULL |
| `password` | VARCHAR(255) | 비밀번호 (해시) | nullable (소셜 로그인) |
| `name` | VARCHAR(255) | 이름 | NOT NULL |
| `role` | ENUM | 역할 | MEMBER, TRAINER, ADMIN |
| `is_approved` | BOOLEAN | 승인 여부 (TRAINER용) | default: false |
| `provider` | VARCHAR(50) | 로그인 제공자 | default: 'local' |
| `provider_id` | VARCHAR(255) | 소셜 로그인 ID | nullable |
| `refresh_token` | TEXT | 리프레시 토큰 | nullable |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |

**인덱스:**
- `idx_users_email` (email)

**관계:**
- `members` 테이블과 1:1 관계 (email로 연결)

---

## 👥 회원 관리

### `members` 테이블

**목적**: 헬스장 회원의 기본 정보

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `name` | VARCHAR(255) | 이름 | NOT NULL |
| `phone` | VARCHAR(50) | 전화번호 | NOT NULL |
| `email` | VARCHAR(255) | 이메일 | UNIQUE, NOT NULL |
| `join_date` | DATE | 가입일 | NOT NULL |
| `status` | ENUM | 상태 | ACTIVE, INACTIVE, SUSPENDED (default: ACTIVE) |
| `goal` | TEXT | 목표 한줄 요약 | nullable |
| `goal_progress` | INTEGER | 목표 진행률 (0-100) | default: 0 |
| `goal_trainer_comment` | TEXT | 트레이너 코멘트 | nullable |
| `total_sessions` | INTEGER | 총 세션 수 | default: 0 |
| `completed_sessions` | INTEGER | 완료된 세션 수 | default: 0 |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |
| `deleted_at` | TIMESTAMP | 삭제일시 (Soft Delete) | nullable |

**인덱스:**
- `idx_members_email` (email)
- `idx_members_status` (status)
- `idx_members_deleted_at` (deleted_at)

**관계:**
- `memberships` 테이블과 One-to-Many 관계
- `pt_usages` 테이블과 One-to-Many 관계
- `assessments` 테이블과 One-to-Many 관계
- `ability_snapshots` 테이블과 One-to-Many 관계
- `injury_histories` 테이블과 One-to-Many 관계
- `pt_sessions` 테이블과 One-to-Many 관계
- `workout_records` 테이블과 One-to-Many 관계
- `workout_routines` 테이블과 One-to-Many 관계

---

### `memberships` 테이블

**목적**: 회원권 정보

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `member_id` | UUID | 회원 ID | FK → members.id (CASCADE) |
| `membership_type` | VARCHAR(100) | 회원권 종류 | NOT NULL |
| `start_date` | DATE | 시작일 | NOT NULL |
| `end_date` | DATE | 만료일 | NOT NULL |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |

**관계:**
- `members` 테이블과 Many-to-One 관계

---

### `pt_usages` 테이블

**목적**: PT 이용권 정보

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `member_id` | UUID | 회원 ID | FK → members.id (CASCADE) |
| `total_sessions` | INTEGER | 총 세션 수 | NOT NULL |
| `used_sessions` | INTEGER | 사용한 세션 수 | default: 0 |
| `remaining_sessions` | INTEGER | 남은 세션 수 | 계산 필드 |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |

**관계:**
- `members` 테이블과 Many-to-One 관계

---

## 📊 평가 및 능력치

### `assessments` 테이블

**목적**: 회원의 평가 정보 (초기 평가, 정기 평가)

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `member_id` | UUID | 회원 ID | FK → members.id (CASCADE) |
| `assessment_type` | ENUM | 평가 유형 | INITIAL, PERIODIC, FLEXIBILITY |
| `evaluation_type` | ENUM | 평가 위계 | STATIC, DYNAMIC (nullable) ⚠️ |
| `static_evaluation` | JSONB | 정적 평가 데이터 | nullable ⚠️ |
| `dynamic_evaluation` | JSONB | 동적 평가 데이터 | nullable ⚠️ |

⚠️ **부분 구현**: DB 컬럼은 존재하지만 점수 계산 로직에서 사용되지 않음 (저장만 됨)
| `is_initial` | BOOLEAN | 초기 평가 여부 | default: false |
| `assessed_at` | DATE | 평가 날짜 | NOT NULL |
| `trainer_comment` | TEXT | 트레이너 코멘트 | nullable |
| `body_weight` | FLOAT | 체중 (kg) | nullable |
| `condition` | ENUM | 컨디션 | EXCELLENT, GOOD, NORMAL, POOR (nullable) |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |
| `deleted_at` | TIMESTAMP | 삭제일시 (Soft Delete) | nullable |

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

### `assessment_items` 테이블

**목적**: 평가의 세부 항목들

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `assessment_id` | UUID | 평가 ID | FK → assessments.id (CASCADE) |
| `category` | ENUM | 카테고리 | STRENGTH, CARDIO, ENDURANCE, FLEXIBILITY, BODY, STABILITY |
| `name` | VARCHAR(255) | 항목명 | NOT NULL |
| `value` | FLOAT | 측정값 | NOT NULL |
| `unit` | VARCHAR(50) | 단위 | NOT NULL |
| `score` | FLOAT | 점수 | NOT NULL |
| `created_at` | TIMESTAMP | 생성일시 | |

**인덱스:**
- `idx_assessment_items_assessment_id` (assessment_id)
- `idx_assessment_items_category` (category)

**관계:**
- `assessments` 테이블과 Many-to-One 관계

---

### `ability_snapshots` 테이블

**목적**: 평가 항목들을 종합하여 계산된 능력치 점수

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `assessment_id` | UUID | 평가 ID | FK → assessments.id (UNIQUE, CASCADE) |
| `member_id` | UUID | 회원 ID | FK → members.id (CASCADE) |
| `assessed_at` | TIMESTAMP | 평가 시점 | NOT NULL |
| `version` | VARCHAR(50) | 점수 계산 버전 | NOT NULL |
| `strength_score` | FLOAT | 하체 근력 점수 | nullable |
| `cardio_score` | FLOAT | 심폐 지구력 점수 | nullable |
| `endurance_score` | FLOAT | 근지구력 점수 | nullable |
| `flexibility_score` | FLOAT | 유연성 점수 | nullable ✅ |

✅ **구현 완료**: DB 컬럼 존재 및 점수 계산 로직에 포함됨 (가중치 15%)
| `body_score` | FLOAT | 체성분 밸런스 점수 | nullable |
| `stability_score` | FLOAT | 부상 안정성 점수 | nullable |
| `total_score` | FLOAT | 종합 점수 | NOT NULL |
| `created_at` | TIMESTAMP | 생성일시 | |

**인덱스:**
- `idx_ability_snapshots_assessment_id` (assessment_id) - UNIQUE
- `idx_ability_snapshots_member_id` (member_id)
- `idx_ability_snapshots_assessed_at` (assessed_at)

**관계:**
- `assessments` 테이블과 One-to-One 관계
- `members` 테이블과 Many-to-One 관계

---

## 🏥 부상 관리

### `injury_histories` 테이블

**목적**: 회원의 부상 이력

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `member_id` | UUID | 회원 ID | FK → members.id (CASCADE) |
| `injury_type` | VARCHAR(255) | 부상 유형 | NOT NULL |
| `body_part` | VARCHAR(255) | 부상 부위 | NOT NULL |
| `date` | DATE | 부상 발생일 | NOT NULL |
| `severity` | ENUM | 심각도 | MILD, MODERATE, SEVERE |
| `description` | TEXT | 설명 | nullable |
| `recovery_status` | ENUM | 회복 상태 | RECOVERED, RECOVERING, CHRONIC |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |

**관계:**
- `members` 테이블과 Many-to-One 관계
- `injury_restrictions` 테이블과 One-to-Many 관계

---

### `injury_restrictions` 테이블

**목적**: 부상으로 인한 평가 제한 사항

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `injury_id` | UUID | 부상 이력 ID | FK → injury_histories.id (CASCADE) |
| `restricted_category` | ENUM | 제한된 카테고리 | STRENGTH, CARDIO, ENDURANCE, FLEXIBILITY, BODY, STABILITY |
| `created_at` | TIMESTAMP | 생성일시 | |

**관계:**
- `injury_histories` 테이블과 Many-to-One 관계

---

## 🎯 목표 및 세션 관리

### `pt_sessions` 테이블

**목적**: PT 세션 기록

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `member_id` | UUID | 회원 ID | FK → members.id (CASCADE) |
| `session_date` | DATE | 세션 날짜 | NOT NULL |
| `session_number` | INTEGER | 회차 번호 | NOT NULL |
| `main_content` | TEXT | 주요 수업 내용 | NOT NULL |
| `trainer_comment` | TEXT | 트레이너 코멘트 | nullable |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |

**인덱스:**
- `idx_pt_sessions_member_id` (member_id)
- `idx_pt_sessions_session_date` (session_date)

**관계:**
- `members` 테이블과 Many-to-One 관계
- `workout_records` 테이블과 One-to-Many 관계 (pt_session_id)

---

### `workout_records` 테이블

**목적**: 운동 기록 (PT 세션 또는 개인 운동)

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `member_id` | UUID | 회원 ID | FK → members.id (CASCADE) |
| `workout_date` | DATE | 운동 날짜 | NOT NULL |
| `body_part` | VARCHAR(50) | 부위 | NOT NULL |
| `exercise_name` | VARCHAR(100) | 운동명 | NOT NULL |
| `weight` | FLOAT | 무게 (kg) | NOT NULL |
| `reps` | INTEGER | 횟수 | NOT NULL |
| `sets` | INTEGER | 세트 수 | NOT NULL |
| `volume` | FLOAT | 볼륨 (weight * reps * sets) | NOT NULL |
| `duration` | INTEGER | 운동 시간 (분) | nullable |
| `workout_type` | ENUM | 운동 타입 | PT, PERSONAL |
| `pt_session_id` | UUID | PT 세션 ID | FK → pt_sessions.id (nullable) |
| `trainer_comment` | TEXT | 트레이너 코멘트 | nullable |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |

**인덱스:**
- `idx_workout_records_member_id` (member_id)
- `idx_workout_records_workout_date` (workout_date)
- `idx_workout_records_workout_type` (workout_type)

**관계:**
- `members` 테이블과 Many-to-One 관계
- `pt_sessions` 테이블과 Many-to-One 관계 (nullable)

---

### `workout_routines` 테이블

**목적**: 추천 운동 루틴 (공통 또는 회원별)

| 컬럼명 | 타입 | 설명 | 제약조건 |
|--------|------|------|----------|
| `id` | UUID | 기본키 | PK |
| `member_id` | UUID | 회원 ID | FK → members.id (nullable, CASCADE) |
| `routine_date` | DATE | 루틴 날짜 | nullable |
| `routine_name` | VARCHAR(255) | 루틴명 | NOT NULL |
| `exercises` | JSONB | 운동 목록 | NOT NULL |
| `estimated_duration` | INTEGER | 예상 소요 시간 (분) | NOT NULL |
| `difficulty` | ENUM | 난이도 | EASY, MEDIUM, HARD |
| `is_completed` | BOOLEAN | 완료 여부 | default: false |
| `created_at` | TIMESTAMP | 생성일시 | |
| `updated_at` | TIMESTAMP | 수정일시 | |

**인덱스:**
- `idx_workout_routines_member_id` (member_id)
- `idx_workout_routines_routine_date` (routine_date)

**관계:**
- `members` 테이블과 Many-to-One 관계 (nullable - 공통 루틴의 경우 null)

**JSONB 구조 (exercises):**
```json
[
  {
    "exerciseName": "벤치프레스",
    "bodyPart": "상체",
    "sets": 3,
    "reps": 10,
    "weight": 50,
    "duration": null,
    "restTime": 60,
    "notes": "가슴 근육에 집중"
  }
]
```

---

## 🔗 전체 테이블 관계도

```
users (사용자 계정)
  └── (email로 연결) ──→ members (회원)

members (회원)
  ├── memberships (회원권) - One-to-Many
  ├── pt_usages (PT 이용권) - One-to-Many
  ├── assessments (평가) - One-to-Many
  │     ├── assessment_items (평가 항목) - One-to-Many
  │     └── ability_snapshots (능력치 스냅샷) - One-to-One
  ├── ability_snapshots (능력치 스냅샷) - One-to-Many
  ├── injury_histories (부상 이력) - One-to-Many
  │     └── injury_restrictions (부상 제한) - One-to-Many
  ├── pt_sessions (PT 세션) - One-to-Many
  │     └── workout_records (운동 기록) - One-to-Many (pt_session_id)
  ├── workout_records (운동 기록) - One-to-Many
  └── workout_routines (운동 루틴) - One-to-Many
```

---

## 📊 주요 특징

### 1. Soft Delete
- `members`, `assessments` 테이블은 Soft Delete 사용 (`deleted_at`)
- 데이터 복구 가능 및 히스토리 유지

### 2. CASCADE DELETE
- 대부분의 관계에서 CASCADE DELETE 사용
- 부모 레코드 삭제 시 자식 레코드 자동 삭제

### 3. JSONB 필드
- `assessments.static_evaluation` - 정적 평가 데이터 ⚠️ (저장만 됨, 계산 로직 미사용)
- `assessments.dynamic_evaluation` - 동적 평가 데이터 ⚠️ (저장만 됨, 계산 로직 미사용)
- `workout_routines.exercises` - 운동 목록 ✅

### 4. 인덱스 최적화
- 자주 조회되는 컬럼에 인덱스 설정
- `member_id`, `assessed_at`, `workout_date` 등

### 5. Enum 타입
- 상태, 역할, 카테고리 등을 Enum으로 관리
- 데이터 일관성 보장

---

---

## ⚠️ 미구현 및 추후 추가 예정 기능

### 1. 유연성(FLEXIBILITY) 점수 계산 로직
- **상태**: ✅ 구현 완료
- **위치**: `src/common/utils/score-calculator.ts`
- **내용**: `calculateCategoryScores()`, `excludeRestrictedCategories()`, `calculateTotalScore()`에 FLEXIBILITY 포함됨
- **가중치**: 15% (1차피드백 제안 가중치 반영)

### 2. 정적/동적 평가 데이터 활용
- **상태**: DB 컬럼만 존재, 점수 계산에 미사용
- **위치**: `assessments.static_evaluation`, `assessments.dynamic_evaluation`
- **작업**: 점수 계산 로직에 정적/동적 평가 데이터 활용 추가 필요

### 3. 가중치 커스터마이징
- **상태**: 하드코딩된 가중치 사용 중
- **위치**: `src/common/utils/score-calculator.ts:calculateTotalScore()`
- **작업**: 트레이너별 가중치 설정 기능 추가 필요 (1차 피드백 요구사항, 낮은 우선순위)

### 4. 평가 항목 점수 표준화 함수
- **상태**: 현재 `value`를 그대로 `score`로 사용
- **위치**: `src/modules/assessments/assessments.service.ts:149` (TODO 주석)
- **작업**: 측정값을 표준화하여 점수로 변환하는 함수 구현 필요

---

## 📚 관련 파일

- **엔티티**: `src/entities/` 디렉토리
- **마이그레이션**: `database/` 디렉토리
- **상세 문서**: `docs/ABILITY_DB_STRUCTURE.md` (능력치 관련 상세 설명)

