import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsArray, ValidateNested, IsString, IsNumber, IsOptional, Min, IsEnum } from 'class-validator';
import { Type } from 'class-transformer';

export class ExerciseDto {
	@ApiProperty({
		description: '운동명',
		example: '스쿼트',
	})
	@IsString()
	exerciseName: string;

	@ApiProperty({
		description: '부위 (하체, 가슴, 등, 어깨, 팔 등)',
		example: '하체',
	})
	@IsString()
	bodyPart: string;

	@ApiPropertyOptional({
		description: '세트 수',
		example: 3,
		minimum: 1,
	})
	@IsOptional()
	@IsNumber()
	@Min(1)
	sets?: number;

	@ApiPropertyOptional({
		description: '횟수',
		example: 10,
		minimum: 1,
	})
	@IsOptional()
	@IsNumber()
	@Min(1)
	reps?: number;

	@ApiPropertyOptional({
		description: '무게 (kg)',
		example: 60,
		minimum: 0,
	})
	@IsOptional()
	@IsNumber()
	@Min(0)
	weight?: number;

	@ApiPropertyOptional({
		description: '운동 시간 (분, 유산소 운동인 경우)',
		example: 30,
		minimum: 0,
	})
	@IsOptional()
	@IsNumber()
	@Min(0)
	duration?: number;

	@ApiPropertyOptional({
		description: '휴식 시간 (초)',
		example: 60,
		minimum: 0,
	})
	@IsOptional()
	@IsNumber()
	@Min(0)
	restTime?: number;

	@ApiPropertyOptional({
		description: '메모',
		example: '자세 주의',
	})
	@IsOptional()
	@IsString()
	notes?: string;
}

export class CreateWorkoutRoutineDto {
	@ApiProperty({
		description: '루틴 이름',
		example: '초보자 상체 루틴',
	})
	@IsString()
	routineName: string;

	@ApiPropertyOptional({
		description: '루틴 날짜 (회원별 루틴인 경우)',
		example: '2024-03-15',
		type: String,
		format: 'date',
	})
	@IsOptional()
	@IsDateString()
	routineDate?: string;

	@ApiProperty({
		description: '운동 목록 (최소 1개)',
		type: [ExerciseDto],
		example: [
			{
				exerciseName: '벤치프레스',
				bodyPart: '상체',
				sets: 3,
				reps: 10,
				weight: 50,
				restTime: 60,
				notes: '가슴 근육에 집중',
			},
		],
	})
	@IsArray()
	@ValidateNested({ each: true })
	@Type(() => ExerciseDto)
	exercises: ExerciseDto[];

	@ApiProperty({
		description: '예상 소요 시간 (분)',
		example: 60,
		minimum: 1,
	})
	@IsNumber()
	@Min(1)
	estimatedDuration: number;

	@ApiProperty({
		description: '난이도',
		enum: ['EASY', 'MEDIUM', 'HARD'],
		example: 'EASY',
	})
	@IsEnum(['EASY', 'MEDIUM', 'HARD'])
	difficulty: 'EASY' | 'MEDIUM' | 'HARD';
}

