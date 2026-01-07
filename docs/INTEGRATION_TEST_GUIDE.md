# 통합 테스트 가이드

## 📋 테스트 순서

### 1. 서버 실행 확인

```bash
npm run start:dev
```

서버가 정상적으로 실행되면:
- `http://localhost:3001` 접속 가능
- Swagger UI: `http://localhost:3001/api`

---

## 2. Swagger에서 API 테스트

### 2-1. 인증 토큰 발급

1. Swagger UI 접속: `http://localhost:3001/api`
2. `POST /api/auth/login` 실행
   - Request Body:
     ```json
     {
       "email": "test",
       "password": "test"
     }
     ```
3. 응답에서 `accessToken` 복사
4. Swagger 우측 상단의 "Authorize" 버튼 클릭
5. `Bearer {accessToken}` 형식으로 입력 (예: `Bearer eyJhbGci...`)

---

### 2-2. 운동 기록 API 테스트

#### 운동 기록 생성
- `POST /api/members/{id}/workout-records`
- Request Body:
  ```json
  {
    "workoutDate": "2024-03-15",
    "bodyPart": "하체",
    "exerciseName": "스쿼트",
    "weight": 60,
    "reps": 10,
    "sets": 3,
    "workoutType": "PERSONAL"
  }
  ```
- 확인 사항:
  - ✅ `volume`이 자동 계산되어 1800 (60 × 10 × 3)인지 확인

#### 부위별 볼륨 조회
- `GET /api/members/{id}/workout-records/volume?period=week`
- 확인 사항:
  - ✅ `bodyPartVolumes` 배열이 반환되는지
  - ✅ `totalVolume`이 정확한지

---

### 2-3. PT 세션 API 테스트

#### PT 세션 생성
- `POST /api/members/{id}/pt-sessions`
- Request Body:
  ```json
  {
    "sessionDate": "2024-03-15",
    "mainContent": "하체 근력 운동 - 스쿼트, 레그프레스",
    "trainerComment": "자세가 많이 개선되었습니다!"
  }
  ```
- 확인 사항:
  - ✅ `sessionNumber`가 자동 계산되는지 (1, 2, 3...)
  - ✅ Member의 `completedSessions`가 자동 증가하는지
  - ✅ Member의 `goalProgress`가 자동 업데이트되는지

#### PT 세션 목록 조회
- `GET /api/members/{id}/pt-sessions`
- 확인 사항:
  - ✅ 세션 목록이 날짜순으로 정렬되는지
  - ✅ 세션 번호가 올바른지

---

### 2-4. 추천 운동 루틴 API 테스트

#### 운동 루틴 생성
- `POST /api/members/{id}/workout-routines`
- Request Body:
  ```json
  {
    "routineDate": "2024-03-15",
    "exercises": [
      {
        "bodyPart": "하체",
        "exerciseName": "스쿼트",
        "sets": 3,
        "reps": 10,
        "weight": 60,
        "notes": "자세 주의"
      },
      {
        "bodyPart": "가슴",
        "exerciseName": "벤치프레스",
        "sets": 3,
        "reps": 8,
        "weight": 50
      }
    ]
  }
  ```
- 확인 사항:
  - ✅ 루틴이 정상적으로 생성되는지
  - ✅ `exercises` 배열이 JSONB로 저장되는지

#### 오늘의 운동 루틴 조회
- `GET /api/members/{id}/workout-routines/today`
- 확인 사항:
  - ✅ 오늘 날짜의 루틴이 반환되는지
  - ✅ 루틴이 없으면 `null`이 반환되는지

#### 운동 루틴 완료 처리
- `PUT /api/members/{id}/workout-routines/{routineId}/complete`
- 확인 사항:
  - ✅ `isCompleted`가 `true`로 변경되는지

---

### 2-5. 대시보드 통합 API 테스트

