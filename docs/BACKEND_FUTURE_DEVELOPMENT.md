# 이후 백엔드 개발 사항

## 현재 완료 상태

### ✅ Phase 1: 가중치 수정 및 레이더 차트 개선 (완료)
- 가중치 수정 (안정성 20%, 근력 15%, 체성분 15%, 유연성 10%)
- 레이더 차트 API 개선 (초기 vs 현재 비교 기능)
- Swagger 문서 업데이트

---

## 이후 개발 사항 (우선순위 순)

### 🔴 Phase 2: 초기 평가 세부항목 정의 (중요) ⭐⭐

**예상 작업 시간**: 2-3주  
**영향도**: 중간 (새로운 기능 추가)

#### 작업 2-1: 초기 평가 항목 정의 (상수 파일)

**파일**: `src/common/constants/initial-assessment-items.ts` (신규)

**작업 내용**:
```typescript
import { Category } from '../enums';

export const INITIAL_ASSESSMENT_ITEMS = {
  [Category.STRENGTH]: [
    '스쿼트 패턴',
    '체어 스탠드',
  ],
  [Category.CARDIO]: [
    '스텝 테스트',
  ],
  [Category.ENDURANCE]: [
    '플랭크',
    '푸쉬업',
  ],
  [Category.FLEXIBILITY]: [
    '좌전굴',
    '어깨 가동',
    '고관절 가동',
  ],
  [Category.BODY]: [
    '인바디',
  ],
  [Category.STABILITY]: [
    'OHSA',
  ],
};

export function isInitialAssessmentItem(category: Category, itemName: string): boolean {
  const items = INITIAL_ASSESSMENT_ITEMS[category] || [];
  return items.includes(itemName);
}
```

#### 작업 2-2: 평가 항목별 점수 계산 기준 정의

**파일**: `src/common/utils/assessment-item-scorer.ts` (신규)

**작업 내용**:
- 각 평가 항목별 점수 계산 함수 구현
- 연령/성별 기준표 반영 (추후 확장)
- 카테고리별 점수 집계 로직

**예시 구조**:
```typescript
export class AssessmentItemScorer {
  /**
   * 평가 항목별 점수 계산
   */
  calculateItemScore(
    category: Category,
    itemName: string,
    value: number,
    unit: string,
    memberAge?: number,
    memberGender?: Gender,
  ): number {
    // 항목별 점수 계산 로직
    // 연령/성별 기준표 참조
  }

  /**
   * 카테고리별 점수 집계
   */
  calculateCategoryScore(
    items: AssessmentItem[],
    category: Category,
  ): number {
    // 카테고리 내 항목들의 평균 또는 가중 평균
  }
}
```

#### 작업 2-3: 초기 평가 검증 로직

**파일**: `src/modules/assessments/assessments.service.ts`

**작업 내용**:
- 필수 평가 항목 체크
- 평가 항목 완성도 검증
- 초기 평가 생성 시 검증

**예시**:
```typescript
async validateInitialAssessment(
  items: CreateAssessmentItemDto[],
): Promise<void> {
  const requiredItems = Object.values(INITIAL_ASSESSMENT_ITEMS).flat();
  const providedItems = items.map(item => item.name);
  
  const missingItems = requiredItems.filter(
    item => !providedItems.includes(item)
  );
  
  if (missingItems.length > 0) {
    throw ApiExceptions.badRequest(
      `초기 평가 필수 항목이 누락되었습니다: ${missingItems.join(', ')}`
    );
  }
}
```

#### 작업 2-4: 연령/성별 기준표 테이블 생성 (DB 마이그레이션)

**파일**: `database/migrations/create_assessment_standards.sql` (신규)

**작업 내용**:
```sql
CREATE TABLE assessment_standards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category VARCHAR(50) NOT NULL,
  item_name VARCHAR(255) NOT NULL,
  age_range VARCHAR(20),  -- "20-29", "30-39" 등
  gender VARCHAR(10),    -- "MALE", "FEMALE"
  grade VARCHAR(10),      -- "상", "중", "하"
  min_value DECIMAL(10,2),
  max_value DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_assessment_standards_category_item 
ON assessment_standards(category, item_name);

CREATE INDEX idx_assessment_standards_age_gender 
ON assessment_standards(age_range, gender);
```

#### 작업 2-5: 기준표 엔티티 및 서비스 생성

**파일**: 
- `src/entities/assessment-standard.entity.ts` (신규)
- `src/modules/assessments/assessment-standards.service.ts` (신규)

