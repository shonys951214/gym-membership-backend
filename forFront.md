# 백엔드 API 가이드 (프론트엔드 개발자용)

## 📋 목차

1. [기본 정보](#기본-정보)
2. [인증](#인증)
3. [API 응답 형식](#api-응답-형식)
4. [에러 처리](#에러-처리)
5. [API 엔드포인트](#api-엔드포인트)
6. [사용 예시](#사용-예시)

---

## 기본 정보

### Base URL

```
개발 환경: http://localhost:3001
프로덕션: (배포 후 설정)
```

### 인증 방식

- **JWT (JSON Web Token)** 사용
- 모든 API 요청 시 `Authorization` 헤더에 토큰 포함 필요
- 예외: 로그인, 회원가입은 인증 불필요

### Content-Type

모든 요청/응답은 `application/json` 형식

---

## 인증

### 로그인

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
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "홍길동",
      "role": "TRAINER"
    }
  },
  "message": "로그인 성공"
}
```

### 회원가입

```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "홍길동",
  "role": "TRAINER"
}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "홍길동",
      "role": "TRAINER"
    }
  },
  "message": "회원가입 성공"
}
```

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
    "role": "TRAINER"
  },
  "message": "세션 확인 성공"
}
```

### 로그아웃

```http
POST /api/auth/logout
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": null,
  "message": "로그아웃 성공"
}
```

> **참고**: JWT는 stateless이므로 클라이언트에서 토큰을 삭제하면 됩니다.

---

## API 응답 형식

모든 API 응답은 다음 형식을 따릅니다:

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

| 상태 코드 | 의미 | 설명 |
|----------|------|------|
| 200 | OK | 성공 |
| 201 | Created | 생성 성공 |
| 400 | Bad Request | 잘못된 요청 |
| 401 | Unauthorized | 인증 실패 |
| 403 | Forbidden | 권한 없음 |
| 404 | Not Found | 리소스 없음 |
| 500 | Internal Server Error | 서버 오류 |

### 에러 코드

```typescript
// 인증 관련
UNAUTHORIZED        // 인증 실패
FORBIDDEN          // 권한 없음

// 회원 관련
MEMBER_NOT_FOUND           // 회원을 찾을 수 없음
MEMBER_ALREADY_EXISTS     // 이미 등록된 회원

// 평가 관련
ASSESSMENT_NOT_FOUND              // 평가를 찾을 수 없음
ASSESSMENT_DELETE_FORBIDDEN      // 평가 삭제 불가
INITIAL_ASSESSMENT_ALREADY_EXISTS // 초기 평가 이미 존재

// 부상 관련
INJURY_NOT_FOUND  // 부상 이력을 찾을 수 없음

// 검증 관련
VALIDATION_ERROR  // 검증 오류
INVALID_INPUT     // 잘못된 입력

// 서버 관련
INTERNAL_SERVER_ERROR  // 서버 오류
DATABASE_ERROR        // 데이터베이스 오류
```

### 에러 응답 예시

```json
{
  "success": false,
  "error": {
    "code": "MEMBER_NOT_FOUND",
    "message": "회원을 찾을 수 없습니다.",
    "details": {
      "memberId": "invalid-id"
    }
  }
}
```

---

## API 엔드포인트

### 회원 관리

#### 회원 목록 조회

```http
GET /api/members
Authorization: Bearer {token}
```

**권한**: ADMIN, TRAINER

**응답:**
```json
{
  "success": true,
  "data": {
    "members": [
      {
        "id": "uuid",
        "name": "홍길동",
        "email": "hong@example.com",
        "phone": "010-1234-5678",
        "joinDate": "2024-01-15",
        "status": "ACTIVE",
        "createdAt": "2024-01-15T00:00:00Z",
        "updatedAt": "2024-01-15T00:00:00Z"
      }
    ],
    "total": 1
  }
}
```

#### 회원 상세 조회

