# Strength Level API 가이드 (프론트엔드 개발자용)

> **목적**: StrengthLevel.com 기반 운동별 상대적 강도 평가 시스템 API 사용 가이드

---

## 📋 목차

1. [개요 및 활용 시나리오](#개요-및-활용-시나리오)
2. [일반적인 활용 방법](#일반적인-활용-방법)
3. [API 엔드포인트](#api-엔드포인트)
4. [데이터 구조](#데이터-구조)
5. [사용 예시](#사용-예시)
6. [주의사항](#주의사항)

---

## 개요 및 활용 시나리오

### Strength Level이란?

Strength Level은 회원의 운동 기록(무게, 횟수)과 체중, 성별을 기반으로 **StrengthLevel.com의 기준**에 따라 운동별 상대적 강도를 평가하는 시스템입니다.

### 주요 활용 시나리오

#### 1. **회원 동기 부여**
- 회원이 자신의 현재 레벨을 확인하고 목표 레벨을 설정
- 시간에 따른 레벨 향상 추적으로 성취감 제공
- 예: "벤치프레스 초보자 → 입문자 달성!"

#### 2. **트레이너의 객관적 평가**
- 회원의 운동 능력을 객관적인 레벨로 평가
- 다른 회원들과의 비교 가능
- 맞춤형 운동 프로그램 제안의 기준

#### 3. **진행 상황 추적**
- 운동 기록을 저장할 때마다 자동으로 레벨 계산
- 시간에 따른 레벨 변화를 그래프로 시각화
- 목표 달성 여부 확인

#### 4. **평가 시스템 통합**
- 초기 평가/정기 평가 시 근력 평가 항목에 Strength Level 자동 포함
- 종합 평가 점수와 함께 Strength Level 표시

---

## 일반적인 활용 방법

### 시나리오 1: 운동 기록 저장 시 레벨 표시

**사용자 플로우:**
1. 회원이 운동 기록 입력 (벤치프레스 80kg × 10회 × 3세트)
2. 저장 시 자동으로 1RM, 상대적 강도, 레벨 계산
3. 저장 완료 후 레벨 배지 표시
   - 예: "🎯 벤치프레스 중급자 달성!"

**UI 예시:**
```
[운동 기록 저장 완료]

벤치프레스 기록이 저장되었습니다.

💪 Strength Level: 중급자 (INTERMEDIATE)
📊 1RM: 100.5kg
📈 상대적 강도: 150.25% (체중 70kg 기준)
```

### 시나리오 2: 운동별 레벨 대시보드

**사용자 플로우:**
1. 회원 대시보드에서 주요 운동별 현재 레벨 확인
2. 각 운동의 레벨을 카드 형태로 표시
3. 클릭 시 상세 정보 및 변화 그래프 확인

**UI 예시:**
```
[운동별 Strength Level]

┌─────────────┬─────────────┬─────────────┐
│ 벤치프레스   │ 스쿼트      │ 데드리프트  │
│ 중급자 ⭐⭐⭐ │ 입문자 ⭐⭐  │ 고급자 ⭐⭐⭐⭐│
│ 1RM: 100kg  │ 1RM: 120kg  │ 1RM: 180kg  │
└─────────────┴─────────────┴─────────────┘
```

### 시나리오 3: 레벨 향상 추적 그래프

**사용자 플로우:**
1. 특정 운동 선택 (예: 벤치프레스)
2. 시간에 따른 1RM, 상대적 강도, 레벨 변화 그래프 표시
3. 목표 레벨까지의 진행 상황 확인

**UI 예시:**
```
[벤치프레스 Strength Level 추적]

현재 레벨: 중급자 (INTERMEDIATE)
목표 레벨: 고급자 (ADVANCED) - 20kg 더 필요

[그래프: 시간에 따른 1RM 변화]
Jan: 80kg (입문자) → Feb: 95kg (중급자) → Mar: 100kg (중급자)
```

### 시나리오 4: 평가 리포트에 포함

**사용자 플로우:**
1. 초기 평가 또는 정기 평가 시 근력 평가 항목 입력
2. 평가 항목의 details에 Strength Level 자동 포함
3. 평가 리포트에 Strength Level 정보 표시

**UI 예시:**
```
[평가 리포트 - 근력 평가]

벤치프레스
- 측정값: 80kg × 10회
- Strength Level: 중급자 (INTERMEDIATE)
- 1RM: 100.5kg
- 상대적 강도: 150.25%
```

---

## 질문: 어떻게 활용하고 싶으신가요?

다음 질문에 답변해주시면 가이드를 더 구체적으로 작성하겠습니다.

### 1. 주요 활용 목적

어떤 목적으로 Strength Level 기능을 사용하고 싶으신가요?

- [ ] 회원 동기 부여 (레벨 달성, 목표 설정)
- [ ] 트레이너의 객관적 평가 도구
- [ ] 진행 상황 추적 및 시각화
- [ ] 평가 시스템과의 통합
- [ ] 기타 (설명 필요)

### 2. UI에서 표시하고 싶은 정보

어떤 정보를 UI에 표시하고 싶으신가요?

- [ ] 현재 레벨만 (BEGINNER, NOVICE 등)
- [ ] 레벨 + 1RM + 상대적 강도
- [ ] 레벨 + 다음 레벨까지 필요한 무게
- [ ] 레벨 + 전체 사용자 대비 백분위수
- [ ] 기타 (설명 필요)

### 3. 추가하고 싶은 기능

현재 구현된 기능 외에 추가하고 싶은 기능이 있나요?

- [ ] 운동 목록 조회 API (GET /api/exercises)
- [ ] Strength Standards 조회 API (기준 데이터 확인)
- [ ] 목표 레벨 설정 기능
- [ ] 레벨 달성 알림/알림 기능
- [ ] 회원 간 레벨 비교 기능
- [ ] 기타 (설명 필요)

### 4. 제거하거나 수정하고 싶은 기능

현재 구현된 기능 중 제거하거나 수정하고 싶은 부분이 있나요?

- [ ] 없음 (현재 구조 유지)
- [ ] 자동 계산 로직 수정 필요
- [ ] API 응답 구조 변경 필요
- [ ] 기타 (설명 필요)

### 5. UI/UX 제안

UI/UX 관점에서 추가하고 싶은 내용이 있나요?

- [ ] Strength Level 배지 디자인 가이드
- [ ] 그래프 차트 예시 코드 (Recharts 등)
- [ ] 레벨별 색상/아이콘 가이드
- [ ] 모바일 반응형 디자인 가이드
- [ ] 기타 (설명 필요)

---

## API 엔드포인트

### 1. 운동 기록의 Strength Level 조회

특정 운동 기록의 Strength Level 정보를 조회합니다.

**엔드포인트:**
```
GET /api/members/:id/workout-records/:recordId/strength-level
```

**파라미터:**
- `id` (path): 회원 ID
- `recordId` (path): 운동 기록 ID

**응답 예시:**
```json
{
  "success": true,
  "data": {
    "oneRepMax": 100.5,
    "relativeStrength": 150.25,
    "strengthLevel": "INTERMEDIATE",
    "strengthLevelName": "중급자",
    "bodyWeight": 70.0,
    "standardWeight": 95.0
  },
  "message": "Strength Level 조회 성공"
}
```

**응답 필드 설명:**
- `oneRepMax`: 1RM 계산값 (kg)
- `relativeStrength`: 상대적 강도 (체중 대비 무게 비율, %)
- `strengthLevel`: Strength Level 판정 결과 (`BEGINNER`, `NOVICE`, `INTERMEDIATE`, `ADVANCED`, `ELITE` 또는 `null`)
- `strengthLevelName`: Strength Level 한글명 (`초보자`, `입문자`, `중급자`, `고급자`, `엘리트`)
- `bodyWeight`: 회원의 체중 (kg)
- `standardWeight`: 해당 레벨의 기준 무게 (kg)

---

### 2. 운동별 Strength Level 변화 추적

회원의 운동별 Strength Level 변화를 시간순으로 조회합니다.

**엔드포인트:**
```
GET /api/members/:id/strength-progress?exerciseName={운동명}
```

**파라미터:**
- `id` (path): 회원 ID
- `exerciseName` (query, 선택): 운동명 (없으면 모든 운동)

**응답 예시:**
```json
{
  "success": true,
  "data": {
    "exerciseName": "벤치프레스",
    "history": [
      {
        "oneRepMax": 80.0,
        "relativeStrength": 120.0,
        "strengthLevel": "NOVICE",
        "strengthLevelName": "입문자",
        "workoutDate": "2024-01-15"
      },
      {
        "oneRepMax": 95.0,
        "relativeStrength": 142.5,
        "strengthLevel": "INTERMEDIATE",
        "strengthLevelName": "중급자",
        "workoutDate": "2024-02-15"
      },
      {
        "oneRepMax": 100.5,
        "relativeStrength": 150.25,
        "strengthLevel": "INTERMEDIATE",
        "strengthLevelName": "중급자",
        "workoutDate": "2024-03-15"
      }
    ],
    "current": {
      "oneRepMax": 100.5,
      "relativeStrength": 150.25,
      "strengthLevel": "INTERMEDIATE",
      "strengthLevelName": "중급자"
    }
  },
  "message": "Strength Level 변화 추적 조회 성공"
}
```

---

## 데이터 구조

### WorkoutRecord 응답에 포함되는 필드

운동 기록 조회 API 응답에 다음 필드가 포함됩니다:

```typescript
interface WorkoutRecord {
  id: string;
  memberId: string;
  workoutDate: string;
  exerciseName: string;
  weight: number;        // 무게 (kg)
  reps: number;          // 횟수
  sets: number;          // 세트 수
  volume: number;        // 볼륨 (weight * reps * sets)
  
  // Strength Level 관련 필드 (자동 계산)
  oneRepMax?: number;              // 1RM (kg)
  relativeStrength?: number;        // 상대적 강도 (%)
  strengthLevel?: StrengthLevel;    // Strength Level
}
```

### AssessmentItem의 details 필드

평가 항목의 `details` 필드에 Strength Level 정보가 포함됩니다:

```typescript
interface AssessmentItem {
  id: string;
  category: "STRENGTH";
  name: string;
  value: number;
  unit: string;
  details?: {
    // 기존 필드들...
    grade?: string;
    internalScore?: number;
    
    // Strength Level 관련 필드 (STRENGTH 카테고리인 경우 자동 추가)
    strengthLevel?: string;        // Strength Level
    oneRepMax?: number;            // 1RM (kg)
    relativeStrength?: number;     // 상대적 강도 (%)
  };
}
```

---

## 사용 예시

### 예시 1: 운동 기록 저장 후 Strength Level 확인

```typescript
// 1. 운동 기록 저장
const createWorkoutRecord = async (memberId: string, data: CreateWorkoutRecordDto) => {
  const response = await fetch(`/api/members/${memberId}/workout-records`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    },
    body: JSON.stringify({
      workoutDate: '2024-03-15',
      exerciseName: '벤치프레스',
      bodyPart: '가슴',
      weight: 80,
      reps: 10,
      sets: 3,
    }),
  });
  
  const result = await response.json();
  return result.data; // WorkoutRecord 객체 (oneRepMax, relativeStrength, strengthLevel 포함)
};

// 2. 저장된 기록에서 Strength Level 확인
const record = await createWorkoutRecord(memberId, workoutData);
console.log('1RM:', record.oneRepMax);           // 예: 100.5
console.log('상대적 강도:', record.relativeStrength); // 예: 150.25
console.log('레벨:', record.strengthLevel);      // 예: "INTERMEDIATE"
```

### 예시 2: 특정 운동 기록의 Strength Level 조회

```typescript
const getStrengthLevel = async (memberId: string, recordId: string) => {
  const response = await fetch(
    `/api/members/${memberId}/workout-records/${recordId}/strength-level`,
    {
      headers: {
        'Authorization': `Bearer ${token}`,
      },
    }
  );
  
  const result = await response.json();
  return result.data;
};

// 사용
const strengthInfo = await getStrengthLevel(memberId, recordId);
console.log('현재 레벨:', strengthInfo.strengthLevelName); // "중급자"
```

### 예시 3: 운동별 Strength Level 변화 추적 (그래프용)

```typescript
const getStrengthProgress = async (memberId: string, exerciseName?: string) => {
  const url = `/api/members/${memberId}/strength-progress${
    exerciseName ? `?exerciseName=${exerciseName}` : ''
  }`;
  
  const response = await fetch(url, {
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  });
  
  const result = await response.json();
  return result.data;
};

// 사용 - 벤치프레스 변화 추적
const progress = await getStrengthProgress(memberId, '벤치프레스');

// 그래프 데이터 준비
const chartData = progress.history.map((item) => ({
  date: item.workoutDate,
  oneRepMax: item.oneRepMax,
  relativeStrength: item.relativeStrength,
  level: item.strengthLevel,
  levelName: item.strengthLevelName,
}));

// Recharts 등으로 그래프 그리기
```

---

## 주의사항

### 1. Strength Level 계산 조건

Strength Level이 계산되려면 다음 조건이 필요합니다:

- ✅ 회원의 **체중** 정보가 있어야 함 (`members.weight`)
- ✅ 회원의 **성별** 정보가 있어야 함 (`members.gender`)
- ✅ 운동명이 `exercises` 테이블에 등록되어 있어야 함
- ✅ 해당 운동의 Strength Standards 데이터가 있어야 함

조건이 충족되지 않으면:
- `oneRepMax`와 `relativeStrength`는 계산되지만
- `strengthLevel`은 `null`로 저장됩니다

### 2. 운동명 매칭

운동명은 다음 순서로 매칭됩니다:

1. `exercises.name` (한글명) - 예: "벤치프레스"
2. `exercises.name_en` (영문명) - 예: "Bench Press"

한글명 또는 영문명 중 하나라도 일치하면 매칭됩니다.

### 3. Strength Standards 데이터

Strength Level 판정을 위해서는 `strength_standards` 테이블에 해당 운동의 기준 데이터가 있어야 합니다.

현재는 예시 데이터만 포함되어 있으므로, 실제 사용 시 strengthlevel.com에서 데이터를 수집하여 추가해야 합니다.

---

## 질문 및 피드백

이 가이드에 대한 질문이나 수정 요청이 있으면 백엔드 개발자에게 문의하세요!














1. 주요 활용 목적
어떤 목적으로 Strength Level 기능을 사용하시겠습니까?

  - 기존의 초기평가는 운동을 처음접해보는 사람 위주의 평가임.
  - 이제 만드는 DB구조를 기준삼아 운동을 하는사람 또는 트레이너가 운동을 입력 
      ex) 등 카테고리 선택하면 등운동에 속한 운동들이 나오고 해당 운동선택시
          몇세트 몇회씩 세트당 무게 설정.(커스텀도 가능하고 선택도 가능하게)
  - 그에 따라 회원의 운동을 기록해놓고 초기평가의 레이더차트와 다른 방식(지금 생각하고있는 방식은 우상향하는 그래프형태)
    으로 운동일지 처럼 기록하고 관리를 원함. 평가의 느낌이 아니라 운동하면서 성장하고있다는걸 보여주는 느낌. 그에따른 성취감, 부족한부분 제공을 느끼게.

2. UI에서 표시하고 싶은 정보
어떤 정보를 UI에 표시하시겠습니까?

  - 보내준 사진의 운동기록분석 쪽에쓸수있는 데이터들을 원함. 
    일주일에 총 운동량을 기록하고 요일별로 눌러보면 그날 어떤운동을햇는지 운동별로 몇세트 몇키로의 무게로 햇는지 등등.
    회원은 자기관리형식으로 쓰고, 트레이너는 해당데이터로 회원관리에 용이하도록
  - 위에서 만든 그래프를 어떻게 활용할지도 생각중. 어떤그래프로 표시하고 몇일간의 데이터와 비교분석해야 할지 등등. 
  - 조그만 알림 모달처럼 '내예상 1rm은?' 정도의 문구와 함께 누르면 아예 다른 탭으로 이동해서 내 데이터들을 종합해서 예상 1rm 표시하고싶어.(1rm추정식 필요)
    거기에 추가적으로 "strengthlevel.com"의 기준표에 따라 초보자 초심자 중급 고급 엘리트 로 내 운동 수준이 어느정도인지 알려주는것도 같이

3. 추가하고 싶은 기능
현재 구현된 기능 외에 추가하고 싶은 기능이 있나요?

  - 그동안 회원, 트레이너가 입력했던 운동을 기반으로 다음 운동때 내가 자주하던 운동들을 루틴으로 묶어주고 세트수 지정해서 캘린더에 등록하고싶음.
  -
  -
  -
  -
  -     

4. 제거하거나 수정하고 싶은 기능
  현재 구현된 기능 중 제거하거나 수정하고 싶은 부분이 있나요?
  - 플랜이전의 기능들은 터치할 이유가 없음.
  -
  -
  -
  -
  -

5. UI/UX 제안
  UI/UX 관점에서 추가하고 싶은 내용이 있나요?
  - Strength Level 배지 디자인 가이드
  - 그래프 차트 예시 코드 (Recharts 등)
  - 레벨별 색상/아이콘 가이드
  - 모바일 반응형 디자인 가이드
  - 기타 (설명 필요)