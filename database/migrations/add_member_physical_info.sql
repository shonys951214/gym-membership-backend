-- 회원 신체 정보 필드 추가 마이그레이션
-- 키(height), 몸무게(weight), 성별(gender) 필드 추가

-- 1. Gender enum 타입 생성
DO $$ BEGIN
    CREATE TYPE gender_enum AS ENUM ('MALE', 'FEMALE');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 2. 키(height) 컬럼 추가 (cm 단위, nullable)
ALTER TABLE members
ADD COLUMN IF NOT EXISTS height REAL NULL;

COMMENT ON COLUMN members.height IS '키 (cm)';

-- 3. 몸무게(weight) 컬럼 추가 (kg 단위, nullable)
ALTER TABLE members
ADD COLUMN IF NOT EXISTS weight REAL NULL;

COMMENT ON COLUMN members.weight IS '몸무게 (kg)';

-- 4. 성별(gender) 컬럼 추가 (enum, nullable)
ALTER TABLE members
ADD COLUMN IF NOT EXISTS gender gender_enum NULL;

COMMENT ON COLUMN members.gender IS '성별 (MALE, FEMALE)';

-- 5. 인덱스 추가 (선택사항 - 성별로 필터링할 경우 유용)
CREATE INDEX IF NOT EXISTS idx_members_gender ON members(gender) WHERE gender IS NOT NULL;

