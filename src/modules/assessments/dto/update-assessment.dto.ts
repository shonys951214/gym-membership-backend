import { IsOptional, IsDateString, IsString, IsNumber, IsEnum, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { Condition } from '../../../common/enums';
import { CreateAssessmentItemDto } from './create-assessment-item.dto';

export class UpdateAssessmentDto {
  @IsOptional()
  @IsDateString({}, { message: '올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)' })
  assessedAt?: string;

  @IsOptional()
  @IsString({ message: '트레이너 코멘트는 문자열이어야 합니다.' })
  trainerComment?: string;

  @IsOptional()
  @IsNumber({}, { message: '체중은 숫자여야 합니다.' })
  bodyWeight?: number;

  @IsOptional()
  @IsEnum(Condition, { message: '올바른 컨디션이 아닙니다.' })
  condition?: Condition;

  @IsOptional()
  @IsArray({ message: '평가 항목은 배열이어야 합니다.' })
  @ValidateNested({ each: true })
  @Type(() => CreateAssessmentItemDto)
  items?: CreateAssessmentItemDto[];
}

