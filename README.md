# 헬스장 회원관리 시스템 - 백엔드

헬스장 회원의 신체 능력을 수치화·평균화·시각화하고 시간에 따른 변화를 추적하는 데이터 기반 헬스 관리 시스템의 백엔드입니다.

## 기술 스택

- **NestJS** - Node.js 프레임워크
- **TypeORM** - ORM
- **PostgreSQL** - 데이터베이스
- **JWT** - 인증
- **TypeScript** - 타입 안정성

## 프로젝트 구조

```
src/
├── entities/              # TypeORM 엔티티
│   ├── user.entity.ts
│   ├── member.entity.ts
│   ├── assessment.entity.ts
│   └── ...
├── modules/               # NestJS 모듈
│   ├── auth/              # 인증 모듈
│   ├── members/            # 회원 관리 모듈
│   ├── assessments/       # 평가 시스템 모듈
│   └── analytics/          # 분석 모듈
├── common/                # 공통 유틸리티
│   ├── utils/              # 유틸리티 함수
│   └── data-source.ts      # TypeORM 설정
└── main.ts                 # 애플리케이션 진입점
```

## 설치 및 실행

### 1. 의존성 설치

```bash
npm install
```

### 2. 환경 변수 설정

`.env` 파일을 생성하고 다음 내용을 입력하세요:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/gym_membership
PORT=3001
NODE_ENV=development
JWT_SECRET=your-secret-key-change-this-in-production
JWT_EXPIRES_IN=7d

# 프론트엔드 URL (선택사항 - 여러 개는 쉼표로 구분)
# FRONTEND_URL=https://gym-admin-mu.vercel.app,http://localhost:3000

# 카카오 로그인 (선택사항)
# KAKAO_CLIENT_ID=your-kakao-client-id
# KAKAO_CLIENT_SECRET=your-kakao-client-secret
# KAKAO_REDIRECT_URI=http://localhost:3001/api/auth/kakao/callback
```

### 3. 데이터베이스 설정

PostgreSQL 데이터베이스를 생성하고 `.env` 파일의 `DATABASE_URL`을 설정하세요.

### 4. 애플리케이션 실행

```bash
# 개발 모드
npm run start:dev

# 프로덕션 모드
npm run build
npm run start:prod
```

## Render 배포

### Build Command

```bash
npm install && npm run build
```

### Start Command

```bash
npm run start:prod
```

자세한 배포 가이드는 [docs/RENDER_DEPLOYMENT.md](docs/RENDER_DEPLOYMENT.md)를 참고하세요.

## Swagger API 문서

애플리케이션 실행 후 다음 URL에서 API 문서를 확인할 수 있습니다:

```
http://localhost:3001/api
```

Swagger UI에서:

- 모든 API 엔드포인트 확인
- 요청/응답 스키마 확인
- 직접 API 테스트 가능
- JWT 인증 토큰 설정 가능

## 주요 API 엔드포인트

### 인증

- `POST /api/auth/login` - 로그인
- `POST /api/auth/register` - 회원가입
- `GET /api/auth/session` - 세션 확인

### 회원 관리

- `GET /api/members` - 회원 목록
- `GET /api/members/:id` - 회원 상세
- `POST /api/members` - 회원 등록
- `PUT /api/members/:id` - 회원 수정
- `DELETE /api/members/:id` - 회원 삭제

### 평가 시스템

- `GET /api/members/:memberId/assessments` - 평가 목록
- `POST /api/members/:memberId/assessments` - 평가 생성
- `PUT /api/members/:memberId/assessments/:id` - 평가 수정
- `GET /api/members/:memberId/assessments/abilities/latest` - 최신 능력치
- `GET /api/members/:memberId/assessments/abilities/compare` - 능력치 비교

### 분석

- `GET /api/analytics/averages` - 전체 평균
- `GET /api/analytics/comparison/:memberId` - 개별 vs 평균 비교

### 부상 관리

- `GET /api/members/:memberId/injuries` - 부상 이력 조회
- `POST /api/members/:memberId/injuries` - 부상 이력 등록
- `POST /api/members/:memberId/injuries/:id/restrictions` - 평가 제한 설정

## 데이터베이스 마이그레이션

```bash
# 마이그레이션 생성
npm run migration:generate -- -n MigrationName

# 마이그레이션 실행
npm run migration:run

# 마이그레이션 되돌리기
npm run migration:revert
```

## 개발 가이드

### 코드 스타일

- TypeScript 사용
- camelCase 네이밍 (변수, 함수)
- PascalCase 네이밍 (클래스, 인터페이스)
- API 응답은 camelCase 사용

### 에러 처리

모든 API 응답은 다음 형식을 따릅니다:

```typescript
// 성공
{
  success: true,
  data: {...},
  message?: string
}

// 실패
{
  success: false,
  error: {
    code: string,
    message: string,
    details?: unknown
  }
}
```

## 라이선스

ISC
