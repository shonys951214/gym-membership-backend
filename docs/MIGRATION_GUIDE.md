# 데이터베이스 마이그레이션 실행 가이드

이 문서는 `db.md` 파일의 데이터베이스 연결 정보를 기반으로 마이그레이션을 실행하는 방법을 설명합니다.

## 📋 데이터베이스 연결 정보 (db.md 기준)

```
DB_TYPE=postgres
DB_HOST=dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com
DB_PORT=5432
DB_NAME=gym_membership_db
DB_USERNAME=gym_membership_db_user
DB_PASSWORD=XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7
```

---

## 🚀 실행 방법

### 방법 1: PostgreSQL CLI (psql) 직접 사용 (권장)

#### Windows

```bash
# 환경 변수 설정
set PGPASSWORD=XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7

# 데이터베이스에 연결하여 SQL 파일 실행
psql -h dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com -p 5432 -U gym_membership_db_user -d gym_membership_db -f database\add_social_login_columns.sql

# 또는 psql 대화형 모드에서 실행
psql -h dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com -p 5432 -U gym_membership_db_user -d gym_membership_db
\i database\add_social_login_columns.sql
\q
```

#### Linux/Mac

```bash
# 환경 변수 설정
export PGPASSWORD=XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7

# 데이터베이스에 연결하여 SQL 파일 실행
psql -h dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com -p 5432 -U gym_membership_db_user -d gym_membership_db -f database/add_social_login_columns.sql

# 또는 psql 대화형 모드에서 실행
psql -h dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com -p 5432 -U gym_membership_db_user -d gym_membership_db
\i database/add_social_login_columns.sql
\q
```

---

### 방법 2: 환경 변수 파일(.env) 활용

프로젝트 루트에 `.env` 파일이 있고 `db.md`의 내용이 있다면:

#### Windows 배치 스크립트

`database/run_migration_with_env.bat` 파일 생성:

```batch
@echo off
REM .env 파일에서 환경 변수 로드 (필요시)
REM 또는 db.md의 값을 직접 사용

set DB_HOST=dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com
set DB_PORT=5432
set DB_USERNAME=gym_membership_db_user
set DB_PASSWORD=XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7
set DB_NAME=gym_membership_db
set SQL_FILE=%1

if "%SQL_FILE%"=="" (
    echo 사용법: run_migration_with_env.bat [SQL_FILE_PATH]
    echo 예: run_migration_with_env.bat database\add_social_login_columns.sql
    exit /b 1
)

echo 마이그레이션 실행 중...
echo 호스트: %DB_HOST%
echo 데이터베이스: %DB_NAME%
echo 파일: %SQL_FILE%

set PGPASSWORD=%DB_PASSWORD%
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USERNAME% -d %DB_NAME% -f %SQL_FILE%

if %ERRORLEVEL% EQU 0 (
    echo 마이그레이션 완료!
) else (
    echo 마이그레이션 실패!
    exit /b 1
)
```

**사용법:**
```bash
run_migration_with_env.bat database\add_social_login_columns.sql
```

#### Linux/Mac 쉘 스크립트

`database/run_migration_with_env.sh` 파일 생성:

```bash
#!/bin/bash

# db.md의 데이터베이스 정보
DB_HOST="dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com"
DB_PORT="5432"
DB_USERNAME="gym_membership_db_user"
DB_PASSWORD="XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7"
DB_NAME="gym_membership_db"

SQL_FILE="$1"

if [ -z "$SQL_FILE" ]; then
    echo "사용법: $0 [SQL_FILE_PATH]"
    echo "예: $0 database/add_social_login_columns.sql"
    exit 1
fi

echo "마이그레이션 실행 중..."
echo "호스트: $DB_HOST"
echo "데이터베이스: $DB_NAME"
echo "파일: $SQL_FILE"

PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME" -d "$DB_NAME" -f "$SQL_FILE"

if [ $? -eq 0 ]; then
    echo "마이그레이션 완료!"
else
    echo "마이그레이션 실패!"
    exit 1
fi
```

**사용법:**
```bash
chmod +x database/run_migration_with_env.sh
./database/run_migration_with_env.sh database/add_social_login_columns.sql
```

---

### 방법 3: DBeaver / pgAdmin GUI 도구 사용 (권장)

#### DBeaver

1. **데이터베이스 연결 설정:**
   - 새 데이터베이스 연결 생성 (PostgreSQL)
   - 호스트: `dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com`
   - 포트: `5432`
   - 데이터베이스: `gym_membership_db`
   - 사용자명: `gym_membership_db_user`
   - 비밀번호: `XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7`

2. **SQL 파일 실행:**
   - DBeaver에서 연결한 데이터베이스 선택
   - `database/` 폴더에서 실행할 SQL 파일 열기
   - `Ctrl+Alt+X` 또는 `F5` 키로 실행
   - 또는 SQL Editor에서 파일 내용 복사 후 실행

3. **여러 파일 실행:**
   - `database/migrations/run_all_assessment_migrations_dbeaver.sql` 같은 통합 스크립트 사용
   - 개별 파일을 순서대로 실행

#### pgAdmin

