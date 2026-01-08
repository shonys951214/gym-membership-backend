# 초기 평가 vs 정기 평가 구조 제안

## 현재 상황 분석

### 이미지 분석 결과

**첫 번째 이미지 (대시보드)**:
- "측정1RM (SBD)" 섹션 존재
  - 스쿼트 80kg (표준)
  - 벤치프레스 50kg (표준이하)
  - 데드리프트 100kg (표준)
  - 총합 230kg △+52kg (개선 추이)

**두 번째 이미지 (Orientation 평가서)**:
- 유연성 테스트 (상체 흉추, 어깨, 하체 햄스트링, 고관절, 발목)
- 기초 근력 테스트 (코어 Plank, Push-Up, Pull-Up, 하체 Extension/Curl)
- OHSA (Overhead Squat Assessment) - 기능적 움직임 평가

### 플랜 핵심 원칙

1. **평가 종목은 '정확한 수치'보다 회원에게 운동을 시켜도 되는지를 판단하는 도구**
2. **안전 → 기능 → 체력 → 결과 순**
3. **초기 평가는 위험 필터링 중심**
4. **1RM 직접 측정은 위험** (일반인은 반복 수행 능력이 더 중요)

## 제안: 3단계 평가 구조

### ① 초기 평가 (Orientation) - 위험 필터링

**목적**: "이 사람을 움직여도 되는가?"

**평가 항목**:

#### 정적 평가
- 설문 (PAR-Q, 통증, 병력)
- 체성분 (인바디)
- 체형 정렬 (정면/측면/후면 사진)

#### 동적 평가 (기능 중심)
- **유연성**: 상체 흉추, 어깨, 햄스트링, 고관절, 발목
- **기초 근력**: 코어 Plank, Push-Up, Pull-Up, 하체 Extension/Curl
- **기능적 움직임**: OHSA (Overhead Squat Assessment)
- **심폐 지구력**: 스텝 테스트 (회복 능력 위주)
- **근지구력**: 플랭크, 푸쉬업 반복

**특징**:
- 1RM 측정 ❌ (위험)
- 안전한 반복 동작 위주
- 기능적 움직임 패턴 확인
- 부상 위험 요소 파악

**결과**:
- 레이더 차트 6개 축 점수 생성
- 운동 제한 플래그 설정
- 기본 운동 프로그램 설계

### ② 정기 평가 (3개월 후) - 변화 추적 + 근력 측정

**목적**: "어떻게 개선되었는가?" + "어느 정도 힘을 쓸 수 있나?"

**평가 항목**:

#### 초기 평가 항목 재평가
- 유연성 (변화 추이 확인)
- 근지구력 (변화 추이 확인)
- 심폐 지구력 (변화 추이 확인)
- 체성분 (변화 추이 확인)
- 안정성 (변화 추이 확인)

#### 추가: SBD 1RM 측정 (안전한 경우만)
- **스쿼트 1RM** (또는 5RM 추정)
- **벤치프레스 1RM** (또는 5RM 추정)
- **데드리프트 1RM** (또는 5RM 추정)

**조건**:
- 초기 평가에서 안정성 O/△ 확인
- 유연성 정상 범위 이상
- 기본 동작 패턴 정상
- 3개월 이상 운동 경험

**결과**:
- 레이더 차트 비교 (초기 vs 현재)
- SBD 1RM 기록 및 추이
- 개선된 프로그램 설계

### ③ 정기 평가 (6개월 후) - 종합 평가

**목적**: "장기적 변화는?"

**평가 항목**:
- 초기 평가 항목 전체 재평가
- SBD 1RM 재측정
- 추가: 기능적 움직임 재평가 (OHSA 등)

## 구분 방식 옵션

### 옵션 1: 평가 타입별 항목 구분 (추천)

**초기 평가 (INITIAL)**:
- 정적 평가 필수
- 기본 동적 평가 (유연성, 근지구력, 심폐, 안정성)
- SBD 1RM ❌

**정기 평가 (PERIODIC)**:
- 정적 평가 선택적 (변화 큰 경우만)
- 기본 동적 평가 재평가
- SBD 1RM 추가 ✅ (조건부)

