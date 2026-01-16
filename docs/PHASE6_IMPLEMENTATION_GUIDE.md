# Phase 6 구현 가이드: Strength Level 기준 데이터 준비

> **목적**: strengthlevel.com에서 Strength Level 기준 데이터를 수집하여 `strength_standards` 테이블에 삽입

---

## 📋 Phase 6 작업 개요

### 목표
- strengthlevel.com에서 운동별 Strength Level 기준 데이터 수집
- `strength_standards` 테이블에 데이터 삽입
- Strength Level 판정 기능 활성화

### 중요성
- Strength Level 기능의 핵심 데이터
- 운동 기록 저장 시 자동으로 레벨 판정 가능
- 회원의 운동 능력 객관적 평가

---

## ✅ 현재 상태

### 이미 구현된 기능
- ✅ `strength_standards` 테이블 (create_full_schema.sql에 포함)
- ✅ Strength Level 계산 로직 (`strength-level-evaluator.ts`)
- ✅ 1RM 계산 로직 (`one-rep-max-calculator.ts`)
- ✅ 상대적 강도 계산 로직 (`relative-strength-calculator.ts`)
- ✅ 운동 기록 저장 시 자동 계산 통합
- ✅ Strength Level API 엔드포인트 (일부 구현됨)

### 필요한 작업
- ⏳ strengthlevel.com에서 기준 데이터 수집
- ⏳ `strength_standards` 테이블에 데이터 삽입

---

## 🔄 데이터 수집 방법

### 방법 1: 자동 수집 (권장)

**스크립트**: `scripts/scrape_strengthlevel.py`

**장점**:
- 빠른 수집 (873개 운동 기준 약 2-3시간)
- 자동화 가능
- 일관된 데이터 형식

**단점**:
- Python 환경 필요
- Selenium 설치 필요
- 사이트 구조 변경 시 스크립트 수정 필요

**사용 방법**:
```bash
# 1. Python 환경 설정
pip install selenium beautifulsoup4 webdriver-manager

# 2. 스크립트 실행
python scripts/scrape_strengthlevel.py

# 3. 생성된 SQL 파일 확인
# database/addExercise.sql (또는 다른 파일명)
```

**참고 문서**: `scripts/README_SCRAPING.md`

---

### 방법 2: 수동 수집

**가이드**: `docs/MANUAL_DATA_COLLECTION_GUIDE.md`

**장점**:
- 정확한 데이터 확인 가능
- 필요한 운동만 선택적으로 수집
- 사이트 구조 변경에 영향 없음

**단점**:
- 시간이 많이 소요 (운동당 5-15분)
- 수집 과정에서 오류 가능성

**예상 작업 시간**:
- 운동 목록 수집: 30분-1시간
- 운동당 기준 데이터 수집: 5-15분
- 전체 (50개 운동 기준): 약 10-13시간

**사용 방법**:
1. `docs/MANUAL_DATA_COLLECTION_GUIDE.md` 참고
2. strengthlevel.com에서 데이터 수집
3. `database/addExercise.sql` 파일에 수동으로 추가

---

## 📊 데이터 수집 우선순위

### 1순위: 빅3 운동 (필수)
- 벤치프레스 (Bench Press)
- 스쿼트 (Squat)
- 데드리프트 (Deadlift)

**이유**: 가장 많이 사용되는 운동이며, Strength Level 기능의 핵심

### 2순위: 주요 상체 운동
- 오버헤드 프레스 (Overhead Press)
- 벤트오버 로우 (Bent Over Row)
- 풀업 (Pull Up)
- 딥스 (Dip)

### 3순위: 주요 하체 운동
- 레그프레스 (Leg Press)
- 프론트 스쿼트 (Front Squat)
- 루마니안 데드리프트 (Romanian Deadlift)

### 4순위: 기타 운동
- 나머지 운동들 (선택적)

---

## 🗄️ 데이터 구조

### strength_standards 테이블 구조

