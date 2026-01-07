import { AbilitySnapshot } from '../../entities/ability-snapshot.entity';
import { SnapshotNormalizer } from './snapshot-normalizer';

/**
 * 분석 관련 헬퍼 유틸리티
 */
export class AnalyticsHelper {
	/**
	 * AbilitySnapshot 배열의 평균 계산
	 */
	static calculateAverages(snapshots: (AbilitySnapshot | null | undefined)[]): {
		strengthScore: number;
		cardioScore: number;
		enduranceScore: number;
		flexibilityScore: number;
		bodyScore: number;
		stabilityScore: number;
		totalScore: number;
	} {
		const validSnapshots = SnapshotNormalizer.normalizeArray(snapshots);

		if (validSnapshots.length === 0) {
			return {
				strengthScore: 0,
				cardioScore: 0,
				enduranceScore: 0,
				flexibilityScore: 0,
				bodyScore: 0,
				stabilityScore: 0,
				totalScore: 0,
			};
		}

		const sums = {
			strengthScore: 0,
			cardioScore: 0,
			enduranceScore: 0,
			flexibilityScore: 0,
			bodyScore: 0,
			stabilityScore: 0,
			totalScore: 0,
		};

		validSnapshots.forEach((snapshot) => {
			sums.strengthScore += snapshot.strengthScore;
			sums.cardioScore += snapshot.cardioScore;
			sums.enduranceScore += snapshot.enduranceScore;
			sums.flexibilityScore += snapshot.flexibilityScore;
			sums.bodyScore += snapshot.bodyScore;
			sums.stabilityScore += snapshot.stabilityScore;
			sums.totalScore += snapshot.totalScore;
		});

		const count = validSnapshots.length;
		return {
			strengthScore: sums.strengthScore / count,
			cardioScore: sums.cardioScore / count,
			enduranceScore: sums.enduranceScore / count,
			flexibilityScore: sums.flexibilityScore / count,
			bodyScore: sums.bodyScore / count,
			stabilityScore: sums.stabilityScore / count,
			totalScore: sums.totalScore / count,
		};
	}

	/**
	 * 백분위 계산
	 */
	static calculatePercentile(memberValue: number, averageValue: number): number {
		if (averageValue === 0) return 50;
		const ratio = memberValue / averageValue;
		return Math.min(100, Math.max(0, (ratio - 0.5) * 100 + 50));
	}

	/**
	 * 백분위 객체 계산
	 */
	static calculatePercentiles(
		memberSnapshot: AbilitySnapshot,
		averages: {
			strengthScore: number;
			cardioScore: number;
			enduranceScore: number;
			flexibilityScore: number;
			bodyScore: number;
			stabilityScore: number;
			totalScore: number;
		},
	): {
		strengthScore: number;
		cardioScore: number;
		enduranceScore: number;
		flexibilityScore: number;
		bodyScore: number;
		stabilityScore: number;
		totalScore: number;
	} {
		const normalized = SnapshotNormalizer.normalize(memberSnapshot);

		return {
			strengthScore: this.calculatePercentile(normalized.strengthScore, averages.strengthScore),
			cardioScore: this.calculatePercentile(normalized.cardioScore, averages.cardioScore),
			enduranceScore: this.calculatePercentile(normalized.enduranceScore, averages.enduranceScore),
			flexibilityScore: this.calculatePercentile(normalized.flexibilityScore, averages.flexibilityScore),
			bodyScore: this.calculatePercentile(normalized.bodyScore, averages.bodyScore),
			stabilityScore: this.calculatePercentile(normalized.stabilityScore, averages.stabilityScore),
			totalScore: this.calculatePercentile(normalized.totalScore, averages.totalScore),
		};
	}
}

