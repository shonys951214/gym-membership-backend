/**
 * 운동 기록 관련 헬퍼 유틸리티
 */
export class WorkoutHelper {
	/**
	 * 볼륨 계산 (weight * reps * sets)
	 */
	static calculateVolume(weight: number, reps: number, sets: number): number {
		return weight * reps * sets;
	}

	/**
	 * 운동 기록 기본값 처리
	 */
	static normalizeWorkoutValues(
		weight?: number,
		reps?: number,
		sets?: number,
	): { weight: number; reps: number; sets: number; volume: number } {
		const normalizedWeight = weight ?? 0;
		const normalizedReps = reps ?? 1;
		const normalizedSets = sets ?? 1;
		const volume = this.calculateVolume(normalizedWeight, normalizedReps, normalizedSets);

		return {
			weight: normalizedWeight,
			reps: normalizedReps,
			sets: normalizedSets,
			volume,
		};
	}
}

