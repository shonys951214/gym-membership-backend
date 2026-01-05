# Vercel 배포 가이드

## 환경 변수 설정

### 로컬 개발 환경 (.env)

```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/gym_membership
PORT=3001
NODE_ENV=development
FRONTEND_URL=http://localhost:3000
JWT_SECRET=dev-secret-key-not-for-production
JWT_EXPIRES_IN=7d
```

### Vercel 프로덕션 환경

Vercel 대시보드에서 다음 환경 변수를 설정하세요:

1. **프로젝트 선택** → **Settings** → **Environment Variables**

2. **추가할 환경 변수:**

| 변수명 | 값 예시 | 설명 |
|--------|---------|------|
| `DATABASE_URL` | `postgresql://user:pass@host:5432/db` | 프로덕션 데이터베이스 연결 문자열 |
| `FRONTEND_URL` | `https://your-app.vercel.app` | Vercel 프론트엔드 도메인 |
| `JWT_SECRET` | `<강력한-랜덤-문자열-32자-이상>` | JWT 서명 비밀키 |
| `NODE_ENV` | `production` | 실행 환경 |
| `PORT` | (자동 설정) | Vercel이 자동으로 설정 |

### FRONTEND_URL 설정 예시

**단일 도메인:**
```env
FRONTEND_URL=https://gym-membership.vercel.app
```

**여러 도메인 허용 (쉼표로 구분):**
```env
FRONTEND_URL=http://localhost:3000,https://gym-membership.vercel.app,https://www.yourdomain.com
```

## CORS 설정

백엔드 코드는 이미 여러 origin을 지원하도록 설정되어 있습니다:

- `FRONTEND_URL`에 쉼표로 구분된 여러 URL을 입력하면 모두 허용됩니다
- 개발 환경에서는 더 유연한 CORS 정책이 적용됩니다

## 데이터베이스 설정

### Vercel과 호환되는 PostgreSQL 옵션

1. **Vercel Postgres** (권장)
   - Vercel 대시보드에서 직접 생성 가능
   - 자동으로 `DATABASE_URL` 환경 변수 설정

2. **외부 PostgreSQL 서비스**
   - Supabase, Neon, Railway 등
   - 연결 문자열을 `DATABASE_URL`에 설정

## 배포 체크리스트

- [ ] Vercel 프로젝트 생성
- [ ] GitHub 레포지토리 연결
- [ ] 환경 변수 설정 (위의 표 참고)
- [ ] 프로덕션 데이터베이스 생성 및 연결
- [ ] `FRONTEND_URL`을 실제 Vercel 도메인으로 설정
- [ ] `JWT_SECRET`을 강력한 랜덤 문자열로 변경
- [ ] `NODE_ENV=production` 설정
- [ ] 배포 후 API 테스트

## 문제 해결

### CORS 오류

프론트엔드에서 CORS 오류가 발생하는 경우:

1. Vercel 대시보드에서 `FRONTEND_URL`이 올바르게 설정되었는지 확인
2. 프론트엔드 도메인이 `FRONTEND_URL`에 포함되어 있는지 확인
3. 여러 도메인을 사용하는 경우 쉼표로 구분하여 모두 입력

### 데이터베이스 연결 오류

1. `DATABASE_URL` 형식 확인
2. 데이터베이스가 외부 접속을 허용하는지 확인
3. 방화벽 설정 확인

### JWT 오류

1. `JWT_SECRET`이 설정되어 있는지 확인
2. 프로덕션 환경에서는 강력한 비밀키 사용 확인

