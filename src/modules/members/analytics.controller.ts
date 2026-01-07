import { Controller, Get, Param, UseGuards } from "@nestjs/common";
import {
	ApiTags,
	ApiBearerAuth,
	ApiOperation,
	ApiParam,
} from "@nestjs/swagger";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { JwtAuthGuard } from "../../common/guards";
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
	@ApiOperation({ summary: '회원 능력치 데이터 조회', description: '특정 회원의 모든 능력치 스냅샷 데이터를 조회합니다.' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	async getMemberAnalytics(@Param("memberId") memberId: string) {
		const snapshots = await this.abilitySnapshotRepository.find({
			where: { memberId },
			order: { assessedAt: "DESC" },
			relations: ["assessment"],
		});

		// 스냅샷 정규화 (totalScore 등 null 값 처리)
		const normalizedSnapshots = snapshots.map(snapshot => ({
			...snapshot,
			strengthScore: snapshot.strengthScore ?? 0,
			cardioScore: snapshot.cardioScore ?? 0,
			enduranceScore: snapshot.enduranceScore ?? 0,
			flexibilityScore: snapshot.flexibilityScore ?? 0,
			bodyScore: snapshot.bodyScore ?? 0,
			stabilityScore: snapshot.stabilityScore ?? 0,
			totalScore: snapshot.totalScore ?? 0,
		}));

		// latest 정규화 (null일 경우 기본 스냅샷 객체 반환)
		const latest = normalizedSnapshots[0] || {
			id: '',
			assessmentId: '',
			memberId,
			assessedAt: new Date(),
			version: 'v1',
			strengthScore: 0,
			cardioScore: 0,
			enduranceScore: 0,
			flexibilityScore: 0,
			bodyScore: 0,
			stabilityScore: 0,
			totalScore: 0,
			createdAt: new Date(),
		};

		return ApiResponseHelper.success(
			{
				snapshots: normalizedSnapshots,
				total: normalizedSnapshots.length,
				latest,
			},
			"회원 능력치 데이터 조회 성공",
		);
	}
}

