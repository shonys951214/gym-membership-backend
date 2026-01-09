# Postman API 테스트 가이드

> **목적**: Postman을 사용하여 백엔드 API를 테스트하는 방법 안내

---

## 🔐 인증 설정 (JWT 토큰)

### 1단계: 로그인하여 토큰 얻기

**요청 설정**:
- **Method**: `POST`
- **URL**: `https://gym-membership-backend-5zjj.onrender.com/api/auth/login`
- **Headers**:
  - `Content-Type: application/json`
- **Body** (raw JSON):
```json
{
  "email": "your-email@example.com",
  "password": "your-password"
}
```

**응답 예시**:
```json
{
  "success": true,
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "uuid",
      "email": "your-email@example.com",
      "name": "홍길동",
      "role": "TRAINER"
    }
  },
  "message": "로그인 성공"
}
```

**⚠️ 중요**: 응답에서 `accessToken` 값을 복사하세요!

---

### 2단계: Postman에 토큰 설정

#### 방법 1: 각 요청마다 헤더 추가 (권장)

1. **새 요청 생성** 또는 기존 요청 선택
2. **Headers** 탭 클릭
3. **Key**: `Authorization`
4. **Value**: `Bearer {복사한 토큰}` (예: `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`)
5. **저장** 클릭

**예시**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

#### 방법 2: Collection 변수 사용 (여러 요청에 공통 적용)

1. **Collection** 우클릭 → **Edit**
2. **Variables** 탭 클릭
3. **변수 추가**:
   - **Variable**: `token`
   - **Initial Value**: (비워두기)
   - **Current Value**: `Bearer {복사한 토큰}`
4. **Save** 클릭
5. 각 요청의 **Headers**에서:
   - **Key**: `Authorization`
   - **Value**: `{{token}}` (중괄호 2개 사용)

---

## 📝 API 테스트 예시

### 예시 1: 능력치 비교 API 테스트

**요청 설정**:
- **Method**: `GET`
- **URL**: `https://gym-membership-backend-5zjj.onrender.com/api/members/{memberId}/abilities/compare?prev=1`
  - ⚠️ `{memberId}`를 **실제 회원 UUID**로 교체하세요!
  - 예: `https://gym-membership-backend-5zjj.onrender.com/api/members/f80ebf7b-c0cf-4e3c-8131-14fcf1c72748/abilities/compare?prev=1`
- **Headers**:
  - `Authorization: Bearer {토큰}`
  - `Content-Type: application/json`
- **Params** (선택사항):
  - `prev`: `1` (이전 평가와 비교할 개수)

**성공 응답 예시**:
```json
{
  "success": true,
  "data": {
    "current": {
      "id": "uuid",
      "memberId": "uuid",
      "assessedAt": "2024-01-15T10:00:00.000Z",
      "strengthScore": 80,
      "cardioScore": 65,
      "enduranceScore": 60,
      "flexibilityScore": 80,
      "bodyScore": 80,
      "stabilityScore": 80,
      "totalScore": 74,
      "version": "v1"
    },
    "previous": {
      "id": "uuid",
      "memberId": "uuid",
      "assessedAt": "2024-01-08T10:00:00.000Z",
      "strengthScore": 75,
      "cardioScore": 60,
      "enduranceScore": 55,
      "flexibilityScore": 75,
      "bodyScore": 75,
      "stabilityScore": 75,
      "totalScore": 68,
      "version": "v1"
    },
    "delta": {
      "strengthScore": 5,
      "cardioScore": 5,
      "enduranceScore": 5,
      "flexibilityScore": 5,
      "bodyScore": 5,
      "stabilityScore": 5,
      "totalScore": 6
    },
    "percentageChange": {
      "strengthScore": 6.67,
      "cardioScore": 8.33,
      "enduranceScore": 9.09,
      "flexibilityScore": 6.67,
      "bodyScore": 6.67,
      "stabilityScore": 6.67,
      "totalScore": 8.82
    }
  },
  "message": "능력치 비교 성공"
}
```

---

### 예시 2: 평가 생성 API 테스트

