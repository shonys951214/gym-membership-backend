import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsDateString, IsEnum, Min } from 'class-validator';
import { WorkoutType } from '../../../entities/workout-record.entity';

export class CreateWorkoutRecordDto {
	@ApiProperty({
		description: '운동 날짜',
		example: '2024-03-15',
		type: String,
		format: 'date',
	})
	@IsDateString()
	workoutDate: string;

	@ApiProperty({
		description: '부위 (하체, 가슴, 등, 어깨, 팔 등)',
		example: '하체',
	})
	@IsString()
	bodyPart: string;

	@ApiProperty({
		description: '운동명',
		example: '스쿼트',
	})
	@IsString()
	exerciseName: string;

	@ApiProperty({
		description: '무게 (kg)',
		example: 60,
		minimum: 0,
	})
	@IsNumber()
	@Min(0)
	weight: number;

	@ApiProperty({
		description: '횟수',
		example: 10,
		minimum: 1,
	})
	@IsNumber()
	@Min(1)
	reps: number;

	@ApiProperty({
		description: '세트 수',
		example: 3,
		minimum: 1,
	})
	@IsNumber()
	@Min(1)
	sets: number;

	@ApiProperty({
		description: '운동 타입',
		enum: WorkoutType,
		example: WorkoutType.PERSONAL,
		default: WorkoutType.PERSONAL,
	})
	@IsEnum(WorkoutType)
	workoutType: WorkoutType;
}

