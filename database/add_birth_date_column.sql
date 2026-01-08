-- 생년월일 및 한국나이 컬럼 추가
-- 생년월일 입력 시 한국나이가 자동으로 계산되어 저장됨

-- 1. 생년월일(birth_date) 컬럼 추가
ALTER TABLE members
ADD COLUMN IF NOT EXISTS birth_date DATE NULL;

COMMENT ON COLUMN members.birth_date IS '생년월일';

-- 2. 한국나이(age) 컬럼 추가
ALTER TABLE members
ADD COLUMN IF NOT EXISTS age INTEGER NULL;

COMMENT ON COLUMN members.age IS '한국나이 (생년월일로부터 자동 계산)';

-- 3. 기존 데이터의 나이 자동 계산 (생년월일이 있는 경우)
UPDATE members
SET age = EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM birth_date) + 1
WHERE birth_date IS NOT NULL AND age IS NULL;

-- 4. 인덱스 추가 (선택사항, 생년월일로 검색할 경우)
-- CREATE INDEX IF NOT EXISTS idx_members_birth_date ON members(birth_date) WHERE birth_date IS NOT NULL;