**작업 내용**:
- 기준표 조회 서비스
- 점수 계산 시 기준표 참조

---

### 🟡 Phase 3: 정기 평가 세부항목 및 환산 메커니즘 (중요) ⭐⭐⭐

**예상 작업 시간**: 3-4주  
**영향도**: 중간 (새로운 기능 추가)

#### 작업 3-1: 환산 규칙 테이블 생성 (DB 마이그레이션)

**파일**: `database/migrations/create_assessment_conversion_rules.sql` (신규)

**작업 내용**:
```sql
CREATE TABLE assessment_conversion_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  metric_name VARCHAR(255) NOT NULL,  -- "스쿼트 5RM", "플랭크" 등
  category VARCHAR(50) NOT NULL,      -- STRENGTH, CARDIO, etc.
  weight DECIMAL(3,2) NOT NULL,       -- 가중치 (0~1)
  score_formula JSONB,                 -- 점수 계산 공식
  is_initial_item BOOLEAN DEFAULT FALSE, -- 초기 평가 항목 여부
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_conversion_rules_metric 
ON assessment_conversion_rules(metric_name);

CREATE INDEX idx_conversion_rules_category 
ON assessment_conversion_rules(category);

CREATE INDEX idx_conversion_rules_initial 
ON assessment_conversion_rules(is_initial_item);
```

#### 작업 3-2: 환산 규칙 엔티티 생성

**파일**: `src/entities/assessment-conversion-rule.entity.ts` (신규)

**작업 내용**:
```typescript
@Entity('assessment_conversion_rules')
export class AssessmentConversionRule {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 255 })
  metricName: string;

  @Column({ type: 'enum', enum: Category })
  category: Category;

  @Column({ type: 'decimal', precision: 3, scale: 2 })
  weight: number;

  @Column({ type: 'jsonb', nullable: true })
  scoreFormula?: {
    type: 'ratio' | 'absolute' | 'custom';
    formula: string;
    thresholds?: { value: number; score: number }[];
  };

  @Column({ name: 'is_initial_item', default: false })
  isInitialItem: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
```

#### 작업 3-3: 환산 서비스 구현

**파일**: `src/common/utils/assessment-converter.ts` (신규)

**작업 내용**:
- 정기 평가 상세 항목 → 초기 평가 축 점수 환산 로직
- 환산 규칙 조회 및 적용
- 가중 평균 계산

**예시 구조**:
```typescript
export class AssessmentConverter {
  /**
   * 정기 평가 상세 항목을 초기 평가 축 점수로 환산
   */
  async convertToCategoryScores(
    items: AssessmentItem[],
    memberId: string,
    bodyWeight?: number,
  ): Promise<CategoryScores> {
    // 1. 환산 규칙 조회
    // 2. 항목별 점수 계산
    // 3. 카테고리별 가중 평균 계산
  }

  /**
   * 단일 항목 점수 계산
   */
  private calculateItemScore(
    item: AssessmentItem,
    rule: AssessmentConversionRule,
    bodyWeight?: number,
  ): number {
    // 환산 규칙의 공식에 따라 점수 계산
  }
}
```

#### 작업 3-4: ScoreCalculator 수정

**파일**: `src/common/utils/score-calculator.ts`

**작업 내용**:
- 환산 서비스 통합
- 초기 평가 vs 정기 평가 구분 로직
- 환산 규칙 적용

**수정 예시**:
```typescript
async calculateAssessmentScore(
  assessmentId: string,
  memberId: string,
): Promise<AbilitySnapshot> {
  const assessment = await this.assessmentRepository.findOne({
    where: { id: assessmentId },
  });

  const items = await this.assessmentItemRepository.find({
    where: { assessmentId },
  });

  let categoryScores: CategoryScores;

  if (assessment.isInitial) {
    // 초기 평가: 기본 항목만 사용
    categoryScores = this.calculateCategoryScores(items);
  } else {
    // 정기 평가: 환산 규칙 적용
    categoryScores = await this.assessmentConverter.convertToCategoryScores(
      items,
      memberId,
      assessment.bodyWeight,
    );
  }

  // 나머지 로직 동일...
}
```

#### 작업 3-5: 정기 평가 항목 확장

**파일**: `src/modules/assessments/assessments.service.ts`

**작업 내용**:
- SBD 1RM 측정 항목 추가 (조건부)
- 기타 상세 지표 추가
- 정기 평가 생성 시 환산 규칙 적용

#### 작업 3-6: 정기 평가 API 개선

