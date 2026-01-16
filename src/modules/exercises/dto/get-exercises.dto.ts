import { IsOptional, IsEnum, IsString, IsUUID, IsBoolean, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { ExerciseCategory } from '../../../entities/exercise.entity';

export class GetExercisesDto {
	@ApiPropertyOptional({
		enum: ExerciseCategory,
		description: '카테고리 필터 (UPPER, LOWER, FULL_BODY)',
	})
	@IsOptional()
	@IsEnum(ExerciseCategory)
	category?: ExerciseCategory;

	@ApiPropertyOptional({
		description: '부위 필터 (가슴, 등, 어깨, 팔, 하체)',
	})
	@IsOptional()
	@IsString()
	bodyPart?: string;

	@ApiPropertyOptional({
		description: '검색어 (운동명 검색)',
	})
	@IsOptional()
	@IsString()
	search?: string;

	@ApiPropertyOptional({
		description: '회원 ID (최근 운동 우선 정렬용)',
	})
	@IsOptional()
	@IsUUID()
	memberId?: string;

	@ApiPropertyOptional({
		description: '최근 운동 정보 포함 여부',
		example: false,
		default: false,
	})
	@IsOptional()
	@IsString()
	includeRecent?: string; // 'true' or 'false' 문자열로 받음

	@ApiPropertyOptional({
		description: '활성화 여부 필터',
		example: true,
		default: true,
	})
	@IsOptional()
	@IsBoolean()
	@Type(() => Boolean)
	isActive?: boolean;

	@ApiPropertyOptional({
		description: '페이지 번호',
		example: 1,
		default: 1,
		minimum: 1,
	})
	@IsOptional()
	@Type(() => Number)
	@IsInt()
	@Min(1)
	page?: number;

	@ApiPropertyOptional({
		description: '페이지당 항목 수',
		example: 50,
		default: 50,
		minimum: 1,
	})
	@IsOptional()
	@Type(() => Number)
	@IsInt()
	@Min(1)
	limit?: number;
}
