-- 유연성(FLEXIBILITY) 점수 컬럼 추가
-- 1차피드백.md 요구사항: 6개 영역 평가 지원 (기존 5개 → 6개)

-- ability_snapshots 테이블에 flexibility_score 컬럼 추가
ALTER TABLE ability_snapshots
ADD COLUMN IF NOT EXISTS flexibility_score FLOAT NULL;

-- 기존 데이터에 대한 설명
-- 기존 스냅샷의 flexibility_score는 NULL로 유지됨
-- 새로운 평가 생성 시 유연성 점수가 포함될 예정

-- 컬럼 추가 확인
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns
WHERE table_name = 'ability_snapshots'
    AND column_name = 'flexibility_score';

