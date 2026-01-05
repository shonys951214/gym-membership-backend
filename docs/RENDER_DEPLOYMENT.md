# Render 배포 가이드

## 📋 Render 설정

### Build Command

```bash
npm install && npm run build
```

또는

```bash
npm install
npm run build
```

### Start Command

```bash
npm run start:prod
```

또는

```bash
node dist/main.js
```

## 🔧 Render 대시보드 설정

### 1. 새 Web Service 생성

1. Render 대시보드에서 **New +** → **Web Service** 선택
2. GitHub 레포지토리 연결
3. 다음 설정 입력:

### 2. 기본 설정

| 항목 | 값 |
|------|-----|
| **Name** | `gym-membership-backend` (원하는 이름) |
| **Environment** | `Node` |
| **Region** | `Singapore` (또는 원하는 지역) |
| **Branch** | `main` (또는 배포할 브랜치) |
| **Root Directory** | (비워두기 - 루트 디렉토리) |

### 3. Build & Start 명령어

**Build Command:**
```bash
npm install && npm run build
```

**Start Command:**
```bash
npm run start:prod
```

### 4. 환경 변수 설정

Render 대시보드의 **Environment** 섹션에서 다음 환경 변수를 추가:

#### 필수 환경 변수

| 변수명 | 설명 | 예시 |
|--------|------|------|
| `NODE_ENV` | 실행 환경 | `production` |
| `PORT` | 서버 포트 | (Render가 자동 설정, 명시적으로 설정 가능) |
| `DATABASE_URL` | PostgreSQL 연결 문자열 | `postgresql://user:pass@host:5432/db` |

#### 데이터베이스 설정 (Render PostgreSQL 사용 시)

Render에서 PostgreSQL 데이터베이스를 생성하면 자동으로 `DATABASE_URL`이 제공됩니다.

**개별 DB 변수 사용 시:**
| 변수명 | 설명 |
|--------|------|
| `DB_HOST` | 데이터베이스 호스트 |
| `DB_PORT` | 데이터베이스 포트 (기본: 5432) |
| `DB_NAME` | 데이터베이스 이름 |
| `DB_USERNAME` | 데이터베이스 사용자명 |
| `DB_PASSWORD` | 데이터베이스 비밀번호 |

#### JWT 설정

| 변수명 | 설명 | 예시 |
|--------|------|------|
| `JWT_SECRET` | JWT 서명 비밀키 (강력한 랜덤 문자열) | `your-very-secure-secret-key-32-chars-min` |
| `JWT_EXPIRES_IN` | 토큰 만료 시간 | `7d` |

#### CORS 설정

| 변수명 | 설명 | 예시 |
|--------|------|------|
| `FRONTEND_URL` | 프론트엔드 URL (여러 개는 쉼표로 구분) | `https://your-app.vercel.app` |

**여러 도메인 허용:**
```env
FRONTEND_URL=http://localhost:3000,https://your-app.vercel.app,https://www.yourdomain.com
```

#### TypeORM 설정

| 변수명 | 설명 | 기본값 |
|--------|------|--------|
| `DB_SYNCHRONIZE` | 스키마 자동 동기화 (프로덕션에서는 false 권장) | `false` |
| `DB_LOGGING` | SQL 쿼리 로깅 | `false` |

#### 기타 설정

| 변수명 | 설명 | 기본값 |
|--------|------|--------|
| `REQUEST_TIMEOUT` | 요청 타임아웃 (ms) | `30000` |

### 5. 완전한 환경 변수 예시

```env
# 서버 설정
NODE_ENV=production
PORT=10000

# 데이터베이스 (Render PostgreSQL 사용 시)
DATABASE_URL=postgresql://user:password@dpg-xxxxx-a.singapore-postgres.render.com:5432/dbname

# 또는 개별 변수
# DB_HOST=dpg-xxxxx-a.singapore-postgres.render.com
# DB_PORT=5432
# DB_NAME=gym_membership_db
# DB_USERNAME=gym_membership_db_user
# DB_PASSWORD=your-password

# TypeORM
DB_SYNCHRONIZE=false
DB_LOGGING=false

# JWT
JWT_SECRET=your-very-secure-secret-key-change-this-in-production
JWT_EXPIRES_IN=7d

# CORS
FRONTEND_URL=https://your-frontend.vercel.app

# 기타
REQUEST_TIMEOUT=30000
```

