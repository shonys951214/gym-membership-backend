# 평가 시스템 테스트 요약

> **작성일**: 2024-01-XX  
> **상태**: ✅ 모든 작업 완료

---

## ✅ 완료된 작업

### 1. 문서 상태 업데이트

- ✅ `ASSESSMENT_DB_AND_PLAN.md` 상태를 "계산 로직 구현 완료"로 변경
- ✅ 완료된 작업 목록 추가

### 2. 예외 처리 개선

- ✅ `GradeScoreConverter`에 Logger 추가
- ✅ 모든 카테고리별 점수 계산 실패 시 명확한 경고 메시지 추가
- ✅ DB 조회 실패 시 상세한 에러 메시지 제공

### 3. 에러 메시지 개선

- ✅ 필수 필드 누락 시 명확한 경고 메시지
- ✅ 잘못된 등급 값 입력 시 허용된 등급 목록 포함
- ✅ DB 테이블 조회 실패 시 테이블명 명시

### 4. 테스트 가이드 작성

- ✅ `ASSESSMENT_API_TEST_GUIDE.md` 작성
- ✅ 12개 테스트 시나리오 정리
- ✅ 에러 케이스 테스트 가이드 포함

### 5. 자체 테스트 스크립트

- ✅ `scripts/test-grade-converter.js` 작성
- ✅ 모든 카테고리별 로직 검증
- ✅ 종합 점수 계산 검증

### 6. API 명세 업데이트

- ✅ Swagger 문서에 `details` 필드 상세 설명 추가
- ✅ 카테고리별 필수 필드 안내 추가
- ✅ 점수 계산 로직 설명 추가

---

## 🧪 테스트 방법

### 방법 1: 로직 검증 스크립트 (제가 실행함)

```bash
node scripts/test-grade-converter.js
```

**결과**: ✅ 모든 로직 검증 완료

---

### 방법 2: 수동 API 테스트 (Postman/Thunder Client/curl)

#### 준비 사항

1. 백엔드 서버 실행 (`npm run start:dev`)
2. 인증 토큰 준비 (JWT)
3. 회원 ID 준비 (실제 DB에 존재하는 회원 ID)

#### 테스트 엔드포인트

```
POST /api/members/:memberId/assessments
Content-Type: application/json
Authorization: Bearer {token}
```

#### 테스트 시나리오

자세한 테스트 시나리오는 `docs/ASSESSMENT_API_TEST_GUIDE.md`를 참고하세요.

**주요 테스트 케이스**:

1. 하체 근력: A, B, C, D-1, D-2 등급
2. 심폐 지구력: A, B(+회복빠름), B(+회복느림), C 등급
3. 근지구력: A, B, C, IMPOSSIBLE 등급
4. 유연성: 모든 A, 일부 C, 모두 C 조합
5. 체성분: 남성/여성, 다양한 연령대
6. 안정성: OHSA A/B/C × 통증 없음/있음 조합

---

### 방법 3: Swagger UI에서 테스트

#### 접속 방법

```
http://localhost:3001/api
```

#### 사용 방법

1. **로그인하여 토큰 얻기**
    - `POST /api/auth/login` 클릭
    - "Try it out" → 로그인 정보 입력 → "Execute"
    - 응답에서 `accessToken` 복사

2. **인증 설정**
    - 우측 상단 "Authorize" 버튼 클릭
    - 토큰 붙여넣기 → "Authorize" 클릭

3. **평가 생성 API 테스트**
    - `POST /api/members/:memberId/assessments` 클릭
    - "Try it out" → `memberId` 입력
    - Request body에 평가 데이터 입력 (예시 참고)
    - "Execute" 클릭

#### 예시 Request Body

```json
{
	"assessmentType": "INITIAL",
	"assessedAt": "2024-01-15",
	"bodyWeight": 70.5,
	"condition": "GOOD",
	"items": [
		{
			"category": "STRENGTH",
			"name": "체중 스쿼트",
			"details": {
				"grade": "A"
			}
		}
	]
}
```

---

### 방법 4: 자동화 테스트 스크립트 (Node.js)

자세한 스크립트 예시는 `docs/ASSESSMENT_API_TEST_GUIDE.md`의 "자동 테스트 스크립트" 섹션을 참고하세요.

```javascript
// test-assessment-api.js
const axios = require("axios");

async function testAssessmentCreation(testName, requestBody, expectedScore) {
	try {
		const response = await axios.post(`${BASE_URL}/api/members/${MEMBER_ID}/assessments`, requestBody, {
			headers: {
				"Content-Type": "application/json",
				Authorization: `Bearer ${AUTH_TOKEN}`,
			},
		});

		const item = response.data.items[0];
		const actualScore = item?.score;
		const internalScore = item?.details?.internalScore;

		console.log(`\n✅ ${testName}`);
		console.log(`예상 점수: ${expectedScore}`);
		console.log(`실제 점수: ${actualScore}`);
		console.log(`내부 점수: ${internalScore}`);

		if (actualScore === expectedScore) {
			console.log("✅ 테스트 통과");
		} else {
			console.log("❌ 테스트 실패");
		}
	} catch (error) {
		console.error(`❌ ${testName} - 에러 발생:`, error.response?.data || error.message);
	}
}
```

