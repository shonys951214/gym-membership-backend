import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, IsInt, Min, Max } from 'class-validator';

export class CreateGoalDto {
	@ApiProperty({
		description: '회원의 목표 한줄 요약',
		example: '체중 5kg 감량, 데드리프트 150kg 달성',
	})
	@IsString()
	goal: string;

	@ApiPropertyOptional({
		description: '목표 진행률 (0-100)',
		example: 0,
		minimum: 0,
		maximum: 100,
		default: 0,
	})
	@IsOptional()
	@IsInt()
	@Min(0)
	@Max(100)
	goalProgress?: number;

	@ApiPropertyOptional({
		description: '트레이너 동기부여 코멘트',
		example: '동기부여 코멘트',
	})
	@IsOptional()
	@IsString()
	goalTrainerComment?: string;
}