```http
GET /api/members/:id
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "홍길동",
    "email": "hong@example.com",
    "phone": "010-1234-5678",
    "joinDate": "2024-01-15",
    "status": "ACTIVE",
    "memberships": [...],
    "ptUsages": [...],
    "assessments": [...],
    "injuries": [...]
  }
}
```

#### 회원 등록

```http
POST /api/members
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "홍길동",
  "email": "hong@example.com",
  "phone": "010-1234-5678",
  "joinDate": "2024-01-15",
  "status": "ACTIVE"
}
```

**권한**: ADMIN, TRAINER

#### 회원 수정

```http
PUT /api/members/:id
Authorization: Bearer {token}
Content-Type: application/json

{
  "name": "홍길동",
  "phone": "010-9999-9999",
  "status": "INACTIVE"
}
```

**권한**: ADMIN, TRAINER

#### 회원 삭제

```http
DELETE /api/members/:id
Authorization: Bearer {token}
```

**권한**: ADMIN

---

### 회원권 관리

#### 회원권 조회

```http
GET /api/members/:id/membership
Authorization: Bearer {token}
```

#### 회원권 등록

```http
POST /api/members/:id/membership
Authorization: Bearer {token}
Content-Type: application/json

{
  "membershipType": "MONTHLY",
  "purchaseDate": "2024-01-15",
  "expiryDate": "2024-02-15",
  "price": 50000,
  "status": "ACTIVE"
}
```

**권한**: ADMIN, TRAINER

**membershipType**: `MONTHLY` | `QUARTERLY` | `YEARLY` | `LIFETIME`
**status**: `ACTIVE` | `EXPIRED` | `SUSPENDED`

#### 회원권 수정

```http
PUT /api/members/:id/membership/:membershipId
Authorization: Bearer {token}
Content-Type: application/json

{
  "status": "EXPIRED"
}
```

**권한**: ADMIN, TRAINER

#### 회원권 삭제

```http
DELETE /api/members/:id/membership/:membershipId
Authorization: Bearer {token}
```

**권한**: ADMIN

---

### PT 횟수 관리

#### PT 횟수 조회

```http
GET /api/members/:id/pt-count
Authorization: Bearer {token}
```

#### PT 횟수 추가/차감

```http
POST /api/members/:id/pt-count
Authorization: Bearer {token}
Content-Type: application/json

{
  "totalCount": 10,
  "remainingCount": 8,
  "usedCount": 2
}
```

**권한**: ADMIN, TRAINER

#### PT 횟수 수정

```http
PUT /api/members/:id/pt-count
Authorization: Bearer {token}
Content-Type: application/json

{
  "totalCount": 20,
  "remainingCount": 18,
  "usedCount": 2
}
```

**권한**: ADMIN, TRAINER

---

### 평가 시스템 ⭐ (핵심)

#### 평가 목록 조회

```http
GET /api/members/:memberId/assessments
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "assessments": [
      {
        "id": "uuid",
        "memberId": "uuid",
        "assessmentType": "INITIAL",
        "isInitial": true,
        "assessedAt": "2024-01-15",
        "trainerComment": "좋은 컨디션",
        "bodyWeight": 70.5,
        "condition": "GOOD",
        "items": [...],
        "snapshot": {...}
      }
    ],
    "total": 1
  }
}
```

#### 평가 상세 조회

```http
GET /api/members/:memberId/assessments/:assessmentId
Authorization: Bearer {token}
```

#### 평가 생성

```http
POST /api/members/:memberId/assessments
Authorization: Bearer {token}
Content-Type: application/json

{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "trainerComment": "좋은 컨디션",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "STRENGTH",
      "name": "스쿼트",
      "value": 100,
      "unit": "kg"
    },
    {
      "category": "CARDIO",
      "name": "VO2 Max",
      "value": 45,
      "unit": "ml/kg/min"
    }
  ]
}
```

