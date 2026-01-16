-- exercises 테이블에 name_en UNIQUE 제약조건 추가
-- 중복된 영문명 방지

-- 기존 중복 데이터 확인 (선택적)
-- SELECT name_en, COUNT(*) FROM exercises GROUP BY name_en HAVING COUNT(*) > 1;

-- UNIQUE 제약조건 추가
ALTER TABLE exercises 
ADD CONSTRAINT unique_exercises_name_en UNIQUE (name_en);
