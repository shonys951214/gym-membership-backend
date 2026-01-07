# 피드백 반영 작업 계획서

## 📋 피드백 요약

### 추가 요청 기능
1. **목표 관리 기능**: 회원의 목표 한줄 요약, 달성률/진행률, 트레이너 코멘트
2. **추천 운동 루틴 기능**: 오늘의 운동 루틴
3. **운동 기록 기능**: 어떤 운동을 언제 몇 키로를 몇 회 했는지 기록
4. **대시보드 개선**:
   - 목표: 회원의 목표, 동기부여 코멘트, 진행률
   - 수업회차: 수업회차 표기 (ex. 50% 10회/20회 + 막대그래프), 클릭시 주요 수업내용 확인
   - 운동캘린더: 달력에 PT참여, 개인운동 참여 표기
   - 운동기록분석: 부위별 운동 볼륨 확인 (주간, 월간)
5. **평가 시스템 개선**: 정적평가와 동적평가로 구분, 평가 항목 세분화

---

## 🔄 작업 순서 (우선순위별)

### Phase 1: 데이터베이스 스키마 확장 (최우선)

#### 1-1. Member 엔티티에 목표 관리 필드 추가
**파일**: `src/entities/member.entity.ts`

**추가 필드**:
- `goal`: string (회원의 목표 한줄 요약)
- `goalProgress`: number (진행률 0-100)
- `goalTrainerComment`: string (트레이너 동기부여 코멘트)
- `totalSessions`: number (총 수업 회차)
- `completedSessions`: number (완료된 수업 회차)

**작업 내용**:
```typescript
@Column({ type: 'text', nullable: true })
goal?: string;

@Column({ type: 'int', name: 'goal_progress', default: 0 })
goalProgress: number; // 0-100

@Column({ type: 'text', name: 'goal_trainer_comment', nullable: true })
goalTrainerComment?: string;

@Column({ type: 'int', name: 'total_sessions', default: 0 })
totalSessions: number;

@Column({ type: 'int', name: 'completed_sessions', default: 0 })
completedSessions: number;
```

**SQL 마이그레이션**: `database/add_member_goal_fields.sql` 생성 필요

---

#### 1-2. 운동 기록 엔티티 생성
**파일**: `src/entities/workout-record.entity.ts` (신규 생성)

**필드 구조**:
```typescript
- id: uuid
- memberId: uuid (FK)
- workoutDate: date (운동 날짜)
- bodyPart: string (부위: 하체, 가슴, 등, 어깨, 팔 등)
- exerciseName: string (운동명: 스쿼트, 벤치프레스 등)
- weight: number (무게, kg)
- reps: number (횟수)
- sets: number (세트 수)
- volume: number (볼륨 = weight * reps * sets, 자동 계산)
- workoutType: enum ('PT' | 'PERSONAL') (PT 참여 / 개인운동)
- createdAt, updatedAt
```

**관계**: Member와 OneToMany 관계

---

#### 1-3. PT 세션 엔티티 생성
**파일**: `src/entities/pt-session.entity.ts` (신규 생성)

**필드 구조**:
```typescript
- id: uuid
- memberId: uuid (FK)
- sessionNumber: number (수업 회차: 1, 2, 3...)
- sessionDate: date (수업 날짜)
- mainContent: string (주요 수업 내용)
- trainerComment?: string (트레이너 코멘트)
- createdAt, updatedAt
```

**관계**: Member와 OneToMany 관계

---

#### 1-4. 추천 운동 루틴 엔티티 생성
**파일**: `src/entities/workout-routine.entity.ts` (신규 생성)

**필드 구조**:
```typescript
- id: uuid
- memberId: uuid (FK)
- routineDate: date (루틴 날짜)
- exercises: jsonb (운동 목록)
  [
    {
      bodyPart: string,
      exerciseName: string,
      sets: number,
      reps: number,
      weight?: number,
      notes?: string
    }
  ]
- isCompleted: boolean (완료 여부)
- createdAt, updatedAt
```

**관계**: Member와 OneToMany 관계

---

#### 1-5. 평가 시스템 개선 - Assessment 엔티티 확장
**파일**: `src/entities/assessment.entity.ts`

