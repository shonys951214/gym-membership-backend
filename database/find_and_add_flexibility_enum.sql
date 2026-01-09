-- ============================================
-- FLEXIBILITY enum 추가 (단계별 실행)
-- ============================================

-- ============================================
-- 1단계: enum 타입 이름 확인
-- ============================================
-- 이 쿼리를 먼저 실행하여 enum 타입 이름을 확인하세요
SELECT 
    DISTINCT t.typname AS enum_type_name,
    COUNT(*) AS enum_value_count
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE e.enumlabel IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'BODY', 'STABILITY')
GROUP BY t.typname
ORDER BY t.typname;

-- ============================================
-- 2단계: 현재 enum 값 목록 확인
-- ============================================
-- 위 쿼리 결과에서 enum_type_name을 확인한 후, 아래 쿼리에서 타입 이름을 변경하여 실행하세요
-- 예: 'category' 또는 'category_type' 등

-- 예시 쿼리 (enum_type_name이 'category'인 경우):
-- SELECT 
--     e.enumlabel AS enum_value,
--     e.enumsortorder AS sort_order
-- FROM pg_type t 
-- JOIN pg_enum e ON t.oid = e.enumtypid 
-- WHERE t.typname = 'category'
-- ORDER BY e.enumsortorder;

-- ============================================
-- 3단계: FLEXIBILITY 추가
-- ============================================
-- 1단계에서 확인한 enum_type_name으로 아래 명령을 실행하세요
-- 주의: ALTER TYPE 명령은 트랜잭션 밖에서 실행해야 합니다 (DBeaver에서 개별 실행)

-- 예시 1: enum 타입 이름이 'category'인 경우
-- ALTER TYPE category ADD VALUE 'FLEXIBILITY';

-- 예시 2: enum 타입 이름이 'category_type'인 경우
-- ALTER TYPE category_type ADD VALUE 'FLEXIBILITY';

-- 예시 3: enum 타입 이름이 다른 경우 (확인된 이름으로 변경)
-- ALTER TYPE [확인된_enum_타입_이름] ADD VALUE 'FLEXIBILITY';

-- ============================================
-- 4단계: 추가 확인
-- ============================================
-- FLEXIBILITY가 추가되었는지 확인
SELECT 
    t.typname AS enum_type_name,
    e.enumlabel AS enum_value,
    e.enumsortorder AS sort_order
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE e.enumlabel IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'BODY', 'STABILITY', 'FLEXIBILITY')
ORDER BY t.typname, e.enumsortorder;

-- ============================================
-- 완료 메시지
-- ============================================
DO $$ 
DECLARE
    enum_type_name TEXT;
    flexibility_exists BOOLEAN;
BEGIN
    -- enum 타입 이름 찾기
    SELECT DISTINCT t.typname INTO enum_type_name
    FROM pg_type t 
    JOIN pg_enum e ON t.oid = e.enumtypid 
    WHERE e.enumlabel = 'STRENGTH'
    LIMIT 1;
    
    -- FLEXIBILITY 존재 확인
    SELECT EXISTS (
        SELECT 1
        FROM pg_type t 
        JOIN pg_enum e ON t.oid = e.enumtypid 
        WHERE t.typname = enum_type_name
          AND e.enumlabel = 'FLEXIBILITY'
    ) INTO flexibility_exists;
    
    IF enum_type_name IS NULL THEN
        RAISE WARNING '========================================';
        RAISE WARNING '❌ category enum 타입을 찾을 수 없습니다.';
        RAISE WARNING '데이터베이스 스키마를 확인해주세요.';
        RAISE WARNING '========================================';
    ELSIF flexibility_exists THEN
        RAISE NOTICE '========================================';
        RAISE NOTICE '✅ FLEXIBILITY enum이 이미 추가되어 있습니다!';
        RAISE NOTICE 'enum 타입 이름: %', enum_type_name;
        RAISE NOTICE '========================================';
    ELSE
        RAISE NOTICE '========================================';
        RAISE NOTICE '⚠️ FLEXIBILITY enum이 아직 추가되지 않았습니다.';
        RAISE NOTICE 'enum 타입 이름: %', enum_type_name;
        RAISE NOTICE '다음 명령을 실행하세요:';
        RAISE NOTICE 'ALTER TYPE % ADD VALUE ''FLEXIBILITY'';', enum_type_name;
        RAISE NOTICE '========================================';
    END IF;
END $$;
