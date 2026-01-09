-- ============================================
-- FLEXIBILITY enum 추가 확인 쿼리
-- ============================================

-- 1. category enum 타입의 모든 값 확인
SELECT 
    t.typname AS enum_type_name,
    e.enumlabel AS enum_value,
    e.enumsortorder AS sort_order
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE t.typname IN (
    SELECT DISTINCT t2.typname
    FROM pg_type t2 
    JOIN pg_enum e2 ON t2.oid = e2.enumtypid 
    WHERE e2.enumlabel IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'BODY', 'STABILITY')
)
ORDER BY t.typname, e.enumsortorder;

-- 2. FLEXIBILITY가 포함된 enum 타입 확인
SELECT 
    t.typname AS enum_type_name,
    e.enumlabel AS enum_value,
    e.enumsortorder AS sort_order
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE e.enumlabel = 'FLEXIBILITY'
ORDER BY t.typname, e.enumsortorder;

-- 3. assessment_items 테이블의 category 컬럼 타입 확인
SELECT 
    column_name,
    data_type,
    udt_name
FROM information_schema.columns
WHERE table_name = 'assessment_items' 
  AND column_name = 'category';

-- 4. 모든 category enum 값 목록 (FLEXIBILITY 포함 여부 확인)
SELECT 
    e.enumlabel AS category_value
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE t.typname = (
    SELECT DISTINCT t2.typname
    FROM pg_type t2 
    JOIN pg_enum e2 ON t2.oid = e2.enumtypid 
    WHERE e2.enumlabel = 'STRENGTH'
    LIMIT 1
)
ORDER BY e.enumsortorder;

-- 5. 완료 메시지
DO $$ 
DECLARE
    flexibility_exists BOOLEAN;
BEGIN
    -- FLEXIBILITY가 존재하는지 확인
    SELECT EXISTS (
        SELECT 1
        FROM pg_type t 
        JOIN pg_enum e ON t.oid = e.enumtypid 
        WHERE e.enumlabel = 'FLEXIBILITY'
    ) INTO flexibility_exists;
    
    IF flexibility_exists THEN
        RAISE NOTICE '========================================';
        RAISE NOTICE '✅ FLEXIBILITY enum이 성공적으로 추가되었습니다!';
        RAISE NOTICE '========================================';
    ELSE
        RAISE WARNING '========================================';
        RAISE WARNING '❌ FLEXIBILITY enum을 찾을 수 없습니다.';
        RAISE WARNING 'ALTER TYPE 명령을 다시 실행해주세요.';
        RAISE WARNING '========================================';
    END IF;
END $$;
