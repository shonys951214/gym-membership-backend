-- ============================================
-- 스쿼트 여성 Strength Standards 데이터 삭제
-- ============================================
-- 이 스크립트는 기존 스쿼트 여성 데이터를 삭제합니다.
-- 수정된 데이터를 다시 추가하기 전에 실행하세요.

-- 스쿼트 여성 데이터 삭제
DELETE FROM strength_standards
WHERE exercise_id IN (
    SELECT id FROM exercises 
    WHERE name = '스쿼트' OR name_en = 'Barbell Squat'
)
AND gender = 'FEMALE';

-- 삭제된 행 수 확인
SELECT COUNT(*) as deleted_count 
FROM strength_standards
WHERE exercise_id IN (
    SELECT id FROM exercises 
    WHERE name = '스쿼트' OR name_en = 'Barbell Squat'
)
AND gender = 'FEMALE';

-- 결과: deleted_count가 0이면 삭제 완료
