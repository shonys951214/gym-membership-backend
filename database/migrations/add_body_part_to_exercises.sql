-- exercises 테이블에 body_part 컬럼 추가
ALTER TABLE exercises 
ADD COLUMN IF NOT EXISTS body_part VARCHAR(50);

-- 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_exercises_body_part ON exercises(body_part);
