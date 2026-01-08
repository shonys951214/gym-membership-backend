# 플랜과 프로젝트 구조 정렬 가이드

## 현재 프로젝트 구조 확인 결과

### ✅ 일치하는 부분

1. **DB 구조**
   - `Assessment` 엔티티: `staticEvaluation`, `dynamicEvaluation` 필드 존재 (JSONB)
   - `AbilitySnapshot` 엔티티: 6개 점수 필드 모두 존재 (strength, cardio, endurance, flexibility, body, stability)
   - `InjuryHistory` + `InjuryRestriction` 엔티티: 부상 제한 기능 구현됨
   - `Member` 엔티티: height, weight, gender 필드 추가됨

2. **평가 구조**
   - 정적/동적 평가 구분: `EvaluationType` enum 존재
   - 부상 제한 로직: `ScoreCalculator`에서 `excludeRestrictedCategories` 메서드 구현됨

### ⚠️ 수정이 필요한 부분

#### 1. 가중치 불일치 (중요)

**현재 코드** (`src/common/utils/score-calculator.ts`):
```typescript
const weights = {
  strength: 0.25,      // 25%
  cardio: 0.2,         // 20%
  endurance: 0.2,     // 20%
  flexibility: 0.15,   // 15%
  body: 0.1,          // 10%
  stability: 0.1,     // 10%
};
```

**플랜 제안 가중치**:
```typescript
const weights = {
  stability: 0.2,     // 20% ⬆️ (10% → 20%)
  cardio: 0.2,        // 20% (동일)
  endurance: 0.2,     // 20% (동일)
  strength: 0.15,     // 15% ⬇️ (25% → 15%)
  body: 0.15,         // 15% ⬆️ (10% → 15%)
  flexibility: 0.1,   // 10% ⬇️ (15% → 10%)
};
```

**수정 필요 파일**: `src/common/utils/score-calculator.ts` (126-136줄)

#### 2. 부상 안정성 평가 등급 체계

**플랜 제안**: O/△/X 개념 (정상/주의/제한)

**현재 상태**: 
- `InjuryRestriction`은 있지만, 부상 안정성 평가 자체의 등급 체계는 없음
- `AbilitySnapshot.stabilityScore`는 숫자 점수만 저장

**제안**:
- `Assessment` 엔티티에 `stabilityGrade` 필드 추가 (enum: 'O' | '△' | 'X')
- 또는 `staticEvaluation` JSONB 내에 `stabilityGrade` 포함

#### 3. 정적 평가 → 동적 평가 점수 제한 로직

**플랜 제안**: 
- 골반 틀어짐 → 스쿼트 점수 상한 제한 (예: 최대 80점)
- 어깨 말림 → 벤치프레스 가중치 ↓

**현재 상태**:
- `ScoreCalculator.excludeRestrictedCategories`: 부상으로 인한 카테고리 전체 제외만 처리
- 정적 평가 결과(체형 불균형)에 따른 점수 상한 제한 로직은 없음

**결정**: 상한 제한 로직은 구현하지 않음 (현재 구조로 충분)

#### 4. 평가 종목 선정 기준

**플랜 제안**: 
- 부상 안정성: 설문, 정적 자세 관찰, 기본 동작 관찰 (O/△/X)
- 유연성: 좌전굴, 어깨 가동, 고관절 가동
- 근지구력: 푸쉬업, 플랭크, 반복 가능한 머신 동작
- 심폐 지구력: 스텝 테스트 (최대 테스트 ❌, 회복 능력 위주)
- 하체 근력: 스쿼트 패턴, 체어 스탠드 (1RM 직접 측정 ❌)
- 체성분 밸런스: 인바디, 좌우 밸런스

**현재 상태**:
- `AssessmentItem`은 범용 구조 (category, name, value, unit, score)
- 특정 종목에 대한 제약이나 가이드라인 없음

**제안**:
- 평가 종목 가이드라인을 문서화 (코드 수정 불필요)
- 또는 `AssessmentItem`에 `testType` 필드 추가하여 종목 타입 명시

#### 5. 가중치 조정 기능

**플랜 제안**: 목표별 가중치 조정 (체중 감량, 근력 향상, 부상 회복)

**현재 상태**:
- 가중치가 하드코딩되어 있음
- 목표별 가중치 조정 기능 없음

**제안**:
- `Member` 엔티티에 `goalType` 필드 추가 (enum: 'WEIGHT_LOSS' | 'STRENGTH' | 'RECOVERY' | 'GENERAL')
- `ScoreCalculator`에서 목표별 가중치 테이블 관리
- 또는 `Assessment` 엔티티에 `customWeights` JSONB 필드 추가

## 수정 우선순위

### 높음 (플랜 구현에 필수)

1. **가중치 수정** (`score-calculator.ts`)
   - 안정성 20%, 근력 15%, 체성분 15%, 유연성 10%로 변경

### 중간 (플랜 완성도를 위해 권장)

3. **부상 안정성 등급 체계**
   - O/△/X 등급 저장 및 표시

4. **목표별 가중치 조정 기능**
   - 회원 목표에 따른 가중치 동적 조정

### 낮음 (문서화로 대체 가능)

5. **평가 종목 가이드라인**
   - 코드 수정 없이 문서화로 충분

## 수정 예시 코드

### 1. 가중치 수정

```typescript
// src/common/utils/score-calculator.ts
private calculateTotalScore(
  categoryScores: CategoryScores,
): number {
  const weights = {
    stability: 0.2,     // 20% (최우선)
    cardio: 0.2,       // 20%
    endurance: 0.2,    // 20%
    strength: 0.15,    // 15%
    body: 0.15,        // 15%
    flexibility: 0.1,  // 10%
  };
  // ... 나머지 로직 동일
}
```

### 2. 부상 안정성 등급 추가

```typescript
// src/entities/assessment.entity.ts
@Column({
  type: 'enum',
  enum: ['O', '△', 'X'],
  name: 'stability_grade',
  nullable: true,
})
stabilityGrade?: 'O' | '△' | 'X';
```

또는 `staticEvaluation` JSONB 내에 포함:

```typescript
// Assessment.staticEvaluation 구조 확장
staticEvaluation?: {
  // ... 기존 필드
  stabilityAssessment?: {
    grade: 'O' | '△' | 'X';
    notes?: string;
  };
};
```

## 요약

**즉시 수정 필요**:
1. 가중치 변경 (안정성 20%, 근력 15%, 체성분 15%, 유연성 10%)

**선택적 개선**:
2. 부상 안정성 등급 체계 (O/△/X)
3. 목표별 가중치 조정 기능

**문서화로 충분**:
4. 평가 종목 가이드라인

**제외 결정**:
- 정적 평가 → 동적 평가 점수 상한 제한 로직 (현재 구조로 충분)

