/**
 * 회원 관련 공통 헬퍼 유틸리티
 */
import { DateHelper } from './date-helper';

export class MemberHelper {
	/**
	 * 생년월일로부터 한국나이 계산 및 반환
	 * @param birthDate 생년월일 (Date 객체 또는 string)
	 * @returns 한국나이 (생년월일이 없으면 null)
	 */
	static calculateAge(birthDate: Date | string | null | undefined): number | null {
		if (!birthDate) {
			return null;
		}

		const birth = typeof birthDate === 'string' ? new Date(birthDate) : birthDate;
		return DateHelper.calculateKoreanAge(birth);
	}

	/**
	 * 생년월일이 업데이트된 경우 나이 재계산
	 * @param currentBirthDate 현재 생년월일
	 * @param newBirthDate 새로운 생년월일 (업데이트 시)
	 * @returns 계산된 나이 (생년월일이 없으면 null)
	 */
	static recalculateAge(
		currentBirthDate: Date | null | undefined,
		newBirthDate: Date | string | null | undefined,
	): number | null {
		// 새로운 생년월일이 명시적으로 제공된 경우
		if (newBirthDate !== undefined) {
			if (newBirthDate === null) {
				return null; // 명시적으로 null로 설정된 경우
			}
			return this.calculateAge(newBirthDate);
		}

		// 새로운 생년월일이 없으면 현재 생년월일로 계산
		return this.calculateAge(currentBirthDate);
	}
}

