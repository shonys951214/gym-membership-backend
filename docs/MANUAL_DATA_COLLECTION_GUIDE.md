# StrengthLevel.com 수동 데이터 수집 가이드

> **목적**: strengthlevel.com에서 모든 운동의 기준 데이터를 수동으로 수집하여 `database/addExercise.sql` 파일에 추가하는 방법
> 
> **사용 목적**: 포트폴리오 프로젝트용 데이터 수집
> 
> **예상 작업 시간**: 
> - 운동 목록 수집: 30분-1시간
> - 운동당 기준 데이터 수집: 5-15분
> - 전체 (50개 운동 기준): 약 10-13시간

---

## 🎯 이 가이드를 읽기 전에

**빠르게 시작하고 싶다면**: `docs/QUICK_START_GUIDE.md` 먼저 읽기

**Excel 템플릿이 필요하다면**: `docs/DATA_COLLECTION_TEMPLATE.md` 참고

**자동 수집을 원한다면**: `scripts/scrape_strengthlevel.py` 사용 (Selenium 필요)

---

## 📋 목차

1. [사전 준비](#사전-준비)
2. [1단계: 운동 목록 수집](#1단계-운동-목록-수집)
3. [2단계: 각 운동의 상세 기준 데이터 수집](#2단계-각-운동의-상세-기준-데이터-수집)
4. [3단계: SQL 파일에 데이터 추가](#3단계-sql-파일에-데이터-추가)
5. [데이터 수집 체크리스트](#데이터-수집-체크리스트)
6. [예시: 벤치프레스 데이터 수집](#예시-벤치프레스-데이터-수집)
7. [자주 묻는 질문](#자주-묻는-질문)

---

## 사전 준비

### 필요한 도구
- 웹 브라우저 (Chrome, Firefox, Edge 등)
- 텍스트 에디터 (VS Code, Notepad++ 등)
- Excel 또는 Google Sheets (선택적, 데이터 정리용)

### 확인 사항
- `database/addExercise.sql` 파일이 프로젝트에 있는지 확인
- 데이터베이스 스키마 이해:
  - `exercises` 테이블: 운동 기본 정보
  - `strength_standards` 테이블: 체중 범위별 성별 레벨별 기준 무게

---

## 1단계: 운동 목록 수집

### 1-1. strengthlevel.com 접속

1. 웹 브라우저에서 `https://strengthlevel.com` 접속
2. 상단 메뉴에서 **"Standards"** 또는 **"Strength Standards"** 탭 클릭

### 1-2. 모든 운동 목록 표시

1. 페이지를 아래로 스크롤하여 운동 목록 확인
2. **"More Exercises"** 또는 **"Load More Exercises"** 버튼 찾기
3. 버튼이 더 이상 나타나지 않을 때까지 계속 클릭
   - 보통 10-20회 정도 클릭하면 모든 운동이 표시됩니다
   - 버튼이 사라지거나 비활성화되면 완료

### 1-3. 운동 정보 확인 및 기록

각 운동 카드/항목에서 다음 정보를 확인하고 기록합니다:

#### 확인할 정보
- **운동명 (한글)**: 예) "벤치프레스"
- **운동명 (영문)**: 예) "Bench Press"
- **카테고리**: 
  - `UPPER` (상체) - 벤치프레스, 오버헤드 프레스, 풀업 등
  - `LOWER` (하체) - 스쿼트, 레그 프레스, 런지 등
  - `FULL_BODY` (전신) - 데드리프트, 클린 등
- **부위**: 
  - 상체: `가슴`, `등`, `어깨`, `팔`
  - 하체: `하체`

#### 기록 방법 (선택)

**방법 1: Excel/Google Sheets 사용 (권장)**
```
운동명(한글) | 운동명(영문) | 카테고리 | 부위
벤치프레스 | Bench Press | UPPER | 가슴
스쿼트 | Squat | LOWER | 하체
데드리프트 | Deadlift | FULL_BODY | 하체
```

**방법 2: 텍스트 파일**
```
벤치프레스 / Bench Press / UPPER / 가슴
스쿼트 / Squat / LOWER / 하체
데드리프트 / Deadlift / FULL_BODY / 하체
```

---

## 2단계: 각 운동의 상세 기준 데이터 수집

### 2-1. 운동 상세 페이지 접속

**방법 1: 운동 목록에서 클릭**
1. Standards 페이지에서 원하는 운동 카드/항목 클릭
2. 운동 상세 페이지로 이동

**방법 2: URL 직접 접속**
1. URL 형식: `https://strengthlevel.com/strength-standards/{운동명}`
   - 운동명은 영문으로, 공백은 하이픈(-)으로 변환
   - 예: `https://strengthlevel.com/strength-standards/bench-press`
   - 예: `https://strengthlevel.com/strength-standards/barbell-squat`
   - 예: `https://strengthlevel.com/strength-standards/deadlift`

**방법 3: 검색 기능 사용**
1. 상단 검색창에 운동명 입력
2. 검색 결과에서 해당 운동 클릭

### 2-2. 기준 데이터 테이블 확인

각 운동 페이지에는 다음과 같은 테이블이 있습니다:

#### 테이블 구조

**일반적인 테이블 레이아웃:**

| 체중 (Bodyweight) | 성별 (Gender) | Beginner | Novice | Intermediate | Advanced | Elite |
|-------------------|--------------|----------|--------|--------------|----------|-------|
| 50-60kg | Male | 35kg | 45kg | 60kg | 75kg | 95kg |
| 50-60kg | Female | 18kg | 22kg | 30kg | 40kg | 55kg |
| 60-70kg | Male | 40kg | 50kg | 65kg | 80kg | 100kg |
| 60-70kg | Female | 20kg | 25kg | 35kg | 45kg | 60kg |
| ... | ... | ... | ... | ... | ... | ... |

**테이블 해석:**
- **행 (Row)**: 체중 범위와 성별 조합
  - 예: 50-60kg Male, 50-60kg Female, 60-70kg Male 등
- **열 (Column)**: 레벨별 기준 무게 (kg)
  - Beginner (초보자)
  - Novice (입문자)
  - Intermediate (중급자)
  - Advanced (고급자)
  - Elite (엘리트)

**주의사항:**
- 일부 운동은 체중 범위가 다를 수 있습니다 (예: 55-65kg, 65-75kg)
- 정확한 체중 범위 값을 확인하세요
- 무게 단위가 lb(파운드)로 표시된 경우 kg로 변환 필요

### 2-3. 데이터 수집 방법

#### 방법 1: 테이블 직접 복사 (가장 빠름) ⭐ 권장

**단계별 가이드:**

1. **테이블 선택**
   - 테이블 위에 마우스를 올리고 클릭
   - 또는 테이블의 왼쪽 상단 모서리를 클릭하여 전체 선택
   - 또는 마우스로 테이블 전체 드래그
   - **팁**: 테이블이 길면 스크롤하면서 선택

2. **복사**
   - `Ctrl+C` (Windows) 또는 `Cmd+C` (Mac)
   - 또는 우클릭 → 복사
   - **팁**: 복사가 안 되면 테이블을 다시 클릭하고 시도

3. **Excel/Google Sheets에 붙여넣기**
   - Excel 또는 Google Sheets 열기
   - `Ctrl+V` (Windows) 또는 `Cmd+V` (Mac)
   - 데이터가 표 형태로 붙여넣어집니다
   - **팁**: 붙여넣기 옵션에서 "텍스트로 붙여넣기" 선택하면 더 깔끔합니다

4. **데이터 정리**
   - 불필요한 행/열 제거 (헤더, 푸터 등)
   - 헤더 행 확인 및 정리
   - 숫자 형식 확인 (kg 단위인지, lb인지)
   - **체중 범위 파싱**: "50-60kg" → 최소: 50, 최대: 60
   - **성별 확인**: "Male" → "MALE", "Female" → "FEMALE"
   - **레벨 확인**: "Beginner" → "BEGINNER" 등

**Excel에서 정리 예시:**

| 체중범위 | 성별 | BEGINNER | NOVICE | INTERMEDIATE | ADVANCED | ELITE |
|---------|------|----------|--------|--------------|----------|-------|
| 50-60 | Male | 35 | 45 | 60 | 75 | 95 |
| 50-60 | Female | 18 | 22 | 30 | 40 | 55 |
| 60-70 | Male | 40 | 50 | 65 | 80 | 100 |

#### 방법 2: 수동 기록 (테이블 복사가 안 될 때)

각 체중 범위별로 다음 정보를 텍스트 파일이나 Excel에 기록:

```
운동: 벤치프레스
체중 범위: 60-70kg

남성 (MALE):
- BEGINNER: 40kg
- NOVICE: 50kg
- INTERMEDIATE: 65kg
- ADVANCED: 80kg
- ELITE: 100kg

여성 (FEMALE):
- BEGINNER: 20kg
- NOVICE: 25kg
- INTERMEDIATE: 35kg
- ADVANCED: 45kg
- ELITE: 60kg
```

#### 방법 3: 스크린샷 + OCR (고급)

1. 테이블 스크린샷 찍기
2. OCR 도구 사용 (Google Lens, OneNote 등)
3. 텍스트 추출 후 Excel에 정리

**팁**: 
- 브라우저 확장 프로그램 사용 (예: Table Capture)
- 개발자 도구에서 테이블 HTML 직접 복사

### 2-4. 체중 범위 확인

#### 일반적인 체중 범위

strengthlevel.com에서 사용하는 일반적인 체중 범위:

**여성 (Female) 기준:**
- 40-50kg
- 50-60kg
- 60-70kg
- 70-80kg
- 80-90kg
- 90-100kg
- 100kg 이상

**남성 (Male) 기준:**
- 50-60kg
- 60-70kg
- 70-80kg
- 80-90kg
- 90-100kg
- 100-110kg
- 110-120kg
- 120-130kg
- 130-140kg
- 140-150kg
- 150kg 이상

**주의사항:**
- 모든 체중 범위를 수집해야 합니다. 빠뜨리지 않도록 주의하세요
- 일부 운동은 체중 범위가 다를 수 있습니다 (예: 55-65kg, 65-75kg)
- 정확한 최소값과 최대값을 확인하세요
- 체중 범위가 "50kg 이상"처럼 표시되면 `bodyweight_min=50.0, bodyweight_max=999.0` 같은 큰 값 사용

#### 체중 범위 확인 방법

1. **테이블에서 확인**: 모든 행을 확인하여 체중 범위 목록 작성
2. **스크롤 확인**: 테이블을 끝까지 스크롤하여 모든 범위 확인
3. **개수 확인**: 
   - 남성: 보통 10-15개 체중 범위
   - 여성: 보통 7-10개 체중 범위
   - 총 데이터 개수 = 체중 범위 개수 × 2(성별) × 5(레벨)

---

## 3단계: SQL 파일에 데이터 추가

### 3-1. `database/addExercise.sql` 파일 열기

텍스트 에디터로 `database/addExercise.sql` 파일을 엽니다.

### 3-2. 운동 기본 정보 추가 (exercises 테이블)

#### 형식
```sql
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '운동명(한글)', '운동명(영문)', '카테고리', '부위', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;
```

#### 파라미터 설명
- `'운동명(한글)'`: 한글 운동명 (예: '벤치프레스')
- `'운동명(영문)'`: 영문 운동명 (예: 'Bench Press')
- `'카테고리'`: `UPPER`, `LOWER`, `FULL_BODY` 중 하나
- `'부위'`: `가슴`, `등`, `어깨`, `팔`, `하체` 중 하나 (또는 빈 문자열 `''`)
- `'kg'`: 단위 (항상 'kg'로 고정)

#### 예시
```sql
-- 벤치프레스
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '벤치프레스', 'Bench Press', 'UPPER', '가슴', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 스쿼트
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '스쿼트', 'Squat', 'LOWER', '하체', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 데드리프트
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '데드리프트', 'Deadlift', 'FULL_BODY', '하체', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;
```

#### 주의사항
- 작은따옴표(`'`)가 포함된 운동명은 두 개로 이스케이프: `''`
  - 예: `O'Brien` → `O''Brien`
- 운동명에 특수문자가 있으면 그대로 입력 (SQL에서 안전한 문자)
- 한글명과 영문명이 같으면 둘 다 같은 값으로 입력 가능

### 3-3. 기준 데이터 추가 (strength_standards 테이블)

#### 형식
```sql
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 체중최소, 체중최대, 'MALE'|'FEMALE', 'BEGINNER'|'NOVICE'|'INTERMEDIATE'|'ADVANCED'|'ELITE', 기준무게, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '운동명(한글)'
ON CONFLICT DO NOTHING;
```

#### 파라미터 설명
- `체중최소`: 체중 범위의 최소값 (예: 60.0)
- `체중최대`: 체중 범위의 최대값 (예: 70.0)
- `'MALE'|'FEMALE'`: 성별 (대문자로 입력)
- `'BEGINNER'|'NOVICE'|'INTERMEDIATE'|'ADVANCED'|'ELITE'`: 레벨 (대문자로 입력)
- `기준무게`: 해당 레벨의 기준 무게 (kg, 숫자만 입력, 따옴표 없음)
- `'운동명(한글)'`: exercises 테이블에 추가한 운동의 한글명 (정확히 일치해야 함)

#### 예시: 벤치프레스 - 남성 60-70kg 체중 범위
```sql
-- 벤치프레스 기준 데이터
-- 남성 60-70kg, BEGINNER
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'BEGINNER', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- 남성 60-70kg, NOVICE
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'NOVICE', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- 남성 60-70kg, INTERMEDIATE
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'INTERMEDIATE', 65.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- 남성 60-70kg, ADVANCED
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'ADVANCED', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- 남성 60-70kg, ELITE
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'ELITE', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;
```

#### 여성 데이터도 동일하게 추가
```sql
-- 여성 50-60kg, BEGINNER
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'FEMALE', 'BEGINNER', 20.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- ... (나머지 레벨과 체중 범위도 동일하게 추가)
```

### 3-4. 데이터 추가 순서

효율적인 작업 순서 (권장):

#### 방법 1: 운동별 완료 방식 (권장)

1. **모든 운동의 기본 정보 먼저 추가**
   - exercises 테이블 INSERT 문 작성
   - 한 번에 모든 운동 추가
   - 이렇게 하면 나중에 기준 데이터 추가 시 운동명 참조 가능

2. **운동별로 기준 데이터 추가**
   - 한 운동씩 완전히 마무리
   - 예: 벤치프레스 → 모든 체중 범위, 모든 성별, 모든 레벨 완료 후 다음 운동
   - 장점: 한 운동에 집중하여 실수 방지

#### 방법 2: 체중 범위별 그룹화

1. **모든 운동의 기본 정보 먼저 추가** (동일)

2. **체중 범위별로 그룹화하여 추가**
   - 같은 체중 범위의 모든 운동, 모든 성별, 모든 레벨을 함께 작성
   - 예: 60-70kg → 모든 운동의 60-70kg 데이터 추가 → 다음 체중 범위
   - 장점: 체중 범위별로 패턴이 비슷하여 빠르게 작성 가능

#### 방법 3: 레벨별 그룹화

1. **모든 운동의 기본 정보 먼저 추가** (동일)

2. **레벨별로 그룹화하여 추가**
   - BEGINNER 레벨 → 모든 운동, 모든 체중 범위, 모든 성별
   - NOVICE 레벨 → 모든 운동, 모든 체중 범위, 모든 성별
   - ... (나머지 레벨도 동일)
   - 장점: 레벨별로 패턴이 비슷하여 빠르게 작성 가능

**추천**: 방법 1 (운동별 완료 방식)이 가장 안전하고 실수하기 어렵습니다.

---

## 데이터 수집 체크리스트

### 운동 목록 수집 체크리스트

- [ ] strengthlevel.com Standards 페이지 접속
- [ ] "More Exercises" 버튼을 더 이상 나타나지 않을 때까지 클릭
- [ ] 모든 운동 목록 확인
- [ ] 각 운동의 다음 정보 기록:
  - [ ] 운동명 (한글)
  - [ ] 운동명 (영문)
  - [ ] 카테고리 (UPPER/LOWER/FULL_BODY)
  - [ ] 부위 (가슴/등/어깨/팔/하체)

### 기준 데이터 수집 체크리스트 (운동별)

각 운동에 대해:

- [ ] 운동 상세 페이지 접속
- [ ] 모든 체중 범위 확인
- [ ] 각 체중 범위별로:
  - [ ] 남성 (MALE) 5개 레벨 수집:
    - [ ] BEGINNER
    - [ ] NOVICE
    - [ ] INTERMEDIATE
    - [ ] ADVANCED
    - [ ] ELITE
  - [ ] 여성 (FEMALE) 5개 레벨 수집:
    - [ ] BEGINNER
    - [ ] NOVICE
    - [ ] INTERMEDIATE
    - [ ] ADVANCED
    - [ ] ELITE

### SQL 파일 작성 체크리스트

- [ ] `database/addExercise.sql` 파일 열기
- [ ] 모든 운동의 exercises INSERT 문 작성
- [ ] 각 운동별로 strength_standards INSERT 문 작성:
  - [ ] 모든 체중 범위 포함
  - [ ] 남성/여성 모두 포함
  - [ ] 5개 레벨 모두 포함
- [ ] SQL 문법 오류 확인
- [ ] 데이터베이스에 실행하여 테스트

---

## 예시: 벤치프레스 데이터 수집 (완전한 가이드)

이 예시를 따라하면 다른 운동도 동일한 방식으로 수집할 수 있습니다.

### 1. 운동 기본 정보 확인

**strengthlevel.com에서 확인:**

1. Standards 페이지에서 "벤치프레스" 또는 "Bench Press" 찾기
2. 운동 카드에서 다음 정보 확인:
   - 운동명 (한글): **벤치프레스**
   - 운동명 (영문): **Bench Press**
   - 카테고리: **상체** → `UPPER`
   - 부위: **가슴** → `가슴`

**확인 방법:**
- 운동 카드의 제목에서 운동명 확인
- 운동 설명이나 태그에서 카테고리 확인
- 운동 이미지나 설명에서 주로 사용하는 부위 확인

### 2. SQL에 기본 정보 추가

```sql
-- 벤치프레스 기본 정보
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '벤치프레스', 'Bench Press', 'UPPER', '가슴', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;
```

**파일 위치**: `database/addExercise.sql`의 "1. EXERCISES 테이블 데이터 삽입" 섹션에 추가

### 3. 기준 데이터 수집

#### 3-1. 운동 상세 페이지 접속

1. 벤치프레스 카드 클릭
2. 또는 URL 직접 접속: `https://strengthlevel.com/strength-standards/bench-press`

#### 3-2. 테이블 확인

벤치프레스 상세 페이지에서 기준 데이터 테이블 확인:

**예시 테이블:**

| Bodyweight | Gender | Beginner | Novice | Intermediate | Advanced | Elite |
|------------|--------|----------|--------|--------------|----------|-------|
| 50-60kg | Male | 35kg | 45kg | 60kg | 75kg | 95kg |
| 50-60kg | Female | 18kg | 22kg | 30kg | 40kg | 55kg |
| 60-70kg | Male | 40kg | 50kg | 65kg | 80kg | 100kg |
| 60-70kg | Female | 20kg | 25kg | 35kg | 45kg | 60kg |
| 70-80kg | Male | 45kg | 60kg | 75kg | 95kg | 115kg |
| 70-80kg | Female | 22kg | 28kg | 40kg | 50kg | 65kg |
| ... | ... | ... | ... | ... | ... | ... |

**실제 데이터는 strengthlevel.com에서 확인하세요. 위는 예시입니다.**

#### 3-3. 데이터 기록

Excel 또는 텍스트 파일에 기록:

| 체중범위 | 성별 | BEGINNER | NOVICE | INTERMEDIATE | ADVANCED | ELITE |
|---------|------|----------|--------|--------------|----------|-------|
| 50-60 | MALE | 35 | 45 | 60 | 75 | 95 |
| 50-60 | FEMALE | 18 | 22 | 30 | 40 | 55 |
| 60-70 | MALE | 40 | 50 | 65 | 80 | 100 |
| 60-70 | FEMALE | 20 | 25 | 35 | 45 | 60 |
| ... | ... | ... | ... | ... | ... | ... |

### 4. SQL에 추가

#### 4-1. 파일 위치

`database/addExercise.sql` 파일의 "2. STRENGTH_STANDARDS 테이블 데이터 삽입" 섹션에 추가합니다.

#### 4-2. SQL 문 작성

**벤치프레스 기준 데이터 전체 예시:**

```sql
-- ============================================
-- 벤치프레스 (Bench Press) 기준 데이터
-- ============================================

-- 남성 50-60kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'BEGINNER', 35.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'NOVICE', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'INTERMEDIATE', 60.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'ADVANCED', 75.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'ELITE', 95.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- 여성 50-60kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'FEMALE', 'BEGINNER', 18.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'FEMALE', 'NOVICE', 22.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'FEMALE', 'INTERMEDIATE', 30.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'FEMALE', 'ADVANCED', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'FEMALE', 'ELITE', 55.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- 남성 60-70kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'BEGINNER', 40.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'NOVICE', 50.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'INTERMEDIATE', 65.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'ADVANCED', 80.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'MALE', 'ELITE', 100.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- 여성 60-70kg
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'FEMALE', 'BEGINNER', 20.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'FEMALE', 'NOVICE', 25.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'FEMALE', 'INTERMEDIATE', 35.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'FEMALE', 'ADVANCED', 45.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 60.0, 70.0, 'FEMALE', 'ELITE', 60.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- ... (나머지 체중 범위도 동일한 형식으로 계속 추가)
-- 남성 70-80kg, 여성 70-80kg, 남성 80-90kg, 여성 80-90kg 등
```

**주의사항:**
- 위 예시의 숫자는 실제 값이 아닙니다. strengthlevel.com에서 실제 데이터를 확인하세요.
- 모든 체중 범위에 대해 동일한 형식으로 추가해야 합니다.
- 각 체중 범위마다 남성 5개 레벨 + 여성 5개 레벨 = 총 10개 INSERT 문이 필요합니다.

---

## 효율적인 작업 팁

### 팁 1: Excel 템플릿 사용 ⭐ 가장 권장

Excel에서 다음과 같은 템플릿을 만들어 사용하면 편리합니다:

**운동 목록 템플릿:**

| 운동명(한글) | 운동명(영문) | 카테고리 | 부위 | 완료여부 |
|------------|------------|---------|------|---------|
| 벤치프레스 | Bench Press | UPPER | 가슴 | ✅ |
| 스쿼트 | Squat | LOWER | 하체 | ⏳ |
| ... | ... | ... | ... | ... |

**기준 데이터 템플릿:**

| 운동명 | 체중범위 | 성별 | BEGINNER | NOVICE | INTERMEDIATE | ADVANCED | ELITE |
|--------|---------|------|----------|--------|--------------|----------|-------|
| 벤치프레스 | 50-60 | MALE | 35 | 45 | 60 | 75 | 95 |
| 벤치프레스 | 50-60 | FEMALE | 18 | 22 | 30 | 40 | 55 |
| 벤치프레스 | 60-70 | MALE | 40 | 50 | 65 | 80 | 100 |
| ... | ... | ... | ... | ... | ... | ... | ... |

**Excel 수식으로 SQL 자동 생성:**

A열: 운동명, B열: 체중최소, C열: 체중최대, D열: 성별, E열: 레벨, F열: 무게

```excel
="INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at) SELECT gen_random_uuid(), e.id, "&B2&", "&C2&", '"&D2&"', '"&E2&"', "&F2&", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM exercises e WHERE e.name = '"&A2&"' ON CONFLICT DO NOTHING;"
```

이렇게 정리한 후 SQL로 변환하면 빠릅니다.

**상세 템플릿**: `docs/DATA_COLLECTION_TEMPLATE.md` 참고

### 팁 2: SQL 템플릿 복사-붙여넣기

한 운동의 SQL 템플릿을 만들고, 값만 바꿔가며 복사-붙여넣기하면 빠릅니다.

**템플릿 예시:**
```sql
-- [운동명] 기준 데이터
-- [체중범위] [성별]
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, [최소], [최대], '[성별]', '[레벨]', [무게], CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '[운동명]'
ON CONFLICT DO NOTHING;
```

### 팁 3: 단계별 진행

1. **1일차**: 운동 목록만 모두 수집 (30분-1시간)
2. **2일차**: 주요 운동(빅3) 기준 데이터 수집 (2-3시간)
   - 벤치프레스
   - 스쿼트
   - 데드리프트
3. **3일차 이후**: 나머지 운동들 하나씩 완료 (운동당 5-10분)

### 팁 4: 검증

각 운동의 데이터를 추가한 후:

**체크리스트:**
- [ ] 체중 범위가 빠지지 않았는지 확인
  - 남성: 보통 10-15개 체중 범위
  - 여성: 보통 7-10개 체중 범위
- [ ] 남성/여성 모두 포함되었는지 확인
- [ ] 5개 레벨 모두 포함되었는지 확인
  - BEGINNER, NOVICE, INTERMEDIATE, ADVANCED, ELITE
- [ ] 무게 값이 kg 단위인지 확인 (lb가 아닌지)
- [ ] SQL 문법 오류가 없는지 확인

**검증 SQL:**
```sql
-- 특정 운동의 기준 데이터 개수 확인
SELECT COUNT(*) 
FROM strength_standards s
JOIN exercises e ON s.exercise_id = e.id
WHERE e.name = '벤치프레스';

-- 예상 개수: 체중 범위 개수 × 2(성별) × 5(레벨)
-- 예: 12개 체중 범위 × 2 × 5 = 120개
```

### 팁 5: 작업 시간 단축

- **우선순위 정하기**: 자주 사용하는 운동부터 수집
- **배치 작업**: 같은 시간에 여러 운동의 데이터만 수집하고, 나중에 SQL 작성
- **도구 활용**: Excel 수식, 텍스트 에디터의 찾기/바꾸기 기능 활용

---

## 자주 묻는 질문

### Q1: 체중 범위가 정확하지 않으면?

**A**: strengthlevel.com에 표시된 정확한 값을 사용하세요. 

**예시:**
- "50-60kg" → `bodyweight_min=50.0, bodyweight_max=60.0`
- "55-65kg" → `bodyweight_min=55.0, bodyweight_max=65.0`
- "60kg 이상" → `bodyweight_min=60.0, bodyweight_max=999.0` (큰 값 사용)

**주의**: 
- 소수점이 있으면 그대로 사용 (예: 50.5-60.5kg)
- 범위가 겹치지 않도록 정확히 확인

### Q2: 무게 단위가 lb(파운드)로 표시되면?

**A**: kg로 변환해야 합니다. 

**변환 공식:**
```
kg = lb × 0.453592
```

**예시:**
- 100lb → 100 × 0.453592 = 45.36kg
- 200lb → 200 × 0.453592 = 90.72kg

**온라인 변환기 사용:**
- Google 검색: "100 lb to kg"
- 또는 변환 사이트 사용

**Excel에서 변환:**
```excel
=A1*0.453592  (A1에 lb 값이 있는 경우)
```

### Q3: 운동명이 한글과 영문이 모두 없으면?

**A**: 
- 영문명만 있으면: 한글명도 영문명과 동일하게 입력
- 한글명만 있으면: 영문명도 한글명과 동일하게 입력
- 둘 다 없으면: 사이트에서 확인하거나 다른 운동으로 대체

### Q4: 카테고리나 부위를 모르겠으면?

**A**: 
- **카테고리**: 운동의 특성으로 판단
  - 상체만 사용 → `UPPER`
  - 하체만 사용 → `LOWER`
  - 전신 사용 → `FULL_BODY`
- **부위**: 
  - 상체 운동: 주로 사용하는 근육 부위 (가슴/등/어깨/팔)
  - 하체 운동: `하체`

### Q5: 데이터가 너무 많아서 시간이 오래 걸리면?

**A**: 
- 우선순위를 정하세요:
  1. 빅3 운동 (벤치프레스, 스쿼트, 데드리프트)
  2. 주요 상체 운동 (오버헤드 프레스, 풀업 등)
  3. 주요 하체 운동 (레그 프레스, 런지 등)
  4. 나머지 운동들
- 자주 사용하는 운동부터 수집하세요.

### Q6: SQL 문법 오류가 발생하면?

**A**: 
- 작은따옴표(`'`)가 포함된 운동명은 두 개로 이스케이프: `''`
- 예: `O'Brien` → `O''Brien`
- 숫자는 따옴표 없이 입력: `40.0` (O), `'40.0'` (X)

### Q7: 데이터베이스에 실행했는데 오류가 나면?

**A**: 

**일반적인 오류와 해결:**

1. **외래 키 제약 조건 오류**
   ```
   ERROR: insert or update on table "strength_standards" violates foreign key constraint
   ```
   - **원인**: `exercises` 테이블에 해당 운동이 없음
   - **해결**: 운동 기본 정보를 먼저 추가하세요

2. **운동명을 찾을 수 없음**
   ```
   ERROR: 운동을 찾을 수 없습니다
   ```
   - **원인**: 운동명이 정확히 일치하지 않음
   - **해결**: 
     - 대소문자 확인
     - 공백 확인
     - 특수문자 확인
     - SQL에서: `SELECT name FROM exercises;`로 정확한 이름 확인

3. **ENUM 타입 오류**
   ```
   ERROR: invalid input value for enum
   ```
   - **원인**: ENUM 값이 잘못됨
   - **해결**: 
     - 성별: `MALE` 또는 `FEMALE` (대문자)
     - 레벨: `BEGINNER`, `NOVICE`, `INTERMEDIATE`, `ADVANCED`, `ELITE` (대문자)
     - 카테고리: `UPPER`, `LOWER`, `FULL_BODY` (대문자)

4. **데이터 타입 오류**
   ```
   ERROR: invalid input syntax for type float
   ```
   - **원인**: 숫자가 아닌 값 입력
   - **해결**: 
     - 무게 값에 따옴표 없이 숫자만 입력: `40.0` (O), `'40.0'` (X)
     - kg, lb 같은 단위 제거

**디버깅 방법:**
```sql
-- 1. 운동이 제대로 추가되었는지 확인
SELECT * FROM exercises WHERE name = '벤치프레스';

-- 2. 기준 데이터 개수 확인
SELECT COUNT(*) FROM strength_standards 
WHERE exercise_id = (SELECT id FROM exercises WHERE name = '벤치프레스');

-- 3. 특정 체중 범위 데이터 확인
SELECT * FROM strength_standards 
WHERE exercise_id = (SELECT id FROM exercises WHERE name = '벤치프레스')
AND bodyweight_min = 60.0 AND bodyweight_max = 70.0;
```

---

## 작업 시간 예상

### 단계별 예상 시간

1. **운동 목록 수집**: 30분 - 1시간
   - "More Exercises" 버튼 클릭: 10-15분
   - 운동 정보 기록: 20-45분
   - **팁**: Excel에 바로 기록하면 더 빠릅니다

2. **운동당 기준 데이터 수집**: 5-15분
   - 상세 페이지 접속 및 테이블 확인: 1-2분
   - 데이터 복사/기록: 2-5분
   - SQL 작성: 2-8분
   - 체중 범위 10개 × 성별 2개 × 레벨 5개 = 100개 데이터
   - **Excel 사용 시**: 3-5분으로 단축 가능

3. **전체 작업 시간**:
   - **운동 10개**: 약 2-3시간
   - **운동 30개**: 약 6-8시간
   - **운동 50개**: 약 10-13시간
   - **운동 100개**: 약 20-25시간

### 시간 단축 팁

- **Excel 템플릿 사용**: SQL 작성 시간 50% 단축
- **배치 작업**: 데이터 수집과 SQL 작성을 분리하여 집중도 향상
- **우선순위**: 자주 사용하는 운동부터 수집
- **템플릿 복사-붙여넣기**: 한 운동의 SQL을 만들고 값만 바꾸기

### 권장 작업 계획

**옵션 1: 단계별 완료 (안정적)**
- **1일차**: 운동 목록 수집 + 빅3 운동 (벤치프레스, 스쿼트, 데드리프트)
- **2일차**: 주요 상체 운동 10개
- **3일차**: 주요 하체 운동 10개
- **4일차 이후**: 나머지 운동들

**옵션 2: 우선순위 완료 (효율적)**
- **1일차**: 빅3 + 자주 사용하는 운동 10개
- **2일차 이후**: 나머지 운동들

**하루에 5-10개 운동씩 나눠서 작업하세요.**

---

## 완료 확인

모든 작업이 완료되면:

### 1. SQL 파일 확인

`database/addExercise.sql` 파일을 열어 다음을 확인:
- [ ] 모든 운동의 exercises INSERT 문이 있는가?
- [ ] 각 운동의 strength_standards INSERT 문이 있는가?
- [ ] SQL 문법 오류가 없는가?

### 2. 데이터베이스에 실행

**PostgreSQL에서 실행:**
```sql
\i database/addExercise.sql
```

**또는 psql 명령어:**
```bash
psql -U username -d database_name -f database/addExercise.sql
```

**또는 데이터베이스 클라이언트에서:**
- SQL 파일 내용을 복사하여 실행

### 3. 데이터 확인

```sql
-- 운동 개수 확인
SELECT COUNT(*) as total_exercises FROM exercises;

-- 기준 데이터 개수 확인
SELECT COUNT(*) as total_standards FROM strength_standards;

-- 운동별 기준 데이터 개수 확인
SELECT 
    e.name,
    COUNT(s.id) as standard_count
FROM exercises e
LEFT JOIN strength_standards s ON e.id = s.exercise_id
GROUP BY e.id, e.name
ORDER BY e.name;

-- 특정 운동의 기준 데이터 확인 (예: 벤치프레스)
SELECT 
    s.bodyweight_min,
    s.bodyweight_max,
    s.gender,
    s.level,
    s.weight_kg
FROM strength_standards s
JOIN exercises e ON s.exercise_id = e.id
WHERE e.name = '벤치프레스'
ORDER BY s.bodyweight_min, s.gender, 
    CASE s.level
        WHEN 'BEGINNER' THEN 1
        WHEN 'NOVICE' THEN 2
        WHEN 'INTERMEDIATE' THEN 3
        WHEN 'ADVANCED' THEN 4
        WHEN 'ELITE' THEN 5
    END;
```

### 4. 데이터 검증

**예상 데이터 개수 계산:**
```
운동당 기준 데이터 개수 = 체중 범위 개수 × 2(성별) × 5(레벨)

예: 벤치프레스
- 남성 체중 범위: 12개
- 여성 체중 범위: 8개
- 총 기준 데이터: (12 + 8) × 5 = 100개
```

**실제 개수와 비교:**
```sql
SELECT 
    e.name,
    COUNT(s.id) as actual_count,
    -- 예상 개수는 수동으로 계산하여 비교
    100 as expected_count
FROM exercises e
LEFT JOIN strength_standards s ON e.id = s.exercise_id
WHERE e.name = '벤치프레스'
GROUP BY e.id, e.name;
```

---

## 추가 도움말

### 문제 해결

**문제가 발생하거나 질문이 있으면:**

1. **이 가이드를 다시 확인**
   - 각 단계를 다시 읽어보세요
   - 예시를 참고하세요

2. **SQL 문법 검사**
   - 온라인 SQL 문법 검사기 사용
   - 데이터베이스 클라이언트의 문법 하이라이트 확인

3. **데이터베이스 로그 확인**
   - 오류 메시지를 자세히 읽어보세요
   - 어떤 테이블, 어떤 컬럼에서 오류가 발생했는지 확인

4. **단계별 테스트**
   - 먼저 exercises만 추가하여 테스트
   - 그 다음 strength_standards 추가

### 추가 리소스

- **상세 가이드**: `docs/MANUAL_DATA_COLLECTION_GUIDE.md` (이 파일)
- **빠른 시작**: `docs/QUICK_START_GUIDE.md`
- **Excel 템플릿**: `docs/DATA_COLLECTION_TEMPLATE.md`
- **자동 수집 스크립트**: `scripts/scrape_strengthlevel.py`

---

## 작업 완료 체크리스트

최종 확인:

- [ ] 모든 운동 목록 수집 완료
- [ ] 각 운동의 기본 정보 (exercises) SQL 작성 완료
- [ ] 각 운동의 기준 데이터 (strength_standards) SQL 작성 완료
- [ ] SQL 파일 문법 오류 없음
- [ ] 데이터베이스에 실행 성공
- [ ] 데이터 개수 확인 완료
- [ ] 샘플 데이터로 테스트 완료

**모든 체크리스트를 완료하면 작업이 끝났습니다!** ✅

**행운을 빕니다!** 🍀
