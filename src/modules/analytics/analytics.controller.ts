import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import {
	ApiTags,
	ApiBearerAuth,
	ApiOperation,
	ApiParam,
} from '@nestjs/swagger';
import { AnalyticsService } from './analytics.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ApiResponseHelper } from '../../common/utils/api-response';

@ApiTags("analytics")
@ApiBearerAuth("JWT-auth")
@Controller('api/analytics')
@UseGuards(JwtAuthGuard)
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('averages')
  @ApiOperation({ summary: '전체 평균 데이터 조회', description: '모든 회원의 능력치 평균 데이터를 조회합니다.' })
  async getAverages() {
    const averages = await this.analyticsService.getAverages();
    return ApiResponseHelper.success(averages, '전체 평균 조회 성공');
  }

	@Get("comparison/:memberId")
	@ApiOperation({ summary: '개별 vs 평균 비교', description: '특정 회원의 능력치와 전체 평균을 비교합니다.' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	async compareWithAverage(@Param("memberId") memberId: string) {
		const comparison = await this.analyticsService.compareWithAverage(memberId);
		return ApiResponseHelper.success(comparison, "평균 비교 조회 성공");
	}
}

