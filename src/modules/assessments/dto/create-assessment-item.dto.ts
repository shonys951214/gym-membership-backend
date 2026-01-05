import { IsEnum, IsString, IsNumber, MaxLength } from 'class-validator';
import { Category } from '../../../common/enums';

export class CreateAssessmentItemDto {
  @IsEnum(Category, { message: '올바른 카테고리가 아닙니다.' })
  category: Category;

  @IsString({ message: '이름은 문자열이어야 합니다.' })
  @MaxLength(255, { message: '이름은 255자 이하여야 합니다.' })
  name: string;

  @IsNumber({}, { message: '값은 숫자여야 합니다.' })
  value: number;

  @IsString({ message: '단위는 문자열이어야 합니다.' })
  @MaxLength(50, { message: '단위는 50자 이하여야 합니다.' })
  unit: string;
}

