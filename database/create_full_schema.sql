-- ============================================
-- 전체 데이터베이스 스키마 재생성 스크립트
-- Render PostgreSQL용
-- 기존 DB와 테이블명, 컬럼명이 정확히 일치하도록 작성
-- ============================================

-- 기존 테이블 및 타입 삭제 (주의: 모든 데이터가 삭제됩니다)
DROP TABLE IF EXISTS workout_records CASCADE;
DROP TABLE IF EXISTS workout_routines CASCADE;
DROP TABLE IF EXISTS pt_sessions CASCADE;
DROP TABLE IF EXISTS injury_restrictions CASCADE;
DROP TABLE IF EXISTS injury_histories CASCADE;
DROP TABLE IF EXISTS ability_snapshots CASCADE;
DROP TABLE IF EXISTS assessment_items CASCADE;
DROP TABLE IF EXISTS assessments CASCADE;
DROP TABLE IF EXISTS pt_usages CASCADE;
DROP TABLE IF EXISTS memberships CASCADE;
DROP TABLE IF EXISTS members CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS strength_standards CASCADE;
DROP TABLE IF EXISTS exercises CASCADE;
DROP TABLE IF EXISTS flexibility_grade_thresholds CASCADE;
DROP TABLE IF EXISTS flexibility_item_weights CASCADE;
DROP TABLE IF EXISTS body_composition_standards CASCADE;
DROP TABLE IF EXISTS assessment_category_scores CASCADE;
DROP TABLE IF EXISTS assessment_grade_constants CASCADE;

-- ENUM 타입 삭제
DROP TYPE IF EXISTS role CASCADE;
DROP TYPE IF EXISTS memberstatus CASCADE;
DROP TYPE IF EXISTS membershiptype CASCADE;
DROP TYPE IF EXISTS membershipstatus CASCADE;
DROP TYPE IF EXISTS assessmenttype CASCADE;
DROP TYPE IF EXISTS evaluationtype CASCADE;
DROP TYPE IF EXISTS condition CASCADE;
DROP TYPE IF EXISTS category CASCADE;
DROP TYPE IF EXISTS severity CASCADE;
DROP TYPE IF EXISTS recoverystatus CASCADE;
DROP TYPE IF EXISTS gender_enum CASCADE;
DROP TYPE IF EXISTS gender CASCADE;
DROP TYPE IF EXISTS strength_level CASCADE;
DROP TYPE IF EXISTS workouttype CASCADE;
DROP TYPE IF EXISTS exercise_category CASCADE;

-- ============================================
-- ENUM 타입 생성
-- ============================================

CREATE TYPE role AS ENUM ('ADMIN', 'TRAINER', 'MEMBER');
CREATE TYPE memberstatus AS ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED');
CREATE TYPE membershiptype AS ENUM ('MONTHLY', 'QUARTERLY', 'YEARLY', 'LIFETIME');
CREATE TYPE membershipstatus AS ENUM ('ACTIVE', 'EXPIRED', 'SUSPENDED');
CREATE TYPE assessmenttype AS ENUM ('INITIAL', 'PERIODIC');
CREATE TYPE evaluationtype AS ENUM ('STATIC', 'DYNAMIC');
CREATE TYPE condition AS ENUM ('EXCELLENT', 'GOOD', 'NORMAL', 'POOR');
CREATE TYPE category AS ENUM ('STRENGTH', 'CARDIO', 'ENDURANCE', 'FLEXIBILITY', 'BODY', 'STABILITY');
CREATE TYPE severity AS ENUM ('MILD', 'MODERATE', 'SEVERE');
CREATE TYPE recoverystatus AS ENUM ('RECOVERED', 'RECOVERING', 'CHRONIC');
CREATE TYPE gender_enum AS ENUM ('MALE', 'FEMALE');
CREATE TYPE gender AS ENUM ('MALE', 'FEMALE'); -- strength_standards용
CREATE TYPE strength_level AS ENUM ('BEGINNER', 'NOVICE', 'INTERMEDIATE', 'ADVANCED', 'ELITE');
CREATE TYPE exercise_category AS ENUM ('UPPER', 'LOWER', 'FULL_BODY');

-- ============================================
-- 테이블 생성
-- ============================================

-- 1. users 테이블
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255),
    name VARCHAR(255) NOT NULL,
    provider VARCHAR(50) DEFAULT 'LOCAL',
    provider_id VARCHAR(255),
    refresh_token VARCHAR(500),
    role role DEFAULT 'MEMBER',
    is_approved BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- 2. members 테이블
