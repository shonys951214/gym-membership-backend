import { IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { Category } from '../../../common/enums';

export class CreateInjuryRestrictionDto {
	@ApiProperty({
		description: '제한할 평가 카테고리',
		enum: Category,
		example: Category.STRENGTH,
	})
	@IsEnum(Category, { message: '올바른 제한 카테고리가 아닙니다.' })
	restrictedCategory: Category;
}

