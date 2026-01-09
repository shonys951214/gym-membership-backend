# 유연성 점수 레이더 차트 미표시 문제 분석

## 문제 현상

레이더 차트 생성 시 다른 항목은 정상적으로 표시되지만, **유연성 항목만 잘 안 들어가고 있음**

---

## 원인 분석

### 1. 점수 계산 로직 문제 (수정 완료)

**위치**: `src/common/utils/score-calculator.ts` (49-76줄)

**문제점**:
```typescript
// 기존 코드
const averageScore = categoryItems.reduce((sum, item) => sum + item.score, 0) / categoryItems.length;
```

- `item.score`가 `null`이거나 `undefined`일 때:
  - `null + 0 = 0` (하지만 타입 변환 문제 가능)
  - `undefined + 0 = NaN`
  - `NaN / length = NaN`
- 결과적으로 `flexibilityScore`가 `NaN`이 되어 레이더 차트에 표시되지 않음

**수정 내용**:
```typescript
// 수정 후 코드
const validItems = categoryItems.filter((item) => item.score !== null && item.score !== undefined);

if (validItems.length > 0) {
  const averageScore = validItems.reduce((sum, item) => sum + (item.score || 0), 0) / validItems.length;
  // ...
}
```

- null/undefined인 score를 제외하고 평균 계산
- 유효한 항목이 없으면 해당 카테고리는 null로 유지

---

### 2. 유연성 점수 계산 실패 가능성

**위치**: `src/common/utils/grade-score-converter.ts` (179-249줄)

**가능한 실패 원인**:

1. **`flexibilityItems` 누락**
   - 프론트엔드에서 `flexibilityItems`를 전송하지 않음
   - → `convertFlexibilityScore`에서 `null` 반환

2. **가중치 데이터 없음**
   - `flexibility_item_weights` 테이블에 데이터가 없음
   - → 점수 계산 실패, `null` 반환

3. **등급 판정 기준 없음**
   - `flexibility_grade_thresholds` 테이블에 데이터가 없음
   - → 점수 계산 실패, `null` 반환

4. **가중치 합 범위 매칭 실패**
   - 계산된 가중치 합이 등급 판정 기준 범위에 없음
   - → 점수 계산 실패, `null` 반환

**확인 방법**:
- 백엔드 로그에서 다음 메시지 확인:
  - `"유연성 점수 계산 실패: flexibilityItems가 없습니다."`
  - `"유연성 점수 계산 실패: 가중치 데이터가 없습니다."`
  - `"유연성 점수 계산 실패: 등급 판정 기준 데이터가 없습니다."`
  - `"유연성 점수 계산 실패: 가중치 합 ${weightSum}에 해당하는 등급 판정 기준을 찾을 수 없습니다."`

---

### 3. 프론트엔드 데이터 매핑 문제

**위치**: `front/Gym-admin/components/members/MemberAbilitiesTab.tsx` (110-112줄)

**현재 코드**:
```typescript
flexibility:
  hexagonData.indicators.find((i) => i.name === "유연성")?.score || 0,
```

**문제 가능성**:
- 백엔드에서 `{ name: "유연성", score: null }` 또는 `{ name: "유연성", score: 0 }`로 전달
- `find()`는 항목을 찾지만 `score`가 `null`이면 `|| 0`으로 처리됨
- 하지만 백엔드에서 이미 `?? 0`으로 처리하고 있어 문제 없어야 함

**백엔드 코드 확인**:
```typescript
// assessments.service.ts (487줄)
{ name: "유연성", score: snapshot.flexibilityScore ?? 0 }
```

→ 백엔드에서 이미 null을 0으로 처리하고 있음

---

## 해결 방법

### ✅ 1. 점수 계산 로직 수정 (완료)

**파일**: `src/common/utils/score-calculator.ts`

**수정 내용**:
- null/undefined인 score를 제외하고 평균 계산
- 유효한 항목이 없으면 해당 카테고리는 null로 유지

### ✅ 2. 로깅 추가 (완료)

**파일**: `src/modules/assessments/assessments.service.ts`

