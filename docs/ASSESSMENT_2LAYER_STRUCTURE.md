# 2단계 평가 레이어 구조 설계

## 핵심 메시지

**초기 평가 레이더 차트는 '요약 지표'로 고정하고, 정기 평가의 상세 데이터들을 '초기 평가 항목으로 환산'해 누적 반영한다**

- 초기 평가 = 공통 언어 (6개 축 고정)
- 정기 평가 = 데이터 원천 (상세 지표 확장 가능)

## 구조 개요

### Layer 1: 상위 평가 축 (고정) - 레이더 차트용

**6대 영역 (절대 변경 불가)**:
1. 하체 근력 (STRENGTH)
2. 심폐 지구력 (CARDIO)
3. 근지구력 (ENDURANCE)
4. 유연성 (FLEXIBILITY)
5. 체성분 밸런스 (BODY)
6. 부상 안정성 (STABILITY)

**특징**:
- 레이더 차트 전용
- 서비스의 "공용 언어"
- 초기 평가에서 정의, 이후 변경 없음

### Layer 2: 하위 상세 지표 (가변) - 그래프 차트용

**정기 평가에서 늘어나는 항목들**:
- 하체 근력: 레그프레스 10RM, 스쿼트 5RM, 데드리프트 3RM, 점프 파워, 좌/우 밸런스
- 심폐 지구력: VO2max, 러닝머신 테스트, 자전거 테스트
- 근지구력: 플랭크 시간, 푸쉬업 횟수, 버피 테스트
- 유연성: 좌전굴, 어깨 가동, 고관절 가동
- 체성분: 인바디 세부 지표
- 안정성: OHSA, Y-Balance, 한 발 서기

**특징**:
- 그래프 차트용
- 비교 분석용
- AI 분석 재료
- 확장 가능

## 환산 메커니즘

### 환산 테이블 구조

정기 평가의 상세 지표를 초기 평가 축 점수로 환산하는 중간 레이어

#### 예시: 하체 근력 환산

```
① 정기 평가 실측 데이터
   - 스쿼트 5RM = 체중 × 1.2 → 75점
   - 레그프레스 10RM = 체중 × 2.0 → 65점

② 지표별 점수화 (0~100)
   - 스쿼트 5RM → 75점
   - 레그프레스 10RM → 65점

③ 가중 평균 → 상위 축 반영
   하체 근력 점수 = (스쿼트 × 0.6) + (레그프레스 × 0.4) = 71점
   
➡️ 이 점수가 레이더 차트에 반영
```

### 환산 규칙 정의

```typescript
// 환산 규칙 정의
interface ConversionRule {
  metricType: string;        // "스쿼트 5RM", "레그프레스 10RM" 등
  category: Category;        // STRENGTH, CARDIO, etc.
  weight: number;            // 가중치 (0~1)
  scoreFormula: (value: number, bodyWeight?: number) => number; // 점수 계산 공식
}

// 예시
const conversionRules: ConversionRule[] = [
  {
    metricType: "스쿼트 5RM",
    category: Category.STRENGTH,
    weight: 0.6,
    scoreFormula: (value, bodyWeight) => {
      const ratio = value / (bodyWeight || 70);
      // 체중 대비 비율로 점수 계산
      if (ratio >= 2.0) return 100;
      if (ratio >= 1.5) return 80;
      if (ratio >= 1.0) return 60;
      return 40;
    }
  },
  {
    metricType: "레그프레스 10RM",
    category: Category.STRENGTH,
    weight: 0.4,
    scoreFormula: (value, bodyWeight) => {
      // ... 계산 로직
    }
  }
];
```

## DB 구조 분석

### 현재 구조

#### 1. Assessment (평가 세션)
```typescript
- id
- memberId
- assessmentType (INITIAL | PERIODIC)
- isInitial
- assessedAt
- staticEvaluation (JSONB)
- dynamicEvaluation (JSONB)
```

#### 2. AssessmentItem (하위 상세 지표)
```typescript
- id
- assessmentId
- category (STRENGTH, CARDIO, etc.)
- name (예: "스쿼트 5RM", "플랭크")
- value (측정값)
- unit (단위)
- score (점수)
```

#### 3. AbilitySnapshot (상위 축 점수)
```typescript
- id
- assessmentId
- memberId
- assessedAt
- version
- strengthScore
- cardioScore
- enduranceScore
- flexibilityScore
- bodyScore
- stabilityScore
- totalScore
```

### 구조 안정성 평가

#### ✅ 장점

1. **확장성**: AssessmentItem의 `name` 필드로 무한 확장 가능
2. **유연성**: JSONB 필드로 추가 데이터 저장 가능
3. **일관성**: AbilitySnapshot으로 레이더 차트 일관성 유지
4. **이력 관리**: 모든 평가 항목이 AssessmentItem에 저장되어 이력 추적 가능

#### ⚠️ 개선 필요 사항

