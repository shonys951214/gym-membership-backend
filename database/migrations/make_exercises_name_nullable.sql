-- exercises 테이블의 name 컬럼을 nullable로 변경
-- 한글명이 없는 경우 NULL로 저장할 수 있도록 함

-- 기존 NOT NULL 제약조건 제거
ALTER TABLE exercises 
ALTER COLUMN name DROP NOT NULL;

-- 코멘트 추가
COMMENT ON COLUMN exercises.name IS '운동 한글명 (없으면 NULL, 나중에 수동으로 추가 가능)';
