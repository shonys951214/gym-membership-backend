# 데이터 수집 템플릿 (Excel/Google Sheets용)

이 템플릿을 사용하여 데이터를 정리한 후 SQL로 변환하세요.

---

## 운동 목록 수집 템플릿

| 운동명(한글) | 운동명(영문) | 카테고리 | 부위 | 비고 |
|------------|------------|---------|------|------|
| 벤치프레스 | Bench Press | UPPER | 가슴 | |
| 스쿼트 | Squat | LOWER | 하체 | |
| 데드리프트 | Deadlift | FULL_BODY | 하체 | |
| ... | ... | ... | ... | ... |

**카테고리 값**: `UPPER`, `LOWER`, `FULL_BODY`  
**부위 값**: `가슴`, `등`, `어깨`, `팔`, `하체`

---

## 기준 데이터 수집 템플릿 (운동별)

### 템플릿 1: 체중 범위별 정리

| 체중 범위 | 성별 | BEGINNER | NOVICE | INTERMEDIATE | ADVANCED | ELITE |
|---------|------|----------|--------|--------------|----------|-------|
| 50-60kg | MALE | | | | | |
| 50-60kg | FEMALE | | | | | |
| 60-70kg | MALE | | | | | |
| 60-70kg | FEMALE | | | | | |
| ... | ... | ... | ... | ... | ... | ... |

### 템플릿 2: 레벨별 정리 (권장)

각 레벨별로 시트를 나누어 정리:

**BEGINNER 시트**
| 운동명 | 체중 범위 | MALE | FEMALE |
|--------|---------|------|--------|
| 벤치프레스 | 50-60kg | 35 | 18 |
| 벤치프레스 | 60-70kg | 40 | 20 |
| ... | ... | ... | ... |

**NOVICE 시트**
| 운동명 | 체중 범위 | MALE | FEMALE |
|--------|---------|------|--------|
| 벤치프레스 | 50-60kg | 45 | 22 |
| ... | ... | ... | ... |

(INTERMEDIATE, ADVANCED, ELITE도 동일한 형식)

---

## SQL 변환 가이드

### Excel에서 SQL로 변환하는 방법

#### 방법 1: 수동 변환

1. Excel에서 데이터 확인
2. SQL 템플릿에 값 복사-붙여넣기

#### 방법 2: Excel 수식 사용 (고급)

Excel에서 다음 수식을 사용하여 SQL 문 자동 생성:

**운동 기본 정보 (A열: 한글명, B열: 영문명, C열: 카테고리, D열: 부위)**
```
="INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at) VALUES (gen_random_uuid(), '"&A2&"', '"&B2&"', '"&C2&"', '"&D2&"', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) ON CONFLICT DO NOTHING;"
```

**기준 데이터 (A열: 운동명, B열: 체중최소, C열: 체중최대, D열: 성별, E열: 레벨, F열: 무게)**
```
="INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at) SELECT gen_random_uuid(), e.id, "&B2&", "&C2&", '"&D2&"', '"&E2&"', "&F2&", CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM exercises e WHERE e.name = '"&A2&"' ON CONFLICT DO NOTHING;"
```

---

## 작업 진행 상황 추적

### 운동별 진행 상황

| 운동명 | 기본정보 | 기준데이터 | 완료여부 | 비고 |
|--------|---------|-----------|---------|------|
| 벤치프레스 | ✅ | ✅ | ✅ | |
| 스쿼트 | ✅ | ✅ | ✅ | |
| 데드리프트 | ✅ | ⏳ | ⏳ | 진행중 |
| ... | ... | ... | ... | ... |

**상태 표시**:
- ✅ 완료
- ⏳ 진행중
- ❌ 미완료

---

## 데이터 검증 체크리스트

각 운동의 데이터를 추가한 후 확인:

- [ ] exercises 테이블에 운동이 추가되었는가?
- [ ] strength_standards에 다음이 모두 포함되었는가?
  - [ ] 모든 체중 범위 (보통 10-15개)
  - [ ] 남성 (MALE) 데이터
  - [ ] 여성 (FEMALE) 데이터
  - [ ] 5개 레벨 모두 (BEGINNER, NOVICE, INTERMEDIATE, ADVANCED, ELITE)
- [ ] 무게 값이 kg 단위인가? (lb가 아닌지 확인)
- [ ] 체중 범위가 정확한가? (예: 60-70kg → bodyweight_min=60.0, bodyweight_max=70.0)
- [ ] SQL 문법 오류가 없는가?

---

## 빠른 참조: SQL 문법

### 운동 추가
```sql
INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '한글명', '영문명', 'UPPER'|'LOWER'|'FULL_BODY', '부위', 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;
```

### 기준 데이터 추가
```sql
INSERT INTO strength_standards (id, exercise_id, bodyweight_min, bodyweight_max, gender, level, weight_kg, created_at, updated_at)
SELECT gen_random_uuid(), e.id, 최소체중, 최대체중, 'MALE'|'FEMALE', 'BEGINNER'|'NOVICE'|'INTERMEDIATE'|'ADVANCED'|'ELITE', 기준무게, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM exercises e WHERE e.name = '한글명'
ON CONFLICT DO NOTHING;
```

### 값 예시
- **카테고리**: `UPPER`, `LOWER`, `FULL_BODY`
- **성별**: `MALE`, `FEMALE`
- **레벨**: `BEGINNER`, `NOVICE`, `INTERMEDIATE`, `ADVANCED`, `ELITE`
- **부위**: `가슴`, `등`, `어깨`, `팔`, `하체`
- **단위**: `kg` (고정)
