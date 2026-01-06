# RefreshToken 설정 가이드

## 📋 개요

DB에 refreshToken을 저장하는 방식으로 구현되었습니다.
- **accessToken**: 15분 (짧은 만료 시간으로 보안 강화)
- **refreshToken**: 7일 (DB에 저장, 토큰 갱신용)

## 🔧 환경 변수 설정

### 로컬 개발 (.env 파일)

```env
# Access Token 만료 시간 (15분)
JWT_EXPIRES_IN=15m

# Refresh Token 만료 시간 (7일)
JWT_REFRESH_EXPIRES_IN=7d

# JWT Secret (기존과 동일)
JWT_SECRET=your-secret-key-change-this-in-production
```

### Render 프로덕션 (대시보드)

다음 환경 변수를 추가하세요:

| Key | Value |
|-----|-------|
| `JWT_EXPIRES_IN` | `15m` |
| `JWT_REFRESH_EXPIRES_IN` | `7d` |
| `JWT_SECRET` | (기존 값 유지) |

## 🗄️ 데이터베이스 마이그레이션

### SQL 실행

DBeaver에서 `database/add_refresh_token_column.sql` 파일을 실행하세요.

**또는 직접 실행:**

```sql
-- refresh_token 컬럼 추가
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS refresh_token VARCHAR(500) NULL;
```

## 📝 API 엔드포인트

### 1. 로그인 (기존과 동일하지만 refreshToken 추가)

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
      "role": "MEMBER",
      "provider": "LOCAL"
    }
  },
  "message": "로그인 성공"
}
```

### 2. 토큰 갱신 (새로 추가됨)

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
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "홍길동",
      "role": "MEMBER",
      "provider": "LOCAL"
    }
  },
  "message": "토큰 갱신 성공"
}
```

### 3. 로그아웃 (refreshToken 삭제)

```http
POST /api/auth/logout
Authorization: Bearer {accessToken}
```

**응답:**
```json
{
  "success": true,
  "data": null,
  "message": "로그아웃 성공"
}
```

## 🔄 토큰 사용 흐름

1. **로그인**
   - 사용자가 로그인
   - accessToken (15분) + refreshToken (7일) 발급
   - refreshToken은 DB에 저장

2. **API 요청**
   - accessToken을 Authorization 헤더에 포함하여 요청
   - accessToken이 만료되면 401 에러

3. **토큰 갱신**
   - accessToken 만료 시 refreshToken으로 `/api/auth/refresh` 호출
   - 새로운 accessToken + refreshToken 발급
   - 기존 refreshToken은 DB에서 업데이트

4. **로그아웃**
   - `/api/auth/logout` 호출
   - DB에서 refreshToken 삭제

## ⚠️ 주의사항

1. **refreshToken 보안**
   - refreshToken은 DB에 저장되므로 탈취 시 즉시 삭제 가능
   - 로그아웃 시 반드시 refreshToken 삭제

2. **accessToken 만료 시간**
   - 15분으로 짧게 설정하여 보안 강화
   - 만료 시 자동으로 refreshToken으로 갱신

3. **프론트엔드 구현**
   - accessToken은 메모리에 저장 (XSS 방지)
   - refreshToken은 httpOnly 쿠키에 저장 권장 (또는 안전한 저장소)

## 🧪 테스트

### 1. 로그인 테스트

```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test","password":"test"}'
```

### 2. 토큰 갱신 테스트

```bash
curl -X POST http://localhost:3001/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{"refreshToken":"YOUR_REFRESH_TOKEN"}'
```

### 3. 로그아웃 테스트

```bash
curl -X POST http://localhost:3001/api/auth/logout \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

