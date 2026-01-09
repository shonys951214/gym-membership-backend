-- ============================================
-- FLEXIBILITY enum 직접 추가 (자동 감지)
-- ============================================
-- 이 SQL을 DBeaver에서 실행하세요
-- 주의: ALTER TYPE 명령은 트랜잭션 밖에서 실행해야 합니다

-- ============================================
-- STEP 1: assessment_items 테이블이 사용하는 enum 타입 찾기
-- ============================================
SELECT 
    c.column_name,
    c.data_type,
    c.udt_name AS enum_type_name,
    pg_catalog.format_type(c.udt_name::regtype, NULL) AS full_type_name
FROM information_schema.columns c
WHERE c.table_name = 'assessment_items' 
  AND c.column_name = 'category';

-- ============================================
-- STEP 2: 찾은 enum 타입의 현재 값 확인
-- ============================================
-- STEP 1의 결과에서 enum_type_name을 확인한 후, 아래 쿼리에서 타입 이름을 변경하여 실행
-- 예: enum_type_name이 'category'인 경우

-- 아래 쿼리의 'category' 부분을 STEP 1에서 확인한 enum_type_name으로 변경하세요
SELECT 
    e.enumlabel AS enum_value,
    e.enumsortorder AS sort_order
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE t.typname = 'category'  -- ← 여기를 STEP 1의 enum_type_name으로 변경
ORDER BY e.enumsortorder;

-- ============================================
-- STEP 3: FLEXIBILITY 추가 (중요: 개별 실행)
-- ============================================
-- STEP 1에서 확인한 enum_type_name으로 아래 명령을 실행하세요
-- DBeaver에서 이 명령만 선택하여 실행 (다른 쿼리와 함께 실행하지 마세요)

-- 예시 (enum_type_name이 'category'인 경우):
ALTER TYPE category ADD VALUE 'FLEXIBILITY';

-- 만약 enum_type_name이 다른 이름이면:
-- ALTER TYPE [확인된_enum_타입_이름] ADD VALUE 'FLEXIBILITY';

-- ============================================
-- STEP 4: 최종 확인
-- ============================================
-- FLEXIBILITY가 추가되었는지 확인
SELECT 
    e.enumlabel AS enum_value,
    e.enumsortorder AS sort_order
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE t.typname = 'category'  -- ← 여기를 STEP 1의 enum_type_name으로 변경
  AND e.enumlabel IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'BODY', 'STABILITY', 'FLEXIBILITY')
ORDER BY e.enumsortorder;

-- ============================================
-- 자동 확인 스크립트
-- ============================================
DO $$ 
DECLARE
    enum_type_name TEXT;
    flexibility_exists BOOLEAN;
    enum_values TEXT;
BEGIN
    -- assessment_items 테이블의 category 컬럼이 사용하는 enum 타입 찾기
    SELECT c.udt_name INTO enum_type_name
    FROM information_schema.columns c
    WHERE c.table_name = 'assessment_items' 
      AND c.column_name = 'category'
    LIMIT 1;
    
    IF enum_type_name IS NULL THEN
        RAISE WARNING '========================================';
        RAISE WARNING '❌ assessment_items.category 컬럼을 찾을 수 없습니다.';
        RAISE WARNING '테이블이 존재하는지 확인해주세요.';
        RAISE WARNING '========================================';
        RETURN;
    END IF;
    
    -- FLEXIBILITY 존재 확인
    SELECT EXISTS (
        SELECT 1
        FROM pg_type t 
        JOIN pg_enum e ON t.oid = e.enumtypid 
        WHERE t.typname = enum_type_name
          AND e.enumlabel = 'FLEXIBILITY'
    ) INTO flexibility_exists;
    
    -- 현재 enum 값 목록
    SELECT string_agg(e.enumlabel, ', ' ORDER BY e.enumsortorder) INTO enum_values
    FROM pg_type t 
    JOIN pg_enum e ON t.oid = e.enumtypid 
    WHERE t.typname = enum_type_name;
    
    RAISE NOTICE '========================================';
    RAISE NOTICE 'enum 타입 이름: %', enum_type_name;
    RAISE NOTICE '현재 enum 값: %', enum_values;
    
    IF flexibility_exists THEN
        RAISE NOTICE '✅ FLEXIBILITY enum이 이미 추가되어 있습니다!';
    ELSE
        RAISE WARNING '❌ FLEXIBILITY enum이 아직 추가되지 않았습니다.';
        RAISE NOTICE '다음 명령을 실행하세요:';
        RAISE NOTICE 'ALTER TYPE % ADD VALUE ''FLEXIBILITY'';', enum_type_name;
    END IF;
    RAISE NOTICE '========================================';
END $$;
