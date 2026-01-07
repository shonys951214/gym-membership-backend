export enum AssessmentType {
	INITIAL = 'INITIAL',
	PERIODIC = 'PERIODIC',
}

// 1차피드백: 평가 위계 구조 - 정적/동적 평가 구분
export enum EvaluationType {
	STATIC = 'STATIC', // 정적평가: 설문조사, 체성분 평가, 육안체형평가
	DYNAMIC = 'DYNAMIC', // 동적평가: 유연성, 근력, 밸런스, 유산소성 평가
}

export enum Condition {
	EXCELLENT = 'EXCELLENT',
	GOOD = 'GOOD',
	NORMAL = 'NORMAL',
	POOR = 'POOR',
}

export enum Category {
	STRENGTH = 'STRENGTH',
	CARDIO = 'CARDIO',
	ENDURANCE = 'ENDURANCE',
	FLEXIBILITY = 'FLEXIBILITY', // 1차피드백: 유연성 추가
	BODY = 'BODY',
	STABILITY = 'STABILITY',
}

