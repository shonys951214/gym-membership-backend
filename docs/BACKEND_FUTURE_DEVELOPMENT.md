# 이후 백엔드 개발 사항

## 현재 완료 상태

### ✅ Phase 1: 가중치 수정 및 레이더 차트 개선 (완료)
- 가중치 수정 (안정성 20%, 근력 15%, 체성분 15%, 유연성 10%)
- 레이더 차트 API 개선 (초기 vs 현재 비교 기능)
- Swagger 문서 업데이트

---

## 이후 개발 사항 (우선순위 순)

### 🟢 Phase 0: 운동 기본 데이터 준비 (NEW) ⭐

**예상 작업 시간**: 1-2일  
**영향도**: 낮음 (데이터 준비 단계)

#### 작업 0-1: free-exercise-db 데이터 다운로드

**작업 내용**:
1. free-exercise-db 저장소 클론 또는 JSON 파일 다운로드
2. 데이터 구조 확인

**명령어**:
```bash
# 저장소 클론
git clone https://github.com/yuhonas/free-exercise-db.git ../free-exercise-db

# 또는 JSON 파일 직접 다운로드
curl -o exercises.json https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json
```

#### 작업 0-2: 필요한 운동만 필터링하여 변환

**파일**: `scripts/convert-free-exercise-db.ts` (이미 생성됨)

**작업 내용**:
1. 프로젝트에 필요한 운동만 필터링 (카테고리, 장비, 레벨 등)
2. exercises 테이블 구조로 변환
3. SQL 파일 생성

**예시 명령어**:
```bash
# 상체 운동만 변환
ts-node scripts/convert-free-exercise-db.ts --category=UPPER

# 바벨과 덤벨 운동만 변환
ts-node scripts/convert-free-exercise-db.ts --equipment=barbell,dumbbell

# 초보자용 상체 운동만 변환
ts-node scripts/convert-free-exercise-db.ts --category=UPPER --level=beginner
```

**또는 배치 스크립트 사용**:
```bash
bash scripts/generate-exercise-seeds.sh
```

#### 작업 0-3: exercises 테이블에 데이터 삽입

**작업 내용**:
1. 생성된 SQL 파일 확인
2. 데이터베이스에 삽입
3. 데이터 검증

**명령어**:
```sql
\i database/seeds/free_exercise_db_seed.sql
```

**검증 쿼리**:
```sql
-- 전체 운동 개수 확인
SELECT COUNT(*) FROM exercises;

-- 카테고리별 개수
SELECT category, COUNT(*) FROM exercises GROUP BY category;

-- 부위별 개수
SELECT body_part, COUNT(*) FROM exercises WHERE body_part IS NOT NULL GROUP BY body_part;
```

#### 작업 0-4: 운동 상세 가이드 문서 생성

**파일**: `docs/EXERCISE_DETAIL_GUIDE.md` (신규)

**작업 내용**:
- 프론트엔드 개발자가 AI를 활용하여 API 작성 시 참고할 수 있는 운동 상세 정보 문서
- 각 운동의 상세 정보, 사용 방법, 주의사항 등 포함

**참고**: `docs/EXERCISE_DETAIL_GUIDE.md` 참고

---

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

### 🔴 Phase 6: Strength Level 판정 기능 (중요) ⭐⭐⭐

**예상 작업 시간**: 2-3주  
**영향도**: 높음 (핵심 기능)

#### 작업 6-1: Strength Level 기준 데이터 수집

**작업 내용**:
1. strengthlevel.com에서 기준 데이터 수집
   - 수동 수집: `docs/MANUAL_DATA_COLLECTION_GUIDE.md` 참고
   - 자동 수집: `scripts/scrape_strengthlevel.py` 사용 (Selenium 필요)
2. `strength_standards` 테이블에 데이터 삽입
3. 데이터 검증

**참고 문서**:
- `docs/MANUAL_DATA_COLLECTION_GUIDE.md` - 수동 수집 가이드
- `docs/QUICK_START_GUIDE.md` - 빠른 시작 가이드
- `scripts/scrape_strengthlevel.py` - 자동 수집 스크립트

