import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import { AnalyticsService } from './analytics.service';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { ApiResponseHelper } from '../../common/utils/api-response';

@Controller('api/analytics')
@UseGuards(JwtAuthGuard)
export class AnalyticsController {
  constructor(private readonly analyticsService: AnalyticsService) {}

  @Get('averages')
  async getAverages() {
    const averages = await this.analyticsService.getAverages();
    return ApiResponseHelper.success(averages, '전체 평균 조회 성공');
  }

	@Get("comparison/:memberId")
	async compareWithAverage(@Param("memberId") memberId: string) {
		const comparison = await this.analyticsService.compareWithAverage(memberId);
		return ApiResponseHelper.success(comparison, "평균 비교 조회 성공");
	}
}

