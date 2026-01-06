import { Controller, Get, UseGuards } from "@nestjs/common";
import { ApiTags, ApiBearerAuth } from "@nestjs/swagger";
import { InsightsService } from "./insights.service";
import { JwtAuthGuard } from "../../common/guards/jwt-auth.guard";
import { RolesGuard } from "../../common/guards/roles.guard";
import { Roles } from "../auth/decorators/roles.decorator";
import { Role } from "../../common/enums";
import { ApiResponseHelper } from "../../common/utils/api-response";

@ApiTags("insights")
@ApiBearerAuth("JWT-auth")
@Controller("api/insights")
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.ADMIN, Role.TRAINER)
export class InsightsController {
	constructor(private readonly insightsService: InsightsService) {}

	@Get("hexagon")
	async getHexagon() {
		const hexagon = await this.insightsService.getHexagon();
		return ApiResponseHelper.success(hexagon, "운영 능력치 헥사곤 조회 성공");
	}

	@Get("weekly-summary")
	async getWeeklySummary() {
		const summary = await this.insightsService.getWeeklySummary();
		return ApiResponseHelper.success(summary, "주간 요약 조회 성공");
	}

	@Get("risk-members")
	async getRiskMembers() {
		const riskMembers = await this.insightsService.getRiskMembers();
		return ApiResponseHelper.success(riskMembers, "위험 신호 회원 조회 성공");
	}
}