#### 대시보드 데이터 조회
- `GET /api/members/{id}/dashboard`
- 확인 사항:
  - ✅ `goal` 정보가 포함되는지
  - ✅ `sessionProgress`가 정확한지
  - ✅ `workoutCalendar`에 PT 세션과 개인 운동이 포함되는지
  - ✅ `workoutAnalysis`에 부위별 볼륨이 포함되는지

---

## 3. 데이터 흐름 확인

### 시나리오 1: PT 세션 생성 → 진행률 업데이트

1. Member 조회: `GET /api/members/{id}`
   - `totalSessions`: 20
   - `completedSessions`: 10
   - `goalProgress`: 50

2. PT 세션 생성: `POST /api/members/{id}/pt-sessions`

3. Member 재조회: `GET /api/members/{id}`
   - ✅ `completedSessions`: 11 (자동 증가)
   - ✅ `goalProgress`: 55 (자동 업데이트)

---

### 시나리오 2: 운동 기록 → 볼륨 분석

1. 운동 기록 생성 (여러 개):
   - 하체: 스쿼트 60kg × 10회 × 3세트
   - 가슴: 벤치프레스 50kg × 8회 × 3세트

2. 부위별 볼륨 조회: `GET /api/members/{id}/workout-records/volume?period=week`
   - ✅ 하체 볼륨: 1800
   - ✅ 가슴 볼륨: 1200
   - ✅ 총 볼륨: 3000

---

### 시나리오 3: 대시보드 통합 데이터

1. 대시보드 조회: `GET /api/members/{id}/dashboard`

2. 확인 사항:
   - ✅ `workoutCalendar`에 PT 세션과 개인 운동이 날짜별로 그룹화되는지
   - ✅ `workoutAnalysis`에 주간 볼륨이 정확한지
   - ✅ `sessionProgress`의 `progressPercentage`가 정확한지

---

## 4. 에러 케이스 테스트

### 권한 테스트
- MEMBER 역할로 PT 세션 생성 시도 → 403 Forbidden
- MEMBER 역할로 운동 루틴 생성 시도 → 403 Forbidden

### 데이터 검증 테스트
- 음수 무게 입력 → 400 Bad Request
- 필수 필드 누락 → 400 Bad Request

### 존재하지 않는 리소스
- 존재하지 않는 Member ID → 404 Not Found
- 존재하지 않는 루틴 ID → 404 Not Found

---

## 5. 데이터베이스 직접 확인

### PostgreSQL에서 확인

```sql
-- 운동 기록 확인
SELECT * FROM workout_records WHERE member_id = 'member-uuid';

-- PT 세션 확인
SELECT * FROM pt_sessions WHERE member_id = 'member-uuid';

-- 운동 루틴 확인
SELECT * FROM workout_routines WHERE member_id = 'member-uuid';

-- Member의 진행률 확인
SELECT 
  id, 
  name, 
  total_sessions, 
  completed_sessions, 
  goal_progress 
FROM members 
WHERE id = 'member-uuid';
```

---

## 6. 체크리스트

- [ ] 서버 정상 실행
- [ ] Swagger UI 접속 가능
- [ ] 인증 토큰 발급 성공
- [ ] 운동 기록 CRUD 테스트 통과
- [ ] PT 세션 CRUD 테스트 통과
- [ ] 추천 운동 루틴 CRUD 테스트 통과
- [ ] 대시보드 통합 API 테스트 통과
- [ ] 자동 계산 로직 확인 (볼륨, 세션 번호, 진행률)
- [ ] 권한 체크 확인
- [ ] 에러 처리 확인
- [ ] 데이터베이스 직접 확인

---

## 문제 해결

### Swagger에서 401 Unauthorized
- 토큰이 만료되었을 수 있습니다. 다시 로그인하여 새 토큰 발급

### 500 Internal Server Error
- 데이터베이스 테이블이 생성되지 않았을 수 있습니다.
- SQL 마이그레이션 실행 확인: `docs/SQL_MIGRATION_GUIDE.md`

### TypeORM 에러
- 엔티티가 TypeORM 설정에 등록되었는지 확인
- `src/config/database.config.ts` 확인

---

**작성일**: 2026-01-07

