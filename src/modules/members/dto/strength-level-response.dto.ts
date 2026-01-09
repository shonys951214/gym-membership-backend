import { ApiProperty } from '@nestjs/swagger';
import { StrengthLevel } from '../../../common/enums';

export class StrengthLevelResponseDto {
	@ApiProperty({ description: '1RM (One Rep Max) 계산값 (kg)', example: 100.5 })
	oneRepMax: number;

	@ApiProperty({ description: '상대적 강도 (체중 대비 무게 비율, %)', example: 150.25 })
	relativeStrength: number;

	@ApiProperty({
		description: 'Strength Level 판정 결과',
		enum: StrengthLevel,
		example: StrengthLevel.INTERMEDIATE,
		nullable: true,
	})
	strengthLevel: StrengthLevel | null;

	@ApiProperty({ description: '기준 무게 (kg)', example: 95.0, nullable: true })
	standardWeight?: number;

	@ApiProperty({ description: '체중 (kg)', example: 70.0 })
	bodyWeight: number;
}

export class StrengthProgressResponseDto {
	@ApiProperty({ description: '운동명', example: '벤치프레스' })
	exerciseName: string;

	@ApiProperty({ type: [StrengthLevelResponseDto], description: '시간별 Strength Level 변화' })
	history: StrengthLevelResponseDto[];

	@ApiProperty({ type: StrengthLevelResponseDto, description: '현재 Strength Level', nullable: true })
	current?: StrengthLevelResponseDto;
}
