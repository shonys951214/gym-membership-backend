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
}