CREATE TABLE members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    join_date DATE NOT NULL,
    status memberstatus DEFAULT 'ACTIVE',
    height REAL,
    weight REAL,
    birth_date DATE,
    age INTEGER,
    gender gender_enum,
    goal TEXT,
    goal_progress INTEGER DEFAULT 0,
    goal_trainer_comment TEXT,
    total_sessions INTEGER DEFAULT 0,
    completed_sessions INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    CONSTRAINT chk_goal_progress_range CHECK (goal_progress >= 0 AND goal_progress <= 100)
);

-- 3. memberships 테이블
CREATE TABLE memberships (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    membership_type membershiptype NOT NULL,
    purchase_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    status membershipstatus DEFAULT 'ACTIVE',
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. pt_usages 테이블
CREATE TABLE pt_usages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    total_count INTEGER DEFAULT 0,
    remaining_count INTEGER DEFAULT 0,
    used_count INTEGER DEFAULT 0,
    last_used_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. assessments 테이블
CREATE TABLE assessments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    assessment_type assessmenttype NOT NULL,
    evaluation_type evaluationtype,
    static_evaluation JSONB,
    dynamic_evaluation JSONB,
    is_initial BOOLEAN DEFAULT false,
    assessed_at DATE NOT NULL,
    trainer_comment TEXT,
    body_weight FLOAT,
    condition condition,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- 6. assessment_items 테이블
CREATE TABLE assessment_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_id UUID NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
    category category NOT NULL,
    name VARCHAR(255) NOT NULL,
    value FLOAT,
    unit VARCHAR(50),
    score FLOAT,
    details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. ability_snapshots 테이블
CREATE TABLE ability_snapshots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assessment_id UUID UNIQUE NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    assessed_at TIMESTAMP NOT NULL,
    version VARCHAR(50) NOT NULL,
    strength_score FLOAT,
    cardio_score FLOAT,
    endurance_score FLOAT,
    flexibility_score FLOAT,
    body_score FLOAT,
    stability_score FLOAT,
    total_score FLOAT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. injury_histories 테이블
CREATE TABLE injury_histories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    injury_type VARCHAR(255) NOT NULL,
    body_part VARCHAR(255) NOT NULL,
    date DATE NOT NULL,
    severity severity NOT NULL,
    description TEXT,
    recovery_status recoverystatus NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

-- 9. injury_restrictions 테이블
CREATE TABLE injury_restrictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    injury_id UUID NOT NULL REFERENCES injury_histories(id) ON DELETE CASCADE,
    restricted_category category NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10. pt_sessions 테이블
CREATE TABLE pt_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    session_number INTEGER NOT NULL,
    session_date DATE NOT NULL,
    main_content TEXT NOT NULL,
    trainer_comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_pt_sessions_member_session UNIQUE (member_id, session_number)
);

-- 11. workout_records 테이블
CREATE TABLE workout_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    workout_date DATE NOT NULL,
    body_part VARCHAR(50) NOT NULL,
    exercise_name VARCHAR(100) NOT NULL,
    weight FLOAT NOT NULL,
    reps INTEGER NOT NULL,
    sets INTEGER NOT NULL,
    volume FLOAT NOT NULL,
    duration INTEGER,
    workout_type VARCHAR(20) NOT NULL DEFAULT 'PERSONAL',
    pt_session_id UUID REFERENCES pt_sessions(id),
    trainer_comment TEXT,
    one_rep_max FLOAT,
    relative_strength FLOAT,
    strength_level strength_level,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_workout_type CHECK (workout_type IN ('PT', 'PERSONAL'))
);

-- 12. workout_routines 테이블
CREATE TABLE workout_routines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    member_id UUID REFERENCES members(id) ON DELETE CASCADE,
    routine_name VARCHAR(255) NOT NULL,
    routine_date DATE,
    exercises JSONB NOT NULL,
    estimated_duration INTEGER NOT NULL,
    difficulty VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
    is_completed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_difficulty CHECK (difficulty IN ('EASY', 'MEDIUM', 'HARD'))
);

-- 13. exercises 테이블
CREATE TABLE exercises (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255) NOT NULL,
    category exercise_category NOT NULL DEFAULT 'FULL_BODY',
    unit VARCHAR(50) NOT NULL DEFAULT 'kg',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 14. strength_standards 테이블
CREATE TABLE strength_standards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    exercise_id UUID NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
    bodyweight_min FLOAT NOT NULL,
    bodyweight_max FLOAT NOT NULL,
    gender gender NOT NULL,
    level strength_level NOT NULL,
    weight_kg FLOAT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 15. assessment_grade_constants 테이블
CREATE TABLE assessment_grade_constants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    grade_code VARCHAR(20) UNIQUE NOT NULL,
    grade_name_kr VARCHAR(50) NOT NULL,
    grade_name_en VARCHAR(50) NOT NULL,
    internal_score INTEGER NOT NULL CHECK (internal_score >= 0 AND internal_score <= 100),
    description TEXT,
    version VARCHAR(50) DEFAULT 'v1',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 16. assessment_category_scores 테이블
