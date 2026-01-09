/**
 * 1RM (One Rep Max) 계산기
 * 다양한 공식을 사용하여 1RM을 계산합니다.
 */

export enum OneRepMaxFormula {
	EPLEY = 'EPLEY', // Epley 공식 (기본값)
	BRZYCKI = 'BRZYCKI', // Brzycki 공식
	LOMBARDI = 'LOMBARDI', // Lombardi 공식
}

/**
 * 1RM 계산 결과
 */
export interface OneRepMaxResult {
	oneRepMax: number; // 계산된 1RM (kg)
	formula: OneRepMaxFormula; // 사용된 공식
}

/**
 * 1RM 계산기 클래스
 */
export class OneRepMaxCalculator {
	/**
	 * Epley 공식으로 1RM 계산
	 * 1RM = weight × (1 + reps/30)
	 */
	static epley(weight: number, reps: number): number {
		if (reps <= 0 || weight <= 0) {
			throw new Error('무게와 횟수는 0보다 커야 합니다.');
		}
		if (reps > 30) {
			// 30회 이상은 정확도가 떨어지므로 경고
			console.warn(`Epley 공식: 30회 이상의 반복은 정확도가 떨어질 수 있습니다. (현재: ${reps}회)`);
		}
		return weight * (1 + reps / 30);
	}

	/**
	 * Brzycki 공식으로 1RM 계산
	 * 1RM = weight × (36 / (37 - reps))
	 */
	static brzycki(weight: number, reps: number): number {
		if (reps <= 0 || weight <= 0) {
			throw new Error('무게와 횟수는 0보다 커야 합니다.');
		}
		if (reps >= 37) {
			throw new Error('Brzycki 공식: 37회 이상의 반복은 계산할 수 없습니다.');
		}
		return weight * (36 / (37 - reps));
	}

	/**
	 * Lombardi 공식으로 1RM 계산
	 * 1RM = weight × reps^0.10
	 */
	static lombardi(weight: number, reps: number): number {
		if (reps <= 0 || weight <= 0) {
			throw new Error('무게와 횟수는 0보다 커야 합니다.');
		}
		return weight * Math.pow(reps, 0.1);
	}

	/**
	 * 지정된 공식으로 1RM 계산
	 * @param weight 무게 (kg)
	 * @param reps 반복 횟수
	 * @param formula 사용할 공식 (기본값: Epley)
	 * @returns 1RM 계산 결과
	 */
	static calculate(
		weight: number,
		reps: number,
		formula: OneRepMaxFormula = OneRepMaxFormula.EPLEY,
	): OneRepMaxResult {
		let oneRepMax: number;

		switch (formula) {
			case OneRepMaxFormula.EPLEY:
				oneRepMax = this.epley(weight, reps);
				break;
			case OneRepMaxFormula.BRZYCKI:
				oneRepMax = this.brzycki(weight, reps);
				break;
			case OneRepMaxFormula.LOMBARDI:
				oneRepMax = this.lombardi(weight, reps);
				break;
			default:
				oneRepMax = this.epley(weight, reps);
		}

		// 소수점 2자리로 반올림
		return {
			oneRepMax: Math.round(oneRepMax * 100) / 100,
			formula,
		};
	}

	/**
	 * 여러 공식의 평균으로 1RM 계산 (더 정확한 결과)
	 * @param weight 무게 (kg)
	 * @param reps 반복 횟수
	 * @returns 평균 1RM
	 */
	static calculateAverage(weight: number, reps: number): number {
		const results: number[] = [];

		// Epley 공식
		try {
			results.push(this.epley(weight, reps));
		} catch (e) {
			// 무시
		}

		// Brzycki 공식
		try {
			results.push(this.brzycki(weight, reps));
		} catch (e) {
			// 무시
		}

		// Lombardi 공식
		try {
			results.push(this.lombardi(weight, reps));
		} catch (e) {
			// 무시
		}

		if (results.length === 0) {
			throw new Error('사용 가능한 공식이 없습니다.');
		}

		const average = results.reduce((sum, val) => sum + val, 0) / results.length;
		return Math.round(average * 100) / 100;
	}
}