**권한**: ADMIN, TRAINER

**assessmentType**: `INITIAL` | `PERIODIC`
**condition**: `EXCELLENT` | `GOOD` | `NORMAL` | `POOR`
**category**: `STRENGTH` | `CARDIO` | `ENDURANCE` | `BODY` | `STABILITY`

> **중요**: 평가 생성 시 서버에서 자동으로 점수를 계산하고 스냅샷을 저장합니다.

#### 평가 수정

```http
PUT /api/members/:memberId/assessments/:assessmentId
Authorization: Bearer {token}
Content-Type: application/json

{
  "trainerComment": "수정된 코멘트",
  "bodyWeight": 71.0,
  "items": [...]
}
```

**권한**: ADMIN, TRAINER

> **참고**: 평가 삭제는 불가능합니다. 데이터 무결성을 위해 수정만 가능합니다.

---

### 능력치 스냅샷 API ⭐ (핵심)

#### 최신 능력치 스냅샷

```http
GET /api/members/:memberId/abilities/latest
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "assessmentId": "uuid",
    "memberId": "uuid",
    "assessedAt": "2024-01-15T00:00:00Z",
    "version": "v1",
    "strengthScore": 75,
    "cardioScore": 60,
    "enduranceScore": 70,
    "bodyScore": 65,
    "stabilityScore": 80,
    "totalScore": 68
  }
}
```

#### 스냅샷 목록

```http
GET /api/members/:memberId/abilities/snapshots
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "snapshots": [...],
    "total": 5
  }
}
```

#### 이전 평가와 비교

```http
GET /api/members/:memberId/abilities/compare?prev=1
Authorization: Bearer {token}
```

**쿼리 파라미터:**
- `prev`: 비교할 이전 평가 개수 (기본값: 1)

**응답:**
```json
{
  "success": true,
  "data": {
    "current": {
      "assessedAt": "2024-03-15",
      "totalScore": 68,
      "strengthScore": 75,
      "cardioScore": 60
    },
    "previous": {
      "assessedAt": "2024-03-08",
      "totalScore": 64,
      "strengthScore": 72,
      "cardioScore": 58
    },
    "delta": {
      "totalScore": 4,
      "strengthScore": 3,
      "cardioScore": 2
    },
    "percentageChange": {
      "totalScore": 6.25,
      "strengthScore": 4.17,
      "cardioScore": 3.45
    }
  }
}
```

#### 능력치 헥사곤 데이터

```http
GET /api/members/:memberId/abilities/hexagon
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "indicators": [
      { "name": "근력", "score": 75 },
      { "name": "심폐", "score": 60 },
      { "name": "지구력", "score": 70 },
      { "name": "신체", "score": 65 },
      { "name": "안정성", "score": 80 }
    ],
    "assessedAt": "2024-01-15T00:00:00Z",
    "version": "v1"
  }
}
```

> **용도**: 레이더 차트(헥사곤) 시각화에 바로 사용 가능

#### 체력 테스트 히스토리

```http
GET /api/members/:memberId/abilities/history
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "history": [
      {
        "assessedAt": "2024-03-15T00:00:00Z",
        "indicators": [
          { "name": "근력", "score": 75 },
          { "name": "심폐", "score": 60 }
        ],
        "version": "v1"
      }
    ]
  }
}
```

> **용도**: 라인 차트로 시간별 변화 추이 시각화

---

### 부상 관리

#### 부상이력 조회

```http
GET /api/members/:memberId/injuries
Authorization: Bearer {token}
```

#### 부상이력 등록

```http
POST /api/members/:memberId/injuries
Authorization: Bearer {token}
Content-Type: application/json

{
  "injuryType": "무릎 인대 손상",
  "bodyPart": "무릎",
  "date": "2024-01-10",
  "severity": "MODERATE",
  "description": "운동 중 부상",
  "recoveryStatus": "RECOVERING"
}
```

