# 프론트엔드 초기 평가 중복 생성 문제 분석 및 수정 방안

## 문제 발견

프론트엔드 코드에서 **명확한 중복 요청 문제**가 발견되었습니다.

## 문제 위치

**파일**: `front/Gym-admin/app/dashboard/members/new/page.tsx`

### 문제 시나리오

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

### 문제점

1. **동일한 memberId로 두 번 INITIAL 평가 생성 시도**
    - 첫 번째 요청이 성공했지만 네트워크 오류/타임아웃으로 에러로 인식
    - 재시도 시 이미 초기 평가가 존재하여 "초기 평가는 이미 존재합니다" 오류 발생

2. **에러 처리 로직의 한계**
    - FLEXIBILITY enum 에러만 체크하고 재시도
    - 네트워크 오류, 타임아웃 등 다른 에러로 인한 중복 요청 가능성 미고려

3. **재시도 전 검증 없음**
    - 재시도 전에 기존 초기 평가 존재 여부를 확인하지 않음
    - 무조건 재시도하여 중복 생성 시도

## 수정 방안

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

## 테스트 시나리오

1. **정상 케이스**: 초기 평가가 정상적으로 생성되는지 확인
2. **중복 요청 케이스**: 네트워크 오류 후 재시도 시 중복 생성되지 않는지 확인
3. **FLEXIBILITY 에러 케이스**: 유연성 항목 제외 후 재시도 시 중복 생성되지 않는지 확인

## 결론

**프론트엔드에서 명확한 중복 요청 문제가 있습니다.**

백엔드 수정만으로는 완전히 해결되지 않으며, 프론트엔드에서도 다음을 수정해야 합니다:

1. ✅ 초기 평가 중복 에러를 가장 먼저 체크
2. ✅ 재시도 전에 기존 평가 존재 여부 확인
3. ✅ 중복 에러 발생 시 재시도하지 않도록 처리