**추가 필드**:
```typescript
- evaluationType: enum ('STATIC' | 'DYNAMIC') (정적평가 / 동적평가)
- staticEvaluation?: jsonb (정적평가 데이터)
  {
    survey?: object, // 설문조사
    bodyComposition?: object, // 체성분 평가 (인바디)
    visualAssessment?: object // 육안체형평가
  }
- dynamicEvaluation?: jsonb (동적평가 데이터)
  {
    flexibility?: object, // 유연성 평가
    strength?: object, // 근력 평가
    balance?: object, // 밸런스 평가
    cardio?: object // 유산소성 평가
  }
```

**참고**: 기존 `AssessmentItem`은 유지하되, 평가 타입별로 그룹화하여 관리

---

### Phase 2: API 개발

#### 2-1. 목표 관리 API
**파일**: `src/modules/members/members.controller.ts`에 추가

**엔드포인트**:
- `GET /api/members/:id/goal` - 목표 조회
- `PUT /api/members/:id/goal` - 목표 수정

**DTO**: `src/modules/members/dto/update-goal.dto.ts` 생성

---

#### 2-2. 운동 기록 API
**파일**: `src/modules/members/workout-records.controller.ts` (신규 생성)

**엔드포인트**:
- `GET /api/members/:id/workout-records` - 운동 기록 목록 (날짜별, 부위별 필터)
- `POST /api/members/:id/workout-records` - 운동 기록 등록
- `PUT /api/members/:id/workout-records/:recordId` - 운동 기록 수정
- `DELETE /api/members/:id/workout-records/:recordId` - 운동 기록 삭제
- `GET /api/members/:id/workout-records/analysis` - 운동 기록 분석 (부위별 볼륨, 주간/월간)

**DTO**: 
- `src/modules/members/dto/create-workout-record.dto.ts`
- `src/modules/members/dto/update-workout-record.dto.ts`
- `src/modules/members/dto/workout-analysis-query.dto.ts`

---

#### 2-3. PT 세션 API
**파일**: `src/modules/members/pt-sessions.controller.ts` (신규 생성)

**엔드포인트**:
- `GET /api/members/:id/pt-sessions` - PT 세션 목록
- `POST /api/members/:id/pt-sessions` - PT 세션 등록
- `GET /api/members/:id/pt-sessions/:sessionId` - PT 세션 상세 (주요 수업내용)
- `PUT /api/members/:id/pt-sessions/:sessionId` - PT 세션 수정
- `GET /api/members/:id/pt-sessions/progress` - 수업 진행률 (50% 10회/20회)

**DTO**:
- `src/modules/members/dto/create-pt-session.dto.ts`
- `src/modules/members/dto/update-pt-session.dto.ts`

---

#### 2-4. 추천 운동 루틴 API
**파일**: `src/modules/members/workout-routines.controller.ts` (신규 생성)

**엔드포인트**:
- `GET /api/members/:id/workout-routines/today` - 오늘의 운동 루틴
- `GET /api/members/:id/workout-routines` - 운동 루틴 목록
- `POST /api/members/:id/workout-routines` - 운동 루틴 생성
- `PUT /api/members/:id/workout-routines/:routineId` - 운동 루틴 수정
- `PUT /api/members/:id/workout-routines/:routineId/complete` - 운동 루틴 완료 처리

**DTO**:
- `src/modules/members/dto/create-workout-routine.dto.ts`
- `src/modules/members/dto/update-workout-routine.dto.ts`

---

#### 2-5. 대시보드 API 확장
**파일**: `src/modules/insights/insights.service.ts`, `insights.controller.ts`

**추가 엔드포인트**:
- `GET /api/insights/member/:id/dashboard` - 회원 대시보드 데이터 (통합)
  - 목표 정보
  - 수업 진행률
  - 운동 캘린더 데이터
  - 운동 기록 분석 (주간/월간)

**응답 구조**:
```typescript
{
  goal: {
    goal: string,
    progress: number,
    trainerComment: string
  },
  sessionProgress: {
    completed: number,
    total: number,
    percentage: number,
    recentSessions: PTSession[] // 최근 수업 내용
  },
  workoutCalendar: {
    year: number,
    month: number,
    events: Array<{
      date: string,
      type: 'PT' | 'PERSONAL',
      count: number
    }>
  },
  workoutAnalysis: {
    weekly: {
      bodyPart: string,
      volume: number,
      sets: number
    }[],
    monthly: {
      bodyPart: string,
      volume: number,
      sets: number
    }[]
  }
}
```

