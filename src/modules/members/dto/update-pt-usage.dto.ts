import { IsOptional, IsInt, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdatePTUsageDto {
	@ApiPropertyOptional({
		description: '전체 PT 횟수',
		example: 20,
		minimum: 0,
	})
	@IsOptional()
	@IsInt({ message: '전체 횟수는 정수여야 합니다.' })
	@Min(0, { message: '전체 횟수는 0 이상이어야 합니다.' })
	totalCount?: number;

	@ApiPropertyOptional({
		description: '남은 PT 횟수',
		example: 15,
		minimum: 0,
	})
	@IsOptional()
	@IsInt({ message: '남은 횟수는 정수여야 합니다.' })
	@Min(0, { message: '남은 횟수는 0 이상이어야 합니다.' })
	remainingCount?: number;

	@ApiPropertyOptional({
		description: '사용한 PT 횟수',
		example: 5,
		minimum: 0,
	})
	@IsOptional()
	@IsInt({ message: '사용 횟수는 정수여야 합니다.' })
	@Min(0, { message: '사용 횟수는 0 이상이어야 합니다.' })
	usedCount?: number;
}

