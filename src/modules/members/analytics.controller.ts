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
		const latestSnapshot = normalizedSnapshots[0] || {
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

		// 전체 평균 계산 (percentile 계산을 위해)
		const allMembers = await this.abilitySnapshotRepository
			.createQueryBuilder('snapshot')
			.select('AVG(snapshot.strengthScore)', 'avgStrength')
			.addSelect('AVG(snapshot.cardioScore)', 'avgCardio')
			.addSelect('AVG(snapshot.enduranceScore)', 'avgEndurance')
			.addSelect('AVG(snapshot.flexibilityScore)', 'avgFlexibility')
			.addSelect('AVG(snapshot.bodyScore)', 'avgBody')
			.addSelect('AVG(snapshot.stabilityScore)', 'avgStability')
			.addSelect('AVG(snapshot.totalScore)', 'avgTotal')
			.where('snapshot.totalScore IS NOT NULL')
			.getRawOne();

		const averages = {
			strengthScore: parseFloat(allMembers?.avgStrength || '0') || 0,
			cardioScore: parseFloat(allMembers?.avgCardio || '0') || 0,
			enduranceScore: parseFloat(allMembers?.avgEndurance || '0') || 0,
			flexibilityScore: parseFloat(allMembers?.avgFlexibility || '0') || 0,
			bodyScore: parseFloat(allMembers?.avgBody || '0') || 0,
			stabilityScore: parseFloat(allMembers?.avgStability || '0') || 0,
			totalScore: parseFloat(allMembers?.avgTotal || '0') || 0,
		};

		// 백분위 계산
		const calculatePercentile = (memberValue: number, averageValue: number): number => {
			if (averageValue === 0) return 50;
			const ratio = memberValue / averageValue;
			return Math.min(100, Math.max(0, (ratio - 0.5) * 100 + 50));
		};

		const percentile = {
			strengthScore: calculatePercentile(latestSnapshot.strengthScore ?? 0, averages.strengthScore),
			cardioScore: calculatePercentile(latestSnapshot.cardioScore ?? 0, averages.cardioScore),
			enduranceScore: calculatePercentile(latestSnapshot.enduranceScore ?? 0, averages.enduranceScore),
			flexibilityScore: calculatePercentile(latestSnapshot.flexibilityScore ?? 0, averages.flexibilityScore),
			bodyScore: calculatePercentile(latestSnapshot.bodyScore ?? 0, averages.bodyScore),
			stabilityScore: calculatePercentile(latestSnapshot.stabilityScore ?? 0, averages.stabilityScore),
			totalScore: calculatePercentile(latestSnapshot.totalScore ?? 0, averages.totalScore),
		};

		// averageSnapshot 생성 (프론트엔드 호환성)
		const averageSnapshot = {
			id: '',
			assessmentId: '',
			memberId: '',
			assessedAt: new Date(),
			version: 'v1',
			strengthScore: averages.strengthScore,
			cardioScore: averages.cardioScore,
			enduranceScore: averages.enduranceScore,
			flexibilityScore: averages.flexibilityScore,
			bodyScore: averages.bodyScore,
			stabilityScore: averages.stabilityScore,
			totalScore: averages.totalScore,
			createdAt: new Date(),
		};

		return ApiResponseHelper.success(
			{
				memberId,
				latestSnapshot,
				averageSnapshot,
				percentile,
				snapshots: normalizedSnapshots,
				total: normalizedSnapshots.length,
				latest: latestSnapshot, // 하위 호환성
			},
			"회원 능력치 데이터 조회 성공",
		);
	}
}