## 📝 주의사항

### 1. 포트 설정

Render는 자동으로 `PORT` 환경 변수를 설정합니다. `main.ts`에서 이미 `process.env.PORT`를 사용하므로 추가 설정이 필요 없습니다.

```typescript
const port = configService.get<number>("PORT") || 3001;
```

### 2. 데이터베이스 SSL

Render PostgreSQL은 SSL 연결이 필요합니다. 코드에서 자동으로 감지하도록 설정되어 있습니다:

```typescript
// src/config/database.config.ts에서 자동 처리
ssl: isProduction ? { rejectUnauthorized: false } : false,
```

### 3. DB_SYNCHRONIZE

**프로덕션에서는 반드시 `false`로 설정하세요!**

- `true`: 데이터베이스 스키마를 자동으로 변경 (데이터 손실 위험)
- `false`: 마이그레이션을 통해서만 스키마 변경 (안전)

### 4. 마이그레이션 실행

배포 후 데이터베이스 마이그레이션이 필요한 경우:

1. Render 대시보드에서 **Shell** 탭 열기
2. 다음 명령어 실행:

```bash
npm run migration:run
```

또는 로컬에서 실행:

```bash
DATABASE_URL=your-render-db-url npm run migration:run
```

### 5. CORS 설정

프론트엔드가 Vercel에 배포된 경우, `FRONTEND_URL`에 Vercel 도메인을 추가:

```env
FRONTEND_URL=http://localhost:3000,https://your-app.vercel.app
```

## 🚀 배포 체크리스트

- [ ] Render Web Service 생성
- [ ] GitHub 레포지토리 연결
- [ ] Build Command 설정: `npm install && npm run build`
- [ ] Start Command 설정: `npm run start:prod`
- [ ] 환경 변수 설정 (위의 표 참고)
- [ ] `NODE_ENV=production` 설정
- [ ] `DB_SYNCHRONIZE=false` 설정
- [ ] `JWT_SECRET` 강력한 값으로 설정
- [ ] `FRONTEND_URL` 프론트엔드 도메인 설정
- [ ] 데이터베이스 마이그레이션 실행 (필요 시)
- [ ] 배포 후 API 테스트

## 🔍 배포 후 확인

### 1. 로그 확인

Render 대시보드의 **Logs** 탭에서 다음 메시지 확인:

```
Application is running on: http://localhost:10000
```

### 2. 헬스 체크

```bash
curl https://your-app.onrender.com/api/auth/session
```

인증이 필요한 엔드포인트이므로 401 응답이 정상입니다.

### 3. 로그인 테스트

```bash
curl -X POST https://your-app.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

## 🐛 문제 해결

### 빌드 실패

- **원인**: TypeScript 컴파일 오류
- **해결**: 로컬에서 `npm run build` 실행하여 오류 확인

### 시작 실패

- **원인**: 환경 변수 누락 또는 데이터베이스 연결 실패
- **해결**: 
  1. 환경 변수 확인
  2. 데이터베이스 연결 문자열 확인
  3. Render 로그 확인

### 데이터베이스 연결 실패

- **원인**: SSL 설정 또는 연결 문자열 오류
- **해결**: 
  1. `DATABASE_URL` 형식 확인
  2. Render PostgreSQL의 외부 연결 허용 확인

### CORS 오류

- **원인**: `FRONTEND_URL` 설정 누락 또는 잘못된 도메인
- **해결**: `FRONTEND_URL`에 정확한 프론트엔드 도메인 설정

## 📚 참고 자료

- [Render 공식 문서](https://render.com/docs)
- [NestJS 배포 가이드](https://docs.nestjs.com/recipes/deployment)

