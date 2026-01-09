# 평가 API 테스트 가이드

> **목적**: 평가 생성 API 테스트 방법 및 테스트 시나리오 정리  
> 등급 → 점수 변환 로직이 정상 작동하는지 확인하는 가이드

---

## 📋 테스트 방법

### 1. 수동 테스트 (Postman/curl/Thunder Client)

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

---

## 🧪 테스트 시나리오

### 시나리오 1: 하체 근력 평가 (A 등급)

**요청 본문**:
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

**예상 응답**:
- `items[0].score`: 80
- `items[0].details.internalScore`: 80
- `snapshot.strengthScore`: 80

---

### 시나리오 2: 하체 근력 평가 (D-1 등급)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "STRENGTH",
      "name": "체어 스쿼트",
      "details": {
        "grade": "D-1"
      }
    }
  ]
}
```

**예상 응답**:
- `items[0].score`: 30
- `items[0].details.internalScore`: 30
- `snapshot.strengthScore`: 30

---

### 시나리오 3: 심폐 지구력 평가 (B + 회복 빠름)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "CARDIO",
      "name": "스텝 테스트",
      "details": {
        "grade": "B",
        "recoverySpeed": ["fast"]
      }
    }
  ]
}
```

**예상 응답**:
- `items[0].score`: 65
- `items[0].details.internalScore`: 65
- `snapshot.cardioScore`: 65

---

### 시나리오 4: 심폐 지구력 평가 (B + 회복 느림)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "CARDIO",
      "name": "스텝 테스트",
      "details": {
        "grade": "B",
        "recoverySpeed": ["slow"]
      }
    }
  ]
}
```

**예상 응답**:
- `items[0].score`: 55
- `items[0].details.internalScore`: 55
- `snapshot.cardioScore`: 55

---

### 시나리오 5: 근지구력 평가 (B 등급)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "ENDURANCE",
      "name": "플랭크",
      "details": {
        "grade": "B"
      }
    }
  ]
}
```

**예상 응답**:
- `items[0].score`: 60
- `items[0].details.internalScore`: 60
- `snapshot.enduranceScore`: 60

---

### 시나리오 6: 유연성 평가 (C 등급 2개)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "FLEXIBILITY",
      "name": "유연성 종합",
      "details": {
        "flexibilityItems": {
          "sitAndReach": "C",
          "shoulder": "C",
          "hip": "A",
          "hamstring": "A"
        }
      }
    }
  ]
}
```

**계산 과정**:
- 어깨 가동성 C: 가중치 1.3
- 좌전굴 C: 가중치 1.0
- 가중치 합: 1.3 + 1.0 = 2.3
- 범위: 1.6 ~ 2.5 → 제한 있음 (40점)

**예상 응답**:
- `items[0].score`: 40
- `items[0].details.internalScore`: 40
- `snapshot.flexibilityScore`: 40

---

### 시나리오 7: 유연성 평가 (모두 A 등급)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "FLEXIBILITY",
      "name": "유연성 종합",
      "details": {
        "flexibilityItems": {
          "sitAndReach": "A",
          "shoulder": "A",
          "hip": "A",
          "hamstring": "A"
        }
      }
    }
  ]
}
```

**계산 과정**:
- C 등급 없음 → 가중치 합: 0
- 범위: 0 → 안정적 (80점)

**예상 응답**:
- `items[0].score`: 80
- `items[0].details.internalScore`: 80
- `snapshot.flexibilityScore`: 80

---

