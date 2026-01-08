-- 가중치 변경에 따른 기존 AbilitySnapshot의 totalScore 재계산
-- 주의: 이 스크립트는 선택적으로 실행하세요. 기존 데이터의 totalScore가 변경됩니다.

-- 가중치 변경 사항:
-- - 안정성: 10% → 20%
-- - 심폐 지구력: 20% (유지)
-- - 근지구력: 20% (유지)
-- - 하체 근력: 25% → 15%
-- - 체성분 밸런스: 10% → 15%
-- - 유연성: 15% → 10%

-- 새로운 가중치로 totalScore 재계산
UPDATE ability_snapshots
SET total_score = (
  COALESCE(stability_score, 0) * 0.2 +
  COALESCE(cardio_score, 0) * 0.2 +
  COALESCE(endurance_score, 0) * 0.2 +
  COALESCE(strength_score, 0) * 0.15 +
  COALESCE(body_score, 0) * 0.15 +
  COALESCE(flexibility_score, 0) * 0.1
) / (
  CASE WHEN stability_score IS NOT NULL THEN 0.2 ELSE 0 END +
  CASE WHEN cardio_score IS NOT NULL THEN 0.2 ELSE 0 END +
  CASE WHEN endurance_score IS NOT NULL THEN 0.2 ELSE 0 END +
  CASE WHEN strength_score IS NOT NULL THEN 0.15 ELSE 0 END +
  CASE WHEN body_score IS NOT NULL THEN 0.15 ELSE 0 END +
  CASE WHEN flexibility_score IS NOT NULL THEN 0.1 ELSE 0 END
)
WHERE (
  CASE WHEN stability_score IS NOT NULL THEN 0.2 ELSE 0 END +
  CASE WHEN cardio_score IS NOT NULL THEN 0.2 ELSE 0 END +
  CASE WHEN endurance_score IS NOT NULL THEN 0.2 ELSE 0 END +
  CASE WHEN strength_score IS NOT NULL THEN 0.15 ELSE 0 END +
  CASE WHEN body_score IS NOT NULL THEN 0.15 ELSE 0 END +
  CASE WHEN flexibility_score IS NOT NULL THEN 0.1 ELSE 0 END
) > 0;

-- 재계산 완료 로그
DO $$
DECLARE
  updated_count INTEGER;
BEGIN
  GET DIAGNOSTICS updated_count = ROW_COUNT;
  RAISE NOTICE '총 %개의 스냅샷 totalScore가 재계산되었습니다.', updated_count;
END $$;

