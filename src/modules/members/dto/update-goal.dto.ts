import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsInt, Min, Max, IsOptional } from 'class-validator';

export class UpdateGoalDto {
  @ApiProperty({
    description: '회원의 목표 한줄 요약',
    example: '체중 5kg 감량 및 근력 향상',
    required: false,
  })
  @IsOptional()
  @IsString()
  goal?: string;

  @ApiProperty({
    description: '목표 진행률 (0-100)',
    example: 65,
    minimum: 0,
    maximum: 100,
    required: false,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(100)
  goalProgress?: number;

  @ApiProperty({
    description: '트레이너 동기부여 코멘트',
    example: '꾸준히 운동하시는 모습이 인상적입니다! 계속 화이팅!',
    required: false,
  })
  @IsOptional()
  @IsString()
  goalTrainerComment?: string;

  @ApiProperty({
    description: '총 수업 회차',
    example: 20,
    minimum: 0,
    required: false,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  totalSessions?: number;

  @ApiProperty({
    description: '완료된 수업 회차',
    example: 10,
    minimum: 0,
    required: false,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  completedSessions?: number;
}

