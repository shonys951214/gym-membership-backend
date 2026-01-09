# 백엔드에 구현되어 있지만 프론트엔드에서 사용하지 않는 API 목록

## 📋 개요

백엔드에 구현되어 있지만 프론트엔드에서 아직 사용하지 않는 API 엔드포인트 목록입니다.

---

## 1. 평가 (Assessments)

### ✅ 사용 중

- `GET /api/members/:memberId/assessments` - 평가 목록 조회
- `GET /api/members/:memberId/assessments/:id` - 평가 상세 조회
- `POST /api/members/:memberId/assessments` - 평가 생성
- `PUT /api/members/:memberId/assessments/:id` - 평가 수정

### ❌ 미사용

- **`GET /api/members/:memberId/assessments/check-initial`** - 초기 평가 존재 여부 확인
    - **설명**: 평가 생성 전에 초기 평가가 있는지 확인하는 엔드포인트
    - **용도**: 프론트엔드에서 평가 생성 폼을 표시하기 전에 초기 평가 여부를 확인하여 평가 타입을 자동으로 결정
    - **백엔드 위치**: `src/modules/assessments/assessments.controller.ts:50-71`

---

## 2. 능력치 (Abilities)

### ✅ 사용 중

- `GET /api/members/:memberId/abilities/latest` - 최신 능력치 스냅샷 조회
- `GET /api/members/:memberId/abilities/snapshots` - 능력치 스냅샷 목록 조회
- `GET /api/members/:memberId/abilities/compare` - 능력치 비교
- `GET /api/members/:memberId/abilities/hexagon` - 능력치 헥사곤 데이터 조회
- `GET /api/members/:memberId/abilities/history` - 체력 테스트 히스토리 조회

**모든 엔드포인트 사용 중** ✅

---

## 3. 분석 (Analytics)

### ✅ 사용 중

- `GET /api/analytics/averages` - 전체 평균 데이터 조회
- `GET /api/analytics/comparison/:memberId` - 개별 vs 평균 비교

### ❌ 미사용

- **`GET /api/members/:memberId/analytics`** - 회원 능력치 데이터 조회
    - **설명**: 특정 회원의 모든 능력치 스냅샷 데이터를 조회하며, 백분위 및 평균 스냅샷을 포함
    - **응답 구조**:
        ```typescript
        {
          memberId: string;
          latestSnapshot: AbilitySnapshot;
          averageSnapshot: AbilitySnapshot;
          percentile: {
            strengthScore: number;
            cardioScore: number;
            // ... 기타 점수들의 백분위
          };
          snapshots: AbilitySnapshot[];
          total: number;
        }
        ```
    - **용도**: 회원 상세 페이지에서 능력치 분석 및 백분위 표시
    - **백엔드 위치**: `src/modules/members/analytics.controller.ts:26-62`
    - **참고**: 프론트엔드 `analytics.ts`에는 `getMemberAnalytics`가 있지만 실제로 사용되는지 확인 필요
    - **프론트엔드 파일**: `front/Gym-admin/lib/api/analytics.ts` (구현되어 있으나 사용 여부 확인 필요)

---

## 4. 인사이트 (Insights)

### ✅ 사용 중

- `GET /api/insights/hexagon` - 운영 능력치 헥사곤 조회
- `GET /api/insights/weekly-summary` - 주간 요약 조회
- `GET /api/insights/risk-members` - 위험 신호 회원 조회

**모든 엔드포인트 사용 중** ✅

---

## 5. 회원 (Members)

### ✅ 사용 중

- `GET /api/members` - 회원 목록 조회
- `GET /api/members/:id` - 회원 상세 조회
- `POST /api/members` - 회원 등록
- `PUT /api/members/:id` - 회원 정보 수정
- `DELETE /api/members/:id` - 회원 삭제

### ✅ 사용 중 (회원 관련 하위 엔드포인트)

#### 5.1 회원권 (Membership) ✅

- `GET /api/members/:id/membership` - 회원권 조회
- `POST /api/members/:id/membership` - 회원권 등록
- `PUT /api/members/:id/membership/:membershipId` - 회원권 수정
- `DELETE /api/members/:id/membership/:membershipId` - 회원권 삭제
- **프론트엔드 파일**: `front/Gym-admin/lib/api/membership.ts`

#### 5.2 PT 횟수 (PT Usage) ✅

