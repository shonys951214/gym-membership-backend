import { Controller, Get, UseGuards } from "@nestjs/common";
import { ApiTags, ApiBearerAuth, ApiOperation } from "@nestjs/swagger";
import { InsightsService } from "./insights.service";
import { JwtRolesGuard } from "../../common/guards";
import { Roles } from "../auth/decorators/roles.decorator";
import { Role } from "../../common/enums";
import { ApiResponseHelper } from "../../common/utils/api-response";

@ApiTags("insights")
@ApiBearerAuth("JWT-auth")
@Controller("api/insights")
@UseGuards(JwtRolesGuard)
@Roles(Role.ADMIN, Role.TRAINER)
export class InsightsController {
	constructor(private readonly insightsService: InsightsService) {}

	@Get("hexagon")
	@ApiOperation({ summary: "운영 능력치 헥사곤 조회", description: "전체 회원의 평균 능력치 헥사곤 데이터를 조회합니다. (ADMIN, TRAINER만)" })
	async getHexagon() {
		const hexagon = await this.insightsService.getHexagon();
		return ApiResponseHelper.success(hexagon, "운영 능력치 헥사곤 조회 성공");
	}

	@Get("weekly-summary")
	@ApiOperation({ summary: "주간 요약 조회", description: "이번 주와 지난 주의 평가 데이터를 비교합니다. (ADMIN, TRAINER만)" })
	async getWeeklySummary() {
		const summary = await this.insightsService.getWeeklySummary();
		return ApiResponseHelper.success(summary, "주간 요약 조회 성공");
	}

	@Get("risk-members")
	@ApiOperation({ summary: "위험 신호 회원 조회", description: "능력치 하락, 부상, 비활성 등 위험 신호가 있는 회원 목록을 조회합니다. (ADMIN, TRAINER만)" })
	async getRiskMembers() {
		const riskMembers = await this.insightsService.getRiskMembers();
		return ApiResponseHelper.success(riskMembers, "위험 신호 회원 조회 성공");
	}
}
