# 빠른 시작 가이드: StrengthLevel.com 데이터 수집

> **5분 안에 시작하기**: 가장 빠르게 데이터 수집을 시작하는 방법

---

## 🚀 3단계 빠른 시작

### Step 1: 사이트 접속 및 운동 목록 확인 (2분)

1. 브라우저에서 `https://strengthlevel.com` 접속
2. 상단 메뉴에서 **"Standards"** 클릭
3. 페이지 하단의 **"More Exercises"** 버튼을 계속 클릭
   - 버튼이 사라질 때까지 클릭 (보통 10-20회)
4. 모든 운동이 표시되었는지 확인

### Step 2: 첫 번째 운동 데이터 수집 (3분)

**예시: 벤치프레스**

1. **벤치프레스 클릭** → 상세 페이지로 이동
2. **테이블 확인**: 체중 범위별, 성별별, 레벨별 무게 확인
3. **데이터 복사**: 테이블 전체 선택 → 복사 (Ctrl+C)
4. **Excel에 붙여넣기**: Excel 열기 → 붙여넣기 (Ctrl+V)
5. **데이터 정리**: 불필요한 행/열 제거

### Step 3: SQL 파일에 추가 (5분)

1. `database/addExercise.sql` 파일 열기
2. 아래 형식에 맞춰 추가:

```sql
-- 벤치프레스 기본 정보
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '벤치프레스', 'Bench Press', 'UPPER', '가슴', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- 벤치프레스 기준 데이터 (Excel에서 복사한 데이터를 아래 형식으로 변환)
-- 남성 50-60kg, BEGINNER
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 50.0, 60.0, 'MALE', 'BEGINNER', 35.0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '벤치프레스'
ON CONFLICT DO NOTHING;

-- ... (나머지도 동일한 형식으로 추가)
```

---

## 📝 작업 패턴

### 패턴 1: 운동별 완료 (권장)

```
벤치프레스 → 모든 데이터 완료 → 다음 운동
스쿼트 → 모든 데이터 완료 → 다음 운동
...
```

**장점**: 한 운동에 집중하여 실수 방지

### 패턴 2: 단계별 완료

```
1단계: 모든 운동 목록만 수집
2단계: 모든 운동의 기본 정보 SQL 작성
3단계: 각 운동의 기준 데이터 수집 및 SQL 작성
```

**장점**: 작업을 단계별로 나눠서 진행

---

## 💡 시간 절약 팁

### 팁 1: Excel 활용

1. 테이블 복사 → Excel 붙여넣기
2. Excel에서 데이터 정리
3. Excel 수식으로 SQL 자동 생성 (선택적)

### 팁 2: 템플릿 사용

한 운동의 SQL 템플릿을 만들고 값만 바꿔가며 복사-붙여넣기

### 팁 3: 우선순위

1. 빅3 운동 (벤치프레스, 스쿼트, 데드리프트)
2. 주요 상체 운동
3. 주요 하체 운동
4. 나머지 운동들

---

## ⚠️ 주의사항

- **무게 단위**: kg로 통일 (lb는 변환 필요)
- **체중 범위**: 정확한 최소/최대값 확인
- **운동명**: exercises 테이블의 이름과 정확히 일치해야 함
- **ENUM 값**: 대문자로 입력 (MALE, FEMALE, BEGINNER 등)

---

## 📚 더 자세한 가이드

- **상세 가이드**: `docs/MANUAL_DATA_COLLECTION_GUIDE.md`
- **Excel 템플릿**: `docs/DATA_COLLECTION_TEMPLATE.md`
- **자동 수집 스크립트**: `scripts/scrape_strengthlevel.py`

---

**시작하세요!** 첫 번째 운동부터 차근차근 진행하면 됩니다. 🎯
