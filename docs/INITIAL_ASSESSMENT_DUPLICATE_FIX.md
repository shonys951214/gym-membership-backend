# 초기 평가 중복 생성 오류 수정

## 문제 상황

회원 등록 시 초기 평가를 생성할 때 "초기 평가는 이미 존재합니다" 오류가 발생했습니다.

## 원인 분석

### 백엔드 문제 ✅ (수정 완료)
1. **Soft Delete 미고려**: 초기 평가 중복 체크 시 `deletedAt`이 null인 평가만 확인해야 하는데, soft delete된 평가도 포함되어 조회되었을 수 있습니다.
2. **중복 체크 로직**: `isInitial: true`만으로 조회하면 soft delete된 평가도 포함될 수 있습니다.

### 프론트엔드 문제
1. **중복 요청**: 회원 등록 시 초기 평가를 여러 번 생성하려고 시도할 수 있습니다.
2. **에러 처리**: 이전 요청이 실패했지만 재시도 시 이미 생성된 평가가 있을 수 있습니다.

## 해결 방법

### 백엔드 수정 완료 ✅

**파일**: `src/modules/assessments/assessments.service.ts`

**수정 내용**:
- `IsNull()` import 추가
- 초기 평가 중복 체크 시 `deletedAt: IsNull()` 조건 추가하여 soft delete된 평가는 제외

**수정 전**:
```typescript
const existingInitial = await this.assessmentRepository.findOne({
  where: { memberId, isInitial: true },
});
```

**수정 후**:
```typescript
const existingInitial = await this.assessmentRepository.findOne({
  where: { 
    memberId, 
    isInitial: true,
    deletedAt: IsNull(), // soft delete된 평가는 제외
  },
});
```

### 프론트엔드 수정 필요

**파일**: `front/Gym-admin/app/dashboard/members/new/page.tsx`

#### 문제 시나리오

1. **첫 번째 요청** (139줄):
   ```typescript
   await assessmentApi.createAssessment(memberId, assessmentData);
   // assessmentType: "INITIAL", 모든 항목 포함
   ```

2. **에러 발생 시 재시도** (181줄):
   ```typescript
   await assessmentApi.createAssessment(memberId, assessmentDataWithoutFlexibility);
   // assessmentType: "INITIAL", 유연성 제외
   ```

#### 문제점

1. **동일한 memberId로 두 번 INITIAL 평가 생성 시도**
   - 첫 번째 요청이 성공했지만 네트워크 오류/타임아웃으로 에러로 인식
   - 재시도 시 이미 초기 평가가 존재하여 "초기 평가는 이미 존재합니다" 오류 발생

2. **에러 처리 로직의 한계**
   - FLEXIBILITY enum 에러만 체크하고 재시도
   - 네트워크 오류, 타임아웃 등 다른 에러로 인한 중복 요청 가능성 미고려

3. **재시도 전 검증 없음**
   - 재시도 전에 기존 초기 평가 존재 여부를 확인하지 않음
   - 무조건 재시도하여 중복 생성 시도

## 프론트엔드 수정 방안

### 방안 1: 재시도 전 기존 평가 확인 (권장)

```typescript
// 재시도 전에 기존 초기 평가 확인
const existingAssessments = await assessmentApi.getAssessments(memberId);
const hasInitialAssessment = existingAssessments.some((assessment) => assessment.assessmentType === "INITIAL");

if (hasInitialAssessment) {
  // 이미 초기 평가가 있으면 재시도하지 않고 업데이트 또는 스킵
  console.warn("초기 평가가 이미 존재합니다. 재시도를 건너뜁니다.");
  // 또는 기존 평가를 업데이트
  // await assessmentApi.updateAssessment(memberId, existingAssessment.id, ...);
  return;
}
```

### 방안 2: 에러 메시지 기반 처리

```typescript
catch (error: any) {
  const errorMessage = error?.message || "";

  // 초기 평가 중복 에러인 경우 재시도하지 않음
  if (
    errorMessage.includes("초기 평가는 이미 존재합니다") ||
    errorMessage.includes("초기 평가가 이미 존재합니다") ||
    errorMessage.includes("INITIAL_ASSESSMENT_ALREADY_EXISTS")
  ) {
    console.warn("초기 평가가 이미 존재합니다. 재시도를 건너뜁니다.");
    // 성공으로 처리하거나 사용자에게 알림
    return;
  }

  // FLEXIBILITY enum 에러인 경우에만 재시도
  // ...
}
```