1. **환산 규칙 관리**
   - 현재: 하드코딩 또는 로직에 분산
   - 제안: 별도 테이블 또는 설정 파일로 관리

2. **초기 평가 항목 정의**
   - 현재: 코드에 하드코딩
   - 제안: 상수 파일 또는 DB 테이블로 관리

3. **가중치 관리**
   - 현재: ScoreCalculator에 하드코딩
   - 제안: 환산 규칙과 함께 관리

## 제안: DB 구조 개선

### 옵션 1: 현재 구조 유지 + 환산 규칙 테이블 추가 (추천)

**장점**: 기존 구조 유지, 최소 변경

```sql
-- 환산 규칙 테이블
CREATE TABLE assessment_conversion_rules (
  id UUID PRIMARY KEY,
  metric_name VARCHAR(255) NOT NULL,  -- "스쿼트 5RM", "플랭크" 등
  category VARCHAR(50) NOT NULL,      -- STRENGTH, CARDIO, etc.
  weight DECIMAL(3,2) NOT NULL,       -- 가중치 (0~1)
  score_formula JSONB,                 -- 점수 계산 공식
  is_initial_item BOOLEAN DEFAULT FALSE, -- 초기 평가 항목 여부
  created_at TIMESTAMP DEFAULT NOW()
);

-- 인덱스
CREATE INDEX idx_conversion_rules_metric ON assessment_conversion_rules(metric_name);
CREATE INDEX idx_conversion_rules_category ON assessment_conversion_rules(category);
```

**사용 방법**:
```typescript
// 정기 평가 시 환산 규칙 조회
const rules = await conversionRuleRepository.find({
  where: { category: Category.STRENGTH }
});

// AssessmentItem의 name으로 매칭하여 환산
const strengthScore = calculateCategoryScore(
  items.filter(item => item.category === Category.STRENGTH),
  rules
);
```

### 옵션 2: AssessmentItem에 메타데이터 추가

**장점**: 단일 테이블로 관리

```sql
-- AssessmentItem에 필드 추가
ALTER TABLE assessment_items ADD COLUMN IF NOT EXISTS 
  is_initial_item BOOLEAN DEFAULT FALSE;

ALTER TABLE assessment_items ADD COLUMN IF NOT EXISTS 
  conversion_weight DECIMAL(3,2);

ALTER TABLE assessment_items ADD COLUMN IF NOT EXISTS 
  metadata JSONB;
```

**사용 방법**:
```typescript
// AssessmentItem 생성 시 메타데이터 포함
const item = {
  name: "스쿼트 5RM",
  category: Category.STRENGTH,
  value: 120,
  unit: "kg",
  score: 75,
  isInitialItem: false,
  conversionWeight: 0.6,
  metadata: {
    testType: "5RM",
    bodyPart: "하체",
    formula: "ratio >= 2.0 ? 100 : ..."
  }
};
```

### 옵션 3: 별도 Metric 테이블 (복잡하지만 확장성 최고)

```sql
-- 평가 지표 정의 테이블
CREATE TABLE assessment_metrics (
  id UUID PRIMARY KEY,
  name VARCHAR(255) UNIQUE NOT NULL,
  category VARCHAR(50) NOT NULL,
  unit VARCHAR(50) NOT NULL,
  is_initial_item BOOLEAN DEFAULT FALSE,
  conversion_weight DECIMAL(3,2),
  score_formula JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 평가 항목과 지표 연결
ALTER TABLE assessment_items ADD COLUMN IF NOT EXISTS 
  metric_id UUID REFERENCES assessment_metrics(id);
```

## 추천 구조: 옵션 1 (환산 규칙 테이블)

### 이유

1. **기존 구조 유지**: Assessment, AssessmentItem, AbilitySnapshot 그대로 사용
2. **확장성**: 새로운 지표 추가 시 규칙만 추가
3. **유연성**: 환산 규칙 변경 시 DB만 수정
4. **명확성**: 환산 로직이 명시적으로 관리됨

### 구현 구조

