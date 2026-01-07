# 다음 단계 가이드

## 📋 현재 완료된 작업

### ✅ Phase 1-4: 기본 기능 구현 완료

1. **목표 관리 기능** ✅
   - 목표 조회/생성/수정/삭제 API
   - 진행률, 트레이너 코멘트 관리

2. **운동 기록 기능** ✅
   - 운동 기록 CRUD
   - 부위별 볼륨 분석
   - 운동 캘린더
   - 페이지네이션 지원

3. **PT 세션 관리 기능** ✅
   - PT 세션 CRUD
   - 세션 번호 자동 계산
   - completedSessions 자동 업데이트

4. **추천 운동 루틴 기능** ✅
   - 공통 루틴 + 회원별 루틴
   - 오늘의 루틴 조회
   - 완료 처리

5. **대시보드 통합** ✅
   - 목표, 수업 진행률, 운동 캘린더, 운동 기록 분석 통합

---

## 🎯 다음 우선순위 작업

### 즉시 진행 (배포 준비)

#### 1. SQL 마이그레이션 실행

**파일 위치**: `database/`

**실행 순서**:

```bash
# 1. 기존 테이블에 새 필드 추가
psql $DATABASE_URL -f database/add_workout_records_fields.sql
psql $DATABASE_URL -f database/add_workout_routines_fields.sql

# 2. 새 테이블 생성 (없는 경우)
psql $DATABASE_URL -f database/create_workout_records_table.sql
psql $DATABASE_URL -f database/create_pt_sessions_table.sql
psql $DATABASE_URL -f database/create_workout_routines_table.sql
```

**자세한 가이드**: `docs/SQL_MIGRATION_FIX.md` 참고

#### 2. Render 배포

**체크리스트**: `docs/DEPLOYMENT_CHECKLIST.md` 참고

**주요 단계**:
1. 코드 푸시
2. 환경 변수 설정
3. 배포 확인
4. API 테스트

---

### 중기 작업 (정보 수집 후 진행)

#### Phase 3: 점수 계산 로직 확장 설계

**목표**: 확장 가능한 구조로 설계하되, 기본값만 사용

**작업 내용**:
- `scoring_criteria` 테이블 생성 (기본 운동 기준표만 입력)
- `assessment_weight_configs` 테이블 생성 (전역 기본값만 입력)
- `assessment_grade_configs` 테이블 생성 (전역 기본값만 입력)
- 점수 계산 로직 확장 (기본값 사용)

**우선순위**: 낮음 (정보 수집 필요)

#### Phase 4: 평가 시스템 개선

**목표**: 정적/동적 평가 구분

**작업 내용**:
- Assessment 엔티티에 `evaluationType` 필드 추가 (STATIC/DYNAMIC)
- 평가 항목 세분화
- 평가 위계 구조 구현

**우선순위**: 중간

---

### 장기 작업 (정보 수집 완료 후)

#### Phase 5: 가중치/등급 커스터마이징

**목표**: 트레이너별 커스터마이징 지원

**작업 내용**:
- 트레이너별 가중치 설정 UI/API
- 트레이너별 등급 기준 설정 UI/API
- 트레이너별 평가 기준표 설정 UI/API

**우선순위**: 낮음 (정보 수집 및 정교한 계산표 확보 후)

---

## 📝 현재 상태 요약

### 완료된 기능

- ✅ 인증 시스템 (JWT, Refresh Token, 카카오 로그인)
- ✅ 회원 관리 (CRUD, 회원권, PT 횟수)
- ✅ 평가 시스템 (초기/정기 평가, 능력치 스냅샷)
- ✅ 부상 관리
- ✅ 분석 및 인사이트
- ✅ 목표 관리
- ✅ 운동 기록
- ✅ PT 세션 관리
- ✅ 추천 운동 루틴
- ✅ 대시보드 통합

### 다음 작업

1. **즉시**: SQL 마이그레이션 실행 및 배포
2. **중기**: 평가 시스템 개선 (정적/동적 구분)
3. **장기**: 가중치/등급 커스터마이징 (정보 수집 후)

---

## 🔗 관련 문서

- `docs/DEPLOYMENT_CHECKLIST.md` - 배포 전 체크리스트
- `docs/SQL_MIGRATION_FIX.md` - SQL 마이그레이션 가이드
- `docs/FRONTEND_DEPLOYMENT.md` - 프론트엔드 배포 연결 가이드
- `1차피드백.md` - 전체 피드백 및 계획
- `docs/FEEDBACK_IMPLEMENTATION_PLAN.md` - 상세 구현 계획

---

**작성일**: 2026-01-07

