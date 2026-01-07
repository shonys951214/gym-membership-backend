import { IsOptional, IsDateString, IsString, IsNumber, IsEnum, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Condition, EvaluationType } from '../../../common/enums';
import { CreateAssessmentItemDto } from './create-assessment-item.dto';

export class UpdateAssessmentDto {
	@ApiPropertyOptional({
		description: '평가일 (YYYY-MM-DD 형식)',
		example: '2024-01-01',
	})
	@IsOptional()
	@IsDateString({}, { message: '올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)' })
	assessedAt?: string;

	@ApiPropertyOptional({
		description: '트레이너 코멘트',
		example: '전반적으로 양호한 상태입니다.',
	})
	@IsOptional()
	@IsString({ message: '트레이너 코멘트는 문자열이어야 합니다.' })
	trainerComment?: string;

	@ApiPropertyOptional({
		description: '체중 (kg)',
		example: 70.5,
	})
	@IsOptional()
	@IsNumber({}, { message: '체중은 숫자여야 합니다.' })
	bodyWeight?: number;

	@ApiPropertyOptional({
		description: '컨디션',
		enum: Condition,
		example: Condition.GOOD,
	})
	@IsOptional()
	@IsEnum(Condition, { message: '올바른 컨디션이 아닙니다.' })
	condition?: Condition;

	@ApiPropertyOptional({
		description: '평가 위계 타입 (정적/동적 평가 구분)',
		enum: EvaluationType,
		example: EvaluationType.DYNAMIC,
		required: false,
	})
	@IsOptional()
	@IsEnum(EvaluationType, { message: '올바른 평가 위계 타입이 아닙니다.' })
	evaluationType?: EvaluationType;

	@ApiPropertyOptional({
		description: '정적평가 데이터 (설문조사, 체성분 평가, 육안체형평가)',
		required: false,
	})
	@IsOptional()
	staticEvaluation?: {
		survey?: any;
		bodyComposition?: any;
		visualAssessment?: any;
	};

	@ApiPropertyOptional({
		description: '동적평가 데이터 (유연성, 근력, 밸런스, 유산소성 평가)',
		required: false,
	})
	@IsOptional()
	dynamicEvaluation?: {
		flexibility?: any;
		strength?: any;
		balance?: any;
		cardio?: any;
	};

	@ApiPropertyOptional({
		description: '평가 항목 배열',
		type: [CreateAssessmentItemDto],
		example: [
			{
				category: 'STRENGTH',
				name: '벤치프레스',
				value: 80,
				unit: 'kg',
			},
		],
	})
	@IsOptional()
	@IsArray({ message: '평가 항목은 배열이어야 합니다.' })
	@ValidateNested({ each: true })
	@Type(() => CreateAssessmentItemDto)
	items?: CreateAssessmentItemDto[];
}

