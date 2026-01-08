# 프론트엔드 수정 요청 사항

## ✅ 이미 수정 완료된 항목
- `workoutType`: "PT" | "PERSONAL" 사용 (이전 `sessionType` 제거됨)

---

## 🔧 수정 필요 사항

### 1. PT 세션 생성 시 `mainContent` 필드 필수 처리

**현재 상태:**
- 프론트엔드: `mainContent`를 optional로 처리
- 백엔드: `mainContent`를 **필수 필드**로 요구

**수정 방법:**
```typescript
// front/Gym-admin/types/api/requests.ts
export interface CreatePTSessionRequest {
  sessionDate: string;
  mainContent: string; // ⚠️ optional(?) 제거 - 필수로 변경
  trainerComment?: string;
}
```

**이유:** 백엔드 DTO에서 `mainContent`가 필수 필드이므로, 프론트엔드에서도 필수로 처리해야 합니다.

**추가 수정 (응답 타입):**
```typescript
// front/Gym-admin/types/api/responses.ts
export interface PTSession {
  id: string;
  memberId: string;
  sessionDate: string;
  sessionNumber: number;
  mainContent: string; // ⚠️ optional(?) 제거 - 필수로 변경
  trainerComment?: string;
  createdAt: string;
  updatedAt: string;
}
```

---

### 2. 유연성 평가 등록 시 `assessmentType` 수정

**문제:**
프론트엔드에서 유연성 평가를 등록할 때 `assessmentType: "FLEXIBILITY"`로 보내고 있으나, 백엔드의 `AssessmentType` enum은 `INITIAL`과 `PERIODIC`만 허용합니다.

**오류 메시지:**
```
유연성 평가 등록에 실패했습니다: 올바른 평가 타입이 아닙니다.
```

**수정 방법:**
**파일**: `front/Gym-admin/app/dashboard/members/new/page.tsx` (142번째 줄)

**수정 전**:
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

**설명:**
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

---

### 3. 초기 평가 중복 생성 방지

**문제:**
회원 등록 시 초기 평가를 여러 번 생성하려고 시도할 수 있습니다.

**수정 방법:**
자세한 내용은 [INITIAL_ASSESSMENT_DUPLICATE_FIX.md](INITIAL_ASSESSMENT_DUPLICATE_FIX.md) 참고

**요약:**
1. 초기 평가 중복 에러를 가장 먼저 체크
2. 재시도 전에 기존 평가 존재 여부 확인
3. 중복 에러 발생 시 재시도하지 않도록 처리

---

### 4. 운동 기록 생성 시 선택적 필드 처리

**현재 상태:**
- 프론트엔드: `weight`, `reps`, `sets`를 optional로 처리 ✅ (올바름)
- 백엔드: `weight`, `reps`, `sets`를 optional로 처리하되, 값이 없으면 자동으로 기본값 설정
  - `weight`: 기본값 0
  - `reps`: 기본값 1
  - `sets`: 기본값 1

**확인 사항:**
- 프론트엔드에서 이 필드들을 보내지 않아도 백엔드가 자동으로 처리하므로 **수정 불필요**
- 단, 프론트엔드에서 명시적으로 `0` 또는 `1`을 보내는 것이 더 명확할 수 있음

---

## ✅ 확인 완료 - 수정 불필요

### 1. 운동 루틴 `routineDate` 필드
- 백엔드: optional 필드로 존재
- 프론트엔드: 없어도 문제 없음 (회원별 루틴 생성 시에만 사용)

### 2. 모든 enum 값 일치
- `workoutType`: "PT" | "PERSONAL" ✅
- `difficulty`: "EASY" | "MEDIUM" | "HARD" ✅
- `status`: "ACTIVE" | "INACTIVE" | "SUSPENDED" ✅
- `severity`: "MILD" | "MODERATE" | "SEVERE" ✅
- `recoveryStatus`: "RECOVERED" | "RECOVERING" | "CHRONIC" ✅

### 3. 필드명 일치
- 모든 요청/응답 필드명이 백엔드와 일치 ✅

---

## 📋 요약

**수정 필요: 3건**
1. PT 세션 생성 시 `mainContent` 필드를 필수로 변경 (요청 및 응답 타입)
2. 유연성 평가 등록 시 `assessmentType`을 `"INITIAL"` 또는 `"PERIODIC"`로 변경
3. 초기 평가 중복 생성 방지 로직 추가

**수정 불필요: 나머지 모두 정상**
