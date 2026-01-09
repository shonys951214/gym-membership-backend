# 프론트엔드 평가 생성 수정 사항

## 문제점

1. **유연성 항목이 전송되지 않음**: 프론트엔드에서 유연성 항목을 items 배열에 추가하지 않고, 필터링으로 제외하고 있었음
2. **체성분 항목 조건이 과도함**: `fatMass`를 필수로 요구하지만, 백엔드는 `muscleMass`와 `bodyFatPercentage`만 있으면 됨

## 수정 사항

### 1. 유연성 항목 추가 (262-282줄)

**현재 코드 (262줄)**:
```typescript
// 4. 유연성은 백엔드 enum 미지원으로 제외
```

**수정 후**:
```typescript
// 4. 유연성
const flexibilityItemsEntries = Object.entries(formData.flexibilityItems || {}).filter(
  ([_, value]) => value && (value === "A" || value === "B" || value === "C")
);

if (flexibilityItemsEntries.length > 0) {
  const flexibilityItemsObj: Record<string, string> = {};
  flexibilityItemsEntries.forEach(([key, value]) => {
    if (value) {
      flexibilityItemsObj[key] = value;
    }
  });
  
  items.push({
    category: "FLEXIBILITY",
    name: "유연성 평가",
    details: {
      flexibilityItems: flexibilityItemsObj,
    },
  });
}
```

### 2. 체성분 조건 수정 (264-281줄)

**현재 코드**:
```typescript
// 5. 체성분
if (
  formData.muscleMass &&
  formData.fatMass &&
  formData.bodyFatPercentage
) {
  items.push({
    category: "BODY",
    name: "인바디",
    value: formData.bodyWeightInput || formData.bodyWeight,
    unit: "kg",
    details: {
      muscleMass: formData.muscleMass,
      fatMass: formData.fatMass,
      bodyFatPercentage: formData.bodyFatPercentage,
    },
  });
}
```

**수정 후**:
```typescript
// 5. 체성분
// muscleMass와 bodyFatPercentage만 있으면 추가 (fatMass는 선택)
if (
  formData.muscleMass &&
  formData.bodyFatPercentage
) {
  items.push({
    category: "BODY",
    name: "인바디",
    value: formData.bodyWeightInput || formData.bodyWeight,
    unit: "kg",
    details: {
      muscleMass: formData.muscleMass,
      ...(formData.fatMass && { fatMass: formData.fatMass }), // fatMass는 선택 사항
      bodyFatPercentage: formData.bodyFatPercentage,
    },
  });
}
```

### 3. FLEXIBILITY 필터링 제거 (325-328줄)

**현재 코드**:
```typescript
// FLEXIBILITY 항목 제외 (백엔드 enum 미지원)
const itemsWithoutFlexibility = cleanedItems.filter(
  (item) => item.category !== "FLEXIBILITY"
);

// 요청 데이터 구성: undefined 값 제외
requestData = {
  assessmentType: "INITIAL",
  assessedAt: formData.assessedAt,
  ...(formData.bodyWeight !== undefined &&
    formData.bodyWeight !== null &&
    !isNaN(formData.bodyWeight) && { bodyWeight: formData.bodyWeight }),
  ...(formData.condition && { condition: formData.condition }),
  ...(formData.trainerComment?.trim() && {
    trainerComment: formData.trainerComment.trim(),
  }),
  items: itemsWithoutFlexibility, // FLEXIBILITY 제외된 항목들 (빈 배열도 허용)
};
```

**수정 후**:
```typescript
// 요청 데이터 구성: undefined 값 제외
requestData = {
  assessmentType: "INITIAL",
  assessedAt: formData.assessedAt,
  ...(formData.bodyWeight !== undefined &&
    formData.bodyWeight !== null &&
    !isNaN(formData.bodyWeight) && { bodyWeight: formData.bodyWeight }),
  ...(formData.condition && { condition: formData.condition }),
  ...(formData.trainerComment?.trim() && {
    trainerComment: formData.trainerComment.trim(),
  }),
  items: cleanedItems, // 모든 항목 포함 (유연성 포함)
};
```

## fatMass와 bodyFatPercentage 관계

### 백엔드 로직 분석 결과

**백엔드 체성분 점수 계산 (`src/common/utils/grade-score-converter.ts`)**:
- **필수 필드**: `bodyFatPercentage`, `muscleMass`, `age`, `gender`
- **선택 필드**: `fatMass`, `bodyWeight`
- **점수 계산**: `bodyFatPercentage`와 `muscleMassPercentage`만 사용
- **`fatMass`는 실제 계산에 사용되지 않음** (destructure만 하고 사용 안 함)

### 프론트엔드 자동 계산 로직 (130-149줄)

현재 프론트엔드에는 다음과 같은 자동 계산 로직이 있습니다:

```typescript
// 골격근량과 체지방량이 입력되면 체지방률 자동 계산
useEffect(() => {
  if (
    formData.bodyWeightInput !== undefined &&
    formData.bodyWeightInput !== null &&
    !isNaN(formData.bodyWeightInput) &&
    formData.bodyWeightInput > 0 &&
    formData.fatMass !== undefined &&
    formData.fatMass !== null &&
    !isNaN(formData.fatMass) &&
    formData.fatMass >= 0
  ) {
    const bodyFatPercentage =
      (formData.fatMass / formData.bodyWeightInput) * 100;
    setFormData((prev) => ({
      ...prev,
      bodyFatPercentage: parseFloat(bodyFatPercentage.toFixed(1)),
    }));
  }
}, [formData.bodyWeightInput, formData.fatMass]);
```

### 결론

1. **`fatMass`는 선택 사항**입니다.
   - 백엔드 점수 계산에 사용되지 않음
   - 프론트엔드에서 `bodyFatPercentage` 자동 계산에만 사용됨

2. **`bodyFatPercentage`는 필수**입니다.
   - 백엔드 점수 계산에 필수
   - 사용자가 직접 입력하거나, `fatMass`와 `bodyWeightInput`으로 자동 계산 가능

3. **권장 사항**:
   - 사용자가 `fatMass`를 입력하면 자동으로 `bodyFatPercentage` 계산 (현재 로직 유지)
   - 사용자가 직접 `bodyFatPercentage`를 입력할 수도 있어야 함
   - 최종적으로는 `muscleMass`와 `bodyFatPercentage`만 백엔드로 전송

## 수정 파일

- `front/Gym-admin/app/dashboard/members/[id]/assessment/new/page.tsx`
  - 262줄: 유연성 항목 추가 로직 추가
  - 264-281줄: 체성분 조건 수정 (fatMass 필수 제거)
  - 325-328줄: FLEXIBILITY 필터링 제거

## 테스트 확인 사항

1. 유연성 항목을 최소 1개 이상 선택했을 때 items 배열에 포함되는지
2. 체성분에서 `muscleMass`와 `bodyFatPercentage`만 입력해도 items 배열에 포함되는지
3. `fatMass` 없이도 체성분 항목이 전송되는지
4. DB의 `assessment_items` 테이블에서 `category = 'FLEXIBILITY'`와 `category = 'BODY'` 항목이 정상적으로 저장되는지
