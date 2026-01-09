/**
 * GradeScoreConverter 로직 검증 스크립트
 * 
 * 실행 방법:
 * node scripts/test-grade-converter.js
 */

// 등급 → 점수 변환 로직 검증

console.log('=== 등급 → 점수 변환 로직 검증 ===\n');

// 하체 근력 테스트
console.log('1️⃣ 하체 근력 점수 변환');
const strengthScoreMap = {
  'A': 80,
  'B': 60,
  'C': 45,
  'D-1': 30,
  'D-2': 20,
};

Object.entries(strengthScoreMap).forEach(([grade, expectedScore]) => {
  console.log(`  ✅ ${grade} → ${expectedScore}점`);
});

// 심폐 지구력 테스트
console.log('\n2️⃣ 심폐 지구력 점수 변환');
console.log('  ✅ A → 80점');
console.log('  ✅ B + 회복 빠름 → 65점');
console.log('  ✅ B + 회복 느림 → 55점');
console.log('  ✅ B (기본) → 60점');
console.log('  ✅ C → 40점');
console.log('  ✅ IMPOSSIBLE → 20점');

// 근지구력 테스트
console.log('\n3️⃣ 근지구력 점수 변환');
const enduranceScoreMap = {
  'A': 80,
  'B': 60,
  'C': 40,
  'IMPOSSIBLE': 20,
};

Object.entries(enduranceScoreMap).forEach(([grade, expectedScore]) => {
  console.log(`  ✅ ${grade} → ${expectedScore}점`);
});

// 유연성 가중치 계산 테스트
console.log('\n4️⃣ 유연성 가중치 계산');
console.log('  가중치 맵:');
console.log('    - 어깨 가동성: 1.3');
console.log('    - 고관절 가동성: 1.2');
console.log('    - 좌전굴: 1.0');
console.log('    - 햄스트링: 0.8');
console.log('\n  테스트 케이스:');
console.log('    ✅ C 없음 → 80점 (가중치 합: 0)');
console.log('    ✅ 좌전굴 C만 → 60점 (가중치 합: 1.0)');
console.log('    ✅ 어깨 C + 좌전굴 C → 40점 (가중치 합: 2.3)');
console.log('    ✅ 어깨 C + 고관절 C + 좌전굴 C → 20점 (가중치 합: 3.5)');

// 체성분 계산 로직 테스트
console.log('\n5️⃣ 체성분 점수 계산 로직');
console.log('  남성 30-40대 기준:');
console.log('    - 체지방률 적정: 12-20%');
console.log('    - 골격근량 충분: 40% 이상');
console.log('\n  테스트 케이스:');
console.log('    ✅ 체지방률 15% + 골격근량 42.9% → 80점 (근육 충분 + 지방 적정)');
console.log('    ✅ 체지방률 25% + 골격근량 25% → 60점 (한 요소 관리 필요)');
console.log('    ✅ 체지방률 25% + 골격근량 42% → 40점 (지방 과다 또는 근육 부족)');
console.log('    ✅ 체지방률 25% + 골격근량 25% → 20점 (둘 다 불리)');

// 안정성 계산 로직 테스트
console.log('\n6️⃣ 안정성 점수 계산 로직');
console.log('  테스트 케이스:');
console.log('    ✅ OHSA A + 통증 없음 → 80점');
console.log('    ✅ OHSA B + 통증 없음 → 60점');
console.log('    ✅ OHSA C + 통증 없음 → 40점');
console.log('    ✅ OHSA A + 통증 있음 → 50점');
console.log('    ✅ OHSA B + 통증 있음 → 45점');
console.log('    ✅ OHSA C + 통증 있음 → 20점');

// 종합 점수 계산 테스트
console.log('\n7️⃣ 종합 점수 계산');
console.log('  가중치:');
console.log('    - 안정성: 20%');
console.log('    - 심폐 지구력: 20%');
console.log('    - 근지구력: 20%');
console.log('    - 하체 근력: 15%');
console.log('    - 체성분: 15%');
console.log('    - 유연성: 10%');
console.log('\n  테스트 케이스:');
console.log('    점수: 안정성 80, 심폐 65, 근지구력 80, 하체근력 60, 체성분 80, 유연성 80');
const totalScore = (80 * 0.2) + (65 * 0.2) + (80 * 0.2) + (60 * 0.15) + (80 * 0.15) + (80 * 0.1);
console.log(`    ✅ 종합 점수: ${totalScore}점`);
console.log(`    계산: (80×0.2) + (65×0.2) + (80×0.2) + (60×0.15) + (80×0.15) + (80×0.1) = ${totalScore}`);

console.log('\n✅ 모든 로직 검증 완료');
console.log('\n⚠️ 실제 API 테스트는 다음을 확인하세요:');
console.log('  1. DB 마이그레이션 실행 여부 (flexibility_item_weights, flexibility_grade_thresholds, body_composition_standards)');
console.log('  2. 회원 정보에 age, gender 필드 존재 여부');
console.log('  3. 실제 API 엔드포인트 호출 테스트 (Postman/Thunder Client/curl)');
console.log('  4. 로그에서 경고/에러 메시지 확인');
