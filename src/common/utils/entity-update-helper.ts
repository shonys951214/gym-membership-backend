/**
 * 엔티티 업데이트 헬퍼 유틸리티
 */
export class EntityUpdateHelper {
	/**
	 * 엔티티 필드 업데이트 (undefined가 아닌 필드만 업데이트)
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
	 */
	static updateFieldsWithDateConversion<T extends Record<string, any>, D extends Record<string, any>>(
		entity: T,
		updateDto: Partial<D>,
		dateFields: string[] = [],
	): T {
		const fieldMappers: Record<string, (value: any) => any> = {};

		dateFields.forEach((field) => {
			fieldMappers[field] = (value: string | Date) => {
				return value ? new Date(value) : value;
			};
		});

		return this.updateFields(entity, updateDto as unknown as Partial<T>, fieldMappers);
	}
}

