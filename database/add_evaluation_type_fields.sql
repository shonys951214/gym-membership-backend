-- 1차피드백: 평가 시스템 개선 - 정적/동적 평가 구분
-- Assessment 테이블에 evaluationType, staticEvaluation, dynamicEvaluation 필드 추가

-- evaluation_type enum 타입 생성 (없는 경우)
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'evaluationtype') THEN
        CREATE TYPE evaluationtype AS ENUM ('STATIC', 'DYNAMIC');
    END IF;
END $$;

-- evaluation_type 컬럼 추가
ALTER TABLE assessments
ADD COLUMN IF NOT EXISTS evaluation_type evaluationtype NULL;

-- static_evaluation JSONB 컬럼 추가
ALTER TABLE assessments
ADD COLUMN IF NOT EXISTS static_evaluation JSONB NULL;

-- dynamic_evaluation JSONB 컬럼 추가
ALTER TABLE assessments
ADD COLUMN IF NOT EXISTS dynamic_evaluation JSONB NULL;

-- 인덱스 추가 (evaluation_type으로 필터링 시 성능 향상)
CREATE INDEX IF NOT EXISTS idx_assessments_evaluation_type ON assessments(evaluation_type);

-- 필드 추가 확인
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'assessments'
AND column_name IN ('evaluation_type', 'static_evaluation', 'dynamic_evaluation')
ORDER BY ordinal_position;

