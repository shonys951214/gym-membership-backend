import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class GoalResponseDto {
	@ApiProperty({
		description: '회원 ID',
		example: 'bc1d82ac-a80c-4674-a308-5e792128a181',
	})
	id: string;

	@ApiProperty({
		description: '회원 ID (memberId와 동일)',
		example: 'bc1d82ac-a80c-4674-a308-5e792128a181',
	})
	memberId: string;

	@ApiPropertyOptional({
		description: '회원의 목표 한줄 요약',
		example: '체중 5kg 감량, 데드리프트 150kg 달성',
	})
	goal?: string;

	@ApiProperty({
		description: '목표 진행률 (0-100)',
		example: 45,
		minimum: 0,
		maximum: 100,
	})
	goalProgress: number;

	@ApiPropertyOptional({
		description: '트레이너 동기부여 코멘트',
		example: '꾸준히 노력하고 있습니다!',
	})
	goalTrainerComment?: string;

	@ApiProperty({
		description: '총 PT 수업 회차',
		example: 20,
		minimum: 0,
	})
	totalSessions: number;

	@ApiProperty({
		description: '완료된 PT 수업 회차',
		example: 10,
		minimum: 0,
	})
	completedSessions: number;

	@ApiProperty({
		description: '생성일시',
		example: '2024-01-01T00:00:00.000Z',
	})
	createdAt: Date;

	@ApiProperty({
		description: '수정일시',
		example: '2024-01-15T00:00:00.000Z',
	})
	updatedAt: Date;
}