### 시나리오 8: 체성분 평가 (남성, 35세, 기준 충족)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70,
  "condition": "GOOD",
  "items": [
    {
      "category": "BODY",
      "name": "인바디",
      "value": 70,
      "unit": "kg",
      "details": {
        "muscleMass": 30,
        "fatMass": 10.5,
        "bodyFatPercentage": 15
      }
    }
  ]
}
```

**계산 과정** (회원: 남성, 35세):
- 연령대 기준: 30-40대 남성 (체지방률 12-20%, 골격근량 40% 이상)
- 골격근량 %: (30 / 70) × 100 = 42.9%
- 체지방률 15%: 적정 범위 (12-20%) ✅
- 골격근량 42.9%: 충분 기준 (40% 이상) ✅
- 상태: 근육 충분 + 지방 적정 → 80점

**예상 응답**:
- `items[0].score`: 80
- `items[0].details.internalScore`: 80
- `snapshot.bodyScore`: 80

**⚠️ 주의**: 회원의 `age`와 `gender`가 DB에 있어야 함. `assessments.service.ts`에서 자동으로 조회하여 추가함.

---

### 시나리오 9: 체성분 평가 (여성, 45세, 한 요소 관리 필요)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 60,
  "condition": "GOOD",
  "items": [
    {
      "category": "BODY",
      "name": "인바디",
      "value": 60,
      "unit": "kg",
      "details": {
        "muscleMass": 15,
        "fatMass": 15,
        "bodyFatPercentage": 25
      }
    }
  ]
}
```

**계산 과정** (회원: 여성, 45세):
- 연령대 기준: 40-50대 여성 (체지방률 23-30%, 골격근량 28% 이상)
- 골격근량 %: (15 / 60) × 100 = 25%
- 체지방률 25%: 적정 범위 (23-30%) ✅
- 골격근량 25%: 기준 미충족 (28% 이상 필요) ❌
- 상태: 한 요소 관리 필요 → 60점

**예상 응답**:
- `items[0].score`: 60
- `items[0].details.internalScore`: 60
- `snapshot.bodyScore`: 60

---

### 시나리오 10: 안정성 평가 (OHSA A + 통증 없음)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "STABILITY",
      "name": "OHSA",
      "details": {
        "ohsa": "A",
        "pain": "none"
      }
    }
  ]
}
```

**예상 응답**:
- `items[0].score`: 80
- `items[0].details.internalScore`: 80
- `snapshot.stabilityScore`: 80

---

### 시나리오 11: 안정성 평가 (OHSA B + 통증 있음)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70.5,
  "condition": "GOOD",
  "items": [
    {
      "category": "STABILITY",
      "name": "OHSA",
      "details": {
        "ohsa": "B",
        "pain": "present"
      }
    }
  ]
}
```

**예상 응답**:
- `items[0].score`: 45
- `items[0].details.internalScore`: 45
- `snapshot.stabilityScore`: 45

---

### 시나리오 12: 전체 카테고리 종합 평가

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "bodyWeight": 70,
  "condition": "GOOD",
  "items": [
    {
      "category": "STRENGTH",
      "name": "체중 스쿼트",
      "details": { "grade": "B" }
    },
    {
      "category": "CARDIO",
      "name": "스텝 테스트",
      "details": {
        "grade": "B",
        "recoverySpeed": ["fast"]
      }
    },
    {
      "category": "ENDURANCE",
      "name": "플랭크",
      "details": { "grade": "A" }
    },
    {
      "category": "FLEXIBILITY",
      "name": "유연성 종합",
      "details": {
        "flexibilityItems": {
          "sitAndReach": "B",
          "shoulder": "A",
          "hip": "A",
          "hamstring": "A"
        }
      }
    },
    {
      "category": "BODY",
      "name": "인바디",
      "value": 70,
      "unit": "kg",
      "details": {
        "muscleMass": 30,
        "fatMass": 10.5,
        "bodyFatPercentage": 15
      }
    },
    {
      "category": "STABILITY",
      "name": "OHSA",
      "details": {
        "ohsa": "A",
        "pain": "none"
      }
    }
  ]
}
```

**예상 점수**:
- 하체 근력: 60점 (B)
- 심폐 지구력: 65점 (B + 회복 빠름)
- 근지구력: 80점 (A)
- 유연성: 80점 (C 없음)
- 체성분: 80점 (근육 충분 + 지방 적정) - 회원이 남성 35세일 경우
- 안정성: 80점 (A + 통증 없음)

**종합 점수 계산**:
```
= (60 × 0.15) + (65 × 0.2) + (80 × 0.2) + (80 × 0.1) + (80 × 0.15) + (80 × 0.2)
= 9 + 13 + 16 + 8 + 12 + 16
= 74점
```

**예상 응답**:
- `snapshot.strengthScore`: 60
- `snapshot.cardioScore`: 65
- `snapshot.enduranceScore`: 80
- `snapshot.flexibilityScore`: 80
- `snapshot.bodyScore`: 80
- `snapshot.stabilityScore`: 80
- `snapshot.totalScore`: 74

---

## 🚨 에러 케이스 테스트

### 에러 케이스 1: 필수 필드 누락 (grade 없음)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "items": [
    {
      "category": "STRENGTH",
      "name": "체중 스쿼트",
      "details": {}
    }
  ]
}
```

