/**
 * 날짜 범위 헬퍼 유틸리티
 */
export class DateRangeHelper {
	/**
	 * 주간 범위 계산 (월요일 ~ 일요일)
	 */
	static getWeekRange(date: Date = new Date()): { start: Date; end: Date } {
		const dayOfWeek = date.getDay();
		const diff = dayOfWeek === 0 ? 6 : dayOfWeek - 1; // 일요일이면 6일 전, 아니면 dayOfWeek - 1

		const start = new Date(date);
		start.setDate(date.getDate() - diff);
		start.setHours(0, 0, 0, 0);

		const end = new Date(date);
		end.setHours(23, 59, 59, 999);

		return { start, end };
	}

	/**
	 * 월간 범위 계산
	 */
	static getMonthRange(date: Date = new Date()): { start: Date; end: Date } {
		const start = new Date(date.getFullYear(), date.getMonth(), 1);
		start.setHours(0, 0, 0, 0);

		const end = new Date(date.getFullYear(), date.getMonth() + 1, 0);
		end.setHours(23, 59, 59, 999);

		return { start, end };
	}

	/**
	 * 날짜 문자열을 Date로 변환 (YYYY-MM-DD 형식)
	 */
	static parseDateString(dateString: string): Date {
		return new Date(dateString);
	}

	/**
	 * Date를 YYYY-MM-DD 형식 문자열로 변환
	 */
	static formatDateString(date: Date): string {
		return date.toISOString().split('T')[0];
	}
}

