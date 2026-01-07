import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

// 대시보드 응답 DTO (Swagger 문서화용)
export class GoalDto {
	@ApiPropertyOptional({
		description: '회원의 목표 한줄 요약',
		example: '체중 5kg 감량',
	})
	goal?: string;

	@ApiProperty({
		description: '목표 진행률 (0-100)',
		example: 60,
		minimum: 0,
		maximum: 100,
	})
	goalProgress: number;

	@ApiPropertyOptional({
		description: '트레이너 동기부여 코멘트',
		example: '좋은 진전이 있습니다! 계속 화이팅!',
	})
	goalTrainerComment?: string;
}

export class SessionProgressDto {
	@ApiProperty({
		description: '총 수업 회차',
		example: 20,
		minimum: 0,
	})
	totalSessions: number;

	@ApiProperty({
		description: '완료된 수업 회차',
		example: 12,
		minimum: 0,
	})
	completedSessions: number;

	@ApiProperty({
		description: '수업 진행률 (%)',
		example: 60,
		minimum: 0,
		maximum: 100,
	})
	progressPercentage: number;
}

export class PTSessionCalendarItemDto {
	@ApiProperty({
		description: 'PT 세션 ID',
		example: 'uuid',
	})
	id: string;

	@ApiProperty({
		description: '세션 번호',
		example: 5,
		minimum: 1,
	})
	sessionNumber: number;

	@ApiProperty({
		description: '주요 수업 내용',
		example: '하체 근력 운동 - 스쿼트, 레그프레스',
	})
	mainContent: string;
}

export class PersonalWorkoutCalendarItemDto {
	@ApiProperty({
		description: '운동 기록 ID',
		example: 'uuid',
	})
	id: string;

	@ApiProperty({
		description: '운동명',
		example: '스쿼트',
	})
	exerciseName: string;

	@ApiProperty({
		description: '부위',
		example: '하체',
	})
	bodyPart: string;
}

export class WorkoutCalendarItemDto {
	@ApiProperty({
		description: '날짜 (YYYY-MM-DD)',
		example: '2024-03-15',
	})
	date: string;

	@ApiProperty({
		description: 'PT 세션 목록',
		type: [PTSessionCalendarItemDto],
	})
	ptSessions: PTSessionCalendarItemDto[];

	@ApiProperty({
		description: '개인 운동 기록 목록',
		type: [PersonalWorkoutCalendarItemDto],
	})
	personalWorkouts: PersonalWorkoutCalendarItemDto[];
}

export class BodyPartVolumeDto {
	@ApiProperty({
		description: '부위',
		example: '하체',
	})
	bodyPart: string;

	@ApiProperty({
		description: '볼륨 (kg)',
		example: 1500.5,
		minimum: 0,
	})
	volume: number;
}

export class WorkoutAnalysisDto {
	@ApiProperty({
		description: '집계 기간',
		enum: ['week', 'month'],
		example: 'week',
	})
	period: 'week' | 'month';

	@ApiProperty({
		description: '부위별 볼륨',
		type: [BodyPartVolumeDto],
	})
	bodyPartVolumes: BodyPartVolumeDto[];

	@ApiProperty({
		description: '총 볼륨 (kg)',
		example: 5000.0,
		minimum: 0,
	})
	totalVolume: number;
}

export class DashboardResponseDto {
	@ApiProperty({
		description: '목표 정보',
		type: GoalDto,
	})
	goal: GoalDto;

	@ApiProperty({
		description: '수업 진행률',
		type: SessionProgressDto,
	})
	sessionProgress: SessionProgressDto;

	@ApiProperty({
		description: '운동 캘린더 (최근 30일)',
		type: [WorkoutCalendarItemDto],
	})
	workoutCalendar: WorkoutCalendarItemDto[];

	@ApiProperty({
		description: '운동 기록 분석',
		type: WorkoutAnalysisDto,
	})
	workoutAnalysis: WorkoutAnalysisDto;
}

// 타입 정의용 인터페이스 (기존 호환성 유지)
export interface DashboardResponse {
	goal: {
		goal?: string;
		goalProgress: number;
		goalTrainerComment?: string;
	};
	sessionProgress: {
		totalSessions: number;
		completedSessions: number;
		progressPercentage: number;
	};
	workoutCalendar: Array<{
		date: string;
		ptSessions: Array<{
			id: string;
			sessionNumber: number;
			mainContent: string;
		}>;
		personalWorkouts: Array<{
			id: string;
			exerciseName: string;
			bodyPart: string;
		}>;
	}>;
	workoutAnalysis: {
		period: 'week' | 'month';
		bodyPartVolumes: Array<{
			bodyPart: string;
			volume: number;
		}>;
		totalVolume: number;
	};
}

