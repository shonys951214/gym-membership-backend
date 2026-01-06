-- ============================================
-- User 테이블에 소셜 로그인 컬럼 추가
-- ============================================
-- 이 SQL을 DBeaver에서 실행하세요

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

-- 완료 메시지
DO $$ 
BEGIN 
    RAISE NOTICE '소셜 로그인 컬럼 추가가 완료되었습니다!';
    RAISE NOTICE '추가된 컬럼: provider, provider_id';
    RAISE NOTICE '인덱스: idx_users_provider_provider_id';
END $$;

