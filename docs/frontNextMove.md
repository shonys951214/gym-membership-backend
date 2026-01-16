# 프론트엔드 개발 가이드 - Strength Level 기능

## 📅 작성일: 2026-01-16

---

## 🎉 오늘 추가된 데이터베이스 내용

### 빅3 운동 Strength Level 기준 데이터 추가 완료

오늘 데이터베이스에 **빅3 운동(벤치프레스, 스쿼트, 데드리프트)의 Strength Level 기준 데이터**를 모두 추가했습니다.

#### 추가된 데이터 요약

| 운동 | 성별 | 체중별 데이터 | 나이별 데이터 | 총 INSERT |
|------|------|--------------|--------------|-----------|
| 벤치프레스 | 남성 | 95개 | 80개 | 175개 |
| 벤치프레스 | 여성 | 85개 | 80개 | 165개 |
| 스쿼트 | 남성 | 95개 | 80개 | 175개 |
| 스쿼트 | 여성 | 85개 | 80개 | 165개 |
| 데드리프트 | 남성 | 95개 | 80개 | 175개 |
| 데드리프트 | 여성 | 85개 | 80개 | 165개 |
| **합계** | - | **540개** | **480개** | **1,020개** |

#### 데이터 구조

- **체중별 기준 (BODYWEIGHT)**: 회원의 체중에 따라 Strength Level 평가
  - 남성: 50kg ~ 140kg (5kg 단위)
  - 여성: 40kg ~ 120kg (5kg 단위)
  
- **나이별 기준 (AGE)**: 회원의 나이에 따라 Strength Level 평가
  - 15세 ~ 90세 (5세 단위)

- **레벨**: 5단계
  - BEGINNER (초급)
  - NOVICE (중급)
  - INTERMEDIATE (숙련)
  - ADVANCED (고급)
  - ELITE (엘리트)

---

## 🚀 다음에 구현할 기능들

### 1. Strength Level 표시 기능 (High Priority)

#### 1.1 운동 기록 화면
- **위치**: 운동 기록 상세 화면 또는 목록 화면
- **표시 내용**:
  - 현재 Strength Level (예: "INTERMEDIATE")
  - 현재 1RM (One Rep Max)
  - 다음 레벨까지 필요한 무게
  - 진행률 (Progress Bar)

#### 1.2 대시보드
- **위치**: 회원 대시보드
- **표시 내용**:
  - 빅3 운동 종합 Strength Level 카드
  - 각 운동별 현재 레벨 표시
  - 최근 Strength Level 변화 추이

#### API 엔드포인트
```
GET /members/:memberId/strength-level/:exerciseId
```

**응답 예시**:
```json
{
  "level": "INTERMEDIATE",
  "currentWeight": 100.5,
  "bodyWeight": 75.0,
  "nextLevel": {
    "level": "ADVANCED",
    "targetWeight": 120.0,
    "progressPercentage": 83.75
  }
}
```

---

### 2. 1RM 트렌드 그래프 (High Priority)

#### 2.1 그래프 표시
- **위치**: 운동 기록 상세 화면 또는 통계 화면
- **표시 내용**:
  - 시간축: 날짜 (X축)
  - 값: 1RM (Y축)
  - 운동별로 다른 색상의 라인
  - 빅3 운동 각각 표시

#### 2.2 그래프 타입
- **선 그래프 (Line Chart)**: 추세 확인
- **상승 추세 강조**: 사용자 동기부여

#### API 엔드포인트
```
GET /members/:memberId/workout-records/trends?exerciseIds=exerciseId1,exerciseId2&startDate=2026-01-01&endDate=2026-01-31
```

**응답 예시**:
```json
{
  "exerciseId": "uuid",
  "exerciseName": "벤치프레스",
  "trends": [
    {
      "date": "2026-01-01",
      "oneRepMax": 80.0
    },
    {
      "date": "2026-01-15",
      "oneRepMax": 85.5
    }
  ]
}
```

---

### 3. 볼륨 트렌드 그래프 (Medium Priority)

#### 3.1 그래프 표시
- **위치**: 운동 기록 상세 화면 또는 통계 화면
- **표시 내용**:
  - 시간축: 날짜 (X축)
  - 값: 총 볼륨 (weight × reps × sets) (Y축)
  - 운동별로 다른 색상의 라인

#### API 엔드포인트
```
GET /members/:memberId/workout-records/volume-trends?exerciseIds=exerciseId1,exerciseId2&startDate=2026-01-01&endDate=2026-01-31
```

---

### 4. 운동 루틴 생성 시 무게 제안 (Medium Priority)

#### 4.1 기능 설명
- 운동 루틴 생성 시 Strength Level 기반으로 권장 무게 자동 제안
- 사용자가 수동으로 무게를 입력할 수도 있음

#### 4.2 UI/UX
- 운동 추가 시 "권장 무게" 버튼 또는 자동 채우기 옵션
- 제안된 무게 옆에 Strength Level 표시

#### API 엔드포인트
```
POST /members/:memberId/workout-routines
```

**요청 예시**:
```json
{
  "routineName": "상체 운동",
  "exercises": [
    {
      "exerciseId": "uuid",
      "sets": 3,
      "reps": 10,
      "weight": null,  // suggestWeights: true일 경우 자동 계산
      "suggestWeight": true
    }
  ],
  "suggestWeights": true
}
```

**응답 예시**:
```json
{
  "id": "uuid",
  "routineName": "상체 운동",
  "exercises": [
    {
      "exerciseId": "uuid",
      "exerciseName": "벤치프레스",
      "suggestedWeight": 85.0,
      "strengthLevel": "INTERMEDIATE"
    }
  ]
}
```

---

