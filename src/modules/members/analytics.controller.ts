import { Controller, Get, Param, UseGuards } from "@nestjs/common";
import {
	ApiTags,
	ApiOperation,
	ApiResponse,
	ApiBearerAuth,
} from "@nestjs/swagger";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { JwtAuthGuard } from "../../common/guards/jwt-auth.guard";
import { AbilitySnapshot } from "../../entities/ability-snapshot.entity";
import { ApiResponseHelper } from "../../common/utils/api-response";

@ApiTags("analytics")
@ApiBearerAuth("JWT-auth")
@Controller("api/members/:memberId/analytics")
@UseGuards(JwtAuthGuard)
export class MemberAnalyticsController {
	constructor(
		@InjectRepository(AbilitySnapshot)
		private abilitySnapshotRepository: Repository<AbilitySnapshot>,
	) {}

	@Get()
	async getMemberAnalytics(@Param("memberId") memberId: string) {
		const snapshots = await this.abilitySnapshotRepository.find({
			where: { memberId },
			order: { assessedAt: "DESC" },
			relations: ["assessment"],
		});

		return ApiResponseHelper.success(
			{
				snapshots,
				total: snapshots.length,
				latest: snapshots[0] || null,
			},
			"회원 능력치 데이터 조회 성공",
		);
	}
}