- `GET /api/members/:id/pt-count` - PT 횟수 조회
- `POST /api/members/:id/pt-count` - PT 횟수 생성/업데이트
- `PUT /api/members/:id/pt-count` - PT 횟수 수정
- **프론트엔드 파일**: `front/Gym-admin/lib/api/pt-count.ts`

#### 5.3 목표 (Goals) ✅

- `GET /api/members/:id/goals` - 회원 목표 조회
- `POST /api/members/:id/goals` - 회원 목표 생성
- `PUT /api/members/:id/goals` - 회원 목표 수정
- `DELETE /api/members/:id/goals` - 회원 목표 삭제
- **프론트엔드 파일**: `front/Gym-admin/lib/api/goals.ts`

#### 5.4 운동 기록 (Workout Records) ✅

- `GET /api/members/:id/workout-records/calendar` - 운동 캘린더 조회
- `GET /api/members/:id/workout-records/volume-analysis` - 운동 기록 볼륨 분석
- `GET /api/members/:id/workout-records` - 운동 기록 목록 조회
- `GET /api/members/:id/workout-records/:recordId` - 운동 기록 상세 조회
- `POST /api/members/:id/workout-records` - 운동 기록 생성
- `PUT /api/members/:id/workout-records/:recordId` - 운동 기록 수정
- `DELETE /api/members/:id/workout-records/:recordId` - 운동 기록 삭제
- **프론트엔드 파일**: `front/Gym-admin/lib/api/workout-records.ts`

#### 5.5 PT 세션 (PT Sessions) ✅

- `GET /api/members/:id/pt-sessions` - PT 세션 목록 조회
- `GET /api/members/:id/pt-sessions/:sessionId` - PT 세션 상세 조회
- `POST /api/members/:id/pt-sessions` - PT 세션 생성
- `PUT /api/members/:id/pt-sessions/:sessionId` - PT 세션 수정
- `DELETE /api/members/:id/pt-sessions/:sessionId` - PT 세션 삭제
- **프론트엔드 파일**: `front/Gym-admin/lib/api/pt-sessions.ts`

#### 5.6 운동 루틴 (Workout Routines - 회원별) ✅

- `GET /api/members/:id/workout-routines/today` - 오늘의 운동 루틴 조회
- `GET /api/members/:id/workout-routines` - 운동 루틴 목록 조회
- `POST /api/members/:id/workout-routines` - 운동 루틴 생성
- `PUT /api/members/:id/workout-routines/:routineId` - 운동 루틴 수정
- `PUT /api/members/:id/workout-routines/:routineId/complete` - 운동 루틴 완료 처리
- `DELETE /api/members/:id/workout-routines/:routineId` - 운동 루틴 삭제
- **프론트엔드 파일**: `front/Gym-admin/lib/api/workout-routines.ts`

#### 5.7 대시보드 ✅

- `GET /api/members/:id/dashboard` - 대시보드 통합 데이터 조회
    - **설명**: 회원의 목표, 수업 진행률, 운동 캘린더, 운동 기록 분석을 통합하여 조회
    - **프론트엔드 파일**: `front/Gym-admin/lib/api/dashboard.ts`

### ❌ 미사용

- **`GET /api/members/:id/workout-records/volume`** - 부위별 볼륨 조회 (하위 호환성)
    - **설명**: `volume-analysis`와 유사하지만 다른 형식의 응답을 반환
    - **참고**: `volume-analysis`를 사용 중이므로 이 엔드포인트는 선택 사항

---

## 6. 부상 (Injuries)

### ✅ 사용 중

- `GET /api/members/:memberId/injuries` - 부상 이력 목록 조회
- `GET /api/members/:memberId/injuries/:id` - 부상 이력 상세 조회
- `POST /api/members/:memberId/injuries` - 부상 이력 등록
- `PUT /api/members/:memberId/injuries/:id` - 부상 이력 수정
- `POST /api/members/:memberId/injuries/:id/restrictions` - 평가 제한 설정

**모든 엔드포인트 사용 중** ✅

---

## 7. 운동 루틴 (Workout Routines - 공통)

### ✅ 사용 중

- `GET /api/workout-routines` - 공통 운동 루틴 목록 조회
- `GET /api/workout-routines/today` - 오늘의 공통 운동 루틴 조회
- `GET /api/workout-routines/:routineId` - 공통 운동 루틴 상세 조회
- `POST /api/workout-routines` - 공통 운동 루틴 생성
- `PUT /api/workout-routines/:routineId` - 공통 운동 루틴 수정
- `DELETE /api/workout-routines/:routineId` - 공통 운동 루틴 삭제