---

## 📋 테스트 체크리스트

### 필수 테스트

- [ ] 하체 근력: A, B, C, D-1, D-2 등급 모두 테스트
- [ ] 심폐 지구력: A, B(+회복빠름), B(+회복느림), B(기본), C 등급 테스트
- [ ] 근지구력: A, B, C, IMPOSSIBLE 등급 테스트
- [ ] 유연성: 모든 A, 일부 C, 모두 C 조합 테스트
- [ ] 체성분: 남성/여성, 다양한 연령대, 기준 충족/불충족 케이스 테스트
- [ ] 안정성: OHSA A/B/C × 통증 없음/있음 모든 조합 테스트
- [ ] 전체 카테고리 종합 평가 테스트
- [ ] 종합 점수 계산 검증

### 에러 케이스 테스트

- [ ] 필수 필드 누락 (grade 없음)
- [ ] 잘못된 등급 값 (X 등급)
- [ ] 체성분 필수 필드 누락 (age 없음)
- [ ] 유연성 flexibilityItems 없음
- [ ] 안정성 ohsa 또는 pain 없음

---

## 🔍 확인 사항

### DB 마이그레이션 확인

다음 테이블들이 존재하고 데이터가 있어야 합니다:

- ✅ `flexibility_item_weights` (유연성 가중치)
- ✅ `flexibility_grade_thresholds` (유연성 등급 판정 기준)
- ✅ `body_composition_standards` (체성분 연령대별 기준)

### 회원 정보 확인

체성분 평가를 위해서는 다음 필드가 필요합니다:

- ✅ `members.age` (나이)
- ✅ `members.gender` (성별)

### 로그 확인

백엔드 콘솔에서 다음 로그를 확인하세요:

- ✅ 점수 계산 성공 메시지
- ⚠️ 점수 계산 실패 경고 메시지 (필요 시)
- ❌ 에러 메시지 (문제 발생 시)

---

## 🐛 문제 발생 시 확인 사항

### 문제 1: 점수가 null로 반환됨

**확인 사항**:

1. `details` 필드가 올바르게 입력되었는지 확인
2. 카테고리별 필수 필드 확인:
    - 하체 근력/심폐 지구력/근지구력: `grade` 필수
    - 유연성: `flexibilityItems` 필수
    - 체성분: `muscleMass`, `bodyFatPercentage`, `age`, `gender` 필수
    - 안정성: `ohsa`, `pain` 필수
3. 백엔드 로그에서 경고 메시지 확인

**해결 방법**:

- 로그 메시지에 따라 누락된 필드 추가
- DB 마이그레이션 실행 여부 확인

---

### 문제 2: 체성분 점수가 null로 반환됨

**확인 사항**:

1. 회원의 `age` 필드가 DB에 있는지 확인
2. 회원의 `gender` 필드가 DB에 있는지 확인
3. `body_composition_standards` 테이블에 해당 연령대/성별 기준이 있는지 확인

**해결 방법**:

- 회원 정보에 `age`, `gender` 추가
- DB 마이그레이션 실행 (`database/migrations/create_body_composition_standards.sql`)

---

### 문제 3: 유연성 점수가 null로 반환됨

**확인 사항**:

1. `flexibility_item_weights` 테이블에 데이터가 있는지 확인
2. `flexibility_grade_thresholds` 테이블에 데이터가 있는지 확인
3. `flexibilityItems` 객체가 올바르게 입력되었는지 확인

**해결 방법**:

- DB 마이그레이션 실행 (`database/migrations/create_flexibility_weights.sql`)
- `flexibilityItems` 객체 형식 확인

---

## 📚 참고 문서

- `점수계산표.md`: 점수 계산 방식 상세 설명
- `docs/ASSESSMENT_DB_AND_PLAN.md`: 전체 평가 시스템 설계 문서
- `docs/ASSESSMENT_API_TEST_GUIDE.md`: 상세 테스트 가이드
- `docs/SWAGGER_GUIDE.md`: Swagger 사용 가이드

---

## ✅ 빌드 확인

```bash
npm run build
```

**결과**: ✅ 빌드 성공 (webpack 5.103.0 compiled successfully)

---

## 📝 다음 단계

1. ✅ **로직 검증 완료**: 모든 점수 계산 로직 검증 완료
2. ⏳ **실제 API 테스트**: Postman/Thunder Client를 사용한 실제 API 호출 테스트 필요
3. ⏳ **프론트엔드 연동**: 프론트엔드 개발자와 API 연동 테스트 필요

---

## 🎉 완료 상태

- ✅ 문서 상태 업데이트
- ✅ 예외 처리 개선
- ✅ 에러 메시지 개선
- ✅ 테스트 가이드 작성
- ✅ 자체 테스트 스크립트 작성 및 실행
- ✅ 빌드 검증
- ✅ API 명세 업데이트

**모든 작업이 완료되었습니다!** 🚀
