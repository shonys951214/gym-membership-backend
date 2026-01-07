/**
 * 페이지네이션 헬퍼 유틸리티
 */
export class PaginationHelper {
	/**
	 * 페이지네이션 파라미터 계산
	 */
	static calculateSkip(page: number, pageSize: number): number {
		return (page - 1) * pageSize;
	}

	/**
	 * 페이지네이션 결과 생성
	 */
	static createResult<T>(
		items: T[],
		total: number,
		page: number,
		pageSize: number,
	): {
		items: T[];
		total: number;
		page: number;
		pageSize: number;
		totalPages: number;
	} {
		return {
			items,
			total,
			page,
			pageSize,
			totalPages: Math.ceil(total / pageSize),
		};
	}

	/**
	 * 페이지네이션 쿼리 파라미터 파싱
	 */
	static parseQueryParams(
		page?: string | number,
		pageSize?: string | number,
	): { page: number; pageSize: number } {
		return {
			page: page ? Number(page) : 1,
			pageSize: pageSize ? Number(pageSize) : 10,
		};
	}
}

