# 다음 단계 개발 가이드 (Next Steps)

## 📅 작성일: 2026-01-16

---

## ✅ 완료된 작업

### Phase 6: 빅3 운동 Strength Level 기준 데이터 수집 및 추가
- ✅ 벤치프레스 남성/여성 데이터 추가
- ✅ 스쿼트 남성/여성 데이터 추가
- ✅ 데드리프트 남성/여성 데이터 추가
- ✅ 체중별(BODYWEIGHT) + 나이별(AGE) 기준 데이터 모두 추가
- ✅ 총 1,020개 INSERT 문 실행 완료

---

## 🎯 다음 단계 (우선순위 순)

### 1. 백엔드 API 검증 및 테스트 (High Priority)

#### 1.1 Strength Level 평가 API 테스트
- [ ] `POST /members/:memberId/workout-records` - 운동 기록 생성 시 자동 Strength Level 계산 확인
- [ ] `PUT /members/:memberId/workout-records/:recordId` - 운동 기록 수정 시 Strength Level 업데이트 확인
- [ ] `GET /members/:memberId/strength-level/:exerciseId` - 특정 운동의 Strength Level 조회 테스트
- [ ] 체중별 기준 우선, 없으면 나이별 기준 사용 로직 검증

#### 1.2 1RM 계산 및 트렌드 API 테스트
- [ ] `GET /members/:memberId/workout-records/trends` - 1RM 트렌드 조회 테스트
- [ ] `GET /members/:memberId/workout-records/volume-trends` - 볼륨 트렌드 조회 테스트
- [ ] 그래프 데이터 포맷 확인 (날짜별, 운동별)

#### 1.3 운동 루틴 무게 제안 API 테스트
- [ ] `POST /members/:memberId/workout-routines` - `suggestWeights: true` 옵션 테스트
- [ ] Strength Level 기반 무게 제안 로직 검증

#### 1.4 운동 목록 API 테스트
- [ ] `GET /exercises` - 필터링 및 정렬 기능 테스트
- [ ] 최근 수행한 운동 우선순위 정렬 확인

---

### 2. 프론트엔드 개발 지원 (High Priority)

#### 2.1 API 엔드포인트 문서화
- [ ] 모든 Strength Level 관련 API 엔드포인트 문서화
- [ ] 요청/응답 예시 작성
- [ ] 에러 케이스 문서화

#### 2.2 데이터 구조 문서화
- [ ] Strength Level 평가 결과 구조 설명
- [ ] 트렌드 데이터 포맷 설명
- [ ] 그래프/차트용 데이터 포맷 정의

---

### 3. 기능 개선 및 최적화 (Medium Priority)

#### 3.1 Strength Level 평가 로직 개선
- [ ] 체중별/나이별 기준 우선순위 로직 최적화
- [ ] 가장 가까운 범위 기준 찾기 로직 개선
- [ ] 평가 결과 캐싱 고려 (성능 최적화)

#### 3.2 데이터 검증 및 품질 관리
- [ ] 추가된 Strength Level 데이터 검증 쿼리 작성
- [ ] 데이터 일관성 체크 스크립트 작성
- [ ] 누락된 데이터 확인 및 보완

#### 3.3 에러 핸들링 개선
- [ ] Strength Level 기준이 없는 운동에 대한 처리
- [ ] 회원 정보(체중, 나이) 누락 시 처리
- [ ] 1RM 계산 실패 시 처리

---

### 4. 추가 기능 개발 (Low Priority)

#### 4.1 대시보드 통계
- [ ] 빅3 운동 종합 Strength Level 표시
- [ ] 전체 운동 평균 Strength Level 계산
- [ ] 월별/주별 Strength Level 변화 추이

#### 4.2 운동 루틴 추천 개선
- [ ] Strength Level 기반 운동 루틴 자동 생성
- [ ] 목표 Strength Level 달성을 위한 루틴 추천
- [ ] 다음 레벨 달성을 위한 무게/횟수 제안

#### 4.3 알림 및 동기부여
- [ ] Strength Level 상승 시 알림
- [ ] 다음 레벨까지 남은 무게 표시
- [ ] 목표 달성률 표시

---

## 📋 체크리스트

### 즉시 확인 필요
- [ ] 데이터베이스에 모든 데이터가 정상적으로 추가되었는지 확인
- [ ] `strength_standards` 테이블 데이터 개수 확인
- [ ] API 엔드포인트가 정상 작동하는지 테스트

### 프론트엔드 협업 준비
- [ ] API 문서 작성 완료
- [ ] 샘플 데이터 제공
- [ ] 그래프/차트 요구사항 명확화

### 장기 계획
- [ ] 추가 운동 데이터 수집 계획 수립
- [ ] 성능 최적화 계획
- [ ] 사용자 피드백 수집 계획

---

## 🔗 관련 파일

### 데이터 파일
- `database/bench_press_male_standards.sql`
- `database/bench_press_female_standards.sql`
- `database/squat_male_standards.sql`
- `database/squat_female_standards.sql`
- `database/deadlift_male_standards.sql`
- `database/deadlift_female_standards.sql`

### 스크립트
- `scripts/generate_bench_press_sql.py`
- `scripts/generate_squat_sql.py`
- `scripts/generate_deadlift_sql.py`

### 코드
- `src/common/utils/strength-level-evaluator.ts`
- `src/modules/members/workout-records.service.ts`
- `src/modules/members/members.controller.ts`

---

## 📝 참고사항

1. **데이터 구조**: 체중별(BODYWEIGHT) 기준이 우선이며, 없을 경우 나이별(AGE) 기준을 사용합니다.
2. **범위 정의**: 체중 범위는 연속적이고 겹치지 않도록 정의되었습니다 (예: 50kg → 40.0~54.99kg).
3. **나이 범위**: 나이 범위도 연속적으로 정의되었습니다 (예: 25세 → 25~29세).
4. **레벨**: BEGINNER, NOVICE, INTERMEDIATE, ADVANCED, ELITE 5단계입니다.

---

**다음 업데이트 예정일**: 프론트엔드 개발자와 협의 후 결정
