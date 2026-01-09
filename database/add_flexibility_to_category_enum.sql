-- ============================================
-- category enum에 FLEXIBILITY 추가
-- ============================================
-- 이 SQL을 DBeaver에서 실행하세요
-- 주의: ALTER TYPE ... ADD VALUE는 트랜잭션 밖에서 실행해야 합니다

-- 1단계: 현재 사용 중인 enum 타입 이름 확인
-- 아래 쿼리를 먼저 실행하여 enum 타입 이름을 확인하세요
SELECT 
    DISTINCT t.typname AS enum_type_name
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE e.enumlabel IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'BODY', 'STABILITY')
ORDER BY t.typname;

-- 2단계: 확인된 enum 타입 이름으로 FLEXIBILITY 추가
-- 위 쿼리 결과에서 enum_type_name을 확인한 후, 아래 쿼리 중 하나를 선택하여 실행하세요
-- (각 ALTER TYPE 명령은 개별적으로 실행해야 합니다)

-- 예시 1: enum 타입 이름이 'category'인 경우
-- ALTER TYPE category ADD VALUE 'FLEXIBILITY';

-- 예시 2: enum 타입 이름이 다른 경우 (확인된 이름으로 변경)
-- ALTER TYPE [확인된_enum_타입_이름] ADD VALUE 'FLEXIBILITY';

-- 3단계: 추가 확인
-- 아래 쿼리로 FLEXIBILITY가 추가되었는지 확인하세요
SELECT 
    t.typname AS enum_type_name,
    e.enumlabel AS enum_value,
    e.enumsortorder AS sort_order
FROM pg_type t 
JOIN pg_enum e ON t.oid = e.enumtypid 
WHERE e.enumlabel IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'BODY', 'STABILITY', 'FLEXIBILITY')
ORDER BY t.typname, e.enumsortorder;

-- 완료 메시지
DO $$ 
BEGIN 
    RAISE NOTICE '========================================';
    RAISE NOTICE 'FLEXIBILITY enum 추가 가이드';
    RAISE NOTICE '========================================';
    RAISE NOTICE '1. 위의 SELECT 쿼리로 enum 타입 이름을 확인하세요';
    RAISE NOTICE '2. 확인된 타입 이름으로 ALTER TYPE 명령을 실행하세요';
    RAISE NOTICE '3. 예: ALTER TYPE category ADD VALUE ''FLEXIBILITY'';';
    RAISE NOTICE '========================================';
END $$;
