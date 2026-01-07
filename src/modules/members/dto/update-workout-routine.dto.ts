import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsArray, ValidateNested, IsBoolean, IsOptional, IsString, IsNumber, IsEnum, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { ExerciseDto } from './create-workout-routine.dto';

export class UpdateWorkoutRoutineDto {
	@ApiPropertyOptional({
		description: '루틴 이름',
		example: '수정된 루틴명',
	})
	@IsOptional()
	@IsString()
	routineName?: string;

	@ApiPropertyOptional({
		description: '루틴 날짜',
		example: '2024-03-15',
	})
	@IsOptional()
	@IsDateString()
	routineDate?: string;

	@ApiPropertyOptional({
		description: '운동 목록',
		type: [ExerciseDto],
	})
	@IsOptional()
	@IsArray()
	@ValidateNested({ each: true })
	@Type(() => ExerciseDto)
	exercises?: ExerciseDto[];

	@ApiPropertyOptional({
		description: '예상 소요 시간 (분)',
		example: 70,
		minimum: 1,
	})
	@IsOptional()
	@IsNumber()
	@Min(1)
	estimatedDuration?: number;

	@ApiPropertyOptional({
		description: '난이도',
		enum: ['EASY', 'MEDIUM', 'HARD'],
		example: 'MEDIUM',
	})
	@IsOptional()
	@IsEnum(['EASY', 'MEDIUM', 'HARD'])
	difficulty?: 'EASY' | 'MEDIUM' | 'HARD';

	@ApiPropertyOptional({
		description: '완료 여부',
		example: true,
	})
	@IsOptional()
	@IsBoolean()
	isCompleted?: boolean;
}

