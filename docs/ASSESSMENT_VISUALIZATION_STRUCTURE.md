# 평가 시각화 구조 설계

## 요구사항

1. **초기 평가**: 레이더 차트로 표시 (6개 축)
2. **정기 평가**: 
   - 초기 평가보다 더 자세한 항목들 (예: SBD 1RM 등)
   - 자세한 항목들은 그래프 차트로 관리
   - 초기 평가 항목 기반 레이더 차트도 계속 업데이트 (성장 추이)

## 제안 구조

### 1. 데이터 구조

#### 1.1 AbilitySnapshot (레이더 차트용)

**목적**: 초기 평가 항목 기준 6개 축 점수 저장

**구조**:
```typescript
interface AbilitySnapshot {
  id: string;
  assessmentId: string;
  memberId: string;
  assessedAt: Date;
  version: string;
  
  // 레이더 차트 6개 축 (초기 평가 항목 기준)
  strengthScore?: number;      // 하체 근력
  cardioScore?: number;         // 심폐 지구력
  enduranceScore?: number;      // 근지구력
  flexibilityScore?: number;    // 유연성
  bodyScore?: number;           // 체성분 밸런스
  stabilityScore?: number;      // 부상 안정성
  
  totalScore: number;           // 종합 점수
}
```

**특징**:
- 초기 평가와 정기 평가 모두에서 생성
- 항상 동일한 6개 축 기준으로 계산
- 레이더 차트 비교용 (초기 vs 현재)

#### 1.2 AssessmentItem (상세 항목 저장)

**목적**: 모든 평가 항목 상세 저장 (그래프 차트용)

**구조**:
```typescript
interface AssessmentItem {
  id: string;
  assessmentId: string;
  category: Category;          // STRENGTH, CARDIO, ENDURANCE, etc.
  name: string;                // "스쿼트 1RM", "플랭크", "좌전굴" 등
  value: number;               // 측정값
  unit: string;                // "kg", "초", "cm" 등
  score: number;               // 계산된 점수 (0-100)
  details?: {                  // 추가 정보
    isInitialOnly?: boolean;   // 초기 평가 전용 항목
    isPeriodicOnly?: boolean; // 정기 평가 전용 항목
    testType?: string;         // "1RM", "반복", "시간" 등
  };
}
```

**특징**:
- 초기 평가: 기본 항목들 저장
- 정기 평가: 기본 항목 + 상세 항목 (SBD 1RM 등) 저장
- 그래프 차트용 데이터 소스

### 2. 평가 흐름

#### 2.1 초기 평가

```
1. 정적 평가 입력
   └─ Assessment.staticEvaluation (JSONB)

2. 동적 평가 항목 입력
   └─ AssessmentItem 생성
      - 유연성: 좌전굴, 어깨 가동, 고관절 가동
      - 근지구력: 플랭크, 푸쉬업
      - 심폐: 스텝 테스트
      - 안정성: OHSA
      - 하체 근력: 스쿼트 패턴, 체어 스탠드
      - 체성분: 인바디

3. AbilitySnapshot 생성
   └─ 6개 축 점수 계산 (카테고리별 평균)
   └─ 레이더 차트 기준선 설정
```

#### 2.2 정기 평가

```
1. 초기 평가 항목 재평가
   └─ AssessmentItem 생성 (초기 평가와 동일한 name)
      - 유연성: 좌전굴, 어깨 가동, 고관절 가동
      - 근지구력: 플랭크, 푸쉬업
      - 심폐: 스텝 테스트
      - 안정성: OHSA
      - 하체 근력: 스쿼트 패턴, 체어 스탠드
      - 체성분: 인바디

2. 상세 항목 추가 평가 (조건부)
   └─ AssessmentItem 생성 (정기 평가 전용)
      - STRENGTH: "스쿼트 1RM", "벤치프레스 1RM", "데드리프트 1RM"
      - STRENGTH: "스쿼트 5RM", "벤치프레스 5RM" (1RM 대체)
      - 기타 상세 항목들

3. AbilitySnapshot 생성
   └─ 초기 평가 항목만으로 6개 축 점수 계산
   └─ 레이더 차트 업데이트 (초기 vs 현재 비교)
```

### 3. 점수 계산 로직

#### 3.1 레이더 차트 점수 계산 (AbilitySnapshot)

**원칙**: 초기 평가 항목만 사용

