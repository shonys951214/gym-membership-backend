# 프론트엔드 유연성 평가 등록 오류 수정

## 문제
프론트엔드에서 유연성 평가를 등록할 때 `assessmentType: "FLEXIBILITY"`로 보내고 있으나, 백엔드의 `AssessmentType` enum은 `INITIAL`과 `PERIODIC`만 허용합니다.

## 오류 메시지
```
유연성 평가 등록에 실패했습니다: 올바른 평가 타입이 아닙니다.
```

## 원인
**파일**: `front/Gym-admin/app/dashboard/members/new/page.tsx` (142번째 줄)

**현재 코드**:
```typescript
const flexibilityAssessmentData: CreateAssessmentRequest = {
  assessmentType: "FLEXIBILITY", // ❌ 잘못된 값
  assessedAt: initialAssessment.assessedAt,
  bodyWeight: initialAssessment.bodyWeight,
  condition: ...,
  trainerComment: initialAssessment.trainerComment,
  items: flexibilityItems,
};
```

## 수정 방법

### 수정 1: assessmentType을 INITIAL로 변경

**파일**: `front/Gym-admin/app/dashboard/members/new/page.tsx` (142번째 줄)

**수정 후**:
```typescript
const flexibilityAssessmentData: CreateAssessmentRequest = {
  assessmentType: "INITIAL", // ✅ INITIAL 또는 PERIODIC 사용
  assessedAt: initialAssessment.assessedAt,
  bodyWeight: initialAssessment.bodyWeight,
  condition: ...,
  trainerComment: initialAssessment.trainerComment,
  items: flexibilityItems, // items 배열에 category: "FLEXIBILITY"가 포함됨
};
```

## 설명

1. **AssessmentType**: 평가의 종류를 나타냄
   - `INITIAL`: 초기 평가
   - `PERIODIC`: 정기 평가

2. **Category**: 평가 항목의 카테고리를 나타냄
   - `STRENGTH`: 근력
   - `CARDIO`: 심폐
   - `ENDURANCE`: 지구력
   - `FLEXIBILITY`: 유연성 ✅
   - `BODY`: 체성분
   - `STABILITY`: 안정성

3. **올바른 사용법**:
   - `assessmentType`: `"INITIAL"` 또는 `"PERIODIC"` 사용
   - `items[].category`: `"FLEXIBILITY"` 사용 (이미 올바르게 사용 중)

## 참고

- 유연성 평가 항목은 `items` 배열의 각 항목에 `category: "FLEXIBILITY"`로 설정되어 있습니다.
- `assessmentType`은 평가 자체의 타입이므로, 초기 평가라면 `"INITIAL"`을 사용해야 합니다.
- 백엔드에서는 `items` 배열의 `category` 필드를 통해 유연성 평가 항목을 구분합니다.