---

### Phase 3: 평가 시스템 개선

#### 3-1. 평가 타입 구분 로직
**파일**: `src/modules/assessments/assessments.service.ts`

**수정 내용**:
- 평가 생성 시 `evaluationType` 필수 입력
- 정적평가/동적평가별 데이터 구조 분리
- 평가 항목을 타입별로 그룹화하여 저장

**DTO 수정**:
- `src/modules/assessments/dto/create-assessment.dto.ts`에 `evaluationType` 필드 추가
- 정적평가/동적평가별 DTO 분리 고려

---

## 📝 작업 체크리스트

### Phase 1: 데이터베이스 스키마
- [ ] Member 엔티티에 목표 필드 추가
- [ ] WorkoutRecord 엔티티 생성
- [ ] PTSession 엔티티 생성
- [ ] WorkoutRoutine 엔티티 생성
- [ ] Assessment 엔티티에 평가 타입 필드 추가
- [ ] SQL 마이그레이션 스크립트 생성 및 실행

### Phase 2: API 개발
- [ ] 목표 관리 API 구현
- [ ] 운동 기록 API 구현
- [ ] PT 세션 API 구현
- [ ] 추천 운동 루틴 API 구현
- [ ] 대시보드 API 확장

### Phase 3: 평가 시스템 개선
- [ ] 평가 타입 구분 로직 구현
- [ ] 정적평가/동적평가 데이터 구조 설계
- [ ] 평가 항목 그룹화 로직 구현

---

## 🚀 시작 순서 권장사항

1. **1단계**: Member 엔티티 확장 (목표 필드 추가) - 가장 간단하고 영향 범위가 작음
2. **2단계**: WorkoutRecord 엔티티 생성 및 API - 운동 기록은 핵심 기능
3. **3단계**: PTSession 엔티티 생성 및 API - 수업회차 관리
4. **4단계**: WorkoutRoutine 엔티티 생성 및 API - 추천 루틴
5. **5단계**: 대시보드 API 확장 - 위 기능들이 완료된 후 통합
6. **6단계**: 평가 시스템 개선 - 가장 복잡하므로 마지막에 진행

---

## 📌 주의사항

1. **데이터베이스 마이그레이션**: 각 엔티티 추가/수정 시 반드시 SQL 마이그레이션 스크립트 생성
2. **기존 데이터 호환성**: 기존 Member 데이터에 목표 필드는 nullable로 설정
3. **API 응답 형식**: 기존 API 응답 형식(`ApiResponseHelper.success`) 유지
4. **권한 관리**: 모든 새 API는 기존 권한 체계(JwtRolesGuard) 적용
5. **Swagger 문서화**: 모든 새 API에 Swagger 데코레이터 추가

---

## 🔗 관련 파일 위치

### 엔티티
- `src/entities/member.entity.ts` - 수정
- `src/entities/workout-record.entity.ts` - 신규
- `src/entities/pt-session.entity.ts` - 신규
- `src/entities/workout-routine.entity.ts` - 신규
- `src/entities/assessment.entity.ts` - 수정

### 컨트롤러
- `src/modules/members/members.controller.ts` - 목표 API 추가
- `src/modules/members/workout-records.controller.ts` - 신규
- `src/modules/members/pt-sessions.controller.ts` - 신규
- `src/modules/members/workout-routines.controller.ts` - 신규
- `src/modules/insights/insights.controller.ts` - 대시보드 API 추가

### 서비스
- `src/modules/members/members.service.ts` - 목표 관리 로직 추가
- `src/modules/members/workout-records.service.ts` - 신규
- `src/modules/members/pt-sessions.service.ts` - 신규
- `src/modules/members/workout-routines.service.ts` - 신규
- `src/modules/insights/insights.service.ts` - 대시보드 로직 추가

### DTO
- `src/modules/members/dto/update-goal.dto.ts` - 신규
- `src/modules/members/dto/create-workout-record.dto.ts` - 신규
- `src/modules/members/dto/create-pt-session.dto.ts` - 신규
- `src/modules/members/dto/create-workout-routine.dto.ts` - 신규

---

**작성일**: 2026-01-06
**작성자**: AI Assistant

