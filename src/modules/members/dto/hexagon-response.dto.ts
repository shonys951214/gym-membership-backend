import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class HexagonIndicatorDto {
  @ApiProperty({ description: '평가 항목 이름', example: '하체 근력' })
  name: string;

  @ApiProperty({ description: '점수 (0-100)', example: 75 })
  score: number;
}

export class HexagonDataDto {
  @ApiProperty({ 
    description: '6개 평가 항목 점수', 
    type: [HexagonIndicatorDto],
    example: [
      { name: '하체 근력', score: 75 },
      { name: '심폐 지구력', score: 60 },
      { name: '근지구력', score: 70 },
      { name: '유연성', score: 65 },
      { name: '체성분 밸런스', score: 80 },
      { name: '부상 안정성', score: 72 }
    ]
  })
  indicators: HexagonIndicatorDto[];

  @ApiProperty({ description: '평가 일시 (ISO 8601)', example: '2024-03-15T10:00:00Z' })
  assessedAt: string;

  @ApiProperty({ description: '버전', example: 'v1' })
  version: string;

  @ApiPropertyOptional({ 
    description: '초기 평가 데이터 (compare=true일 때만 포함)', 
    type: HexagonDataDto,
    nullable: true,
    example: {
      indicators: [
        { name: '하체 근력', score: 50 },
        { name: '심폐 지구력', score: 45 },
        { name: '근지구력', score: 55 },
        { name: '유연성', score: 50 },
        { name: '체성분 밸런스', score: 40 },
        { name: '부상 안정성', score: 60 }
      ],
      assessedAt: '2024-01-15T10:00:00Z',
      version: 'v1'
    }
  })
  initial?: HexagonDataDto | null;
}

