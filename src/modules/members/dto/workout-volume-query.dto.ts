import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsOptional } from 'class-validator';

export enum VolumePeriod {
	WEEK = 'week',
	MONTH = 'month',
}

export class WorkoutVolumeQueryDto {
	@ApiProperty({
		description: '집계 기간',
		enum: VolumePeriod,
		example: VolumePeriod.WEEK,
		required: false,
		default: VolumePeriod.WEEK,
	})
	@IsOptional()
	@IsEnum(VolumePeriod)
	period?: VolumePeriod;
}

