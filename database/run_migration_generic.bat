@echo off
REM 범용 마이그레이션 실행 스크립트 (Windows)
REM 사용법: run_migration_generic.bat [SQL_FILE_PATH]

REM db.md의 데이터베이스 정보 설정
set DB_HOST=dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com
set DB_PORT=5432
set DB_USERNAME=gym_membership_db_user
set DB_PASSWORD=XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7
set DB_NAME=gym_membership_db

set SQL_FILE=%1

if "%SQL_FILE%"=="" (
    echo ================================================
    echo 마이그레이션 실행 스크립트
    echo ================================================
    echo.
    echo 사용법: run_migration_generic.bat [SQL_FILE_PATH]
    echo.
    echo 예시:
    echo   run_migration_generic.bat database\add_social_login_columns.sql
    echo   run_migration_generic.bat database\migrations\add_assessment_items_details.sql
    echo.
    echo 현재 설정:
    echo   호스트: %DB_HOST%
    echo   포트: %DB_PORT%
    echo   데이터베이스: %DB_NAME%
    echo   사용자: %DB_USERNAME%
    echo.
    exit /b 1
)

if not exist "%SQL_FILE%" (
    echo 오류: 파일을 찾을 수 없습니다: %SQL_FILE%
    exit /b 1
)

echo ================================================
echo 마이그레이션 실행 중...
echo ================================================
echo.
echo 호스트: %DB_HOST%
echo 포트: %DB_PORT%
echo 데이터베이스: %DB_NAME%
echo 사용자: %DB_USERNAME%
echo 파일: %SQL_FILE%
echo.

set PGPASSWORD=%DB_PASSWORD%
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USERNAME% -d %DB_NAME% -f "%SQL_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ================================================
    echo 마이그레이션 완료!
    echo ================================================
) else (
    echo.
    echo ================================================
    echo 마이그레이션 실패!
    echo ================================================
    exit /b 1
)

pause
