-- ============================================
-- provider 컬럼 확인 및 추가
-- ============================================
-- 이 SQL을 DBeaver에서 실행하세요

-- 1. 현재 컬럼 상태 확인
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default
FROM information_schema.columns
WHERE table_name = 'users'
AND column_name IN ('provider', 'provider_id', 'password')
ORDER BY column_name;

-- 2. provider 컬럼이 없으면 추가
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'provider'
    ) THEN
        ALTER TABLE users 
        ADD COLUMN provider VARCHAR(50) DEFAULT 'LOCAL';
        RAISE NOTICE 'provider 컬럼이 추가되었습니다.';
    ELSE
        RAISE NOTICE 'provider 컬럼이 이미 존재합니다.';
    END IF;
END $$;

-- 3. provider_id 컬럼이 없으면 추가
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'provider_id'
    ) THEN
        ALTER TABLE users 
        ADD COLUMN provider_id VARCHAR(255) NULL;
        RAISE NOTICE 'provider_id 컬럼이 추가되었습니다.';
    ELSE
        RAISE NOTICE 'provider_id 컬럼이 이미 존재합니다.';
    END IF;
END $$;

-- 4. password 컬럼을 nullable로 변경 (이미 nullable이면 에러 없음)
DO $$ 
BEGIN
    ALTER TABLE users 
    ALTER COLUMN password DROP NOT NULL;
    RAISE NOTICE 'password 컬럼이 nullable로 변경되었습니다.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'password 컬럼 변경 중 오류 (이미 nullable일 수 있음): %', SQLERRM;
END $$;

-- 5. 인덱스 추가 (이미 있으면 에러 없음)
CREATE INDEX IF NOT EXISTS idx_users_provider_provider_id 
ON users(provider, provider_id);

-- 6. 기존 사용자들의 provider를 'LOCAL'로 설정
UPDATE users 
SET provider = 'LOCAL' 
WHERE provider IS NULL;

-- 7. 최종 확인
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default
FROM information_schema.columns
WHERE table_name = 'users'
AND column_name IN ('provider', 'provider_id', 'password')
ORDER BY column_name;