```typescript
// 초기 평가 항목 정의
const INITIAL_ASSESSMENT_ITEMS = {
  STRENGTH: ['스쿼트 패턴', '체어 스탠드'],
  CARDIO: ['스텝 테스트'],
  ENDURANCE: ['플랭크', '푸쉬업'],
  FLEXIBILITY: ['좌전굴', '어깨 가동', '고관절 가동'],
  BODY: ['인바디'],
  STABILITY: ['OHSA'],
};

// 점수 계산 시 초기 평가 항목만 필터링
private calculateCategoryScores(items: AssessmentItem[]): CategoryScores {
  // 초기 평가 항목만 필터링
  const initialItems = items.filter(item => 
    INITIAL_ASSESSMENT_ITEMS[item.category]?.includes(item.name)
  );
  
  // 카테고리별 평균 점수 계산
  // ... 기존 로직
}
```

#### 3.2 그래프 차트 데이터 (AssessmentItem)

**원칙**: 모든 항목 저장, name으로 구분

```typescript
// 그래프 차트용 데이터 조회
async getAssessmentHistory(memberId: string, itemName: string): Promise<AssessmentItem[]> {
  return this.assessmentItemRepository.find({
    where: { 
      assessment: { memberId },
      name: itemName 
    },
    relations: ['assessment'],
    order: { assessment: { assessedAt: 'ASC' } }
  });
}

// 예: "스쿼트 1RM" 그래프
const squat1RMHistory = await getAssessmentHistory(memberId, '스쿼트 1RM');
// → 시간별 추이 그래프 생성
```

### 4. 시각화 구조

#### 4.1 레이더 차트

**데이터 소스**: `AbilitySnapshot`

**표시 내용**:
- 초기 평가: 회색 선 (기준선)
- 현재 평가: 색상 선 (최신 AbilitySnapshot)
- 목표 점수: 점선 (선택적)

**6개 축**:
1. 하체 근력 (strengthScore)
2. 심폐 지구력 (cardioScore)
3. 근지구력 (enduranceScore)
4. 유연성 (flexibilityScore)
5. 체성분 밸런스 (bodyScore)
6. 부상 안정성 (stabilityScore)

**업데이트 시점**:
- 초기 평가 생성 시
- 정기 평가 생성 시 (초기 평가 항목 재평가 결과 반영)

#### 4.2 그래프 차트

**데이터 소스**: `AssessmentItem`

**표시 내용**:
- 시간별 추이 (X축: 날짜, Y축: 측정값 또는 점수)
- 여러 항목 비교 가능

**예시 그래프**:
- SBD 1RM 추이 (스쿼트, 벤치프레스, 데드리프트)
- 플랭크 시간 추이
- 좌전굴 거리 추이
- 인바디 체지방률 추이

**필터링**:
- 초기 평가 항목: 레이더 차트와 연동
- 정기 평가 전용 항목: 그래프 차트만 표시

### 5. API 구조

#### 5.1 레이더 차트 데이터

```typescript
GET /api/members/:memberId/abilities/radar

Response:
{
  initial: {
    strengthScore: 50,
    cardioScore: 45,
    enduranceScore: 55,
    flexibilityScore: 50,
    bodyScore: 40,
    stabilityScore: 60,
    totalScore: 50.5,
    assessedAt: "2024-01-01"
  },
  current: {
    strengthScore: 65,
    cardioScore: 60,
    enduranceScore: 70,
    flexibilityScore: 60,
    bodyScore: 55,
    stabilityScore: 75,
    totalScore: 66.25,
    assessedAt: "2024-04-01"
  }
}
```

#### 5.2 그래프 차트 데이터

```typescript
GET /api/members/:memberId/assessments/items/:itemName/history

Response:
{
  itemName: "스쿼트 1RM",
  unit: "kg",
  history: [
    { assessedAt: "2024-04-01", value: 80, score: 65 },
    { assessedAt: "2024-07-01", value: 100, score: 75 },
    { assessedAt: "2024-10-01", value: 120, score: 85 }
  ]
}
```

#### 5.3 대시보드 통합 데이터

```typescript
GET /api/members/:memberId/dashboard

Response:
{
  radarChart: {
    initial: { ... },
    current: { ... }
  },
  graphs: {
    sbd1RM: {
      squat: [...],
      bench: [...],
      deadlift: [...]
    },
    endurance: {
      plank: [...],
      pushup: [...]
    },
    // ... 기타 항목들
  },
  inbody: {
    current: { weight: 70, muscleMass: 33, bodyFat: 20 },
    history: [...]
  }
}
```

### 6. 구현 고려사항

#### 6.1 초기 평가 항목 정의