### 방안 3: 재시도 로직 개선 (가장 안전)

```typescript
try {
  await assessmentApi.createAssessment(memberId, assessmentData);
  // 성공
} catch (error: any) {
  const errorMessage = error?.message || "";

  // 초기 평가 중복 에러 체크 (가장 먼저)
  if (
    errorMessage.includes("초기 평가는 이미 존재합니다") ||
    errorMessage.includes("INITIAL_ASSESSMENT_ALREADY_EXISTS")
  ) {
    console.warn("초기 평가가 이미 존재합니다.");
    // 성공으로 처리 (이미 생성되었으므로)
    setSubmitProgress("평가 항목 등록 완료");
    return; // 재시도하지 않음
  }

  // FLEXIBILITY enum 에러인 경우에만 재시도
  const isFlexibilityEnumError = /* ... */;

  if (isFlexibilityEnumError) {
    // 재시도 전에 기존 평가 확인
    try {
      const existingAssessments = await assessmentApi.getAssessments(memberId);
      const hasInitialAssessment = existingAssessments.some(
        (assessment) => assessment.assessmentType === "INITIAL"
      );

      if (hasInitialAssessment) {
        console.warn("초기 평가가 이미 존재합니다. 재시도를 건너뜁니다.");
        return; // 재시도하지 않음
      }
    } catch (checkError) {
      console.error("기존 평가 확인 실패:", checkError);
      // 확인 실패해도 재시도는 진행 (기존 평가가 없을 수도 있음)
    }

    // 재시도 로직
    // ...
  }
}
```

## 권장 수정 사항

### 1. 에러 처리 순서 변경

초기 평가 중복 에러를 가장 먼저 체크하여 재시도를 방지:

```typescript
catch (error: any) {
  const errorMessage = error?.message || "";

  // 1. 초기 평가 중복 에러 체크 (최우선)
  if (
    errorMessage.includes("초기 평가는 이미 존재합니다") ||
    errorMessage.includes("초기 평가가 이미 존재합니다") ||
    errorMessage.includes("INITIAL_ASSESSMENT_ALREADY_EXISTS")
  ) {
    console.warn("초기 평가가 이미 존재합니다. 재시도를 건너뜁니다.");
    // 성공으로 처리하거나 사용자에게 알림
    setSubmitProgress("평가 항목 등록 완료 (이미 존재)");
    return;
  }

  // 2. FLEXIBILITY enum 에러 체크
  const isFlexibilityEnumError = /* ... */;

  // 3. 재시도 로직
}
```

### 2. 재시도 전 검증 추가

재시도 전에 기존 초기 평가 존재 여부를 확인:

```typescript
if (isFlexibilityEnumError) {
  // 재시도 전 검증
  const existingAssessments = await assessmentApi.getAssessments(memberId);
  const hasInitialAssessment = existingAssessments.some((assessment) => assessment.assessmentType === "INITIAL");

  if (hasInitialAssessment) {
    console.warn("초기 평가가 이미 존재합니다. 재시도를 건너뜁니다.");
    return;
  }

  // 재시도 진행
}
```

### 3. 중복 요청 방지

`isSubmitting` 상태를 활용하여 중복 요청 방지 (이미 구현되어 있음).

## 테스트 방법

1. 회원 등록 시 초기 평가가 정상적으로 생성되는지 확인
2. 동일한 회원에 대해 초기 평가를 다시 생성하려고 시도 시 적절한 에러 메시지가 표시되는지 확인
3. Soft delete된 초기 평가가 있는 경우, 새로운 초기 평가를 생성할 수 있는지 확인
4. 네트워크 오류 후 재시도 시 중복 생성되지 않는지 확인

## 결론

**백엔드 수정 완료 ✅**

**프론트엔드 수정 필요**:
1. ✅ 초기 평가 중복 에러를 가장 먼저 체크
2. ✅ 재시도 전에 기존 평가 존재 여부 확인
3. ✅ 중복 에러 발생 시 재시도하지 않도록 처리
