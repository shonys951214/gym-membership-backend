/**
 * 한국시간(KST, UTC+9) 변환 유틸리티
 */
export class DateHelper {
	/**
	 * 현재 시간을 한국시간(KST) ISO 문자열로 반환
	 * @returns 한국시간 ISO 문자열 (예: "2026-01-06T10:23:31.404+09:00")
	 */
	static getKoreaTimeISOString(): string {
		const now = new Date();
		const koreaTime = new Date(now.getTime() + 9 * 60 * 60 * 1000); // UTC+9
		return koreaTime.toISOString().replace('Z', '+09:00');
	}

	/**
	 * Date 객체를 한국시간 ISO 문자열로 변환
	 * @param date 변환할 Date 객체
	 * @returns 한국시간 ISO 문자열
	 */
	static toKoreaTimeISOString(date: Date): string {
		const koreaTime = new Date(date.getTime() + 9 * 60 * 60 * 1000);
		return koreaTime.toISOString().replace('Z', '+09:00');
	}

	/**
	 * 현재 시간을 한국시간 Date 객체로 반환
	 * @returns 한국시간 Date 객체
	 */
	static getKoreaTime(): Date {
		const now = new Date();
		return new Date(now.getTime() + 9 * 60 * 60 * 1000);
	}

	/**
	 * 생년월일로부터 한국나이 계산
	 * 한국나이: 태어난 해를 1살로 계산하고, 현재 연도에서 출생 연도를 뺀 값에 1을 더함
	 * @param birthDate 생년월일 (Date 객체 또는 문자열)
	 * @returns 한국나이 (생년월일이 없으면 null)
	 * @example
	 * // 2000년 1월 1일생이 2024년 기준
	 * calculateKoreanAge(new Date('2000-01-01')) // 25 (2024 - 2000 + 1)
	 */
	static calculateKoreanAge(birthDate: Date | string | null | undefined): number | null {
		if (!birthDate) {
			return null;
		}

		const birth = typeof birthDate === 'string' ? new Date(birthDate) : birthDate;
		
		if (isNaN(birth.getTime())) {
			return null;
		}

		const now = new Date();
		const currentYear = now.getFullYear();
		const birthYear = birth.getFullYear();
		
		// 한국나이: 현재 연도 - 출생 연도 + 1
		return currentYear - birthYear + 1;
	}
}