```sql
CREATE TABLE strength_standards (
    id UUID PRIMARY KEY,
    exercise_id UUID REFERENCES exercises(id),
    bodyweight_min FLOAT NOT NULL,    -- 체중 최소값 (kg)
    bodyweight_max FLOAT NOT NULL,    -- 체중 최대값 (kg)
    gender gender NOT NULL,           -- MALE | FEMALE
    level strength_level NOT NULL,     -- BEGINNER | NOVICE | INTERMEDIATE | ADVANCED | ELITE
    weight_kg FLOAT NOT NULL,         -- 기준 무게 (kg)
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);
```

### 데이터 예시

```sql
-- 벤치프레스, 남성, 50-60kg 체중, BEGINNER 레벨
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT 
    gen_random_uuid(),
    e.id,
    50.0,
    60.0,
    'MALE',
    'BEGINNER',
    35.0,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM exercises e 
WHERE e.name_en = 'Bench Press'
ON CONFLICT DO NOTHING;
```

---

## 📝 데이터 삽입 방법

### 1단계: SQL 파일 생성

**자동 수집**: `scripts/scrape_strengthlevel.py` 실행 후 생성된 파일 사용

**수동 수집**: `database/addExercise.sql` 파일에 데이터 추가

### 2단계: 데이터베이스에 삽입

```sql
-- PostgreSQL에 연결 후
\i database/addExercise.sql
```

또는 psql:
```bash
psql -U your_username -d your_database -f database/addExercise.sql
```

### 3단계: 데이터 검증

```sql
-- 전체 기준 데이터 개수 확인
SELECT COUNT(*) as total_standards FROM strength_standards;

-- 운동별 기준 데이터 개수
SELECT 
    e.name_en,
    COUNT(s.id) as standard_count
FROM exercises e
LEFT JOIN strength_standards s ON e.id = s.exercise_id
GROUP BY e.id, e.name_en
ORDER BY standard_count DESC, e.name_en
LIMIT 20;

-- 성별별 기준 데이터 개수
SELECT 
    gender,
    level,
    COUNT(*) as count
FROM strength_standards
GROUP BY gender, level
ORDER BY gender, level;

-- 빅3 운동 기준 데이터 확인
SELECT 
    e.name_en,
    s.gender,
    s.level,
    COUNT(*) as count
FROM strength_standards s
JOIN exercises e ON s.exercise_id = e.id
WHERE e.name_en IN ('Bench Press', 'Squat', 'Deadlift')
GROUP BY e.name_en, s.gender, s.level
ORDER BY e.name_en, s.gender, s.level;
```

---

## ⚠️ 주의사항

### 1. exercise_id 매칭
- `exercises.name_en`과 정확히 일치해야 함
- 대소문자 구분
- 공백, 하이픈 등 정확히 일치

### 2. 체중 범위
- `bodyweight_min` ≤ `bodyweight_max`
- 일반적으로 5kg 또는 10kg 단위
- 마지막 범위는 `bodyweight_max = 999.0` (이상)

### 3. 레벨 순서
- BEGINNER < NOVICE < INTERMEDIATE < ADVANCED < ELITE
- 각 레벨의 `weight_kg`는 순차적으로 증가해야 함

### 4. 성별별 데이터
- MALE과 FEMALE 모두 수집 필요
- 각 성별별로 동일한 체중 범위와 레벨 구조

---

## 🎯 다음 단계

Phase 6 완료 후:
- **Phase 2**: 초기 평가 세부항목 정의
- **Phase 3**: 정기 평가 세부항목 및 환산 메커니즘
- **Phase 4**: 그래프 차트 및 상세 시각화

---

## 📚 참고 문서

- `scripts/README_SCRAPING.md` - 자동 수집 스크립트 가이드
- `docs/MANUAL_DATA_COLLECTION_GUIDE.md` - 수동 수집 상세 가이드
- `docs/QUICK_START_GUIDE.md` - 빠른 시작 가이드
- `docs/STRENGTH_LEVEL_API_GUIDE.md` - Strength Level API 가이드

---

**작성일**: 2026-01-16  
**상태**: Phase 0 완료, Phase 6 시작 준비
