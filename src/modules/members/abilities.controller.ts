import { Controller, Get, Param, Query, UseGuards } from "@nestjs/common";
import {
	ApiTags,
	ApiBearerAuth,
} from "@nestjs/swagger";
import { JwtAuthGuard } from "../../common/guards/jwt-auth.guard";
import { AssessmentsService } from "../assessments/assessments.service";
import { ApiResponseHelper } from "../../common/utils/api-response";

@ApiTags("abilities")
@ApiBearerAuth("JWT-auth")
@Controller("api/members/:memberId/abilities")
@UseGuards(JwtAuthGuard)
export class AbilitiesController {
	constructor(private readonly assessmentsService: AssessmentsService) {}

	@Get("latest")
	async getLatestSnapshot(@Param("memberId") memberId: string) {
		const snapshot = await this.assessmentsService.getLatestSnapshot(memberId);
		return ApiResponseHelper.success(snapshot, "최신 능력치 조회 성공");
	}

	@Get("snapshots")
	async getSnapshots(@Param("memberId") memberId: string) {
		const snapshots = await this.assessmentsService.getSnapshots(memberId);
		return ApiResponseHelper.success({
			snapshots,
			total: snapshots.length,
		});
	}

	@Get("compare")
	async compareSnapshots(
		@Param("memberId") memberId: string,
		@Query("prev") prev?: string,
	) {
		const prevCount = prev ? parseInt(prev, 10) : 1;
		const comparison = await this.assessmentsService.compareSnapshots(
			memberId,
			prevCount,
		);
		return ApiResponseHelper.success(comparison, "능력치 비교 성공");
	}

	@Get("hexagon")
	async getHexagon(@Param("memberId") memberId: string) {
		const hexagon = await this.assessmentsService.getHexagonData(memberId);
		return ApiResponseHelper.success(hexagon, "능력치 헥사곤 조회 성공");
	}

	@Get("history")
	async getHistory(@Param("memberId") memberId: string) {
		const history = await this.assessmentsService.getHistory(memberId);
		return ApiResponseHelper.success(history, "체력 테스트 히스토리 조회 성공");
	}
}

