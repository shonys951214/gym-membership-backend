# 초기 평가 중복 생성 오류 수정

## 문제 상황

회원 등록 시 초기 평가를 생성할 때 "초기 평가는 이미 존재합니다" 오류가 발생했습니다.

## 원인 분석

### 백엔드 문제
1. **Soft Delete 미고려**: 초기 평가 중복 체크 시 `deletedAt`이 null인 평가만 확인해야 하는데, soft delete된 평가도 포함되어 조회되었을 수 있습니다.
2. **중복 체크 로직**: `isInitial: true`만으로 조회하면 soft delete된 평가도 포함될 수 있습니다.

### 프론트엔드 문제 (예상)
1. **중복 요청**: 회원 등록 시 초기 평가를 여러 번 생성하려고 시도할 수 있습니다.
2. **에러 처리**: 이전 요청이 실패했지만 재시도 시 이미 생성된 평가가 있을 수 있습니다.

## 해결 방법

### 백엔드 수정 완료

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

## 프론트엔드 권장 사항

1. **중복 요청 방지**: 회원 등록 시 초기 평가 생성 요청을 한 번만 보내도록 처리
2. **에러 처리 개선**: 
   - 초기 평가 생성 실패 시, 기존 초기 평가가 있는지 확인
   - 기존 초기 평가가 있으면 업데이트하거나 사용자에게 알림
3. **재시도 로직**: 
   - 초기 평가 생성 실패 시, 기존 평가를 조회하여 사용
   - 또는 사용자에게 "초기 평가가 이미 존재합니다. 수정하시겠습니까?" 메시지 표시

## 테스트 방법

1. 회원 등록 시 초기 평가가 정상적으로 생성되는지 확인
2. 동일한 회원에 대해 초기 평가를 다시 생성하려고 시도 시 적절한 에러 메시지가 표시되는지 확인
3. Soft delete된 초기 평가가 있는 경우, 새로운 초기 평가를 생성할 수 있는지 확인

