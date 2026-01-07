# 프론트엔드 배포 주소 연결 가이드

## 프론트엔드 주소

프론트엔드가 다음 주소에 배포되어 있습니다:

- **프로덕션**: https://gym-admin-mu.vercel.app

## 백엔드 CORS 설정

백엔드는 이미 프론트엔드 주소를 허용하도록 설정되어 있습니다.

### 자동 허용되는 Origin

다음 주소들은 자동으로 CORS 허용됩니다:

- `http://localhost:3000` (로컬 개발)
- `https://gym-admin-mu.vercel.app` (프로덕션)

### 추가 Origin 설정 (선택사항)

환경 변수 `FRONTEND_URL`에 추가 주소를 설정할 수 있습니다:

```env
FRONTEND_URL=https://gym-admin-mu.vercel.app,http://localhost:3000,https://another-domain.com
```

## Render 배포 시 환경 변수

Render에서 배포할 때는 다음 환경 변수를 설정하세요:

### 필수 환경 변수

```
DATABASE_URL=postgresql://...
PORT=10000
NODE_ENV=production
JWT_SECRET=your-secret-key
JWT_REFRESH_SECRET=your-refresh-secret-key
```

### 선택적 환경 변수

```
FRONTEND_URL=https://gym-admin-mu.vercel.app
```

> **참고**: `FRONTEND_URL`을 설정하지 않아도 기본적으로 `https://gym-admin-mu.vercel.app`는 허용됩니다.

## CORS 설정 확인

백엔드 코드에서 CORS 설정은 `src/config/cors.config.ts`에 있습니다:

```typescript
const defaultOrigins = [
  'http://localhost:3000',
  'https://gym-admin-mu.vercel.app', // 프론트엔드 배포 주소
];
```

## 테스트

프론트엔드에서 백엔드 API를 호출할 때:

1. **프로덕션 백엔드 URL**: Render 배포 주소 사용
2. **CORS**: 자동으로 허용됨
3. **인증**: JWT 토큰을 `Authorization: Bearer {token}` 헤더로 전송

## 문제 해결

### CORS 오류가 발생하는 경우

1. **환경 변수 확인**: Render 대시보드에서 `NODE_ENV=production` 확인
2. **Origin 확인**: 브라우저 콘솔에서 실제 요청 Origin 확인
3. **백엔드 로그 확인**: Render 로그에서 CORS 관련 오류 확인

### 프론트엔드에서 API 호출 예시

```typescript
// 프론트엔드에서 백엔드 API 호출
const response = await fetch('https://your-backend.onrender.com/api/auth/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  credentials: 'include', // 쿠키 포함 (필요한 경우)
  body: JSON.stringify({
    email: 'test',
    password: 'test',
  }),
});
```

---

**작성일**: 2026-01-07