**요청 설정**:
- **Method**: `POST`
- **URL**: `https://gym-membership-backend-5zjj.onrender.com/api/members/{memberId}/assessments`
  - ⚠️ `{memberId}`를 **실제 회원 UUID**로 교체하세요!
- **Headers**:
  - `Authorization: Bearer {토큰}`
  - `Content-Type: application/json`
- **Body** (raw JSON):
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "STRENGTH",
      "name": "체중 스쿼트",
      "details": {
        "grade": "A"
      }
    },
    {
      "category": "CARDIO",
      "name": "스텝 테스트",
      "details": {
        "grade": "B",
        "recoverySpeed": ["fast"]
      }
    },
    {
      "category": "ENDURANCE",
      "name": "플랭크",
      "details": {
        "grade": "A"
      }
    },
    {
      "category": "FLEXIBILITY",
      "name": "유연성 종합",
      "details": {
        "flexibilityItems": {
          "sitAndReach": "A",
          "shoulder": "A",
          "hip": "A",
          "hamstring": "A"
        }
      }
    },
    {
      "category": "BODY",
      "name": "인바디",
      "value": 70,
      "unit": "kg",
      "details": {
        "muscleMass": 30,
        "fatMass": 10.5,
        "bodyFatPercentage": 15
      }
    },
    {
      "category": "STABILITY",
      "name": "OHSA",
      "details": {
        "ohsa": "A",
        "pain": "none"
      }
    }
  ]
}
```

---

## ⚠️ 주의사항

### 1. URL 파라미터 교체

**❌ 잘못된 예**:
```
GET /api/members/{memberId}/abilities/compare
```
→ `{memberId}`가 그대로 문자열로 전송됨

**✅ 올바른 예**:
```
GET /api/members/f80ebf7b-c0cf-4e3c-8131-14fcf1c72748/abilities/compare
```
→ 실제 회원 UUID로 교체

### 2. JWT 토큰 형식

**❌ 잘못된 예**:
```
Authorization: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**✅ 올바른 예**:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```
→ `Bearer ` 접두사 필수!

### 3. 토큰 만료

- `accessToken`은 **15분** 후 만료됩니다.
- 만료되면 다시 로그인하여 새 토큰을 받아야 합니다.

### 4. 권한 확인

일부 API는 특정 권한이 필요합니다:
- `ADMIN`, `TRAINER`: 평가 생성/수정
- `MEMBER`: 조회만 가능

---

## 🐛 에러 해결

### 에러 1: UNAUTHORIZED (401)

**원인**: JWT 토큰이 없거나 잘못됨

**해결 방법**:
1. 로그인 API로 새 토큰 받기
2. `Authorization` 헤더에 `Bearer {토큰}` 형식으로 추가
3. 토큰이 만료되지 않았는지 확인 (15분)

---

### 에러 2: 404 Not Found

**원인**: 
- URL 경로가 잘못됨
- `{memberId}`를 실제 UUID로 교체하지 않음

**해결 방법**:
1. URL에서 `{memberId}`를 실제 회원 UUID로 교체
2. 엔드포인트 경로 확인 (`/api/members/:memberId/abilities/compare`)

---

### 에러 3: 403 Forbidden

**원인**: 권한 부족

**해결 방법**:
1. `ADMIN` 또는 `TRAINER` 권한으로 로그인
2. 토큰의 `role` 확인

---

## 📋 테스트 체크리스트

- [ ] 로그인 API로 `accessToken` 받기
- [ ] `Authorization` 헤더에 `Bearer {토큰}` 추가
- [ ] URL에서 `{memberId}`를 실제 UUID로 교체
- [ ] `Content-Type: application/json` 헤더 추가
- [ ] 요청 본문 형식 확인 (JSON)
- [ ] 쿼리 파라미터 확인 (`?prev=1`)

---

## 🔗 참고 문서

- `docs/SWAGGER_GUIDE.md`: Swagger UI 사용 가이드
- `docs/ASSESSMENT_API_TEST_GUIDE.md`: 평가 API 상세 테스트 가이드
- `forFront.md`: 프론트엔드 개발자용 API 가이드
