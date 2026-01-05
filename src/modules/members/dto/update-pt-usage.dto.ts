import { IsOptional, IsInt, Min } from 'class-validator';

export class UpdatePTUsageDto {
  @IsOptional()
  @IsInt({ message: '전체 횟수는 정수여야 합니다.' })
  @Min(0, { message: '전체 횟수는 0 이상이어야 합니다.' })
  totalCount?: number;

  @IsOptional()
  @IsInt({ message: '남은 횟수는 정수여야 합니다.' })
  @Min(0, { message: '남은 횟수는 0 이상이어야 합니다.' })
  remainingCount?: number;

  @IsOptional()
  @IsInt({ message: '사용 횟수는 정수여야 합니다.' })
  @Min(0, { message: '사용 횟수는 0 이상이어야 합니다.' })
  usedCount?: number;
}

