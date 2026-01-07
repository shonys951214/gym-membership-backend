# 백엔드 API 가이드 (프론트엔드 개발자용)

## 📋 목차

1. [기본 정보](#기본-정보)
2. [Swagger API 문서](#swagger-api-문서) ⭐ **추천**
3. [인증](#인증)
4. [API 응답 형식](#api-응답-형식)
5. [에러 처리](#에러-처리)
6. [데이터 검증 규칙](#데이터-검증-규칙)
7. [API 엔드포인트](#api-엔드포인트)
8. [백엔드 구조](#백엔드-구조)

---

## 기본 정보

### Base URL

```
개발 환경: http://localhost:3001
프로덕션: (배포 후 설정)
```

### 인증 방식

- **JWT (JSON Web Token)** 사용
- 모든 API 요청 시 `Authorization: Bearer {token}` 헤더 필수
- 예외: 로그인, 회원가입은 인증 불필요 (`@Public()` 데코레이터)

### Content-Type

모든 요청/응답은 `application/json` 형식

---

## Swagger API 문서 ⭐

**가장 쉬운 방법!** Swagger UI에서 모든 API를 확인하고 테스트할 수 있습니다.

### 접근 방법

```
로컬: http://localhost:3001/api
프로덕션: https://your-app.onrender.com/api
```

### 주요 기능

1. **모든 API 엔드포인트 확인**: 왼쪽 사이드바에서 API 목록 확인
2. **요청/응답 스키마 확인**: 각 API의 데이터 구조 확인
3. **직접 테스트**: 브라우저에서 바로 API 호출 가능
4. **JWT 인증 설정**: 우측 상단 "Authorize" 버튼으로 토큰 설정

### 사용 방법

1. **로그인하여 토큰 얻기**
    - `POST /api/auth/login` 클릭
    - "Try it out" → 로그인 정보 입력 → "Execute"
    - 응답에서 `accessToken` 복사

2. **인증 설정**
    - 우측 상단 "Authorize" 버튼 클릭
    - 토큰 붙여넣기 → "Authorize" 클릭
    - 이제 모든 API 요청에 자동으로 토큰 포함!

3. **API 테스트**
    - 원하는 API 클릭 → "Try it out" → 파라미터 입력 → "Execute"

### 상세 가이드

자세한 사용 방법은 [docs/SWAGGER_GUIDE.md](../docs/SWAGGER_GUIDE.md)를 참고하세요.

---

## 인증

### 일반 로그인

```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**응답:**

```json
{
	"success": true,
	"data": {
		"accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
		"refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
		"user": {
			"id": "uuid",
			"email": "user@example.com",
			"name": "홍길동",
			"role": "TRAINER",
			"provider": "LOCAL",
			"isApproved": true
		}
	},
	"message": "로그인 성공"
}
```

> **토큰 정보**:
>
> - `accessToken`: 15분 유효 (API 요청 시 사용)
> - `refreshToken`: 7일 유효 (토큰 갱신 시 사용, DB에 저장)
> - JWT payload에 `isApproved` 포함 (프론트엔드에서 승인 상태 확인 가능)

> **TRAINER 승인 대기 처리**:
>
> - 승인 대기 중인 TRAINER(`isApproved: false`)도 로그인 가능
> - 프론트엔드에서 `role === 'TRAINER' && isApproved === false`인 경우 `/dashboard/approval-pending`으로 리다이렉트

### 회원가입

```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "홍길동",
  "role": "TRAINER"  // 선택사항, 기본값: MEMBER
}
```

**응답 (TRAINER인 경우):**

```json
{
	"success": true,
	"data": {
		"id": "uuid",
		"email": "user@example.com",
		"name": "홍길동",
		"role": "TRAINER",
		"isApproved": false
	},
	"message": "TRAINER 회원가입이 완료되었습니다. ADMIN의 승인을 기다려주세요."
}
```

> **중요**:
>
> - `role: "TRAINER"`로 가입하면 `isApproved: false` 상태로 저장됨
> - **승인 대기 중인 TRAINER도 로그인 가능** (프론트엔드에서 승인 대기 페이지로 리다이렉트)
> - `role: "MEMBER"`는 자동 승인 (`isApproved: true`)
> - `role: "ADMIN"`은 회원가입 불가 (test 계정만 사용)

### 세션 확인

```http
GET /api/auth/session
Authorization: Bearer {token}
```

**응답:**

```json
{
	"success": true,
	"data": {
		"id": "uuid",
		"email": "user@example.com",
		"name": "홍길동",
		"role": "TRAINER",
		"isApproved": false
	},
	"message": "세션 확인 성공"
}
```

> **참고**: `isApproved` 필드로 승인 상태 확인 가능

### 토큰 갱신

```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**응답:**

```json
{
  "success": true,
  "data": {
    "accessToken": "새로운 토큰...",
    "refreshToken": "새로운 refreshToken...",
    "user": { ... }
  },
  "message": "토큰 갱신 성공"
}
```

> **중요**:
>
> - `accessToken`이 만료되면 `refreshToken`으로 갱신
> - `refreshToken`도 만료되면 다시 로그인 필요
> - `refreshToken`은 DB에 저장되어 단일 기기 세션 관리

### 로그아웃

```http
POST /api/auth/logout
Authorization: Bearer {token}
```

> **참고**: 로그아웃 시 DB에서 `refreshToken`이 삭제됩니다.

### 사용자 정보 수정

#### 본인 정보 수정

```http
PUT /api/auth/profile
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "새로운 이름",
  "email": "newemail@example.com",
  "password": "newpassword123"
}
```

> **제한사항**: 본인 정보 수정에서는 `role` 변경 불가

#### 사용자 정보 수정 (관리자)

```http
PUT /api/auth/users/:id
Authorization: Bearer {adminToken}
Content-Type: application/json

{
  "name": "수정된 이름",
  "email": "updated@example.com",
  "password": "newpassword123",
  "role": "TRAINER"
}
```

> **권한**: ADMIN만 가능, `role` 변경 포함 모든 필드 수정 가능

### TRAINER 승인 관리 (ADMIN만)

#### 승인 대기 TRAINER 목록

```http
GET /api/auth/pending-trainers
Authorization: Bearer {adminToken}
```

**응답:**

```json
{
	"success": true,
	"data": {
		"trainers": [
			{
				"id": "uuid",
				"email": "trainer@example.com",
				"name": "트레이너",
				"role": "TRAINER",
				"isApproved": false,
				"createdAt": "2024-01-01T00:00:00.000Z"
			}
		],
		"total": 1
	},
	"message": "승인 대기 TRAINER 목록 조회 성공"
}
```

#### TRAINER 승인

```http
POST /api/auth/approve-trainer/:id
Authorization: Bearer {adminToken}
```

#### TRAINER 거부 (계정 삭제)

```http
DELETE /api/auth/reject-trainer/:id
Authorization: Bearer {adminToken}
```

> **중요**:
>
> - TRAINER로 회원가입하면 승인 대기 상태 (`isApproved: false`)
> - **승인 대기 중인 TRAINER도 로그인 가능** (프론트엔드에서 승인 대기 페이지로 리다이렉트)
> - ADMIN이 승인하면 `isApproved: true`로 변경되어 정상 사용 가능
> - 거부 시 계정이 삭제됨

### 카카오 로그인

```http
GET /api/auth/kakao
```

- 카카오 로그인 페이지로 리다이렉트

```http
GET /api/auth/kakao/callback
```

- 카카오 인증 후 콜백 처리
- 일반 로그인과 동일한 JWT 토큰 형식 반환

**응답 형식:**

```json
{
	"success": true,
	"data": {
		"accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
		"refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
		"user": {
			"id": "uuid",
			"email": "user@kakao.com",
			"name": "홍길동",
			"role": "MEMBER",
			"provider": "KAKAO"
		}
	},
	"message": "카카오 로그인 성공"
}
```

> **참고**:
>
> - 카카오 로그인 사용자는 `provider: "KAKAO"` 필드가 포함됩니다
> - 같은 이메일로 일반 로그인과 카카오 로그인을 할 경우, 기존 계정에 자동 연결됩니다
> - 카카오 로그인 사용자는 비밀번호가 없으므로 일반 로그인은 불가능합니다
> - 카카오에서 이메일 정보를 제공하지 않으면 자동 생성됩니다 (`KAKAO_{providerId}@social.local`)

---

## API 응답 형식

### 성공 응답

```typescript
{
  success: true;
  data: T;           // 실제 데이터
  message?: string;  // 선택적 메시지
}
```

### 에러 응답

```typescript
{
  success: false;
  error: {
    code: string;      // 에러 코드
    message: string;   // 에러 메시지
    details?: unknown; // 추가 정보 (선택)
  };
}
```

---

## 에러 처리

### HTTP 상태 코드

| 상태 코드 | 의미                  | 설명        |
| --------- | --------------------- | ----------- |
| 200       | OK                    | 성공        |
| 201       | Created               | 생성 성공   |
| 400       | Bad Request           | 잘못된 요청 |
| 401       | Unauthorized          | 인증 실패   |
| 403       | Forbidden             | 권한 없음   |
| 404       | Not Found             | 리소스 없음 |
| 500       | Internal Server Error | 서버 오류   |

### 주요 에러 코드

```typescript
// 인증 관련
UNAUTHORIZED; // 인증 실패 (토큰 없음/만료)
FORBIDDEN; // 권한 없음

// 회원 관련
MEMBER_NOT_FOUND; // 회원을 찾을 수 없음
MEMBER_ALREADY_EXISTS; // 이미 등록된 회원

// 평가 관련
ASSESSMENT_NOT_FOUND; // 평가를 찾을 수 없음
INITIAL_ASSESSMENT_ALREADY_EXISTS; // 초기 평가 이미 존재

// 부상 관련
INJURY_NOT_FOUND; // 부상 이력을 찾을 수 없음

// 검증 관련
VALIDATION_ERROR; // 입력 데이터 검증 실패 (전화번호 형식 등)

// 서버 관련
INTERNAL_SERVER_ERROR; // 서버 오류
```

### 에러 응답 예시

```json
{
	"success": false,
	"error": {
		"code": "VALIDATION_ERROR",
		"message": "유효한 전화번호 형식이어야 합니다. (예: 010-1234-5678, 02-1234-5678)",
		"details": {
			"path": "/api/members",
			"method": "POST",
			"timestamp": "2024-01-06T14:46:19.468+09:00"
		}
	}
}
```

---

## API 엔드포인트

### 인증 (`/api/auth`)

| Method | Endpoint               | 설명                   | 인증 | 권한  |
| ------ | ---------------------- | ---------------------- | ---- | ----- |
| POST   | `/login`               | 일반 로그인            | ❌   | -     |
| POST   | `/register`            | 회원가입               | ❌   | -     |
| GET    | `/session`             | 세션 확인              | ✅   | -     |
| POST   | `/logout`              | 로그아웃               | ✅   | -     |
| POST   | `/refresh`             | 토큰 갱신              | ❌   | -     |
| POST   | `/create-test-account` | 테스트 계정 생성       | ❌   | -     |
| PUT    | `/profile`             | 본인 정보 수정         | ✅   | -     |
| PUT    | `/users/:id`           | 사용자 정보 수정       | ✅   | ADMIN |
| GET    | `/pending-trainers`    | 승인 대기 TRAINER 목록 | ✅   | ADMIN |
| POST   | `/approve-trainer/:id` | TRAINER 승인           | ✅   | ADMIN |
| DELETE | `/reject-trainer/:id`  | TRAINER 거부           | ✅   | ADMIN |
| GET    | `/kakao`               | 카카오 로그인          | ❌   | -     |
| GET    | `/kakao/callback`      | 카카오 콜백            | ❌   | -     |

### 회원 관리 (`/api/members`)

| Method | Endpoint | 설명      | 권한           |
| ------ | -------- | --------- | -------------- |
| GET    | `/`      | 회원 목록 | ADMIN, TRAINER |
| GET    | `/:id`   | 회원 상세 | ✅             |
| POST   | `/`      | 회원 등록 | ADMIN, TRAINER |
| PUT    | `/:id`   | 회원 수정 | ADMIN, TRAINER |
| DELETE | `/:id`   | 회원 삭제 | ADMIN          |

**회원 등록 시 데이터 검증:**

- `name`: 문자열, 최대 255자
- `phone`: 한국 전화번호 형식 (예: `010-1234-5678`, `02-1234-5678`)
- `email`: 이메일 형식, 최대 255자
- `joinDate`: `YYYY-MM-DD` 형식
- `status`: 선택사항, 기본값 `ACTIVE`

### 회원권 관리 (`/api/members/:id/membership`)

| Method | Endpoint         | 설명        | 권한           |
| ------ | ---------------- | ----------- | -------------- |
| GET    | `/`              | 회원권 조회 | ✅             |
| POST   | `/`              | 회원권 등록 | ADMIN, TRAINER |
| PUT    | `/:membershipId` | 회원권 수정 | ADMIN, TRAINER |
| DELETE | `/:membershipId` | 회원권 삭제 | ADMIN          |

**membershipType**: `MONTHLY` | `QUARTERLY` | `YEARLY` | `LIFETIME`  
**status**: `ACTIVE` | `EXPIRED` | `SUSPENDED`

### PT 횟수 관리 (`/api/members/:id/pt-count`)

| Method | Endpoint | 설명         | 권한           |
| ------ | -------- | ------------ | -------------- |
| GET    | `/`      | PT 횟수 조회 | ✅             |
| PUT    | `/`      | PT 횟수 수정 | ADMIN, TRAINER |

### 평가 시스템 (`/api/members/:memberId/assessments`)

| Method | Endpoint         | 설명      | 권한           |
| ------ | ---------------- | --------- | -------------- |
| GET    | `/`              | 평가 목록 | ✅             |
| GET    | `/:assessmentId` | 평가 상세 | ✅             |
| POST   | `/`              | 평가 생성 | ADMIN, TRAINER |
| PUT    | `/:assessmentId` | 평가 수정 | ADMIN, TRAINER |

**assessmentType**: `INITIAL` | `PERIODIC`  
**condition**: `EXCELLENT` | `GOOD` | `NORMAL` | `POOR`  
**category**: `STRENGTH` | `CARDIO` | `ENDURANCE` | `FLEXIBILITY` | `BODY` | `STABILITY`

> **중요**:
>
> - 초기 평가(INITIAL)는 회원당 1회만 생성 가능
> - 평가 삭제는 불가능 (데이터 무결성)
> - 평가 생성/수정 시 자동으로 능력치 스냅샷 저장

### 능력치 API (`/api/members/:memberId/abilities`)

| Method | Endpoint          | 설명                               | 권한 |
| ------ | ----------------- | ---------------------------------- | ---- |
| GET    | `/latest`         | 최신 능력치 스냅샷                 | ✅   |
| GET    | `/snapshots`      | 스냅샷 목록                        | ✅   |
| GET    | `/compare?prev=1` | 이전 평가와 비교                   | ✅   |
| GET    | `/hexagon`        | 헥사곤 데이터 (레이더 차트용)      | ✅   |
| GET    | `/history`        | 체력 테스트 히스토리 (라인 차트용) | ✅   |

**비교 API 응답 예시** (`GET /api/members/:memberId/abilities/compare?prev=1`):

```json
{
	"success": true,
	"data": {
		"current": {
			"id": "uuid",
			"strengthScore": 75,
			"cardioScore": 60,
			"enduranceScore": 70,
			"flexibilityScore": 65,
			"bodyScore": 80,
			"stabilityScore": 72,
			"totalScore": 70.5,
			"assessedAt": "2024-03-15T10:00:00+09:00"
		},
		"previous": {
			"id": "uuid",
			"strengthScore": 70,
			"cardioScore": 58,
			"enduranceScore": 68,
			"flexibilityScore": 62,
			"bodyScore": 78,
			"stabilityScore": 70,
			"totalScore": 67.6,
			"assessedAt": "2024-03-08T10:00:00+09:00"
		},
		"delta": {
			"strengthScore": 5,
			"cardioScore": 2,
			"enduranceScore": 2,
			"flexibilityScore": 3,
			"bodyScore": 2,
			"stabilityScore": 2,
			"totalScore": 2.9
		},
		"percentageChange": {
			"strengthScore": 7.14,
			"cardioScore": 3.45,
			"enduranceScore": 2.94,
			"flexibilityScore": 4.84,
			"bodyScore": 2.56,
			"stabilityScore": 2.86,
			"totalScore": 4.29
		}
	},
	"message": "능력치 비교 성공"
}
```

**헥사곤 API 응답 예시** (`GET /api/members/:memberId/abilities/hexagon`):

```json
{
	"success": true,
	"data": {
		"indicators": [
			{ "name": "하체 근력", "score": 75 },
			{ "name": "심폐 지구력", "score": 60 },
			{ "name": "근지구력", "score": 70 },
			{ "name": "유연성", "score": 65 },
			{ "name": "체성분 밸런스", "score": 80 },
			{ "name": "부상 안정성", "score": 72 }
		],
		"assessedAt": "2024-03-15T10:00:00+09:00",
		"version": "v1"
	},
	"message": "능력치 헥사곤 조회 성공"
}
```

**히스토리 API 응답 예시** (`GET /api/members/:memberId/abilities/history`):

```json
{
	"success": true,
	"data": {
		"history": [
			{
				"assessedAt": "2024-03-15T10:00:00+09:00",
				"indicators": [
					{ "name": "하체 근력", "score": 75 },
					{ "name": "심폐 지구력", "score": 60 },
					{ "name": "근지구력", "score": 70 },
					{ "name": "유연성", "score": 65 },
					{ "name": "체성분 밸런스", "score": 80 },
					{ "name": "부상 안정성", "score": 72 }
				],
				"version": "v1"
			},
			{
				"assessedAt": "2024-03-08T10:00:00+09:00",
				"indicators": [
					{ "name": "하체 근력", "score": 70 },
					{ "name": "심폐 지구력", "score": 58 },
					{ "name": "근지구력", "score": 68 },
					{ "name": "유연성", "score": 62 },
					{ "name": "체성분 밸런스", "score": 78 },
					{ "name": "부상 안정성", "score": 70 }
				],
				"version": "v1"
			}
		]
	},
	"message": "체력 테스트 히스토리 조회 성공"
}
```

> **1차피드백 반영**: 6개 영역으로 확장 (유연성 추가), 지표 이름 변경

### 부상 관리 (`/api/members/:memberId/injuries`)

| Method | Endpoint            | 설명           | 권한           |
| ------ | ------------------- | -------------- | -------------- |
| GET    | `/`                 | 부상 이력 조회 | ✅             |
| POST   | `/`                 | 부상 이력 등록 | ADMIN, TRAINER |
| PUT    | `/:id`              | 부상 이력 수정 | ADMIN, TRAINER |
| POST   | `/:id/restrictions` | 평가 제한 설정 | ADMIN, TRAINER |

**severity**: `MILD` | `MODERATE` | `SEVERE`  
**recoveryStatus**: `RECOVERED` | `RECOVERING` | `CHRONIC`

> **중요**: 부상이 있는 영역은 평가에서 제외됩니다 (감점 아님)

### 분석 API (`/api/analytics`)

| Method | Endpoint                | 설명              | 권한 |
| ------ | ----------------------- | ----------------- | ---- |
| GET    | `/averages`             | 전체 평균 데이터  | ✅   |
| GET    | `/comparison/:memberId` | 개별 vs 평균 비교 | ✅   |

### 회원 분석 (`/api/members/:memberId/analytics`)

| Method | Endpoint | 설명               | 권한 |
| ------ | -------- | ------------------ | ---- |
| GET    | `/`      | 회원 능력치 데이터 | ✅   |

### 인사이트 API (`/api/insights`) - 대시보드용

| Method | Endpoint          | 설명                           | 권한           |
| ------ | ----------------- | ------------------------------ | -------------- |
| GET    | `/hexagon`        | 운영 능력치 헥사곤 (전체 평균) | ADMIN, TRAINER |
| GET    | `/weekly-summary` | 이번 주 vs 지난 주 비교        | ADMIN, TRAINER |
| GET    | `/risk-members`   | 위험 신호 회원 리스트          | ADMIN, TRAINER |

**riskType**: `DECLINE` | `INJURY` | `INACTIVE`

**운영 헥사곤 API 응답 예시** (`GET /api/insights/hexagon`):

```json
{
	"success": true,
	"data": {
		"indicators": [
			{ "name": "하체 근력", "score": 68 },
			{ "name": "심폐 지구력", "score": 65 },
			{ "name": "근지구력", "score": 70 },
			{ "name": "유연성", "score": 62 },
			{ "name": "체성분 밸런스", "score": 75 },
			{ "name": "부상 안정성", "score": 72 }
		],
		"assessedAt": "2024-03-15T10:00:00+09:00",
		"version": "v1"
	},
	"message": "운영 능력치 헥사곤 조회 성공"
}
```

> **1차피드백 반영**: 6개 영역으로 확장 (유연성 추가), 지표 이름 변경

---

## 백엔드 구조

### 모듈 구조

```
src/
├── modules/
│   ├── auth/              # 인증 모듈
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   └── strategies/
│   │       └── jwt.strategy.ts
│   │       └── kakao.strategy.ts (예정)
│   ├── members/           # 회원 관리 모듈
│   │   ├── members.controller.ts
│   │   ├── members.service.ts
│   │   ├── abilities.controller.ts
│   │   ├── injuries.controller.ts
│   │   └── analytics.controller.ts
│   ├── assessments/       # 평가 시스템 모듈
│   │   ├── assessments.controller.ts
│   │   └── assessments.service.ts
│   ├── analytics/         # 분석 모듈
│   └── insights/          # 인사이트 모듈 (대시보드용)
├── entities/              # TypeORM 엔티티
├── common/                # 공통 모듈
│   ├── guards/            # 인증/권한 가드
│   ├── filters/           # 예외 필터
│   ├── interceptors/     # 인터셉터
│   └── utils/             # 유틸리티
└── main.ts                # 애플리케이션 진입점
```

### 인증 시스템

- **JWT 기반 인증**: 모든 API는 JWT 토큰으로 인증
- **토큰 관리**:
    - `accessToken`: 15분 유효 (API 요청용)
    - `refreshToken`: 7일 유효 (토큰 갱신용, DB 저장)
- **역할 기반 접근 제어 (RBAC)**: ADMIN, TRAINER, MEMBER
- **TRAINER 승인 시스템**:
    - TRAINER 회원가입 시 ADMIN 승인 필요
    - 승인 대기 중에도 로그인 가능 (프론트엔드에서 승인 대기 페이지로 리다이렉트)
    - ADMIN만 승인/거부 가능
- **소셜 로그인**: 카카오 로그인 구현 완료
    - User 엔티티에 `provider`, `providerId` 필드
    - 자동 계정 생성 및 기존 계정 연결 지원

### 주요 기능

1. **인증 시스템**: JWT 기반 인증, Refresh Token, 카카오 로그인, TRAINER 승인 시스템
2. **사용자 관리**: 본인 정보 수정, 관리자 사용자 관리
3. **회원 관리**: CRUD, 회원권, PT 횟수 관리
4. **평가 시스템**: 초기/정기 평가, 능력치 스냅샷 자동 생성
5. **부상 관리**: 부상 이력 및 평가 제한 설정
6. **분석**: 평균 비교, 변화 추이 분석
7. **인사이트**: 대시보드용 통계 및 위험 신호 감지

### 데이터 흐름

```
평가 생성 → 평가 항목 저장 → 점수 계산 → 능력치 스냅샷 저장
                ↓
         부상 제한 확인 → 제외된 영역 처리
                ↓
         헥사곤/히스토리 데이터 생성
```

---

## 주요 개념

### 1. 평가 시스템

- **초기 평가 (INITIAL)**: 회원 등록 시 1회만 생성 가능, 모든 비교의 기준점
- **정기 평가 (PERIODIC)**: 주기적으로 생성하여 변화 추적
- **평가 삭제 불가**: 데이터 무결성을 위해 수정만 가능

### 2. 능력치 점수

- **0-100 점수**: 모든 능력치 점수는 0-100 범위
- **6개 영역**: 하체 근력(STRENGTH), 심폐 지구력(CARDIO), 근지구력(ENDURANCE), 유연성(FLEXIBILITY), 체성분 밸런스(BODY), 부상 안정성(STABILITY)
- **종합 점수**: 6개 영역의 가중 평균

### 3. 부상-평가 제한

- 부상이 있는 영역은 평가에서 **제외** (감점 아님)
- 해당 영역의 점수는 `null`로 처리
- 종합 점수 계산 시 제외된 영역은 고려하지 않음

### 4. 스냅샷

- 평가 생성/수정 시 자동으로 능력치 스냅샷 저장
- 시간별 비교를 위한 핵심 데이터
- `version` 필드로 계산 기준 버전 관리

---

## 데이터 검증 규칙

### 회원가입/로그인

- **이메일**:
    - 일반: 이메일 형식 필수 (`user@example.com`)
    - 예외: `test` 계정 허용 (테스트용)
- **비밀번호**:
    - 최소 6자 이상
    - `test` 계정은 예외 (1자 허용)

### 회원 등록/수정

- **이름**: 문자열, 최대 255자
- **전화번호**: 한국 전화번호 형식 필수
    - 허용 형식: `010-1234-5678`, `010-123-4567`, `02-1234-5678`, `02-123-4567`, `031-123-4567`, `1588-1234` 등
    - 하이픈 없이도 가능: `01012345678`
    - 최소 9자, 최대 11자 (하이픈 제외)
- **이메일**: 이메일 형식, 최대 255자
- **가입일**: `YYYY-MM-DD` 형식

### 사용자 정보 수정

- **이름**: 문자열, 최대 255자 (선택)
- **이메일**: 이메일 형식 또는 `test`, 최대 255자 (선택)
- **비밀번호**: 최소 6자 이상 (선택)
- **역할**: ADMIN만 변경 가능 (선택)

> **중요**: 프론트엔드에서도 동일한 검증을 구현하는 것을 권장합니다 (UX 개선 + 보안 강화)

---

## 주의사항

1. **인증 토큰**: 모든 API 요청 시 `Authorization: Bearer {accessToken}` 헤더 필수
2. **토큰 관리**:
    - `accessToken` 만료 시 `refreshToken`으로 갱신
    - `refreshToken`도 만료되면 다시 로그인 필요
3. **날짜 형식**: ISO 8601 형식 사용 (`YYYY-MM-DD` 또는 `YYYY-MM-DDTHH:mm:ssZ`)
4. **시간대**: 모든 타임스탬프는 한국 시간(KST, UTC+9)으로 반환
5. **에러 처리**: `success: false`인 경우 `error` 객체 확인
6. **권한**: 일부 API는 ADMIN 또는 TRAINER 권한 필요
7. **평가 삭제**: 평가는 삭제 불가, 수정만 가능
8. **TRAINER 승인**: TRAINER로 회원가입하면 ADMIN 승인 필요, 승인 대기 중에도 로그인 가능 (프론트엔드에서 승인 대기 페이지로 리다이렉트)
9. **전화번호 형식**: 한국 전화번호 형식 필수 (예: `010-1234-5678`, `02-1234-5678`)
10. **데이터 검증**: 프론트엔드와 백엔드 모두에서 검증 권장 (UX + 보안)
11. **User vs Member**:
    - `User`: 시스템 사용자 (로그인, 인증용)
    - `Member`: 헬스장 회원 (비즈니스 데이터)
    - 두 엔티티는 독립적이며 연결 관계 없음
12. **로그아웃**: 로그아웃 시 DB에서 `refreshToken`이 삭제되어 다른 기기에서도 세션이 종료됨

---

## 문의

백엔드 개발자에게 문의하세요!
