import { SelectQueryBuilder } from 'typeorm';

/**
 * 쿼리 빌더 헬퍼 유틸리티
 */
export class QueryBuilderHelper {
	/**
	 * 날짜 범위 필터 추가
	 */
	static addDateRangeFilter<T>(
		queryBuilder: SelectQueryBuilder<T>,
		dateField: string,
		startDate?: string,
		endDate?: string,
	): SelectQueryBuilder<T> {
		if (startDate) {
			queryBuilder.andWhere(`${dateField} >= :startDate`, { startDate });
		}

		if (endDate) {
			queryBuilder.andWhere(`${dateField} <= :endDate`, { endDate });
		}

		return queryBuilder;
	}

	/**
	 * memberId 필터 추가
	 */
	static addMemberIdFilter<T>(
		queryBuilder: SelectQueryBuilder<T>,
		memberIdField: string,
		memberId: string,
	): SelectQueryBuilder<T> {
		return queryBuilder.where(`${memberIdField} = :memberId`, { memberId });
	}

	/**
	 * 정렬 추가
	 */
	static addOrderBy<T>(
		queryBuilder: SelectQueryBuilder<T>,
		field: string,
		direction: 'ASC' | 'DESC' = 'DESC',
	): SelectQueryBuilder<T> {
		return queryBuilder.orderBy(field, direction);
	}

	/**
	 * 추가 정렬 추가 (여러 필드 정렬 지원)
	 */
	static addAdditionalOrderBy<T>(
		queryBuilder: SelectQueryBuilder<T>,
		field: string,
		direction: 'ASC' | 'DESC' = 'DESC',
	): SelectQueryBuilder<T> {
		return queryBuilder.addOrderBy(field, direction);
	}

	/**
	 * 페이지네이션 적용
	 */
	static addPagination<T>(
		queryBuilder: SelectQueryBuilder<T>,
		page: number,
		pageSize: number,
	): SelectQueryBuilder<T> {
		const skip = (page - 1) * pageSize;
		return queryBuilder.skip(skip).take(pageSize);
	}
}