**파일**: `src/modules/assessments/assessments.controller.ts`

**작업 내용**:
- 초기 평가 항목 재평가
- 상세 항목 추가 평가
- 환산된 점수로 AbilitySnapshot 업데이트

---

### 🟡 Phase 4: 그래프 차트 및 상세 시각화 (중요) ⭐⭐

**예상 작업 시간**: 2-3주  
**영향도**: 낮음 (시각화 개선)

#### 작업 4-1: 그래프 차트 데이터 API

**파일**: `src/modules/assessments/assessments.service.ts`

**작업 내용**:
- 상세 항목별 시간별 데이터 조회
- SBD 1RM 추이 데이터
- 초기 평가 항목 추이 데이터

**새로운 메서드**:
```typescript
async getGraphData(
  memberId: string,
  itemName?: string,
  category?: Category,
): Promise<{
  history: Array<{
    assessedAt: string;
    value: number;
    score: number;
  }>;
}> {
  // AssessmentItem 조회 및 시간순 정렬
  // itemName 또는 category 필터링
}
```

#### 작업 4-2: 그래프 차트 컨트롤러 추가

**파일**: `src/modules/members/abilities.controller.ts`

**작업 내용**:
- 새로운 엔드포인트 추가
- 쿼리 파라미터 처리 (itemName, category)

**새로운 엔드포인트**:
```typescript
@Get("graph")
@ApiOperation({ 
  summary: '상세 항목별 그래프 데이터 조회',
  description: '특정 평가 항목의 시간별 추이 데이터를 조회합니다.'
})
async getGraphData(
  @Param("memberId") memberId: string,
  @Query("itemName") itemName?: string,
  @Query("category") category?: Category,
) {
  const data = await this.assessmentsService.getGraphData(
    memberId,
    itemName,
    category,
  );
  return ApiResponseHelper.success(data, "그래프 데이터 조회 성공");
}
```

#### 작업 4-3: 데이터 집계 및 포맷팅

**파일**: `src/common/utils/graph-data-formatter.ts` (신규)

**작업 내용**:
- 시간별 데이터 집계
- 차트에 바로 사용 가능한 형식 제공
- 여러 항목 비교 데이터 포맷팅

---

### 🟢 Phase 5: 평가 기준표 및 등급 체계 (선택적) ⭐

**예상 작업 시간**: 2주  
**영향도**: 낮음 (부가 기능)

#### 작업 5-1: 등급 계산 로직

**파일**: `src/common/utils/grade-calculator.ts` (신규)

**작업 내용**:
- 점수 → 등급 변환 (S/A/B/C/D 또는 상/중/하)
- 부상 안정성 특별 등급 (O/△/X)

**예시**:
```typescript
export class GradeCalculator {
  calculateGrade(score: number): 'S' | 'A' | 'B' | 'C' | 'D' {
    if (score >= 90) return 'S';
    if (score >= 80) return 'A';
    if (score >= 60) return 'B';
    if (score >= 40) return 'C';
    return 'D';
  }

  calculateStabilityGrade(
    stabilityScore: number,
    hasPain: boolean,
    hasRestrictions: boolean,
  ): 'O' | '△' | 'X' {
    if (hasPain || hasRestrictions) return 'X';
    if (stabilityScore < 60) return '△';
    return 'O';
  }
}
```

#### 작업 5-2: 등급 필드 추가 (선택적)

**파일**: `src/entities/ability-snapshot.entity.ts`

**작업 내용**:
- `grade` 필드 추가 (선택적)
- `stabilityGrade` 필드 추가 (선택적)

**주의**: 기존 데이터 마이그레이션 필요

---

## 개발 우선순위 요약

### 즉시 진행 (Phase 2)
1. 초기 평가 항목 정의 (상수 파일)
2. 평가 항목별 점수 계산 기준 정의
3. 초기 평가 검증 로직
4. 연령/성별 기준표 테이블 생성

### 중기 진행 (Phase 3)
1. 환산 규칙 테이블 생성
2. 환산 서비스 구현
3. ScoreCalculator 수정
4. 정기 평가 항목 확장

### 장기 진행 (Phase 4-5)
1. 그래프 차트 데이터 API
2. 등급 계산 로직
3. 등급 필드 추가 (선택적)

---

## 각 Phase별 상세 작업 목록

### Phase 2 상세 작업