### 5. 운동 목록 화면 개선 (Low Priority)

#### 5.1 최근 수행한 운동 우선순위
- 운동 선택 화면에서 최근 수행한 운동이 상단에 표시
- "최근 수행" 배지 표시

#### API 엔드포인트
```
GET /exercises?memberId=uuid&includeRecent=true&category=UPPER
```

**응답 예시**:
```json
{
  "exercises": [
    {
      "id": "uuid",
      "name": "벤치프레스",
      "nameEn": "Bench Press",
      "category": "UPPER",
      "recentCount": 5,  // 최근 5회 수행
      "lastPerformed": "2026-01-15"
    }
  ],
  "total": 100
}
```

---

## 📊 UI/UX 요구사항

### 1. Strength Level 표시
- **색상 코딩**:
  - BEGINNER: 회색 또는 연한 파란색
  - NOVICE: 파란색
  - INTERMEDIATE: 초록색
  - ADVANCED: 주황색
  - ELITE: 금색 또는 빨간색

- **아이콘/배지**: 레벨별 아이콘 또는 배지 표시

### 2. 그래프/차트
- **라이브러리 추천**: Chart.js, Recharts, Victory 등
- **반응형**: 모바일/태블릿/데스크톱 모두 지원
- **인터랙션**: 호버 시 상세 정보 표시, 줌/팬 기능

### 3. 진행률 표시
- **Progress Bar**: 다음 레벨까지의 진행률
- **퍼센트 표시**: "83.75% 달성"
- **목표 무게 표시**: "다음 레벨까지 19.5kg 남음"

---

## 🔌 API 엔드포인트 정리

### Strength Level 관련

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| GET | `/members/:memberId/strength-level/:exerciseId` | 특정 운동의 Strength Level 조회 |
| GET | `/members/:memberId/workout-records/trends` | 1RM 트렌드 조회 |
| GET | `/members/:memberId/workout-records/volume-trends` | 볼륨 트렌드 조회 |

### 운동 기록 관련

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| POST | `/members/:memberId/workout-records` | 운동 기록 생성 (자동 Strength Level 계산) |
| PUT | `/members/:memberId/workout-records/:recordId` | 운동 기록 수정 (자동 Strength Level 업데이트) |
| GET | `/members/:memberId/workout-records` | 운동 기록 목록 조회 |

### 운동 루틴 관련

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| POST | `/members/:memberId/workout-routines` | 운동 루틴 생성 (무게 제안 옵션) |

### 운동 목록 관련

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| GET | `/exercises` | 운동 목록 조회 (최근 수행 운동 우선순위 옵션) |

---

## 📝 데이터 구조

### Strength Level 평가 결과
```typescript
interface StrengthLevelEvaluationResult {
  level: 'BEGINNER' | 'NOVICE' | 'INTERMEDIATE' | 'ADVANCED' | 'ELITE' | null;
  currentWeight: number;  // 현재 1RM (kg)
  bodyWeight: number;     // 회원 체중 (kg)
  nextLevel?: {
    level: 'BEGINNER' | 'NOVICE' | 'INTERMEDIATE' | 'ADVANCED' | 'ELITE';
    targetWeight: number;  // 다음 레벨 목표 무게 (kg)
    progressPercentage: number;  // 진행률 (0-100)
  };
}
```

### 운동 기록 (Workout Record)
```typescript
interface WorkoutRecord {
  id: string;
  exerciseId: string;
  exerciseName: string;
  weight: number;        // 무게 (kg)
  reps: number;          // 횟수
  sets: number;          // 세트 수
  volume: number;       // 총 볼륨 (weight × reps × sets)
  oneRepMax: number;    // 계산된 1RM (kg)
  relativeStrength: number;  // 상대 근력 (1RM / 체중)
  strengthLevel: 'BEGINNER' | 'NOVICE' | 'INTERMEDIATE' | 'ADVANCED' | 'ELITE' | null;
  workoutDate: string;   // 날짜 (YYYY-MM-DD)
}
```

---

## ⚠️ 주의사항

### 1. 데이터 없음 처리
- Strength Level 기준이 없는 운동의 경우 `level: null` 반환
- UI에서 "기준 없음" 또는 "평가 불가" 표시

### 2. 회원 정보 필수
- Strength Level 평가를 위해서는 회원의 **체중**과 **나이** 정보가 필요
- 정보가 없을 경우 안내 메시지 표시

### 3. 빅3 운동 우선
- 현재는 벤치프레스, 스쿼트, 데드리프트만 Strength Level 평가 가능
- 다른 운동은 추후 추가 예정

---

## 🎯 우선순위 권장사항

### Phase 1 (즉시 시작)
1. ✅ Strength Level 표시 기능 (운동 기록 화면)
2. ✅ 1RM 트렌드 그래프 (빅3 운동)

### Phase 2 (1주 내)
3. ✅ 볼륨 트렌드 그래프
4. ✅ 대시보드 Strength Level 카드

### Phase 3 (2주 내)
5. ✅ 운동 루틴 무게 제안 기능
6. ✅ 운동 목록 최근 수행 우선순위

---

## 📞 문의사항

백엔드 개발자에게 문의할 사항:
- API 엔드포인트 상세 스펙
- 에러 케이스 처리
- 데이터 포맷 변경 요청

---

## 🔗 관련 문서

- `docs/nextMove.md` - 백엔드 다음 단계 가이드
- `docs/EXERCISE_DETAIL_GUIDE.md` - 운동 상세 가이드
- `docs/STRENGTH_LEVEL_API_GUIDE.md` - Strength Level API 가이드 (작성 예정)

---

**작성자**: 백엔드 개발팀  
**최종 업데이트**: 2026-01-16
