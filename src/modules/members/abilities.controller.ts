import { Controller, Get, Param, Query, UseGuards } from "@nestjs/common";
import {
	ApiTags,
	ApiBearerAuth,
	ApiOperation,
	ApiParam,
	ApiQuery,
} from "@nestjs/swagger";
import { JwtAuthGuard } from "../../common/guards/jwt-auth.guard";
import { AssessmentsService } from "../assessments/assessments.service";
import { ApiResponseHelper } from "../../common/utils/api-response";
import { CompareSnapshotsQueryDto } from "./dto/compare-snapshots-query.dto";

@ApiTags("abilities")
@ApiBearerAuth("JWT-auth")
@Controller("api/members/:memberId/abilities")
@UseGuards(JwtAuthGuard)
export class AbilitiesController {
	constructor(private readonly assessmentsService: AssessmentsService) {}

	@Get("latest")
	@ApiOperation({ summary: '최신 능력치 스냅샷 조회', description: '회원의 최신 능력치 스냅샷을 조회합니다.' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	async getLatestSnapshot(@Param("memberId") memberId: string) {
		const snapshot = await this.assessmentsService.getLatestSnapshot(memberId);
		
		// snapshot이 null이면 기본값 반환 (프론트엔드 오류 방지)
		if (!snapshot) {
			return ApiResponseHelper.success(null, "능력치 스냅샷이 없습니다.");
		}
		
		return ApiResponseHelper.success(snapshot, "최신 능력치 조회 성공");
	}

	@Get("snapshots")
	@ApiOperation({ summary: '능력치 스냅샷 목록 조회', description: '회원의 모든 능력치 스냅샷 목록을 조회합니다.' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	async getSnapshots(@Param("memberId") memberId: string) {
		const snapshots = await this.assessmentsService.getSnapshots(memberId);
		return ApiResponseHelper.success({
			snapshots,
			total: snapshots.length,
		});
	}

	@Get("compare")
	@ApiOperation({ summary: '능력치 비교', description: '현재 능력치와 이전 평가를 비교합니다.' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	@ApiQuery({ name: 'prev', description: '이전 평가와 비교할 개수 (기본값: 1)', required: false, type: Number, example: 1 })
	async compareSnapshots(
		@Param("memberId") memberId: string,
		@Query() query: CompareSnapshotsQueryDto,
	) {
		const prevCount = query.prev || 1;
		const comparison = await this.assessmentsService.compareSnapshots(
			memberId,
			prevCount,
		);
		return ApiResponseHelper.success(comparison, "능력치 비교 성공");
	}

	@Get("hexagon")
	@ApiOperation({ summary: '능력치 헥사곤 데이터 조회', description: '레이더 차트용 헥사곤 데이터를 조회합니다.' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	async getHexagon(@Param("memberId") memberId: string) {
		const hexagon = await this.assessmentsService.getHexagonData(memberId);
		return ApiResponseHelper.success(hexagon, "능력치 헥사곤 조회 성공");
	}

	@Get("history")
	@ApiOperation({ summary: '체력 테스트 히스토리 조회', description: '라인 차트용 체력 테스트 히스토리를 조회합니다.' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	async getHistory(@Param("memberId") memberId: string) {
		const history = await this.assessmentsService.getHistory(memberId);
		return ApiResponseHelper.success(history, "체력 테스트 히스토리 조회 성공");
	}
}

