-- 1차피드백: Member 엔티티에 목표 관리 필드 추가
-- 목표 관리 기능 구현을 위한 컬럼 추가

-- members 테이블에 목표 관련 컬럼 추가
ALTER TABLE members
ADD COLUMN IF NOT EXISTS goal TEXT NULL,
ADD COLUMN IF NOT EXISTS goal_progress INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS goal_trainer_comment TEXT NULL,
ADD COLUMN IF NOT EXISTS total_sessions INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS completed_sessions INT DEFAULT 0;

-- goal_progress는 0-100 범위로 제한 (애플리케이션 레벨에서 검증)
-- CHECK 제약조건 추가 (선택사항)
ALTER TABLE members
ADD CONSTRAINT chk_goal_progress_range 
CHECK (goal_progress >= 0 AND goal_progress <= 100);

-- 컬럼 추가 확인
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'members'
    AND column_name IN ('goal', 'goal_progress', 'goal_trainer_comment', 'total_sessions', 'completed_sessions')
ORDER BY column_name;

