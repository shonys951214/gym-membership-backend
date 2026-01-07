import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsDateString, IsEnum, IsOptional, Min } from 'class-validator';
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
		default: WorkoutType.PERSONAL,
		required: false,
	})
	@IsOptional()
	@IsEnum(WorkoutType)
	workoutType?: WorkoutType;

	@ApiProperty({
		description: '운동 시간 (분)',
		example: 30,
		required: false,
	})
	@IsOptional()
	@IsNumber()
	@Min(0)
	duration?: number;

	@ApiProperty({
		description: 'PT 세션 ID (workoutType이 PT인 경우)',
		example: 'uuid',
		required: false,
	})
	@IsOptional()
	@IsString()
	ptSessionId?: string;

	@ApiProperty({
		description: '트레이너 코멘트',
		example: '좋은 자세',
		required: false,
	})
	@IsOptional()
	@IsString()
	trainerComment?: string;
}

