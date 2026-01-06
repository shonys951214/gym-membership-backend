import { IsOptional, IsInt, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class CompareSnapshotsQueryDto {
	@ApiPropertyOptional({
		description: '이전 평가와 비교할 개수 (기본값: 1)',
		example: 1,
		minimum: 1,
		default: 1,
	})
	@IsOptional()
	@Type(() => Number)
	@IsInt({ message: 'prev는 정수여야 합니다.' })
	@Min(1, { message: 'prev는 1 이상이어야 합니다.' })
	prev?: number;
}

