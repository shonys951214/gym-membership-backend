-- ============================================
-- FLEXIBILITY enum 추가 확인
-- ============================================

-- 1. FLEXIBILITY가 포함된 모든 enum 값 확인
SELECT 
    t.typname AS enum_type_name,
    e.enumlabel AS enum_value,
    e.enumsortorder AS sort_order
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE e.enumlabel IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'BODY', 'STABILITY', 'FLEXIBILITY')
ORDER BY t.typname, e.enumsortorder;

-- 2. FLEXIBILITY만 확인
SELECT 
    t.typname AS enum_type_name,
    e.enumlabel AS enum_value
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE e.enumlabel = 'FLEXIBILITY';

-- 3. 완료 메시지
DO $$ 
DECLARE
    flexibility_exists BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM pg_type t 
        JOIN pg_enum e ON t.oid = e.enumtypid 
        WHERE e.enumlabel = 'FLEXIBILITY'
    ) INTO flexibility_exists;
    
    IF flexibility_exists THEN
        RAISE NOTICE '========================================';
        RAISE NOTICE '✅ FLEXIBILITY enum이 성공적으로 추가되었습니다!';
        RAISE NOTICE '이제 초기 평가 생성 시 유연성 항목을 사용할 수 있습니다.';
        RAISE NOTICE '========================================';
    ELSE
        RAISE WARNING '========================================';
        RAISE WARNING '❌ FLEXIBILITY enum을 찾을 수 없습니다.';
        RAISE WARNING 'ALTER TYPE 명령을 다시 실행해주세요.';
        RAISE WARNING '========================================';
    END IF;
END $$;