#### 작업 6-2: Strength Level 계산 로직 (이미 부분 구현됨)

**파일**: `src/common/utils/strength-level-evaluator.ts` (이미 생성됨)

**작업 내용**:
- ✅ 1RM 계산 (이미 구현됨)
- ✅ Strength Level 판정 (이미 구현됨)
- ✅ 운동 기록 저장 시 자동 계산 (이미 구현됨)
- ⏳ 예외 처리 개선
- ⏳ 로깅 개선

#### 작업 6-3: Strength Level API 엔드포인트 (일부 구현됨)

**파일**: `src/modules/members/members.controller.ts`

**작업 내용**:
- ✅ 주요 운동 1RM 추정 API (이미 구현됨)
- ✅ 1RM 추세 데이터 API (이미 구현됨)
- ✅ 볼륨 추세 데이터 API (이미 구현됨)
- ✅ Strength Level 변화 추적 API (이미 구현됨)
- ⏳ 운동별 Strength Level 조회 API 개선
- ⏳ 다음 레벨 목표 무게 계산 API

**이미 구현된 엔드포인트**:
```typescript
GET /api/members/:id/one-rep-max-estimate
GET /api/members/:id/workout-records/one-rep-max-trend
GET /api/members/:id/workout-records/volume-trend
GET /api/members/:id/strength-progress
GET /api/members/:id/workout-routines/suggest-weight
```

#### 작업 6-4: 운동 루틴 무게 제안 기능 (이미 구현됨)

**파일**: `src/modules/members/workout-routines.service.ts`

**작업 내용**:
- ✅ Strength Level 기반 무게 제안 (이미 구현됨)
- ⏳ 루틴 생성 시 자동 무게 제안 옵션 추가

#### 작업 6-5: 운동 목록 API 개선 (이미 구현됨)

**파일**: `src/modules/exercises/exercises.service.ts`

**작업 내용**:
- ✅ 카테고리 필터링 (이미 구현됨)
- ✅ 부위 필터링 (이미 구현됨)
- ✅ 검색 기능 (이미 구현됨)
- ✅ 최근 운동 우선 정렬 (이미 구현됨)
- ✅ 페이징 지원 (이미 구현됨)

**엔드포인트**:
```typescript
GET /api/exercises?category=UPPER&bodyPart=가슴&search=bench&page=1&limit=20
```

---

## 개발 우선순위 요약

### 즉시 진행 (Phase 0)
1. ✅ free-exercise-db 데이터 다운로드
2. ✅ 필요한 운동만 필터링하여 변환
3. ✅ exercises 테이블에 삽입
4. ✅ 운동 상세 가이드 문서 생성

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

### 중기 진행 (Phase 6)
1. Strength Level 기준 데이터 수집 (strengthlevel.com)
2. Strength Level 계산 로직 개선
3. Strength Level API 엔드포인트 개선

### 장기 진행 (Phase 4-5)
1. 그래프 차트 데이터 API
2. 등급 계산 로직
3. 등급 필드 추가 (선택적)

---

## 각 Phase별 상세 작업 목록

### Phase 0 상세 작업

#### 백엔드 작업
- [x] `scripts/convert-free-exercise-db.ts` 생성 (완료)
- [x] `scripts/generate-exercise-seeds.sh` 생성 (완료)
- [x] `docs/FREE_EXERCISE_DB_INTEGRATION.md` 생성 (완료)
- [x] `docs/FREE_EXERCISE_DB_FILTERING.md` 생성 (완료)
- [ ] free-exercise-db 데이터 다운로드
- [ ] 필요한 운동만 필터링하여 변환
- [ ] exercises 테이블에 데이터 삽입
- [ ] 데이터 검증
- [ ] `docs/EXERCISE_DETAIL_GUIDE.md` 생성

#### 프론트엔드 작업 (프론트엔드 개발자)
- [ ] 운동 선택 UI 구현 (카테고리, 부위 필터)
- [ ] 운동 검색 기능 구현
- [ ] 최근 운동 우선 정렬 UI
- [ ] 운동 상세 정보 표시 (가이드 문서 참고)

