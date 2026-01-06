-- ============================================
-- User 테이블에 is_approved 컬럼 추가
-- ============================================
-- 이 SQL을 DBeaver에서 실행하세요

-- is_approved 컬럼 추가 (기본값: true)
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS is_approved BOOLEAN DEFAULT true;

-- 기존 사용자들은 모두 승인된 것으로 설정
UPDATE users 
SET is_approved = true 
WHERE is_approved IS NULL;

-- TRAINER 역할이면서 승인되지 않은 사용자 확인용 인덱스 (선택사항)
CREATE INDEX IF NOT EXISTS idx_users_role_is_approved 
ON users(role, is_approved) 
WHERE role = 'TRAINER' AND is_approved = false;

-- 완료 메시지
DO $$ 
BEGIN 
    RAISE NOTICE 'is_approved 컬럼 추가가 완료되었습니다!';
    RAISE NOTICE '추가된 컬럼: is_approved (기본값: true)';
    RAISE NOTICE '인덱스: idx_users_role_is_approved';
END $$;