CREATE TABLE assessment_category_scores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category VARCHAR(50) NOT NULL CHECK (category IN ('STRENGTH', 'CARDIO', 'ENDURANCE', 'FLEXIBILITY', 'BODY', 'STABILITY')),
    input_grade VARCHAR(20) NOT NULL,
    conditions JSONB DEFAULT NULL,
    internal_score INTEGER NOT NULL CHECK (internal_score >= 0 AND internal_score <= 100),
    final_grade_code VARCHAR(20) NOT NULL REFERENCES assessment_grade_constants(grade_code),
    description TEXT,
    version VARCHAR(50) DEFAULT 'v1',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 17. flexibility_item_weights 테이블
CREATE TABLE flexibility_item_weights (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    item_name VARCHAR(100) UNIQUE NOT NULL,
    item_name_kr VARCHAR(100) NOT NULL,
    weight DECIMAL(5, 2) NOT NULL CHECK (weight > 0),
    importance VARCHAR(50),
    version VARCHAR(50) DEFAULT 'v1',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 18. flexibility_grade_thresholds 테이블
CREATE TABLE flexibility_grade_thresholds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    weight_sum_min DECIMAL(5, 2) NOT NULL,
    weight_sum_max DECIMAL(5, 2) NOT NULL CHECK (weight_sum_max >= weight_sum_min),
    final_grade_code VARCHAR(20) NOT NULL REFERENCES assessment_grade_constants(grade_code),
    internal_score INTEGER NOT NULL CHECK (internal_score >= 0 AND internal_score <= 100),
    version VARCHAR(50) DEFAULT 'v1',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 19. body_composition_standards 테이블
CREATE TABLE body_composition_standards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    gender VARCHAR(10) NOT NULL CHECK (gender IN ('MALE', 'FEMALE')),
    age_min INTEGER NOT NULL CHECK (age_min >= 0),
    age_max INTEGER NOT NULL CHECK (age_max >= age_min),
    body_fat_percentage_min DECIMAL(5, 2) NOT NULL,
    body_fat_percentage_max DECIMAL(5, 2) NOT NULL CHECK (body_fat_percentage_max >= body_fat_percentage_min),
    muscle_mass_percentage_min DECIMAL(5, 2) NOT NULL,
    version VARCHAR(50) DEFAULT 'v1',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_gender_age_range UNIQUE (gender, age_min, age_max)
);

-- ============================================
-- 인덱스 생성
-- ============================================

-- users 인덱스
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_provider_providerId ON users(provider, provider_id);
CREATE INDEX idx_users_deleted_at ON users(deleted_at);

-- members 인덱스
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_members_status ON members(status);
CREATE INDEX idx_members_deleted_at ON members(deleted_at);
CREATE INDEX idx_members_gender ON members(gender) WHERE gender IS NOT NULL;

-- memberships 인덱스
CREATE INDEX idx_memberships_member_id ON memberships(member_id);
CREATE INDEX idx_memberships_status ON memberships(status);
CREATE INDEX idx_memberships_expiry_date ON memberships(expiry_date);

-- pt_usages 인덱스
CREATE INDEX idx_pt_usages_member_id ON pt_usages(member_id);

-- assessments 인덱스
CREATE INDEX idx_assessments_member_id ON assessments(member_id);
CREATE INDEX idx_assessments_assessed_at ON assessments(assessed_at);
CREATE INDEX idx_assessments_is_initial ON assessments(is_initial);
CREATE INDEX idx_assessments_deleted_at ON assessments(deleted_at);
CREATE INDEX idx_assessments_evaluation_type ON assessments(evaluation_type);

-- assessment_items 인덱스
CREATE INDEX idx_assessment_items_assessment_id ON assessment_items(assessment_id);
CREATE INDEX idx_assessment_items_category ON assessment_items(category);
CREATE INDEX idx_assessment_items_details ON assessment_items USING GIN (details);

-- ability_snapshots 인덱스
CREATE INDEX idx_ability_snapshots_assessment_id ON ability_snapshots(assessment_id);
CREATE INDEX idx_ability_snapshots_member_id ON ability_snapshots(member_id);
CREATE INDEX idx_ability_snapshots_assessed_at ON ability_snapshots(assessed_at);

-- injury_histories 인덱스
CREATE INDEX idx_injury_histories_member_id ON injury_histories(member_id);
CREATE INDEX idx_injury_histories_recovery_status ON injury_histories(recovery_status);
CREATE INDEX idx_injury_histories_deleted_at ON injury_histories(deleted_at);

