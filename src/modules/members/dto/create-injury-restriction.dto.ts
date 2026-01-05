import { IsEnum } from 'class-validator';
import { Category } from '../../../common/enums';

export class CreateInjuryRestrictionDto {
  @IsEnum(Category, { message: '올바른 제한 카테고리가 아닙니다.' })
  restrictedCategory: Category;
}

