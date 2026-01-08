#!/bin/bash
# 회원 신체 정보 마이그레이션 실행 스크립트

# 환경 변수에서 데이터베이스 정보 읽기
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USERNAME="${DB_USERNAME:-postgres}"
DB_NAME="${DB_NAME:-gym_membership_db}"

# DATABASE_URL이 있으면 사용
if [ -n "$DATABASE_URL" ]; then
    echo "DATABASE_URL을 사용하여 마이그레이션 실행 중..."
    psql "$DATABASE_URL" -f database/migrations/add_member_physical_info.sql
else
    echo "개별 설정을 사용하여 마이그레이션 실행 중..."
    echo "호스트: $DB_HOST"
    echo "포트: $DB_PORT"
    echo "사용자: $DB_USERNAME"
    echo "데이터베이스: $DB_NAME"
    PGPASSWORD="${DB_PASSWORD}" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME" -d "$DB_NAME" -f database/migrations/add_member_physical_info.sql
fi

echo "마이그레이션 완료!"