---

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

### Phase 6 상세 작업

#### 백엔드 작업
- [x] `src/common/utils/strength-level-evaluator.ts` 생성 (완료)
- [x] `src/common/utils/one-rep-max-calculator.ts` 생성 (완료)
- [x] `src/common/utils/relative-strength-calculator.ts` 생성 (완료)
- [x] `src/modules/members/workout-records.service.ts` - Strength Level 계산 통합 (완료)
- [x] `src/modules/members/members.controller.ts` - Strength Level API 엔드포인트 (완료)
- [x] `src/modules/exercises/exercises.service.ts` - 운동 목록 API (완료)
- [ ] strengthlevel.com에서 기준 데이터 수집
- [ ] `strength_standards` 테이블에 데이터 삽입
- [ ] 데이터 검증
- [ ] 예외 처리 개선
- [ ] 로깅 개선

#### 프론트엔드 작업 (프론트엔드 개발자)
- [ ] Strength Level 배지 표시
- [ ] 1RM 추정 모달/페이지 구현
- [ ] Strength Level 변화 그래프 구현
- [ ] 운동 기록 입력 시 Strength Level 표시
- [ ] 루틴 생성 시 무게 제안 UI

---

## 참고 문서

- [ASSESSMENT_GUIDE.md](ASSESSMENT_GUIDE.md) - 평가 가이드 문서
- [2차개발방향.md](2차개발방향.md) - 상세 개발 방향
- [STRENGTH_LEVEL_API_GUIDE.md](STRENGTH_LEVEL_API_GUIDE.md) - Strength Level API 가이드
- [FREE_EXERCISE_DB_INTEGRATION.md](FREE_EXERCISE_DB_INTEGRATION.md) - free-exercise-db 통합 가이드
- [FREE_EXERCISE_DB_FILTERING.md](FREE_EXERCISE_DB_FILTERING.md) - free-exercise-db 필터링 가이드
- [EXERCISE_DETAIL_GUIDE.md](EXERCISE_DETAIL_GUIDE.md) - 운동 상세 가이드 (프론트엔드 AI 활용용)
- [MANUAL_DATA_COLLECTION_GUIDE.md](MANUAL_DATA_COLLECTION_GUIDE.md) - strengthlevel.com 수동 수집 가이드

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

- **Phase 0**: 1-2일
- **Phase 2**: 2-3주
- **Phase 3**: 3-4주
- **Phase 4**: 2-3주
- **Phase 5**: 2주 (선택적)
- **Phase 6**: 2-3주 (일부 완료)

**총 예상 기간**: 10-15주 (Phase 5 제외 시 8-13주)

---

## 데이터 소스 정리

### exercises 테이블 (운동 기본 정보)
- **데이터 소스**: free-exercise-db
- **용도**: 운동 목록 제공, 운동 선택 UI
- **수집 방법**: 
  - free-exercise-db JSON 파일 다운로드
  - 변환 스크립트로 필터링 및 변환
  - exercises 테이블에 삽입

### strength_standards 테이블 (Strength Level 기준 데이터)
- **데이터 소스**: strengthlevel.com
- **용도**: 1RM 기반 레벨 판정 (BEGINNER, NOVICE, INTERMEDIATE, ADVANCED, ELITE)
- **수집 방법**:
  - 수동 수집: `docs/MANUAL_DATA_COLLECTION_GUIDE.md` 참고
  - 자동 수집: `scripts/scrape_strengthlevel.py` 사용 (Selenium 필요)

### 두 데이터 소스의 관계
- `exercises` 테이블: 운동 목록 (운동명, 카테고리, 부위)
- `strength_standards` 테이블: Strength Level 기준 데이터 (체중별, 성별, 레벨별 기준 무게)
- 두 테이블은 운동명으로 연결됨 (`exercises.name` 또는 `exercises.name_en` ↔ `strength_standards`의 운동명)