**예상 동작**:
- `items[0].score`: null
- 로그에 경고 메시지: "하체 근력 점수 계산 실패: grade가 없습니다."

---

### 에러 케이스 2: 잘못된 등급 값

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "items": [
    {
      "category": "STRENGTH",
      "name": "체중 스쿼트",
      "details": {
        "grade": "X"
      }
    }
  ]
}
```

**예상 동작**:
- `items[0].score`: null
- 로그에 경고 메시지: "하체 근력 점수 계산 실패: 알 수 없는 등급 'X'..."

---

### 에러 케이스 3: 체성분 필수 필드 누락 (age 없음)

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "items": [
    {
      "category": "BODY",
      "name": "인바디",
      "details": {
        "muscleMass": 30,
        "bodyFatPercentage": 15
      }
    }
  ]
}
```

**예상 동작**:
- `items[0].score`: null
- 로그에 경고 메시지: "체성분 점수 계산 실패: age가 없습니다."
- 또는 회원 정보가 없으면: "회원을 찾을 수 없습니다."

---

### 에러 케이스 4: 유연성 flexibilityItems 없음

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "items": [
    {
      "category": "FLEXIBILITY",
      "name": "유연성 종합",
      "details": {}
    }
  ]
}
```

**예상 동작**:
- `items[0].score`: null
- 로그에 경고 메시지: "유연성 점수 계산 실패: flexibilityItems가 없습니다."

---

### 에러 케이스 5: 안정성 ohsa 또는 pain 없음

**요청 본문**:
```json
{
  "assessmentType": "INITIAL",
  "assessedAt": "2024-01-15",
  "items": [
    {
      "category": "STABILITY",
      "name": "OHSA",
      "details": {
        "ohsa": "A"
      }
    }
  ]
}
```

**예상 동작**:
- `items[0].score`: null
- 로그에 경고 메시지: "안정성 점수 계산 실패: pain이 없습니다."

---

## 🔧 자동 테스트 스크립트 (Node.js)

### 테스트 스크립트 작성

다음 스크립트를 사용하여 자동 테스트 가능:

```javascript
// test-assessment-api.js
const axios = require('axios');

const BASE_URL = 'http://localhost:3000';
const MEMBER_ID = 'your-member-id'; // 실제 회원 ID로 변경
const AUTH_TOKEN = 'your-auth-token'; // 실제 JWT 토큰으로 변경