1. **서버 연결:**
   - 새 서버 등록
   - 위와 동일한 연결 정보 입력

2. **쿼리 도구 사용:**
   - 연결된 데이터베이스에서 우클릭 → Query Tool
   - SQL 파일 열기 또는 내용 복사
   - 실행 버튼 클릭 (F5)

---

### 방법 4: DATABASE_URL 사용 (Render 등)

Render 데이터베이스의 경우 내부 연결 URL을 사용할 수 있습니다:

```bash
# DATABASE_URL 형식
# postgresql://username:password@host:port/database

# 환경 변수로 설정
export DATABASE_URL="postgresql://gym_membership_db_user:XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7@dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com:5432/gym_membership_db"

# SQL 파일 실행
psql "$DATABASE_URL" -f database/add_social_login_columns.sql
```

---

## 📁 마이그레이션 파일 구조

### 주요 마이그레이션 파일 위치

```
database/
├── add_social_login_columns.sql         # 소셜 로그인 컬럼 추가
├── add_refresh_token_column.sql         # Refresh Token 컬럼 추가
├── add_member_goal_fields.sql           # 회원 목표 필드 추가
├── add_workout_records_fields.sql       # 운동 기록 필드 추가
├── create_pt_sessions_table.sql         # PT 세션 테이블 생성
├── create_workout_records_table.sql     # 운동 기록 테이블 생성
└── migrations/                          # 평가 시스템 마이그레이션
    ├── add_assessment_items_details.sql
    ├── create_body_composition_standards.sql
    ├── create_assessment_grade_constants.sql
    ├── run_all_assessment_migrations_dbeaver.sql  # 통합 실행 스크립트
    └── ...
```

---

## ✅ 마이그레이션 실행 체크리스트

### 실행 전

- [ ] 데이터베이스 백업 (선택사항이지만 권장)
- [ ] 실행할 SQL 파일 확인
- [ ] 마이그레이션 순서 확인 (의존성 확인)
- [ ] 데이터베이스 연결 정보 확인

### 실행 중

- [ ] SQL 파일 실행
- [ ] 오류 메시지 확인
- [ ] 실행 결과 확인

### 실행 후

- [ ] 테이블/컬럼 생성 확인
- [ ] 데이터 무결성 확인
- [ ] 애플리케이션 재시작 (필요시)

---

## 🔍 마이그레이션 실행 확인

### 테이블 존재 확인

```sql
-- 특정 테이블 확인
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'your_table_name';

-- 모든 테이블 목록
\dt
```

### 컬럼 존재 확인

```sql
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'your_table_name'
ORDER BY ordinal_position;
```

### 인덱스 확인

```sql
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'your_table_name';
```

---

## ⚠️ 주의사항

1. **프로덕션 환경**: 프로덕션 데이터베이스에 마이그레이션을 실행하기 전에 반드시 테스트 환경에서 먼저 검증하세요.

2. **순서**: 마이그레이션 파일들은 의존성이 있을 수 있으므로 순서를 확인하고 실행하세요.

3. **트랜잭션**: 마이그레이션은 트랜잭션으로 실행되므로 오류 발생 시 자동 롤백됩니다. 하지만 일부 DDL 문은 트랜잭션 내에서 실행될 수 없으므로 주의하세요.

4. **권한**: 데이터베이스 사용자에게 적절한 권한(ALTER TABLE, CREATE TABLE 등)이 필요합니다.

5. **백업**: 중요한 데이터가 있는 경우 마이그레이션 전 백업을 권장합니다.

---

## 🛠️ 문제 해결

### 오류: "relation does not exist"

- 테이블이 존재하지 않습니다. 먼저 관련 테이블을 생성하는 마이그레이션을 실행하세요.

### 오류: "column already exists"

- 컬럼이 이미 존재합니다. `IF NOT EXISTS` 구문이 있는지 확인하거나, 이미 실행된 마이그레이션인지 확인하세요.

### 오류: "permission denied"

- 데이터베이스 사용자에게 필요한 권한이 없습니다. 관리자 권한이 있는 사용자로 실행하세요.

### 오류: "could not connect to server"

- 데이터베이스 연결 정보를 확인하세요 (`db.md` 참고)
- 네트워크 연결을 확인하세요
- Render 데이터베이스의 경우 외부 접속이 허용되어 있는지 확인하세요

### 오류: "password authentication failed"

- `db.md`의 `DB_PASSWORD` 값을 확인하세요
- 비밀번호에 특수문자가 포함되어 있다면 따옴표로 감싸세요

---

## 📚 관련 문서

- [SQL_MIGRATION_GUIDE.md](./SQL_MIGRATION_GUIDE.md) - SQL 마이그레이션 상세 가이드
- [DATABASE_MIGRATION_STEPS.md](./DATABASE_MIGRATION_STEPS.md) - 마이그레이션 단계별 가이드
- [migrations/README_ASSESSMENT_MIGRATIONS.md](../database/migrations/README_ASSESSMENT_MIGRATIONS.md) - 평가 시스템 마이그레이션 가이드

---

**마지막 업데이트**: 2024-01-XX