**방법 1: 상수로 정의** (추천)
```typescript
// src/common/constants/assessment-items.ts
export const INITIAL_ASSESSMENT_ITEM_NAMES = {
  STRENGTH: ['스쿼트 패턴', '체어 스탠드'],
  CARDIO: ['스텝 테스트'],
  ENDURANCE: ['플랭크', '푸쉬업'],
  FLEXIBILITY: ['좌전굴', '어깨 가동', '고관절 가동'],
  BODY: ['인바디'],
  STABILITY: ['OHSA'],
};
```

**방법 2: AssessmentItem에 플래그 추가**
```typescript
// AssessmentItem에 필드 추가
@Column({ name: 'is_initial_item', default: false })
isInitialItem: boolean;
```

#### 6.2 점수 계산 로직 수정

```typescript
// src/common/utils/score-calculator.ts
private calculateCategoryScores(
  items: AssessmentItem[],
  assessmentType: AssessmentType
): CategoryScores {
  // 초기 평가 항목만 필터링
  const itemsForRadar = assessmentType === AssessmentType.INITIAL
    ? items
    : items.filter(item => this.isInitialAssessmentItem(item.name));
  
  // 카테고리별 평균 점수 계산
  // ... 기존 로직
}

private isInitialAssessmentItem(itemName: string): boolean {
  return Object.values(INITIAL_ASSESSMENT_ITEM_NAMES)
    .flat()
    .includes(itemName);
}
```

#### 6.3 정기 평가 시 초기 항목 재평가

```typescript
// 정기 평가 생성 시
async createPeriodicAssessment(
  memberId: string,
  dto: CreateAssessmentDto
): Promise<Assessment> {
  // 1. 초기 평가 항목 재평가 (레이더 차트용)
  const initialItems = dto.items.filter(item => 
    this.isInitialAssessmentItem(item.name)
  );
  
  // 2. 상세 항목 추가 (그래프 차트용)
  const detailedItems = dto.items.filter(item => 
    !this.isInitialAssessmentItem(item.name)
  );
  
  // 3. AssessmentItem 모두 저장
  const allItems = [...initialItems, ...detailedItems];
  
  // 4. AbilitySnapshot 생성 (초기 항목만으로 계산)
  const categoryScores = this.calculateCategoryScores(
    initialItems,
    AssessmentType.PERIODIC
  );
  
  // ... 나머지 로직
}
```

### 7. 데이터베이스 구조

#### 7.1 기존 구조 유지

- `Assessment`: 평가 세션
- `AssessmentItem`: 모든 평가 항목 (초기 + 정기)
- `AbilitySnapshot`: 레이더 차트용 6개 축 점수

#### 7.2 추가 고려사항

**인덱스 추가**:
```sql
-- AssessmentItem.name으로 빠른 조회
CREATE INDEX idx_assessment_items_name ON assessment_items(name);

-- 그래프 차트용 조회 최적화
CREATE INDEX idx_assessment_items_member_name 
ON assessment_items(assessment_id) 
WHERE name IN ('스쿼트 1RM', '벤치프레스 1RM', '데드리프트 1RM');
```

### 8. 프론트엔드 구조

#### 8.1 레이더 차트 컴포넌트

```typescript
// RadarChart.tsx
interface RadarChartProps {
  initial: AbilitySnapshot;
  current: AbilitySnapshot;
}

// 초기 평가(회색) vs 현재 평가(색상) 비교
```

#### 8.2 그래프 차트 컴포넌트

```typescript
// AssessmentGraph.tsx
interface AssessmentGraphProps {
  itemName: string;
  history: AssessmentItem[];
}

// 시간별 추이 그래프
```

#### 8.3 대시보드 통합

```typescript
// MemberDashboard.tsx
- 레이더 차트 (상단)
- SBD 1RM 그래프 (중간)
- 기타 상세 항목 그래프 (하단)
```

## 요약

### 핵심 구조

1. **AbilitySnapshot**: 초기 평가 항목 기준 6개 축 점수 (레이더 차트용)
   - 초기 평가와 정기 평가 모두에서 생성
   - 항상 동일한 기준으로 계산

2. **AssessmentItem**: 모든 평가 항목 상세 저장 (그래프 차트용)
   - 초기 평가: 기본 항목
   - 정기 평가: 기본 항목 + 상세 항목 (SBD 1RM 등)

3. **점수 계산**: 정기 평가 시에도 초기 평가 항목만으로 AbilitySnapshot 계산

### 장점

- 레이더 차트: 초기 vs 현재 비교 가능 (일관된 기준)
- 그래프 차트: 상세 항목별 시간별 추이 확인 가능
- 확장성: 새로운 항목 추가 시 그래프 차트만 추가하면 됨
- 기존 구조 유지: 큰 변경 없이 구현 가능