**구현 방법**:
- `Assessment.assessmentType`으로 구분
- `AssessmentItem.category`에 "SBD_SQUAT", "SBD_BENCH", "SBD_DEADLIFT" 추가
- 또는 `AssessmentItem.name`으로 구분 ("스쿼트 1RM", "벤치프레스 1RM" 등)

### 옵션 2: 평가 항목 플래그 방식

**모든 평가 항목에 플래그 추가**:
- `isInitialOnly`: 초기 평가에만 사용
- `isPeriodicOnly`: 정기 평가에만 사용
- `isBoth`: 둘 다 사용

**구현 방법**:
- `AssessmentItem`에 `testType` 필드 추가
- 또는 `AssessmentItem.details` JSONB에 포함

### 옵션 3: 평가 템플릿 방식

**평가 템플릿 정의**:
- `initial_assessment_template`: 초기 평가 항목 목록
- `periodic_assessment_template`: 정기 평가 항목 목록

**구현 방법**:
- 별도 테이블 `AssessmentTemplate` 생성
- 또는 설정 파일/상수로 관리

## 추천 방안: 옵션 1 (평가 타입별 구분)

### 이유

1. **현장 친화적**: 초기 평가는 위험 필터링, 정기 평가는 변화 추적 + 근력 측정
2. **구현 단순**: 기존 구조 유지, `AssessmentItem.name`으로 구분
3. **확장 용이**: 나중에 다른 항목 추가 가능

### 구현 예시

```typescript
// 초기 평가 항목
const initialAssessmentItems = [
  { category: 'FLEXIBILITY', name: '좌전굴', ... },
  { category: 'FLEXIBILITY', name: '어깨 가동', ... },
  { category: 'ENDURANCE', name: '플랭크', ... },
  { category: 'ENDURANCE', name: '푸쉬업', ... },
  { category: 'CARDIO', name: '스텝 테스트', ... },
  { category: 'STABILITY', name: 'OHSA', ... },
];

// 정기 평가 항목 (초기 항목 + SBD)
const periodicAssessmentItems = [
  ...initialAssessmentItems, // 초기 항목 재평가
  { category: 'STRENGTH', name: '스쿼트 1RM', ... },
  { category: 'STRENGTH', name: '벤치프레스 1RM', ... },
  { category: 'STRENGTH', name: '데드리프트 1RM', ... },
];
```

### SBD 측정 조건

```typescript
// 정기 평가 생성 시 SBD 측정 가능 여부 확인
async canMeasureSBD(memberId: string): Promise<boolean> {
  const latestSnapshot = await this.getLatestSnapshot(memberId);
  
  // 조건 1: 초기 평가 완료
  const initialAssessment = await this.findInitialAssessment(memberId);
  if (!initialAssessment) return false;
  
  // 조건 2: 안정성 점수 70점 이상
  if (latestSnapshot.stabilityScore < 70) return false;
  
  // 조건 3: 유연성 점수 60점 이상
  if (latestSnapshot.flexibilityScore < 60) return false;
  
  // 조건 4: 3개월 이상 경과
  const monthsSinceInitial = this.calculateMonths(initialAssessment.assessedAt, new Date());
  if (monthsSinceInitial < 3) return false;
  
  return true;
}
```

## 플랜에 반영할 내용

### 1. 초기 평가 섹션

**평가 항목**:
- 정적 평가 (설문, 체성분, 체형 정렬)
- 유연성 (상체, 하체)
- 기초 근력 (코어, Push, Pull, 하체)
- 기능적 움직임 (OHSA)
- 심폐 지구력 (스텝 테스트)
- 근지구력 (플랭크, 푸쉬업)
- **SBD 1RM ❌** (위험하므로 제외)

### 2. 정기 평가 섹션

**평가 항목**:
- 초기 평가 항목 재평가 (변화 추이)
- **SBD 1RM 추가 ✅** (조건부)
  - 안정성 70점 이상
  - 유연성 60점 이상
  - 3개월 이상 경과
  - 초기 평가 완료

### 3. 평가 주기

- **초기 평가**: 신규 회원 등록 시 필수
- **정기 평가**: 3개월 후 (SBD 포함), 6개월 후 (종합 평가)

## 다음 단계

1. 플랜에 초기/정기 평가 구분 명시
2. SBD 측정 조건 정의
3. 가이드 문서에 반영