async function testAssessmentCreation(testName, requestBody, expectedScore) {
  try {
    const response = await axios.post(
      `${BASE_URL}/api/members/${MEMBER_ID}/assessments`,
      requestBody,
      {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${AUTH_TOKEN}`
        }
      }
    );

    const item = response.data.items[0];
    const actualScore = item?.score;
    const internalScore = item?.details?.internalScore;

    console.log(`\n✅ ${testName}`);
    console.log(`예상 점수: ${expectedScore}`);
    console.log(`실제 점수: ${actualScore}`);
    console.log(`내부 점수: ${internalScore}`);
    
    if (actualScore === expectedScore) {
      console.log('✅ 테스트 통과');
    } else {
      console.log('❌ 테스트 실패');
    }
  } catch (error) {
    console.error(`❌ ${testName} - 에러 발생:`, error.response?.data || error.message);
  }
}

// 테스트 실행
async function runTests() {
  // 시나리오 1: 하체 근력 A
  await testAssessmentCreation(
    '하체 근력 A 등급',
    {
      assessmentType: 'INITIAL',
      assessedAt: '2024-01-15',
      items: [{
        category: 'STRENGTH',
        name: '체중 스쿼트',
        details: { grade: 'A' }
      }]
    },
    80
  );

  // 시나리오 2: 하체 근력 D-1
  await testAssessmentCreation(
    '하체 근력 D-1 등급',
    {
      assessmentType: 'INITIAL',
      assessedAt: '2024-01-15',
      items: [{
        category: 'STRENGTH',
        name: '체어 스쿼트',
        details: { grade: 'D-1' }
      }]
    },
    30
  );

  // 시나리오 3: 심폐 지구력 B + 회복 빠름
  await testAssessmentCreation(
    '심폐 지구력 B + 회복 빠름',
    {
      assessmentType: 'INITIAL',
      assessedAt: '2024-01-15',
      items: [{
        category: 'CARDIO',
        name: '스텝 테스트',
        details: { grade: 'B', recoverySpeed: ['fast'] }
      }]
    },
    65
  );

  // 시나리오 4: 심폐 지구력 B + 회복 느림
  await testAssessmentCreation(
    '심폐 지구력 B + 회복 느림',
    {
      assessmentType: 'INITIAL',
      assessedAt: '2024-01-15',
      items: [{
        category: 'CARDIO',
        name: '스텝 테스트',
        details: { grade: 'B', recoverySpeed: ['slow'] }
      }]
    },
    55
  );

  // 시나리오 5: 근지구력 B
  await testAssessmentCreation(
    '근지구력 B 등급',
    {
      assessmentType: 'INITIAL',
      assessedAt: '2024-01-15',
      items: [{
        category: 'ENDURANCE',
        name: '플랭크',
        details: { grade: 'B' }
      }]
    },
    60
  );

  // 시나리오 6: 안정성 A + 통증 없음
  await testAssessmentCreation(
    '안정성 A + 통증 없음',
    {
      assessmentType: 'INITIAL',
      assessedAt: '2024-01-15',
      items: [{
        category: 'STABILITY',
        name: 'OHSA',
        details: { ohsa: 'A', pain: 'none' }
      }]
    },
    80
  );

  // 시나리오 7: 안정성 B + 통증 있음
  await testAssessmentCreation(
    '안정성 B + 통증 있음',
    {
      assessmentType: 'INITIAL',
      assessedAt: '2024-01-15',
      items: [{
        category: 'STABILITY',
        name: 'OHSA',
        details: { ohsa: 'B', pain: 'present' }
      }]
    },
    45
  );
}

runTests();
```

**실행 방법**:
```bash
npm install axios
node test-assessment-api.js
```

---

## 📝 테스트 체크리스트

- [ ] 하체 근력: A, B, C, D-1, D-2 등급 모두 테스트
- [ ] 심폐 지구력: A, B(+회복빠름), B(+회복느림), B(기본), C 등급 테스트
- [ ] 근지구력: A, B, C, IMPOSSIBLE 등급 테스트
- [ ] 유연성: 모든 A, 일부 C, 모두 C 조합 테스트
- [ ] 체성분: 남성/여성, 다양한 연령대, 기준 충족/불충족 케이스 테스트
- [ ] 안정성: OHSA A/B/C × 통증 없음/있음 모든 조합 테스트
- [ ] 전체 카테고리 종합 평가 테스트
- [ ] 에러 케이스: 필수 필드 누락, 잘못된 값 등 테스트
- [ ] 종합 점수 계산 검증

---

## 🐛 문제 발생 시 확인 사항

1. **DB 마이그레이션 확인**
   - `flexibility_item_weights` 테이블 데이터 존재 확인
   - `flexibility_grade_thresholds` 테이블 데이터 존재 확인
   - `body_composition_standards` 테이블 데이터 존재 확인

2. **회원 정보 확인**
   - 회원의 `age` 필드 존재 확인 (체성분 평가 시 필요)
   - 회원의 `gender` 필드 존재 확인 (체성분 평가 시 필요)

3. **로그 확인**
   - 백엔드 콘솔에서 경고/에러 메시지 확인
   - "점수 계산 실패" 관련 로그 확인

---

## 📅 업데이트 이력

- 2024-01-XX: 초안 작성
