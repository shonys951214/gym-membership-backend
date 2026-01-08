/**
 * 엔티티 업데이트 헬퍼 유틸리티
 * 날짜 변환 및 필드 업데이트 로직 통일
 */
export class EntityUpdateHelper {
	/**
	 * 엔티티 필드 업데이트 (undefined가 아닌 필드만 업데이트)
	 * @param entity 업데이트할 엔티티
	 * @param updateDto 업데이트할 데이터
	 * @param fieldMappers 필드별 변환 함수 (선택)
	 * @returns 업데이트된 엔티티
	 */
	static updateFields<T extends Record<string, any>>(
		entity: T,
		updateDto: Partial<T>,
		fieldMappers?: Record<string, (value: any) => any>,
	): T {
		Object.keys(updateDto).forEach((key) => {
			const value = updateDto[key];
			if (value !== undefined) {
				if (fieldMappers && fieldMappers[key]) {
					(entity as any)[key] = fieldMappers[key](value);
				} else {
					(entity as any)[key] = value;
				}
			}
		});

		return entity;
	}

	/**
	 * 날짜 필드 변환과 함께 업데이트
	 * DTO의 날짜 필드는 string이지만 Entity는 Date이므로 변환 필요
	 * @param entity 업데이트할 엔티티
	 * @param updateDto 업데이트할 데이터
	 * @param dateFields 날짜로 변환할 필드명 배열
	 * @returns 업데이트된 엔티티
	 */
	static updateFieldsWithDateConversion<T extends Record<string, any>, D extends Record<string, any>>(
		entity: T,
		updateDto: Partial<D>,
		dateFields: string[] = [],
	): T {
		const fieldMappers: Record<string, (value: any) => any> = {};

		dateFields.forEach((field) => {
			fieldMappers[field] = (value: string | Date | null | undefined) => {
				if (value === null || value === undefined) {
					return value;
				}
				return value instanceof Date ? value : new Date(value);
			};
		});

		return this.updateFields(entity, updateDto as unknown as Partial<T>, fieldMappers);
	}

	/**
	 * DTO에서 엔티티 생성 시 날짜 필드 변환
	 * @param dto DTO 객체
	 * @param dateFields 날짜로 변환할 필드명 배열
	 * @returns 변환된 객체
	 */
	static convertDateFields<T extends Record<string, any>>(
		dto: T,
		dateFields: string[] = [],
	): T {
		const result = { ...dto } as any;
		dateFields.forEach((field) => {
			if (result[field] !== undefined && result[field] !== null) {
				result[field] = result[field] instanceof Date 
					? result[field] 
					: new Date(result[field]);
			}
		});
		return result as T;
	}
}