**수정 내용**:
- 유연성 점수 계산 실패 시 경고 로그 추가
- 디버깅을 위한 상세 정보 포함

### 3. DB 데이터 확인 (필요 시)

**확인 사항**:
1. `flexibility_item_weights` 테이블에 데이터가 있는지 확인
2. `flexibility_grade_thresholds` 테이블에 데이터가 있는지 확인
3. 유연성 평가 항목이 제대로 생성되었는지 확인

**SQL 쿼리**:
```sql
-- 가중치 데이터 확인
SELECT * FROM flexibility_item_weights WHERE is_active = true;

-- 등급 판정 기준 확인
SELECT * FROM flexibility_grade_thresholds WHERE is_active = true;

-- 최근 평가의 유연성 항목 확인
SELECT 
  ai.id,
  ai.category,
  ai.name,
  ai.score,
  ai.details
FROM assessment_items ai
WHERE ai.category = 'FLEXIBILITY'
ORDER BY ai.created_at DESC
LIMIT 10;
```

---

## 디버깅 체크리스트

### 백엔드 확인

- [ ] 유연성 평가 항목이 제대로 생성되는지 확인
  - `assessment_items` 테이블에서 `category = 'FLEXIBILITY'` 항목 확인
- [ ] 유연성 점수가 계산되는지 확인
  - `assessment_items.score`가 null이 아닌지 확인
- [ ] 스냅샷에 유연성 점수가 저장되는지 확인
  - `ability_snapshots.flexibility_score`가 null이 아닌지 확인
- [ ] 로그 확인
  - 유연성 점수 계산 실패 관련 경고 메시지 확인

### 프론트엔드 확인

- [ ] API 응답 확인
  - `/api/members/{memberId}/abilities/hexagon` 응답에서 `indicators` 배열 확인
  - `{ name: "유연성", score: ... }` 항목이 있는지 확인
- [ ] 데이터 매핑 확인
  - `MemberAbilitiesTab.tsx`에서 `hexagonData.indicators.find((i) => i.name === "유연성")` 결과 확인
- [ ] 콘솔 로그 확인
  - 개발 환경에서 디버깅 로그 확인

---

## 예상 시나리오

### 시나리오 1: 유연성 점수 계산 실패

**증상**: 
- `assessment_items.score`가 `null`
- `ability_snapshots.flexibility_score`가 `null`

**원인**:
- `flexibilityItems` 누락
- 가중치 데이터 없음
- 등급 판정 기준 없음

**해결**:
- DB 마이그레이션 확인
- 프론트엔드에서 `flexibilityItems` 전송 확인

### 시나리오 2: 평균 계산 시 NaN 발생

**증상**:
- `ability_snapshots.flexibility_score`가 `NaN`

**원인**:
- `calculateCategoryScores`에서 null인 score를 포함해서 평균 계산

**해결**:
- ✅ 이미 수정 완료 (null 체크 추가)

### 시나리오 3: 프론트엔드 매핑 문제

**증상**:
- API 응답에는 정상이지만 레이더 차트에 표시되지 않음

**원인**:
- `find()` 결과가 없거나 score가 0

**해결**:
- 프론트엔드 코드 확인 (현재는 정상으로 보임)

---

## 수정 완료 사항

1. ✅ `score-calculator.ts`: null 체크 추가
2. ✅ `assessments.service.ts`: 유연성 점수 계산 실패 시 로깅 추가

---

## 다음 단계

1. **백엔드 재배포 후 테스트**
2. **DB 데이터 확인** (가중치, 등급 판정 기준)
3. **로그 확인** (유연성 점수 계산 실패 메시지)
4. **프론트엔드 디버깅** (API 응답 확인)

---

## 참고

- 유연성 점수 계산 로직: `src/common/utils/grade-score-converter.ts` (179-249줄)
- 점수 평균 계산 로직: `src/common/utils/score-calculator.ts` (34-79줄)
- 헥사곤 데이터 생성: `src/modules/assessments/assessments.service.ts` (462-520줄)