```typescript
// 1. 환산 규칙 엔티티
@Entity('assessment_conversion_rules')
export class AssessmentConversionRule {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 255 })
  metricName: string;  // "스쿼트 5RM", "플랭크" 등

  @Column({ type: 'enum', enum: Category })
  category: Category;

  @Column({ type: 'decimal', precision: 3, scale: 2 })
  weight: number;  // 가중치 (0~1)

  @Column({ type: 'jsonb', nullable: true })
  scoreFormula?: {
    type: 'ratio' | 'absolute' | 'custom';
    formula: string;  // 점수 계산 공식
    thresholds?: { value: number; score: number }[];  // 기준값
  };

  @Column({ name: 'is_initial_item', default: false })
  isInitialItem: boolean;  // 초기 평가 항목 여부

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}

// 2. 점수 계산 로직 수정
class ScoreCalculator {
  async calculateCategoryScores(
    items: AssessmentItem[],
    assessmentType: AssessmentType
  ): Promise<CategoryScores> {
    // 환산 규칙 조회
    const rules = await this.conversionRuleRepository.find();
    
    // 초기 평가 항목 필터링
    const initialItems = assessmentType === AssessmentType.INITIAL
      ? items
      : items.filter(item => 
          rules.find(r => r.metricName === item.name && r.isInitialItem)
        );
    
    // 카테고리별 환산 점수 계산
    const categoryScores = this.convertToCategoryScores(initialItems, rules);
    
    return categoryScores;
  }

  private convertToCategoryScores(
    items: AssessmentItem[],
    rules: AssessmentConversionRule[]
  ): CategoryScores {
    const categoryScores: CategoryScores = {};

    // 카테고리별로 그룹화
    const itemsByCategory = items.reduce((acc, item) => {
      if (!acc[item.category]) {
        acc[item.category] = [];
      }
      acc[item.category].push(item);
      return acc;
    }, {} as Record<Category, AssessmentItem[]>);

    // 각 카테고리별 환산 점수 계산
    Object.keys(itemsByCategory).forEach((category) => {
      const categoryItems = itemsByCategory[category as Category];
      const categoryRules = rules.filter(r => r.category === category);

      // 가중 평균 계산
      let totalWeight = 0;
      let weightedSum = 0;

      categoryItems.forEach(item => {
        const rule = categoryRules.find(r => r.metricName === item.name);
        if (rule) {
          weightedSum += item.score * rule.weight;
          totalWeight += rule.weight;
        }
      });

      if (totalWeight > 0) {
        const averageScore = weightedSum / totalWeight;
        
        switch (category) {
          case Category.STRENGTH:
            categoryScores.strengthScore = averageScore;
            break;
          // ... 나머지 카테고리
        }
      }
    });

    return categoryScores;
  }
}
```

## 시각화 구조

### 레이더 차트

**데이터 소스**: `AbilitySnapshot`

**표시 방식**:
- 초기 평가: 회색 선 (기준선)
- 최근 평가: 색상 선 (최신 AbilitySnapshot)
- 모든 평가: 투명도로 히스토리 표시 (선택적)

**특징**:
- 항상 6축 고정
- 초기 vs 최근 비교
- 성장 추이 시각화

### 그래프 차트

**데이터 소스**: `AssessmentItem`

**표시 방식**:
- 시간별 추이 (X축: 날짜, Y축: 측정값 또는 점수)
- 여러 항목 비교 가능

**예시**:
- 스쿼트 5RM 추이
- 플랭크 시간 추이
- VO2max 추정치 추이

## 평가 흐름

### 초기 평가

```
1. 정적 평가 입력
   └─ Assessment.staticEvaluation

2. 동적 평가 항목 입력
   └─ AssessmentItem 생성 (초기 평가 항목)
      - isInitialItem: true

3. AbilitySnapshot 생성
   └─ 초기 평가 항목만으로 6개 축 점수 계산
   └─ 레이더 차트 기준선 설정
```

### 정기 평가

```
1. 초기 평가 항목 재평가
   └─ AssessmentItem 생성 (초기 평가 항목)
      - isInitialItem: true

2. 상세 항목 추가 평가
   └─ AssessmentItem 생성 (상세 항목)
      - isInitialItem: false
      - conversionWeight: 환산 규칙에서 조회

3. AbilitySnapshot 생성
   └─ 초기 평가 항목 + 상세 항목 환산
   └─ 환산 규칙 적용하여 6개 축 점수 계산
   └─ 레이더 차트 업데이트
```

## DB 구조 안정성 최종 평가

### ✅ 현재 구조로 충분한 부분

1. **Assessment**: 평가 세션 관리 - 충분
2. **AssessmentItem**: 상세 지표 저장 - 충분 (확장 가능)
3. **AbilitySnapshot**: 레이더 차트 점수 - 충분

### ⚠️ 추가 권장 사항

1. **환산 규칙 테이블 추가** (옵션 1)
   - 새로운 지표 추가 시 유연성 확보
   - 환산 로직 변경 시 DB만 수정

2. **초기 평가 항목 플래그**
   - `AssessmentItem`에 `isInitialItem` 필드 추가
   - 또는 환산 규칙 테이블에서 관리

3. **인덱스 최적화**
   ```sql
   -- 그래프 차트용 조회 최적화
   CREATE INDEX idx_assessment_items_name_member 
   ON assessment_items(name, assessment_id) 
   WHERE name IN ('스쿼트 5RM', '벤치프레스 5RM', '데드리프트 5RM');
   ```

### 결론

**현재 DB 구조는 안정적이며, 환산 규칙 테이블만 추가하면 완벽합니다.**

- 기존 구조 유지 가능
- 확장성 확보
- 환산 로직 명시적 관리
- 최소 변경으로 구현 가능