**권한**: ADMIN, TRAINER

**severity**: `MILD` | `MODERATE` | `SEVERE`
**recoveryStatus**: `RECOVERED` | `RECOVERING` | `CHRONIC`

#### 부상이력 수정

```http
PUT /api/members/:memberId/injuries/:id
Authorization: Bearer {token}
Content-Type: application/json

{
  "recoveryStatus": "RECOVERED"
}
```

**권한**: ADMIN, TRAINER

#### 부상 영역 평가 제한 설정

```http
POST /api/members/:memberId/injuries/:id/restrictions
Authorization: Bearer {token}
Content-Type: application/json

{
  "restrictedCategory": "STRENGTH"
}
```

**권한**: ADMIN, TRAINER

**restrictedCategory**: `STRENGTH` | `CARDIO` | `ENDURANCE` | `BODY` | `STABILITY`

> **중요**: 부상이 있는 영역은 평가에서 제외됩니다. 감점이 아닌 평가 불가 상태입니다.

---

### 분석 API

#### 전체 평균 데이터

```http
GET /api/analytics/averages
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "strengthScore": 70,
    "cardioScore": 65,
    "enduranceScore": 68,
    "bodyScore": 72,
    "stabilityScore": 75,
    "totalScore": 70,
    "totalMembers": 50
  }
}
```

#### 개별 vs 평균 비교

```http
GET /api/analytics/comparison/:memberId
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "member": {
      "totalScore": 68,
      "strengthScore": 75
    },
    "average": {
      "totalScore": 70,
      "strengthScore": 72
    },
    "percentile": {
      "totalScore": 45,
      "strengthScore": 60
    }
  }
}
```

#### 회원 능력치 데이터

```http
GET /api/members/:memberId/analytics
Authorization: Bearer {token}
```

**응답:**
```json
{
  "success": true,
  "data": {
    "snapshots": [...],
    "total": 5,
    "latest": {...}
  }
}
```

---

### 인사이트 API (대시보드용)

#### 운영 능력치 헥사곤

```http
GET /api/insights/hexagon
Authorization: Bearer {token}
```

**권한**: ADMIN, TRAINER

**응답:**
```json
{
  "success": true,
  "data": {
    "indicators": [
      { "name": "근력", "score": 70 },
      { "name": "심폐", "score": 65 },
      { "name": "지구력", "score": 68 },
      { "name": "신체", "score": 72 },
      { "name": "안정성", "score": 75 }
    ],
    "assessedAt": "2024-03-15T00:00:00Z",
    "version": "v1"
  }
}
```

> **용도**: 대시보드에서 전체 회원 평균 능력치를 헥사곤으로 표시

#### 이번 주 vs 지난 주 비교

```http
GET /api/insights/weekly-summary
Authorization: Bearer {token}
```

**권한**: ADMIN, TRAINER

**응답:**
```json
{
  "success": true,
  "data": {
    "thisWeek": {
      "totalScore": 70,
      "strengthScore": 72
    },
    "lastWeek": {
      "totalScore": 68,
      "strengthScore": 70
    },
    "changes": {
      "totalScore": 2,
      "strengthScore": 2
    },
    "percentageChange": {
      "totalScore": 2.94,
      "strengthScore": 2.86
    }
  }
}
```

#### 위험 신호 회원 리스트

```http
GET /api/insights/risk-members
Authorization: Bearer {token}
```

**권한**: ADMIN, TRAINER

**응답:**
```json
{
  "success": true,
  "data": [
    {
      "memberId": "uuid",
      "memberName": "홍길동",
      "riskType": "DECLINE",
      "description": "능력치가 15% 하락했습니다.",
      "currentScore": 60,
      "previousScore": 70,
      "declinePercentage": 15
    },
    {
      "memberId": "uuid",
      "memberName": "김철수",
      "riskType": "INACTIVE",
      "description": "마지막 평가로부터 35일이 경과했습니다."
    }
  ]
}
```

