import { AbilitySnapshot } from '../../entities/ability-snapshot.entity';

/**
 * AbilitySnapshot 정규화 유틸리티
 * null/undefined 값을 0으로 변환하여 프론트엔드 오류 방지
 */
export class SnapshotNormalizer {
	/**
	 * AbilitySnapshot 정규화 (null 값 처리)
	 */
	static normalize(snapshot: AbilitySnapshot | null | undefined, memberId?: string): AbilitySnapshot {
		if (!snapshot) {
			return this.createDefaultSnapshot(memberId || '');
		}

		return {
			...snapshot,
			strengthScore: snapshot.strengthScore ?? 0,
			cardioScore: snapshot.cardioScore ?? 0,
			enduranceScore: snapshot.enduranceScore ?? 0,
			flexibilityScore: snapshot.flexibilityScore ?? 0,
			bodyScore: snapshot.bodyScore ?? 0,
			stabilityScore: snapshot.stabilityScore ?? 0,
			totalScore: snapshot.totalScore ?? 0,
		};
	}

	/**
	 * AbilitySnapshot 배열 정규화
	 */
	static normalizeArray(snapshots: (AbilitySnapshot | null | undefined)[]): AbilitySnapshot[] {
		return snapshots
			.filter((s): s is AbilitySnapshot => s !== null && s !== undefined)
			.map((snapshot) => this.normalize(snapshot));
	}

	/**
	 * 기본 스냅샷 객체 생성
	 */
	static createDefaultSnapshot(memberId: string): AbilitySnapshot {
		return {
			id: '',
			assessmentId: '',
			memberId,
			assessedAt: new Date(),
			version: 'v1',
			strengthScore: 0,
			cardioScore: 0,
			enduranceScore: 0,
			flexibilityScore: 0,
			bodyScore: 0,
			stabilityScore: 0,
			totalScore: 0,
			createdAt: new Date(),
		} as AbilitySnapshot;
	}

	/**
	 * 평균 스냅샷 생성
	 */
	static createAverageSnapshot(averages: {
		strengthScore: number;
		cardioScore: number;
		enduranceScore: number;
		flexibilityScore: number;
		bodyScore: number;
		stabilityScore: number;
		totalScore: number;
	}): AbilitySnapshot {
		return {
			id: '',
			assessmentId: '',
			memberId: '',
			assessedAt: new Date(),
			version: 'v1',
			strengthScore: averages.strengthScore,
			cardioScore: averages.cardioScore,
			enduranceScore: averages.enduranceScore,
			flexibilityScore: averages.flexibilityScore,
			bodyScore: averages.bodyScore,
			stabilityScore: averages.stabilityScore,
			totalScore: averages.totalScore,
			createdAt: new Date(),
		} as AbilitySnapshot;
	}
}

