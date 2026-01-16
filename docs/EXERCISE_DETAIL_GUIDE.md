# 운동 상세 가이드 (프론트엔드 AI 활용용)

> **목적**: 프론트엔드 개발자가 AI를 활용하여 운동 관련 API를 작성할 때 참고할 수 있는 상세 가이드 문서
> 
> **대상**: 프론트엔드 개발자, AI 도구 (ChatGPT, Claude, GitHub Copilot 등)

---

## 📋 목차

1. [운동 데이터 구조](#운동-데이터-구조)
2. [API 엔드포인트](#api-엔드포인트)
3. [운동 기록 데이터 구조](#운동-기록-데이터-구조)
4. [운동 루틴 데이터 구조](#운동-루틴-데이터-구조)
5. [Strength Level 관련 데이터](#strength-level-관련-데이터)
6. [UI 컴포넌트 가이드](#ui-컴포넌트-가이드)
7. [사용 예시](#사용-예시)

---

## 운동 데이터 구조

### Exercise 엔티티

```typescript
interface Exercise {
  id: string;                    // UUID
  name: string;                  // 한글명: "벤치프레스"
  nameEn: string;                // 영문명: "Bench Press"
  category: ExerciseCategory;    // "UPPER" | "LOWER" | "FULL_BODY"
  bodyPart?: string;             // "가슴" | "등" | "어깨" | "팔" | "하체"
  unit: string;                  // "kg" (고정)
  isActive: boolean;             // 활성화 여부
  createdAt: Date;
  updatedAt: Date;
}
```

### ExerciseCategory Enum

```typescript
enum ExerciseCategory {
  UPPER = 'UPPER',        // 상체
  LOWER = 'LOWER',        // 하체
  FULL_BODY = 'FULL_BODY' // 전신
}
```

### 주요 운동 예시

#### 상체 운동 (UPPER)
- **가슴**: 벤치프레스, 인클라인 벤치프레스, 덤벨 프레스, 딥스
- **등**: 랫풀다운, 벤트오버 로우, 풀업, 케이블 로우
- **어깨**: 오버헤드 프레스, 숄더 프레스, 사이드 레터럴 레이즈
- **팔**: 바벨 컬, 덤벨 컬, 트라이셉스 익스텐션

#### 하체 운동 (LOWER)
- **하체**: 스쿼트, 레그프레스, 레그 컬, 레그 익스텐션, 런지, 카프 레이즈

#### 전신 운동 (FULL_BODY)
- **하체**: 데드리프트, 루마니안 데드리프트, 스모 데드리프트

---

## API 엔드포인트

### 1. 운동 목록 조회

**엔드포인트**: `GET /api/exercises`

**인증**: JWT 토큰 필요

**쿼리 파라미터**:
```typescript
{
  category?: 'UPPER' | 'LOWER' | 'FULL_BODY';  // 카테고리 필터
  bodyPart?: string;                           // 부위 필터: "가슴", "등", "어깨", "팔", "하체"
  search?: string;                             // 검색어 (운동명)
  memberId?: string;                           // 회원 ID (최근 운동 우선 정렬용)
  isActive?: boolean;                          // 활성화된 운동만 (기본: true)
  page?: number;                               // 페이지 번호 (기본: 1)
  limit?: number;                              // 페이지당 항목 수 (기본: 50, 최대: 100)
}
```

**응답 구조**:
```typescript
{
  success: true;
  data: {
    data: Array<{
      id: string;
      name: string;              // 한글명
      nameEn: string;            // 영문명
      category: ExerciseCategory;
      bodyPart?: string;
      recentCount?: number;      // 최근 30일 내 기록 횟수 (memberId 제공 시)
    }>;
    total: number;               // 전체 개수
    page: number;               // 현재 페이지
    limit: number;               // 페이지당 항목 수
  };
  message: string;
}
```

**사용 예시**:
```typescript
// 상체 운동만 조회
GET /api/exercises?category=UPPER

// 가슴 운동만 조회
GET /api/exercises?bodyPart=가슴

// 검색어로 필터링
GET /api/exercises?search=bench

// 회원의 최근 운동 우선 정렬
GET /api/exercises?memberId={memberId}

// 복합 필터
GET /api/exercises?category=UPPER&bodyPart=가슴&search=press&page=1&limit=20
```

### 2. 운동 상세 조회

**엔드포인트**: `GET /api/exercises/:id`

**인증**: JWT 토큰 필요

**응답 구조**:
```typescript
{
  success: true;
  data: Exercise;  // 전체 Exercise 객체
  message: string;
}
```

### 3. 운동 기록 관련 API

#### 3-1. 운동 기록 생성

**엔드포인트**: `POST /api/members/:id/workout-records`

**인증**: JWT 토큰 필요

**요청 본문**:
```typescript
{
  workoutDate: string;        // "2024-03-15" (YYYY-MM-DD)
  bodyPart: string;           // "가슴", "등", "어깨", "팔", "하체"
  exerciseName: string;       // "벤치프레스" 또는 "Bench Press"
  weight: number;             // 무게 (kg)
  reps: number;               // 횟수
  sets: number;               // 세트 수
  duration?: number;          // 운동 시간 (분, 선택적)
  workoutType: 'PT' | 'PERSONAL';  // PT 세션 또는 개인 운동
  ptSessionId?: string;       // PT 세션 ID (workoutType이 'PT'인 경우)
  trainerComment?: string;    // 트레이너 코멘트 (선택적)
}
```

**응답 구조**:
```typescript
{
  success: true;
  data: {
    id: string;
    workoutDate: string;
    bodyPart: string;
    exerciseName: string;
    weight: number;
    reps: number;
    sets: number;
    volume: number;            // 자동 계산: weight * reps * sets
    duration?: number;
    workoutType: 'PT' | 'PERSONAL';
    ptSessionId?: string;
    trainerComment?: string;
    oneRepMax?: number;        // 자동 계산: 1RM 추정값 (kg)
    relativeStrength?: number; // 자동 계산: 상대적 강도 (%)
    strengthLevel?: 'BEGINNER' | 'NOVICE' | 'INTERMEDIATE' | 'ADVANCED' | 'ELITE'; // 자동 계산
    createdAt: string;
    updatedAt: string;
  };
  message: string;
}
```

**주의사항**:
- `volume`은 자동 계산됨 (weight × reps × sets)
- `oneRepMax`, `relativeStrength`, `strengthLevel`은 자동 계산됨 (조건 충족 시)
- Strength Level 계산 조건:
  - 회원의 체중 정보 필요 (`members.weight`)
  - 회원의 성별 정보 필요 (`members.gender`)
  - 해당 운동의 Strength Standards 데이터 필요

#### 3-2. 운동 기록 목록 조회

**엔드포인트**: `GET /api/members/:id/workout-records`

**인증**: JWT 토큰 필요

**쿼리 파라미터**:
```typescript
{
  startDate?: string;         // "2024-03-01" (YYYY-MM-DD)
  endDate?: string;           // "2024-03-31" (YYYY-MM-DD)
  exerciseName?: string;      // 운동명 필터
  bodyPart?: string;          // 부위 필터
  workoutType?: 'PT' | 'PERSONAL';  // 운동 타입 필터
  page?: number;
  limit?: number;
}
```

**응답 구조**:
```typescript
{
  success: true;
  data: {
    data: Array<WorkoutRecord>;
    total: number;
    page: number;
    limit: number;
  };
  message: string;
}
```

#### 3-3. 주요 운동 1RM 추정치 조회

**엔드포인트**: `GET /api/members/:id/one-rep-max-estimate`

**인증**: JWT 토큰 필요

**설명**: 3대 운동(벤치프레스, 스쿼트, 데드리프트)의 최신/최고 1RM 추정치와 히스토리를 조회합니다. 기록이 없으면 대체 운동을 자동 탐색합니다.

**응답 구조**:
```typescript
{
  success: true;
  data: {
    benchPress: {
      exerciseName: string;        // "벤치프레스" 또는 대체 운동명
      latestOneRepMax?: number;    // 최신 1RM
      bestOneRepMax?: number;      // 최고 1RM
      strengthLevel?: string;      // 현재 Strength Level
      history: Array<{
        workoutDate: string;
        oneRepMax: number;
        strengthLevel?: string;
      }>;
    };
    squat: { /* 동일한 구조 */ };
    deadlift: { /* 동일한 구조 */ };
  };
  message: string;
}
```

#### 3-4. 1RM 추세 데이터 조회

**엔드포인트**: `GET /api/members/:id/workout-records/one-rep-max-trend`

**인증**: JWT 토큰 필요

**쿼리 파라미터**:
```typescript
{
  exerciseName?: string;      // 운동명 (선택적, 없으면 전체)
  startDate?: string;         // "2024-03-01" (YYYY-MM-DD)
  endDate?: string;           // "2024-03-31" (YYYY-MM-DD)
}
```

**응답 구조**:
```typescript
{
  success: true;
  data: {
    exerciseName?: string;    // 필터링된 운동명
    trend: Array<{
      date: string;           // "2024-03-15"
      oneRepMax: number;      // 해당 날짜의 최고 1RM
      workoutCount: number;   // 해당 날짜의 운동 기록 개수
    }>;
  };
  message: string;
}
```

#### 3-5. 볼륨 추세 데이터 조회

**엔드포인트**: `GET /api/members/:id/workout-records/volume-trend`

**인증**: JWT 토큰 필요

**쿼리 파라미터**:
```typescript
{
  startDate?: string;         // "2024-03-01" (YYYY-MM-DD)
  endDate?: string;           // "2024-03-31" (YYYY-MM-DD)
  bodyPart?: string;          // 부위 필터 (선택적)
}
```

**응답 구조**:
```typescript
{
  success: true;
  data: {
    trend: Array<{
      date: string;           // "2024-03-15"
      totalVolume: number;    // 해당 날짜의 총 볼륨
      workoutCount: number;   // 해당 날짜의 운동 기록 개수
      bodyPartVolumes?: Array<{
        bodyPart: string;
        volume: number;
      }>;
    }>;
  };
  message: string;
}
```

#### 3-6. Strength Level 변화 추적

**엔드포인트**: `GET /api/members/:id/strength-progress`

**인증**: JWT 토큰 필요

**쿼리 파라미터**:
```typescript
{
  exerciseName?: string;      // 운동명 (선택적, 없으면 전체)
}
```

**응답 구조**:
```typescript
{
  success: true;
  data: {
    exerciseName?: string;
    currentLevel?: 'BEGINNER' | 'NOVICE' | 'INTERMEDIATE' | 'ADVANCED' | 'ELITE';
    history: Array<{
      workoutDate: string;
      oneRepMax: number;
      strengthLevel?: string;
      strengthLevelName?: string;  // "초보자", "입문자", "중급자", "고급자", "엘리트"
    }>;
  };
  message: string;
}
```

### 4. 운동 루틴 관련 API

#### 4-1. 운동 루틴 생성

**엔드포인트**: `POST /api/members/:id/workout-routines`

**인증**: JWT 토큰 필요

**요청 본문**:
```typescript
{
  routineName: string;        // "초보자 상체 루틴"
  routineDate?: string;      // "2024-03-15" (회원별 루틴인 경우)
  exercises: Array<{
    exerciseName: string;     // "벤치프레스"
    bodyPart: string;         // "가슴"
    sets: number;             // 3
    reps: number;             // 10
    weight?: number;          // 50 (kg, 선택적)
    restTime?: number;        // 60 (초, 선택적)
    notes?: string;           // "가슴 근육에 집중"
  }>;
  estimatedDuration: number;  // 예상 소요 시간 (분)
  difficulty: 'EASY' | 'MEDIUM' | 'HARD';
  suggestWeights?: boolean;  // Strength Level 기반 무게 자동 제안 여부
}
```

**응답 구조**:
```typescript
{
  success: true;
  data: {
    id: string;
    routineName: string;
    routineDate?: string;
    exercises: Array<{
      exerciseName: string;
      bodyPart: string;
      sets: number;
      reps: number;
      weight?: number;
      restTime?: number;
      notes?: string;
    }>;
    estimatedDuration: number;
    difficulty: 'EASY' | 'MEDIUM' | 'HARD';
    isCompleted: boolean;
    createdAt: string;
    updatedAt: string;
  };
  message: string;
}
```

**주의사항**:
- `suggestWeights: true`인 경우, `exercises[].weight`가 없으면 Strength Level 기반으로 자동 계산됨
- 자동 계산된 무게는 회원의 최신 1RM 또는 Strength Level 기준으로 제안됨

#### 4-2. 운동 루틴 목록 조회

**엔드포인트**: `GET /api/members/:id/workout-routines`

**인증**: JWT 토큰 필요

**쿼리 파라미터**:
```typescript
{
  startDate?: string;         // "2024-03-01" (YYYY-MM-DD)
  endDate?: string;           // "2024-03-31" (YYYY-MM-DD)
  isCompleted?: boolean;      // 완료 여부 필터
  page?: number;
  limit?: number;
}
```

#### 4-3. 루틴 운동 무게 제안

**엔드포인트**: `GET /api/members/:id/workout-routines/suggest-weight`

**인증**: JWT 토큰 필요

**쿼리 파라미터**:
```typescript
{
  exerciseName: string;       // 필수: "벤치프레스"
  reps: number;                // 필수: 10
}
```

**응답 구조**:
```typescript
{
  success: true;
  data: {
    exerciseName: string;
    suggestedWeightKg: number | null;  // 권장 무게 (kg), 계산 불가 시 null
  };
  message: string;
}
```

**설명**: 회원의 최신 Strength Level을 기반으로 특정 운동 및 반복 횟수에 대한 권장 무게를 제안합니다.

---

## 운동 기록 데이터 구조

### WorkoutRecord 엔티티

```typescript
interface WorkoutRecord {
  id: string;
  memberId: string;
  workoutDate: string;         // "2024-03-15" (YYYY-MM-DD)
  bodyPart: string;            // "가슴", "등", "어깨", "팔", "하체"
  exerciseName: string;        // "벤치프레스" 또는 "Bench Press"
  weight: number;              // 무게 (kg)
  reps: number;                // 횟수
  sets: number;                // 세트 수
  volume: number;              // 자동 계산: weight * reps * sets
  duration?: number;           // 운동 시간 (분)
  workoutType: 'PT' | 'PERSONAL';
  ptSessionId?: string;        // PT 세션 ID (workoutType이 'PT'인 경우)
  trainerComment?: string;     // 트레이너 코멘트
  oneRepMax?: number;          // 자동 계산: 1RM 추정값 (kg)
  relativeStrength?: number;   // 자동 계산: 상대적 강도 (%)
  strengthLevel?: 'BEGINNER' | 'NOVICE' | 'INTERMEDIATE' | 'ADVANCED' | 'ELITE';
  createdAt: string;
  updatedAt: string;
}
```

### 1RM 계산 공식

시스템은 Epley 공식을 기본으로 사용합니다:

```
1RM = weight × (1 + reps / 30)
```

**예시**:
- 80kg × 10회 → 1RM = 80 × (1 + 10/30) = 80 × 1.333 = 106.67kg

### 상대적 강도 계산

```
상대적 강도 (%) = (1RM / 체중) × 100
```

**예시**:
- 1RM: 100kg, 체중: 70kg → 상대적 강도 = (100 / 70) × 100 = 142.86%

### Strength Level 판정

Strength Level은 strengthlevel.com의 기준에 따라 판정됩니다:

- **BEGINNER** (초보자)
- **NOVICE** (입문자)
- **INTERMEDIATE** (중급자)
- **ADVANCED** (고급자)
- **ELITE** (엘리트)

판정 기준:
- 회원의 체중
- 회원의 성별
- 운동의 1RM
- strength_standards 테이블의 기준 데이터

---

## 운동 루틴 데이터 구조

### WorkoutRoutine 엔티티

```typescript
interface WorkoutRoutine {
  id: string;
  memberId?: string;           // null이면 공통 루틴
  routineName: string;          // "초보자 상체 루틴"
  routineDate?: string;         // "2024-03-15" (회원별 루틴인 경우)
  exercises: Array<{           // JSONB
    exerciseName: string;       // "벤치프레스"
    bodyPart: string;           // "가슴"
    sets: number;               // 3
    reps: number;               // 10
    weight?: number;           // 50 (kg)
    restTime?: number;         // 60 (초)
    notes?: string;            // "가슴 근육에 집중"
  }>;
  estimatedDuration: number;    // 예상 소요 시간 (분)
  difficulty: 'EASY' | 'MEDIUM' | 'HARD';
  isCompleted: boolean;        // 완료 여부
  createdAt: string;
  updatedAt: string;
}
```

---

## Strength Level 관련 데이터

### Strength Level 한글명 매핑

```typescript
const STRENGTH_LEVEL_NAMES = {
  BEGINNER: '초보자',
  NOVICE: '입문자',
  INTERMEDIATE: '중급자',
  ADVANCED: '고급자',
  ELITE: '엘리트',
};
```

### Strength Level 색상 가이드 (제안)

```typescript
const STRENGTH_LEVEL_COLORS = {
  BEGINNER: '#9E9E9E',      // 회색
  NOVICE: '#4CAF50',        // 초록색
  INTERMEDIATE: '#2196F3',  // 파란색
  ADVANCED: '#FF9800',      // 주황색
  ELITE: '#F44336',         // 빨간색
};
```

### Strength Level 아이콘 가이드 (제안)

```typescript
const STRENGTH_LEVEL_ICONS = {
  BEGINNER: '⭐',           // 1개 별
  NOVICE: '⭐⭐',           // 2개 별
  INTERMEDIATE: '⭐⭐⭐',   // 3개 별
  ADVANCED: '⭐⭐⭐⭐',     // 4개 별
  ELITE: '⭐⭐⭐⭐⭐',       // 5개 별
};
```

---

## UI 컴포넌트 가이드

### 1. 운동 선택 컴포넌트

**기능**:
- 카테고리 필터 (UPPER, LOWER, FULL_BODY)
- 부위 필터 (가슴, 등, 어깨, 팔, 하체)
- 검색 기능
- 최근 운동 우선 정렬

**API 호출 예시**:
```typescript
// 카테고리 선택 시
const exercises = await fetch(`/api/exercises?category=${selectedCategory}`);

// 부위 선택 시
const exercises = await fetch(`/api/exercises?bodyPart=${selectedBodyPart}`);

// 검색 시
const exercises = await fetch(`/api/exercises?search=${searchTerm}`);

// 회원의 최근 운동 우선 정렬
const exercises = await fetch(`/api/exercises?memberId=${memberId}`);
```

### 2. 운동 기록 입력 컴포넌트

**필수 입력 필드**:
- 운동 날짜
- 운동 선택 (운동 목록에서 선택)
- 무게 (kg)
- 횟수
- 세트 수
- 운동 타입 (PT / 개인)

**자동 계산 필드 (표시만)**:
- 볼륨 (weight × reps × sets)
- 1RM 추정값
- 상대적 강도
- Strength Level

**API 호출 예시**:
```typescript
const createWorkoutRecord = async (data: {
  workoutDate: string;
  bodyPart: string;
  exerciseName: string;
  weight: number;
  reps: number;
  sets: number;
  workoutType: 'PT' | 'PERSONAL';
}) => {
  const response = await fetch(`/api/members/${memberId}/workout-records`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify(data),
  });
  
  const result = await response.json();
  
  // Strength Level 표시
  if (result.data.strengthLevel) {
    showStrengthLevelBadge(result.data.strengthLevel);
  }
  
  return result.data;
};
```

### 3. 운동 기록 분석 컴포넌트

**기능**:
- 주간/월간 운동량 표시
- 요일별 운동 기록 상세
- 운동별 세트/무게 표시
- 1RM 추세 그래프
- 볼륨 추세 그래프

**API 호출 예시**:
```typescript
// 주간 볼륨 추세
const volumeTrend = await fetch(
  `/api/members/${memberId}/workout-records/volume-trend?startDate=${startDate}&endDate=${endDate}`
);

// 1RM 추세
const oneRepMaxTrend = await fetch(
  `/api/members/${memberId}/workout-records/one-rep-max-trend?exerciseName=${exerciseName}`
);

// Strength Level 변화
const strengthProgress = await fetch(
  `/api/members/${memberId}/strength-progress?exerciseName=${exerciseName}`
);
```

### 4. 1RM 추정 모달/페이지

**기능**:
- 주요 운동(빅3)의 1RM 추정치 표시
- Strength Level 표시
- 히스토리 그래프

**API 호출 예시**:
```typescript
const oneRepMaxEstimate = await fetch(
  `/api/members/${memberId}/one-rep-max-estimate`
);

// 응답 데이터 구조
const { benchPress, squat, deadlift } = oneRepMaxEstimate.data;

// 벤치프레스 정보 표시
console.log('최신 1RM:', benchPress.latestOneRepMax);
console.log('최고 1RM:', benchPress.bestOneRepMax);
console.log('현재 레벨:', benchPress.strengthLevel);
```

### 5. 운동 루틴 생성 컴포넌트

**기능**:
- 운동 추가/제거
- 세트/횟수/무게 설정
- 무게 자동 제안 (Strength Level 기반)
- 루틴 저장

**API 호출 예시**:
```typescript
// 무게 제안 요청
const suggestWeight = async (exerciseName: string, reps: number) => {
  const response = await fetch(
    `/api/members/${memberId}/workout-routines/suggest-weight?exerciseName=${exerciseName}&reps=${reps}`
  );
  const result = await response.json();
  return result.data.suggestedWeightKg;
};

// 루틴 생성
const createRoutine = async (routineData: {
  routineName: string;
  exercises: Array<{
    exerciseName: string;
    bodyPart: string;
    sets: number;
    reps: number;
    weight?: number;
  }>;
  estimatedDuration: number;
  difficulty: 'EASY' | 'MEDIUM' | 'HARD';
  suggestWeights: boolean;
}) => {
  const response = await fetch(`/api/members/${memberId}/workout-routines`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify(routineData),
  });
  
  return await response.json();
};
```

---

## 사용 예시

### 예시 1: 운동 선택 UI 구현

```typescript
// React 컴포넌트 예시
const ExerciseSelector = ({ memberId, onSelect }) => {
  const [exercises, setExercises] = useState([]);
  const [category, setCategory] = useState('UPPER');
  const [bodyPart, setBodyPart] = useState('');
  const [search, setSearch] = useState('');

  useEffect(() => {
    const fetchExercises = async () => {
      const params = new URLSearchParams({
        category,
        ...(bodyPart && { bodyPart }),
        ...(search && { search }),
        ...(memberId && { memberId }),
      });
      
      const response = await fetch(`/api/exercises?${params}`);
      const result = await response.json();
      setExercises(result.data.data);
    };
    
    fetchExercises();
  }, [category, bodyPart, search, memberId]);

  return (
    <div>
      {/* 카테고리 필터 */}
      <select value={category} onChange={(e) => setCategory(e.target.value)}>
        <option value="UPPER">상체</option>
        <option value="LOWER">하체</option>
        <option value="FULL_BODY">전신</option>
      </select>
      
      {/* 부위 필터 */}
      <select value={bodyPart} onChange={(e) => setBodyPart(e.target.value)}>
        <option value="">전체</option>
        <option value="가슴">가슴</option>
        <option value="등">등</option>
        <option value="어깨">어깨</option>
        <option value="팔">팔</option>
        <option value="하체">하체</option>
      </select>
      
      {/* 검색 */}
      <input
        type="text"
        placeholder="운동명 검색"
        value={search}
        onChange={(e) => setSearch(e.target.value)}
      />
      
      {/* 운동 목록 */}
      <ul>
        {exercises.map((exercise) => (
          <li key={exercise.id} onClick={() => onSelect(exercise)}>
            {exercise.name} ({exercise.nameEn})
            {exercise.recentCount && (
              <span>최근 {exercise.recentCount}회</span>
            )}
          </li>
        ))}
      </ul>
    </div>
  );
};
```

### 예시 2: 운동 기록 입력 UI 구현

```typescript
const WorkoutRecordForm = ({ memberId, workoutDate }) => {
  const [exercise, setExercise] = useState(null);
  const [weight, setWeight] = useState(0);
  const [reps, setReps] = useState(0);
  const [sets, setSets] = useState(0);
  const [estimatedOneRepMax, setEstimatedOneRepMax] = useState(null);

  // 1RM 자동 계산
  useEffect(() => {
    if (weight > 0 && reps > 0) {
      const oneRepMax = weight * (1 + reps / 30);
      setEstimatedOneRepMax(oneRepMax);
    }
  }, [weight, reps]);

  const handleSubmit = async () => {
    const response = await fetch(`/api/members/${memberId}/workout-records`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`,
      },
      body: JSON.stringify({
        workoutDate,
        bodyPart: exercise.bodyPart,
        exerciseName: exercise.name,
        weight,
        reps,
        sets,
        workoutType: 'PERSONAL',
      }),
    });
    
    const result = await response.json();
    
    // Strength Level 표시
    if (result.data.strengthLevel) {
      alert(`Strength Level: ${STRENGTH_LEVEL_NAMES[result.data.strengthLevel]}`);
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* 운동 선택 */}
      <ExerciseSelector onSelect={setExercise} />
      
      {/* 무게, 횟수, 세트 입력 */}
      <input
        type="number"
        placeholder="무게 (kg)"
        value={weight}
        onChange={(e) => setWeight(Number(e.target.value))}
      />
      <input
        type="number"
        placeholder="횟수"
        value={reps}
        onChange={(e) => setReps(Number(e.target.value))}
      />
      <input
        type="number"
        placeholder="세트"
        value={sets}
        onChange={(e) => setSets(Number(e.target.value))}
      />
      
      {/* 자동 계산된 값 표시 */}
      {estimatedOneRepMax && (
        <div>
          <p>예상 1RM: {estimatedOneRepMax.toFixed(1)}kg</p>
          <p>볼륨: {(weight * reps * sets).toFixed(1)}kg</p>
        </div>
      )}
      
      <button type="submit">저장</button>
    </form>
  );
};
```

### 예시 3: 1RM 추정 모달 구현

```typescript
const OneRepMaxModal = ({ memberId, isOpen, onClose }) => {
  const [data, setData] = useState(null);

  useEffect(() => {
    if (isOpen) {
      fetch(`/api/members/${memberId}/one-rep-max-estimate`)
        .then(res => res.json())
        .then(result => setData(result.data));
    }
  }, [memberId, isOpen]);

  if (!isOpen || !data) return null;

  return (
    <div className="modal">
      <h2>내 예상 1RM은?</h2>
      
      {/* 벤치프레스 */}
      <div>
        <h3>벤치프레스</h3>
        <p>최신 1RM: {data.benchPress.latestOneRepMax?.toFixed(1)}kg</p>
        <p>최고 1RM: {data.benchPress.bestOneRepMax?.toFixed(1)}kg</p>
        {data.benchPress.strengthLevel && (
          <p>
            Strength Level: {STRENGTH_LEVEL_NAMES[data.benchPress.strengthLevel]}
          </p>
        )}
      </div>
      
      {/* 스쿼트 */}
      <div>
        <h3>스쿼트</h3>
        {/* 동일한 구조 */}
      </div>
      
      {/* 데드리프트 */}
      <div>
        <h3>데드리프트</h3>
        {/* 동일한 구조 */}
      </div>
      
      <button onClick={onClose}>닫기</button>
    </div>
  );
};
```

### 예시 4: 운동 기록 분석 그래프 구현

```typescript
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';

const WorkoutAnalysisChart = ({ memberId, exerciseName }) => {
  const [trendData, setTrendData] = useState([]);

  useEffect(() => {
    const fetchTrend = async () => {
      const response = await fetch(
        `/api/members/${memberId}/workout-records/one-rep-max-trend?exerciseName=${exerciseName}`
      );
      const result = await response.json();
      
      // 그래프 데이터 포맷팅
      const chartData = result.data.trend.map(item => ({
        date: item.date,
        oneRepMax: item.oneRepMax,
      }));
      
      setTrendData(chartData);
    };
    
    fetchTrend();
  }, [memberId, exerciseName]);

  return (
    <LineChart width={600} height={300} data={trendData}>
      <CartesianGrid strokeDasharray="3 3" />
      <XAxis dataKey="date" />
      <YAxis />
      <Tooltip />
      <Legend />
      <Line
        type="monotone"
        dataKey="oneRepMax"
        stroke="#8884d8"
        name="1RM (kg)"
      />
    </LineChart>
  );
};
```

---

## 주의사항

### 1. 운동명 매칭

운동명은 한글명 또는 영문명으로 매칭됩니다:
- `exercises.name` (한글명): "벤치프레스"
- `exercises.name_en` (영문명): "Bench Press"
- `workout_records.exercise_name`: "벤치프레스" 또는 "Bench Press" 모두 가능

### 2. Strength Level 계산 조건

Strength Level이 계산되려면:
- ✅ 회원의 체중 정보 필요
- ✅ 회원의 성별 정보 필요
- ✅ 해당 운동의 Strength Standards 데이터 필요

조건이 충족되지 않으면 `strengthLevel`은 `null`로 저장됩니다.

### 3. 데이터 단위

- 모든 무게는 **kg** 단위입니다
- 시간은 **분** 단위입니다
- 휴식 시간은 **초** 단위입니다

### 4. 페이징

운동 목록 API는 페이징을 지원합니다:
- 기본값: `page=1`, `limit=50`
- 최대값: `limit=100`

---

## 추가 리소스

- **API 문서**: Swagger UI (`/api/docs`)
- **Strength Level 가이드**: `docs/STRENGTH_LEVEL_API_GUIDE.md`
- **free-exercise-db 통합 가이드**: `docs/FREE_EXERCISE_DB_INTEGRATION.md`
- **필터링 가이드**: `docs/FREE_EXERCISE_DB_FILTERING.md`

---

## AI 활용 팁

이 문서를 AI 도구에 제공하면:

1. **API 호출 코드 생성**: "운동 목록을 가져오는 React 훅을 만들어줘"
2. **컴포넌트 생성**: "운동 기록 입력 폼 컴포넌트를 만들어줘"
3. **그래프 구현**: "1RM 추세 그래프를 Recharts로 만들어줘"
4. **타입 정의**: "WorkoutRecord 타입을 정의해줘"

**예시 프롬프트**:
```
이 문서를 참고해서 운동 기록 입력 폼을 만들어줘.
- 운동 선택 (카테고리, 부위 필터)
- 무게, 횟수, 세트 입력
- 1RM 자동 계산 표시
- Strength Level 표시
```

---

**이 문서는 지속적으로 업데이트됩니다. 새로운 API가 추가되면 이 문서도 함께 업데이트하세요.**