**riskType**: `DECLINE` | `INJURY` | `INACTIVE`

---

## 사용 예시

### TypeScript/JavaScript 예시

```typescript
// API 클라이언트 설정
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001';

// 인증 토큰 저장 (예: localStorage)
let authToken: string | null = null;

// API 요청 헬퍼
async function apiRequest<T>(
  endpoint: string,
  options?: RequestInit
): Promise<T> {
  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(authToken && { Authorization: `Bearer ${authToken}` }),
      ...options?.headers,
    },
  });

  const data = await response.json();

  if (!data.success) {
    throw new Error(data.error.message);
  }

  return data.data;
}

// 로그인 예시
async function login(email: string, password: string) {
  const response = await apiRequest<{
    accessToken: string;
    user: { id: string; email: string; name: string; role: string };
  }>('/api/auth/login', {
    method: 'POST',
    body: JSON.stringify({ email, password }),
  });

  authToken = response.accessToken;
  localStorage.setItem('token', response.accessToken);
  return response;
}

// 회원 목록 조회 예시
async function getMembers() {
  return apiRequest<{
    members: Array<{
      id: string;
      name: string;
      email: string;
      status: string;
    }>;
    total: number;
  }>('/api/members');
}

// 평가 생성 예시
async function createAssessment(memberId: string, data: {
  assessmentType: 'INITIAL' | 'PERIODIC';
  assessedAt: string;
  items: Array<{
    category: string;
    name: string;
    value: number;
    unit: string;
  }>;
}) {
  return apiRequest('/api/members/' + memberId + '/assessments', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

// 능력치 헥사곤 조회 예시
async function getHexagon(memberId: string) {
  return apiRequest<{
    indicators: Array<{ name: string; score: number }>;
    assessedAt: string;
    version: string;
  }>('/api/members/' + memberId + '/abilities/hexagon');
}
```

### React Hook 예시

```typescript
import { useState, useEffect } from 'react';

function useMemberAbilities(memberId: string) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function fetchData() {
      try {
        setLoading(true);
        const hexagon = await getHexagon(memberId);
        setData(hexagon);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }

    if (memberId) {
      fetchData();
    }
  }, [memberId]);

  return { data, loading, error };
}
```

---

## 주요 개념

### 1. 평가 시스템

- **초기 평가 (INITIAL)**: 회원 등록 시 1회만 생성 가능, 모든 비교의 기준점
- **정기 평가 (PERIODIC)**: 주기적으로 생성하여 변화 추적
- **평가 삭제 불가**: 데이터 무결성을 위해 수정만 가능

### 2. 능력치 점수

- **0-100 점수**: 모든 능력치 점수는 0-100 범위
- **5개 영역**: 근력, 심폐, 지구력, 신체, 안정성
- **종합 점수**: 5개 영역의 가중 평균

### 3. 부상-평가 제한

- 부상이 있는 영역은 평가에서 **제외** (감점 아님)
- 해당 영역의 점수는 `null`로 처리
- 종합 점수 계산 시 제외된 영역은 고려하지 않음

### 4. 스냅샷

- 평가 생성/수정 시 자동으로 능력치 스냅샷 저장
- 시간별 비교를 위한 핵심 데이터
- `version` 필드로 계산 기준 버전 관리

---

## 주의사항

1. **인증 토큰**: 모든 API 요청 시 `Authorization: Bearer {token}` 헤더 필수
2. **날짜 형식**: ISO 8601 형식 사용 (`YYYY-MM-DD` 또는 `YYYY-MM-DDTHH:mm:ssZ`)
3. **에러 처리**: `success: false`인 경우 `error` 객체 확인
4. **권한**: 일부 API는 ADMIN 또는 TRAINER 권한 필요
5. **평가 삭제**: 평가는 삭제 불가, 수정만 가능

---

## 문의

백엔드 개발자에게 문의하세요!

