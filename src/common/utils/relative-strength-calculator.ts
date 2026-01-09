/**
 * 상대적 강도 계산기
 * 체중 대비 무게 비율을 계산합니다.
 */

/**
 * 상대적 강도 계산 결과
 */
export interface RelativeStrengthResult {
	relativeStrength: number; // 상대적 강도 (%)
	oneRepMax: number; // 1RM (kg)
	bodyWeight: number; // 체중 (kg)
}

/**
 * 상대적 강도 계산기 클래스
 */
export class RelativeStrengthCalculator {
	/**
	 * 상대적 강도 계산
	 * relativeStrength = (1RM / bodyWeight) × 100
	 * @param oneRepMax 1RM (kg)
	 * @param bodyWeight 체중 (kg)
	 * @returns 상대적 강도 (%)
	 */
	static calculate(oneRepMax: number, bodyWeight: number): RelativeStrengthResult {
		if (bodyWeight <= 0) {
			throw new Error('체중은 0보다 커야 합니다.');
		}
		if (oneRepMax < 0) {
			throw new Error('1RM은 0 이상이어야 합니다.');
		}

		const relativeStrength = (oneRepMax / bodyWeight) * 100;

		return {
			relativeStrength: Math.round(relativeStrength * 100) / 100, // 소수점 2자리
			oneRepMax,
			bodyWeight,
		};
	}

	/**
	 * 무게와 횟수로부터 상대적 강도 계산
	 * @param weight 무게 (kg)
	 * @param reps 반복 횟수
	 * @param bodyWeight 체중 (kg)
	 * @param formula 1RM 계산 공식 (기본값: Epley)
	 * @returns 상대적 강도 계산 결과
	 */
	static calculateFromWeightAndReps(
		weight: number,
		reps: number,
		bodyWeight: number,
		formula?: any, // OneRepMaxFormula (순환 참조 방지를 위해 any 사용)
	): RelativeStrengthResult {
		// 1RM 계산을 위해 one-rep-max-calculator를 동적으로 import
		const { OneRepMaxCalculator, OneRepMaxFormula } = require('./one-rep-max-calculator');
		const oneRepMaxResult = OneRepMaxCalculator.calculate(
			weight,
			reps,
			formula || OneRepMaxFormula.EPLEY,
		);

		return this.calculate(oneRepMaxResult.oneRepMax, bodyWeight);
	}
}
