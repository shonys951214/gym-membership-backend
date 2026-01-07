import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsDateString, IsEnum, Min, IsOptional } from 'class-validator';
import { WorkoutType } from '../../../entities/workout-record.entity';

export class UpdateWorkoutRecordDto {
	@ApiProperty({
		description: '운동 날짜',
		example: '2024-03-15',
		required: false,
	})
	@IsOptional()
	@IsDateString()
	workoutDate?: string;

	@ApiProperty({
		description: '부위 (하체, 가슴, 등, 어깨, 팔 등)',
		example: '하체',
		required: false,
	})
	@IsOptional()
	@IsString()
	bodyPart?: string;

	@ApiProperty({
		description: '운동명',
		example: '스쿼트',
		required: false,
	})
	@IsOptional()
	@IsString()
	exerciseName?: string;

	@ApiProperty({
		description: '무게 (kg)',
		example: 60,
		minimum: 0,
		required: false,
	})
	@IsOptional()
	@IsNumber()
	@Min(0)
	weight?: number;

	@ApiProperty({
		description: '횟수',
		example: 10,
		minimum: 1,
		required: false,
	})
	@IsOptional()
	@IsNumber()
	@Min(1)
	reps?: number;

	@ApiProperty({
		description: '세트 수',
		example: 3,
		minimum: 1,
		required: false,
	})
	@IsOptional()
	@IsNumber()
	@Min(1)
	sets?: number;

	@ApiProperty({
		description: '운동 타입',
		enum: WorkoutType,
		example: WorkoutType.PERSONAL,
		required: false,
	})
	@IsOptional()
	@IsEnum(WorkoutType)
	workoutType?: WorkoutType;
}

