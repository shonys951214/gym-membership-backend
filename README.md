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
│   ├── assessment-item.entity.ts
│   ├── ability-snapshot.entity.ts
│   ├── injury-history.entity.ts
│   └── ...
├── entities-generated/    # 자동 생성된 엔티티 (레거시)
│   └── ...
├── modules/               # NestJS 모듈
│   ├── auth/              # 인증 모듈
│   ├── members/           # 회원 관리 모듈
│   ├── assessments/       # 평가 시스템 모듈
│   ├── analytics/         # 분석 모듈
│   └── insights/          # 인사이트 모듈
├── common/                # 공통 유틸리티
│   ├── decorators/        # 커스텀 데코레이터
│   ├── enums/             # 열거형 타입
│   ├── exceptions/        # 예외 처리
│   ├── filters/           # 예외 필터
│   ├── guards/            # 가드 (인증/인가)
│   ├── interceptors/      # 인터셉터
│   ├── utils/             # 유틸리티 함수
│   └── data-source.ts     # TypeORM 설정
├── config/                # 설정 파일
│   ├── cors.config.ts
│   └── database.config.ts
├── app.module.ts          # 루트 모듈
├── app.controller.ts      # 루트 컨트롤러
├── app.service.ts         # 루트 서비스
└── main.ts                # 애플리케이션 진입점
```

## 설치 및 실행

### 사전 요구사항

- **Node.js** v18 이상
- **npm** 또는 **yarn**
- **PostgreSQL** 12 이상
- **Python** 3.x (선택사항 - 스크립트 실행 시만 필요)

### 1. 저장소 클론

```bash
git clone <repository-url>
cd gym-membership-backend
```

### 2. 의존성 설치

```bash
npm install
```

### 2. 환경 변수 설정

`.env.example` 파일을 복사하여 `.env` 파일을 생성하세요:

```bash
# Windows
copy .env.example .env

# Linux/Mac
cp .env.example .env
```

그 다음 `.env` 파일을 열어 실제 환경에 맞게 값을 수정하세요:

- `DATABASE_URL`: PostgreSQL 데이터베이스 연결 문자열
- `JWT_SECRET`: 강력한 랜덤 문자열 (최소 32자)
- `FRONTEND_URL`: 프론트엔드 URL (여러 개는 쉼표로 구분)

자세한 설정은 `.env.example` 파일을 참고하세요.

### 4. 데이터베이스 설정

PostgreSQL 데이터베이스를 생성하고 `.env` 파일의 `DATABASE_URL`을 설정하세요.

**로컬 PostgreSQL 사용 시:**
```bash
# PostgreSQL 설치 후 데이터베이스 생성
createdb gym_membership

# 또는 psql 사용
psql -U postgres
CREATE DATABASE gym_membership;
```

**스키마 생성:**
```bash
# database/create_full_schema.sql 파일 실행
psql -U postgres -d gym_membership -f database/create_full_schema.sql
```

**초기 데이터 추가 (선택사항):**
```bash
# 운동 데이터 추가
psql -U postgres -d gym_membership -f database/seeds/exercises_seed.sql

# Strength Level 기준 데이터 추가 (빅3 운동)
psql -U postgres -d gym_membership -f database/bench_press_male_standards.sql
psql -U postgres -d gym_membership -f database/bench_press_female_standards.sql
psql -U postgres -d gym_membership -f database/squat_male_standards.sql
psql -U postgres -d gym_membership -f database/squat_female_standards.sql
psql -U postgres -d gym_membership -f database/deadlift_male_standards.sql
psql -U postgres -d gym_membership -f database/deadlift_female_standards.sql
```

### 5. 애플리케이션 실행

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
- `GET /api/members/:id/abilities/hexagon` - 레이더 차트 데이터 (초기 vs 현재 비교 지원)

### 분석

- `GET /api/analytics/averages` - 전체 평균
- `GET /api/analytics/comparison/:memberId` - 개별 vs 평균 비교

### 인사이트 (관리자/트레이너 전용)

- `GET /api/insights/hexagon` - 운영 능력치 헥사곤 조회
- `GET /api/insights/weekly-summary` - 주간 요약 조회
- `GET /api/insights/risk-members` - 위험 신호 회원 조회

### 부상 관리

- `GET /api/members/:memberId/injuries` - 부상 이력 조회
- `POST /api/members/:memberId/injuries` - 부상 이력 등록
- `POST /api/members/:memberId/injuries/:id/restrictions` - 평가 제한 설정

### 운동 기록

- `GET /api/members/:id/workout-records` - 운동 기록 목록
- `POST /api/members/:id/workout-records` - 운동 기록 생성
- `PUT /api/members/:id/workout-records/:recordId` - 운동 기록 수정
- `DELETE /api/members/:id/workout-records/:recordId` - 운동 기록 삭제
- `GET /api/members/:id/workout-records/volume` - 부위별 볼륨 조회
- `GET /api/members/:id/workout-records/volume-analysis` - 부위별 볼륨 분석
- `GET /api/members/:id/workout-records/calendar` - 운동 캘린더 조회

### 🔄 추후 구현 예정 API

- `GET /api/members/:id/workout-records/:recordId/strength-level` - 운동 기록의 Strength Level 조회 (추후 구현 예정)
- `GET /api/members/:id/strength-progress` - 회원의 운동별 Strength Level 변화 추적 (추후 구현 예정)

## 현재 구현 상태

### ✅ 구현 완료

- 기본 인증 시스템 (JWT 기반, 카카오 소셜 로그인 지원)
- 회원 관리 CRUD
- 평가 시스템 기본 기능
- 능력치 계산 및 스냅샷 생성
- 레이더 차트 데이터 API (초기 vs 현재 비교 포함)
- 전체 평균 및 개별 비교 분석
- 인사이트 모듈 (운영 헥사곤, 주간 요약, 위험 신호 회원)
- 부상 이력 관리
- 운동 기록 및 루틴 관리
- PT 세션 관리
- Swagger API 문서

### 🔄 추후 구현 예정

다음 기능들은 추후 단계적으로 구현될 예정입니다:

- **Phase 2**: 초기 평가 세부항목 정의 및 검증 로직
- **Phase 3**: 정기 평가 세부항목 및 환산 메커니즘
- **Phase 4**: 그래프 차트 및 상세 시각화 API
- **Phase 5**: 평가 기준표 및 등급 체계
- **Phase 6**: Strength Level 판정 기능
    - Strength Level 자동 계산 및 판정 (StrengthLevel.com 기준)
    - 평가 항목 생성 시 Strength Level 자동 계산
    - 운동 기록 생성/수정 시 Strength Level 자동 계산
    - Strength Level 조회 API (`GET /api/members/:id/workout-records/:recordId/strength-level`)
    - Strength Level 변화 추적 API (`GET /api/members/:id/strength-progress`)
    - **참고**: DB에는 `strength_standards` 테이블이 이미 추가되어 있으며, API 구현은 추후 진행 예정입니다.

자세한 내용은 [docs/BACKEND_FUTURE_DEVELOPMENT.md](docs/BACKEND_FUTURE_DEVELOPMENT.md)를 참고하세요.

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