**모든 엔드포인트 사용 중** ✅

---

## 8. 인증 (Auth)

### ✅ 사용 중

- `POST /api/auth/login` - 로그인
- `POST /api/auth/register` - 회원가입
- `GET /api/auth/session` - 세션 확인
- `POST /api/auth/logout` - 로그아웃
- `POST /api/auth/refresh` - 토큰 갱신
- `PUT /api/auth/profile` - 본인 정보 수정

### ✅ 사용 중

- `POST /api/auth/refresh` - 토큰 갱신
- `PUT /api/auth/profile` - 본인 정보 수정

### ❌ 미사용

#### 8.1 테스트 계정

- **`POST /api/auth/create-test-account`** - 테스트 계정 생성
    - **설명**: 개발 환경 전용 테스트 계정 생성 (email: test, password: test, 권한: ADMIN)

#### 8.2 카카오 로그인

- **`GET /api/auth/kakao`** - 카카오 로그인 시작
- **`GET /api/auth/kakao/callback`** - 카카오 로그인 콜백

#### 8.3 관리자 기능

- **`PUT /api/auth/users/:id`** - 사용자 정보 수정 (관리자)
    - **설명**: ADMIN이 다른 사용자의 정보를 수정 (이름, 이메일, 비밀번호, 역할)

#### 8.4 TRAINER 관리 ✅ (일부 사용 중)

- **`GET /api/auth/pending-trainers`** - 승인 대기 TRAINER 목록 조회 ✅
- **`GET /api/auth/trainers`** - 전체 TRAINER 목록 조회 ✅
- **`POST /api/auth/approve-trainer/:id`** - TRAINER 승인 ✅
- **`POST /api/auth/disapprove-trainer/:id`** - TRAINER 승인 취소 ✅
- **`DELETE /api/auth/reject-trainer/:id`** - TRAINER 거부 ✅
- **프론트엔드 파일**: `front/Gym-admin/lib/api/trainers.ts`

---

## 📊 요약

### 전체 통계

- **총 백엔드 엔드포인트**: 약 80개 이상
- **프론트엔드에서 사용 중**: 약 70개 이상
- **미사용 엔드포인트**: 약 10개 미만

### 주요 미사용 기능 카테고리

1. **평가 관리**
    - 초기 평가 존재 여부 확인 (`GET /api/members/:memberId/assessments/check-initial`)

2. **분석**
    - 회원별 능력치 데이터 (백분위 포함) (`GET /api/members/:memberId/analytics`)
    - 부위별 볼륨 조회 (하위 호환성) (`GET /api/members/:id/workout-records/volume`)

3. **인증/권한 관리**
    - 테스트 계정 생성 (`POST /api/auth/create-test-account`)
    - 카카오 로그인 (`GET /api/auth/kakao`, `GET /api/auth/kakao/callback`)
    - 사용자 정보 수정 (관리자) (`PUT /api/auth/users/:id`)

---

## 💡 권장 사항

### 우선순위 높음

1. **`GET /api/members/:memberId/assessments/check-initial`** - 평가 생성 UX 개선
    - 평가 생성 폼 표시 전에 초기 평가 여부를 확인하여 평가 타입을 자동으로 결정
    - 현재는 평가 생성 시도 후 에러로 처리되는데, 이를 사전에 확인 가능

2. **`GET /api/members/:memberId/analytics`** - 백분위 표시 기능 추가
    - 회원 상세 페이지에서 능력치 백분위 표시
    - 평균 대비 회원의 위치를 시각적으로 표현

### 우선순위 중간

3. **`GET /api/members/:id/workout-records/volume`** - 부위별 볼륨 조회 (하위 호환성)
    - `volume-analysis`와 다른 형식의 응답이 필요한 경우 사용

### 우선순위 낮음

4. **`POST /api/auth/create-test-account`** - 테스트 계정 생성 (개발 환경 전용)
5. **`GET /api/auth/kakao`**, **`GET /api/auth/kakao/callback`** - 카카오 로그인 (소셜 로그인)
6. **`PUT /api/auth/users/:id`** - 사용자 정보 수정 (관리자 기능)

---

## 📝 참고

- 모든 엔드포인트는 Swagger UI (`/api/docs`)에서 확인 가능
- 백엔드 컨트롤러 파일 위치: `src/modules/*/**.controller.ts`
- 프론트엔드 API 파일 위치: `front/Gym-admin/lib/api/*.ts`
