# 데이터베이스 마이그레이션 단계별 가이드

## 소셜 로그인 컬럼 추가

### 1단계: SQL 실행

DBeaver에서 `database/add_social_login_columns.sql` 파일을 열고 실행하세요.

**또는 직접 SQL 실행:**

```sql
-- provider 컬럼 추가 (기본값: 'LOCAL')
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS provider VARCHAR(50) DEFAULT 'LOCAL';

-- providerId 컬럼 추가
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS provider_id VARCHAR(255) NULL;

-- password 컬럼을 nullable로 변경 (소셜 로그인 사용자는 비밀번호 없음)
ALTER TABLE users 
ALTER COLUMN password DROP NOT NULL;

-- provider와 providerId 조합 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_users_provider_provider_id 
ON users(provider, provider_id);

-- 기존 사용자들의 provider를 'LOCAL'로 설정
UPDATE users 
SET provider = 'LOCAL' 
WHERE provider IS NULL;
```

### 2단계: SQL 실행 확인

다음 쿼리로 컬럼이 추가되었는지 확인:

```sql
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'users'
AND column_name IN ('provider', 'provider_id', 'password')
ORDER BY column_name;
```

예상 결과:
- `provider`: VARCHAR(50), nullable=false, default='LOCAL'
- `provider_id`: VARCHAR(255), nullable=true, default=null
- `password`: VARCHAR(255), nullable=true (변경됨)

### 3단계: 서버 재시작

**개발 서버가 실행 중인 경우:**

1. 터미널에서 `Ctrl + C`로 서버 중지
2. 다시 시작:
   ```bash
   npm run start:dev
   ```

**또는 프로세스 재시작:**

```bash
# 서버 중지 후
npm run start:dev
```

### 4단계: 테스트

서버 재시작 후 회원가입 API 테스트:

```bash
POST http://localhost:3001/api/auth/register
Content-Type: application/json

{
  "email": "test",
  "password": "test",
  "name": "테스트 사용자",
  "role": "ADMIN"
}
```

성공 응답이 오면 정상적으로 작동하는 것입니다!

## 문제 해결

### Q: "column already exists" 오류

A: 이미 컬럼이 존재합니다. `IF NOT EXISTS`를 사용했으므로 무시해도 됩니다.

### Q: "permission denied" 오류

A: 데이터베이스 사용자에게 ALTER TABLE 권한이 필요합니다. 관리자 권한으로 실행하세요.

### Q: 서버 재시작 후에도 여전히 에러가 나요

A: 다음을 확인하세요:
1. SQL이 정상적으로 실행되었는지 확인
2. 데이터베이스 연결 정보가 올바른지 확인
3. 서버 로그에서 에러 메시지 확인

