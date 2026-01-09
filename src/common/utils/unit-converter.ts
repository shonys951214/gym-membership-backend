/**
 * 단위 변환 유틸리티
 * lb (파운드) ↔ kg (킬로그램) 변환
 */

export enum WeightUnit {
	KG = 'kg',
	LB = 'lb',
}

/**
 * 단위 변환기 클래스
 */
export class UnitConverter {
	/**
	 * lb를 kg으로 변환
	 * 1 lb = 0.453592 kg
	 */
	static lbToKg(lb: number): number {
		if (lb < 0) {
			throw new Error('무게는 0 이상이어야 합니다.');
		}
		return Math.round((lb * 0.453592) * 100) / 100;
	}

	/**
	 * kg을 lb로 변환
	 * 1 kg = 2.20462 lb
	 */
	static kgToLb(kg: number): number {
		if (kg < 0) {
			throw new Error('무게는 0 이상이어야 합니다.');
		}
		return Math.round((kg * 2.20462) * 100) / 100;
	}

	/**
	 * 단위 변환
	 * @param value 변환할 값
	 * @param fromUnit 원본 단위
	 * @param toUnit 목표 단위
	 * @returns 변환된 값
	 */
	static convert(value: number, fromUnit: WeightUnit, toUnit: WeightUnit): number {
		if (fromUnit === toUnit) {
			return value;
		}

		if (fromUnit === WeightUnit.KG && toUnit === WeightUnit.LB) {
			return this.kgToLb(value);
		}

		if (fromUnit === WeightUnit.LB && toUnit === WeightUnit.KG) {
			return this.lbToKg(value);
		}

		throw new Error(`지원하지 않는 단위 변환: ${fromUnit} → ${toUnit}`);
	}
}
