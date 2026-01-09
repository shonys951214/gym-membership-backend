/**
 * Strength Level Enum
 * StrengthLevel.com 기준 운동별 상대적 강도 레벨
 */
export enum StrengthLevel {
	BEGINNER = 'BEGINNER',
	NOVICE = 'NOVICE',
	INTERMEDIATE = 'INTERMEDIATE',
	ADVANCED = 'ADVANCED',
	ELITE = 'ELITE',
}

/**
 * Strength Level 한글명 매핑
 */
export const StrengthLevelNames: Record<StrengthLevel, string> = {
	[StrengthLevel.BEGINNER]: '초보자',
	[StrengthLevel.NOVICE]: '입문자',
	[StrengthLevel.INTERMEDIATE]: '중급자',
	[StrengthLevel.ADVANCED]: '고급자',
	[StrengthLevel.ELITE]: '엘리트',
};

/**
 * Strength Level 순서 (낮은 레벨부터 높은 레벨까지)
 */
export const StrengthLevelOrder: StrengthLevel[] = [
	StrengthLevel.BEGINNER,
	StrengthLevel.NOVICE,
	StrengthLevel.INTERMEDIATE,
	StrengthLevel.ADVANCED,
	StrengthLevel.ELITE,
];
