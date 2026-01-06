import { IsEnum, IsString, IsNumber, MaxLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Category } from '../../../common/enums';

export class CreateAssessmentItemDto {
	@ApiProperty({
		description: '평가 카테고리',
		enum: Category,
		example: Category.STRENGTH,
	})
	@IsEnum(Category, { message: '올바른 카테고리가 아닙니다.' })
	category: Category;

	@ApiProperty({
		description: '평가 항목 이름',
		example: '벤치프레스',
		maxLength: 255,
	})
	@IsString({ message: '이름은 문자열이어야 합니다.' })
	@MaxLength(255, { message: '이름은 255자 이하여야 합니다.' })
	name: string;

	@ApiProperty({
		description: '측정값',
		example: 80,
	})
	@IsNumber({}, { message: '값은 숫자여야 합니다.' })
	value: number;

	@ApiProperty({
		description: '단위',
		example: 'kg',
		maxLength: 50,
	})
	@IsString({ message: '단위는 문자열이어야 합니다.' })
	@MaxLength(50, { message: '단위는 50자 이하여야 합니다.' })
	unit: string;
}

