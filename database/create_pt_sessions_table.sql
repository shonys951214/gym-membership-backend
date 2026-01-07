-- 1차피드백: PT 세션 테이블 생성
-- PT 세션 관리 기능 구현을 위한 테이블 생성

-- pt_sessions 테이블 생성
CREATE TABLE IF NOT EXISTS pt_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL,
    session_number INT NOT NULL, -- 수업 회차: 1, 2, 3... (자동 계산)
    session_date DATE NOT NULL,
    main_content TEXT NOT NULL, -- 주요 수업 내용
    trainer_comment TEXT NULL, -- 트레이너 코멘트
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pt_sessions_member 
        FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
    CONSTRAINT uk_pt_sessions_member_session 
        UNIQUE (member_id, session_number) -- 회원당 회차는 중복 불가
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_pt_sessions_member_id ON pt_sessions(member_id);
CREATE INDEX IF NOT EXISTS idx_pt_sessions_session_date ON pt_sessions(session_date);
CREATE INDEX IF NOT EXISTS idx_pt_sessions_session_number ON pt_sessions(member_id, session_number);

-- 테이블 생성 확인
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'pt_sessions'
ORDER BY ordinal_position;

