# TypeORM 엔티티 자동 생성 가이드

기존 데이터베이스 스키마로부터 TypeORM 엔티티를 자동 생성하는 방법입니다.

## 방법 1: npm 스크립트 사용 (권장)

### 1. 환경 변수 설정

`.env` 파일에 `DATABASE_URL`이 설정되어 있어야 합니다:

```env
DATABASE_URL=postgresql://user:password@localhost:5432/gym_membership
```

### 2. 엔티티 생성 실행

```bash
npm run generate:entities
```

이 명령어는 `src/entities-generated` 폴더에 엔티티 파일들을 생성합니다.

## 방법 2: 직접 명령어 실행

### Windows (PowerShell)

```powershell
typeorm-model-generator `
  -h localhost `
  -d gym_membership `
  -u postgres `
  -x your_password `
  -p 5432 `
  -e postgres `
  -o ./src/entities-generated `
  --noConfig true `
  --cf camelCase `
  --ce pascal `
  --cp camel
```

### Linux/Mac

```bash
typeorm-model-generator \
  -h localhost \
  -d gym_membership \
  -u postgres \
  -x your_password \
  -p 5432 \
  -e postgres \
  -o ./src/entities-generated \
  --noConfig true \
  --cf camelCase \
  --ce pascal \
  --cp camel
```

## 명령어 옵션 설명

- `-h`: 데이터베이스 호스트 (기본값: localhost)
- `-d`: 데이터베이스 이름
- `-u`: 사용자 이름
- `-x`: 비밀번호
- `-p`: 포트 (기본값: 5432)
- `-e`: 데이터베이스 엔진 (postgres, mysql, mssql 등)
- `-o`: 출력 디렉토리
- `--noConfig`: 설정 파일 생성 안 함
- `--cf camelCase`: 컬럼명을 camelCase로 변환
- `--ce pascal`: 클래스명을 PascalCase로 변환
- `--cp camel`: 프로퍼티명을 camelCase로 변환

## 생성된 파일 확인

실행 후 `src/entities-generated` 폴더에 다음 파일들이 생성됩니다:

```
src/entities-generated/
├── entities/
│   ├── Users.ts
│   ├── Members.ts
│   ├── Memberships.ts
│   ├── PtUsages.ts
│   ├── Assessments.ts
│   ├── AssessmentItems.ts
│   ├── AbilitySnapshots.ts
│   ├── InjuryHistories.ts
│   └── InjuryRestrictions.ts
└── tsconfig.json
```

## 생성된 엔티티 사용 방법

### 1. 생성된 엔티티 확인 및 수정

생성된 엔티티 파일들을 확인하고 필요에 따라 수정합니다:

- 관계(Relations) 설정 확인
- ENUM 타입 확인
- 컬럼 타입 확인

### 2. 기존 엔티티와 비교

생성된 엔티티를 기존 `src/entities/` 폴더의 엔티티와 비교하여 필요한 부분만 업데이트합니다.

### 3. 엔티티 통합

생성된 엔티티의 내용을 기존 엔티티에 반영하거나, 생성된 엔티티를 직접 사용할 수 있습니다.

## 주의사항

1. **기존 엔티티 백업**: 생성 전에 기존 엔티티를 백업하세요.
2. **관계 설정**: 자동 생성된 관계 설정을 확인하고 필요시 수정하세요.
3. **ENUM 타입**: ENUM 타입이 올바르게 생성되었는지 확인하세요.
4. **컬럼명**: snake_case로 생성될 수 있으므로 camelCase로 변환 옵션을 사용하세요.

## 문제 해결

### 연결 오류

```
Error: connect ECONNREFUSED
```

- 데이터베이스가 실행 중인지 확인
- 호스트, 포트, 사용자명, 비밀번호가 올바른지 확인
- 방화벽 설정 확인

### 권한 오류

```
Error: permission denied
```

- 데이터베이스 사용자에게 적절한 권한이 있는지 확인
- 스키마 접근 권한 확인

## 참고

- [typeorm-model-generator GitHub](https://github.com/Kononnable/typeorm-model-generator)
- [TypeORM 공식 문서](https://typeorm.io/)