-- injury_restrictions 인덱스
CREATE INDEX idx_injury_restrictions_injury_id ON injury_restrictions(injury_id);
CREATE INDEX idx_injury_restrictions_category ON injury_restrictions(restricted_category);

-- pt_sessions 인덱스
CREATE INDEX idx_pt_sessions_member_id ON pt_sessions(member_id);
CREATE INDEX idx_pt_sessions_session_date ON pt_sessions(session_date);
CREATE INDEX idx_pt_sessions_session_number ON pt_sessions(member_id, session_number);

-- workout_records 인덱스
CREATE INDEX idx_workout_records_member_id ON workout_records(member_id);
CREATE INDEX idx_workout_records_workout_date ON workout_records(workout_date);
CREATE INDEX idx_workout_records_workout_type ON workout_records(workout_type);

-- workout_routines 인덱스
CREATE INDEX idx_workout_routines_member_id ON workout_routines(member_id);
CREATE INDEX idx_workout_routines_routine_date ON workout_routines(routine_date);
CREATE INDEX idx_workout_routines_member_date ON workout_routines(member_id, routine_date);

-- exercises 인덱스
CREATE INDEX idx_exercises_name ON exercises(name);
CREATE INDEX idx_exercises_name_en ON exercises(name_en);
CREATE INDEX idx_exercises_category ON exercises(category);
CREATE INDEX idx_exercises_is_active ON exercises(is_active);

-- strength_standards 인덱스
CREATE INDEX idx_strength_standards_exercise_id ON strength_standards(exercise_id);
CREATE INDEX idx_strength_standards_gender ON strength_standards(gender);
CREATE INDEX idx_strength_standards_level ON strength_standards(level);
CREATE INDEX idx_strength_standards_bodyweight ON strength_standards(bodyweight_min, bodyweight_max);
CREATE INDEX idx_strength_standards_lookup ON strength_standards(exercise_id, gender, level, bodyweight_min, bodyweight_max);

-- assessment_grade_constants 인덱스
CREATE INDEX idx_assessment_grade_constants_code ON assessment_grade_constants(grade_code);
CREATE INDEX idx_assessment_grade_constants_active ON assessment_grade_constants(is_active) WHERE is_active = true;

-- assessment_category_scores 인덱스
CREATE INDEX idx_assessment_category_scores_category ON assessment_category_scores(category);
CREATE INDEX idx_assessment_category_scores_input_grade ON assessment_category_scores(input_grade);
CREATE INDEX idx_assessment_category_scores_conditions ON assessment_category_scores USING GIN (conditions);
CREATE INDEX idx_assessment_category_scores_active ON assessment_category_scores(is_active) WHERE is_active = true;

-- flexibility_item_weights 인덱스
CREATE INDEX idx_flexibility_item_weights_item_name ON flexibility_item_weights(item_name);
CREATE INDEX idx_flexibility_item_weights_active ON flexibility_item_weights(is_active) WHERE is_active = true;

-- flexibility_grade_thresholds 인덱스
CREATE INDEX idx_flexibility_grade_thresholds_active ON flexibility_grade_thresholds(is_active) WHERE is_active = true;

-- body_composition_standards 인덱스
CREATE INDEX idx_body_composition_standards_gender_age ON body_composition_standards(gender, age_min, age_max);
CREATE INDEX idx_body_composition_standards_active ON body_composition_standards(is_active) WHERE is_active = true;

-- ============================================
-- 코멘트 추가
-- ============================================

COMMENT ON COLUMN members.height IS '키 (cm)';
COMMENT ON COLUMN members.weight IS '몸무게 (kg)';
COMMENT ON COLUMN members.gender IS '성별 (MALE, FEMALE)';
COMMENT ON COLUMN members.birth_date IS '생년월일';
COMMENT ON COLUMN members.age IS '한국나이 (생년월일로부터 자동 계산)';
COMMENT ON COLUMN workout_records.one_rep_max IS '1RM (One Rep Max) 계산값 (kg)';
COMMENT ON COLUMN workout_records.relative_strength IS '상대적 강도 (체중 대비 무게 비율, %)';
COMMENT ON COLUMN workout_records.strength_level IS 'Strength Level 판정 결과 (BEGINNER, NOVICE, INTERMEDIATE, ADVANCED, ELITE)';
COMMENT ON COLUMN assessment_items.value IS '측정값 (등급 기반 평가의 경우 null 가능)';
COMMENT ON COLUMN assessment_items.unit IS '단위 (value가 null이면 unit도 null)';
COMMENT ON COLUMN assessment_items.score IS '계산된 점수 (0-100)';

-- ============================================
-- 완료 메시지
-- ============================================
SELECT 'Database schema created successfully!' AS message;
