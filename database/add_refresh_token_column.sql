-- ============================================
-- User 테이블에 refresh_token 컬럼 추가
-- ============================================
-- 이 SQL을 DBeaver에서 실행하세요

-- refresh_token 컬럼 추가
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS refresh_token VARCHAR(500) NULL;

-- 완료 메시지
DO $$ 
BEGIN 
    RAISE NOTICE 'refresh_token 컬럼 추가가 완료되었습니다!';
END $$;