#### 백엔드 작업
- [ ] `src/common/constants/initial-assessment-items.ts` 생성
- [ ] `src/common/utils/assessment-item-scorer.ts` 생성
- [ ] `src/modules/assessments/assessments.service.ts` - 초기 평가 검증 로직 추가
- [ ] `database/migrations/create_assessment_standards.sql` 생성
- [ ] `src/entities/assessment-standard.entity.ts` 생성
- [ ] `src/modules/assessments/assessment-standards.service.ts` 생성
- [ ] `src/modules/assessments/assessment-standards.module.ts` 생성
- [ ] Swagger 문서 업데이트
- [ ] 테스트 코드 작성

#### 프론트엔드 작업 (프론트엔드 개발자)
- [ ] 초기 평가 입력 폼 개선
- [ ] 카테고리별 평가 항목 입력 UI
- [ ] 필수 항목 표시
- [ ] 입력값 검증
- [ ] 초기 평가 완성도 표시

---

### Phase 3 상세 작업

#### 백엔드 작업
- [ ] `database/migrations/create_assessment_conversion_rules.sql` 생성
- [ ] `src/entities/assessment-conversion-rule.entity.ts` 생성
- [ ] `src/common/utils/assessment-converter.ts` 생성
- [ ] `src/common/utils/score-calculator.ts` - 환산 서비스 통합
- [ ] `src/modules/assessments/assessments.service.ts` - 정기 평가 환산 로직 추가
- [ ] `src/modules/assessments/assessments.controller.ts` - API 개선
- [ ] Swagger 문서 업데이트
- [ ] 테스트 코드 작성

#### 프론트엔드 작업 (프론트엔드 개발자)
- [ ] 정기 평가 입력 폼 확장
- [ ] 초기 평가 항목 재평가 섹션
- [ ] 상세 항목 추가 섹션
- [ ] SBD 1RM 입력 UI (조건부 표시)
- [ ] 그래프 차트 컴포넌트 구현

---

### Phase 4 상세 작업

#### 백엔드 작업
- [ ] `src/modules/assessments/assessments.service.ts` - `getGraphData` 메서드 추가
- [ ] `src/modules/members/abilities.controller.ts` - 그래프 차트 엔드포인트 추가
- [ ] `src/common/utils/graph-data-formatter.ts` 생성
- [ ] Swagger 문서 업데이트
- [ ] 테스트 코드 작성

#### 프론트엔드 작업 (프론트엔드 개발자)
- [ ] 라인 차트 컴포넌트 구현
- [ ] 그래프 차트 페이지 구현
- [ ] 필터링 기능 (항목별, 기간별)

---

### Phase 5 상세 작업

#### 백엔드 작업
- [ ] `src/common/utils/grade-calculator.ts` 생성
- [ ] `src/entities/ability-snapshot.entity.ts` - 등급 필드 추가 (선택적)
- [ ] `database/migrations/add_grade_fields.sql` 생성 (선택적)
- [ ] Swagger 문서 업데이트
- [ ] 테스트 코드 작성

#### 프론트엔드 작업 (프론트엔드 개발자)
- [ ] 등급 표시 UI
- [ ] 레이더 차트에 등급 표시
- [ ] 평가 상세 페이지에 등급 표시
- [ ] 등급별 색상 구분

---

## 참고 문서

- [ASSESSMENT_GUIDE.md](ASSESSMENT_GUIDE.md) - 평가 가이드 문서
- [2차개발방향.md](2차개발방향.md) - 상세 개발 방향
- [DEVELOPMENT_PRIORITY.md](DEVELOPMENT_PRIORITY.md) - 개발 우선순위
- [ASSESSMENT_2LAYER_STRUCTURE.md](ASSESSMENT_2LAYER_STRUCTURE.md) - 2단계 평가 레이어 구조

---

## 개발 시 주의사항

### 데이터 마이그레이션
- 새로운 테이블 생성 시 마이그레이션 스크립트 작성
- 기존 데이터 변경 시 백업 필수
- 테스트 환경에서 먼저 검증

### API 하위 호환성
- 기존 API는 유지
- 새로운 기능은 새로운 엔드포인트 또는 쿼리 파라미터로 추가
- Swagger 문서 항상 업데이트

### 테스트
- 각 Phase별 단위 테스트 작성
- 통합 테스트 작성
- 프론트엔드와 연동 테스트

---

## 예상 일정

- **Phase 2**: 2-3주
- **Phase 3**: 3-4주
- **Phase 4**: 2-3주
- **Phase 5**: 2주 (선택적)

**총 예상 기간**: 9-12주 (Phase 5 제외 시 7-10주)

