# 개발 진행 상황

## 완료된 작업 ✅

### Phase 1: 가중치 수정 및 레이더 차트 개선

#### 1. 가중치 수정 (백엔드) ✅
- **파일**: `src/common/utils/score-calculator.ts`
- **변경 사항**:
  - 안정성: 10% → 20% (최우선)
  - 심폐 지구력: 20% (유지)
  - 근지구력: 20% (유지)
  - 하체 근력: 25% → 15%
  - 체성분 밸런스: 10% → 15%
  - 유연성: 15% → 10%
- **상태**: 완료 및 빌드 성공

#### 2. 레이더 차트 API 개선 (백엔드) ✅
- **파일**: 
  - `src/modules/assessments/assessments.service.ts`
  - `src/modules/members/abilities.controller.ts`
  - `src/modules/members/dto/hexagon-response.dto.ts` (신규)
- **추가된 기능**:
  - `getInitialSnapshot` 메서드: 초기 평가 스냅샷 조회
  - `getHexagonData` 메서드 확장: `includeInitial` 파라미터 추가
  - API 엔드포인트 확장: `?compare=true` 쿼리 파라미터 추가
  - Swagger DTO 추가: `HexagonDataDto`
- **상태**: 완료 및 빌드 성공

#### 3. 문서화 ✅
- **프론트엔드 개발자용 가이드**: `docs/FRONTEND_RADAR_CHART_UPDATE.md`
- **기존 스냅샷 재계산 스크립트**: `database/migrations/recalculate_total_scores.sql` (선택적, 실행 완료)

---

## 프론트엔드 작업 필요 (프론트엔드 개발자)

### 작업 내용
1. API 호출 함수 수정 (`compare=true` 파라미터 추가)
2. TypeScript 타입 정의 추가
3. 레이더 차트 컴포넌트 개선
   - 점수 표시 기능 추가
   - 초기 vs 현재 비교 표시 (회색 선 vs 색상 선)
   - 툴팁 개선

### 참고 문서
- [FRONTEND_RADAR_CHART_UPDATE.md](FRONTEND_RADAR_CHART_UPDATE.md) - 상세 가이드

---

## 선택적 작업 (백엔드)

### 1. 기존 스냅샷 totalScore 재계산 ✅ (실행 완료)
- **파일**: `database/migrations/recalculate_total_scores.sql`
- **설명**: 가중치 변경으로 인해 기존 `AbilitySnapshot`의 `totalScore`를 새로운 가중치로 재계산
- **상태**: 스크립트 실행 완료

### 2. 테스트 코드 작성/수정 (선택적)
- 가중치 변경 테스트
- 레이더 차트 API 테스트
- 초기 평가 조회 테스트

---

## 다음 단계

### 즉시 진행 가능
1. 프론트엔드 개발자가 레이더 차트 컴포넌트 개선 작업 시작

### 추후 진행
- Phase 2: 초기 평가 세부항목 정의
- Phase 3: 정기 평가 세부항목 및 환산 메커니즘
- Phase 4: 그래프 차트 및 상세 시각화
- Phase 5: 평가 기준표 및 등급 체계

**자세한 내용**: [BACKEND_FUTURE_DEVELOPMENT.md](BACKEND_FUTURE_DEVELOPMENT.md) 참고

---

## API 변경사항 요약

### 엔드포인트
- `GET /api/members/:id/abilities/hexagon` (기존)
- `GET /api/members/:id/abilities/hexagon?compare=true` (신규)

### 응답 형식
- 기본: `{ indicators, assessedAt, version }`
- compare=true: `{ indicators, assessedAt, version, initial }`

### 가중치 변경
- 새로운 평가부터는 새로운 가중치로 계산
- 기존 평가는 재계산 완료 (새로운 가중치 적용)

---

## 체크리스트

### 백엔드
- [x] 가중치 수정
- [x] 레이더 차트 API 개선
- [x] 초기 평가 스냅샷 조회 메서드 추가
- [x] 컨트롤러 엔드포인트 확장
- [x] 기존 스냅샷 재계산 (실행 완료)
- [ ] Swagger 문서 업데이트 (선택적)
- [ ] 테스트 코드 작성/수정 (선택적)

### 프론트엔드 (프론트엔드 개발자 작업)
- [ ] API 호출 함수 수정
- [ ] TypeScript 타입 정의 추가
- [ ] 레이더 차트 컴포넌트 개선
- [ ] 점수 표시 기능 추가
- [ ] 초기 vs 현재 비교 표시
- [ ] 툴팁 개선
