import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsDateString, IsOptional } from 'class-validator';

export class CreatePTSessionDto {
	@ApiProperty({
		description: '수업 날짜',
		example: '2024-03-15',
		type: String,
		format: 'date',
	})
	@IsDateString()
	sessionDate: string;

	@ApiProperty({
		description: '주요 수업 내용',
		example: '하체 근력 운동 - 스쿼트, 레그프레스, 런지',
	})
	@IsString()
	mainContent: string;

	@ApiProperty({
		description: '트레이너 코멘트',
		example: '자세가 많이 개선되었습니다!',
		required: false,
	})
	@IsOptional()
	@IsString()
	trainerComment?: string;
}

