import {
	Controller,
	Get,
	Post,
	Put,
	Param,
	Body,
	UseGuards,
	Query,
	HttpCode,
	HttpStatus,
} from "@nestjs/common";
import {
	ApiTags,
	ApiBearerAuth,
	ApiOperation,
	ApiParam,
	ApiBody,
	ApiResponse,
} from "@nestjs/swagger";
import { AssessmentsService } from './assessments.service';
import { CreateAssessmentDto } from './dto/create-assessment.dto';
import { UpdateAssessmentDto } from './dto/update-assessment.dto';
import { JwtAuthGuard, JwtRolesGuard } from '../../common/guards';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '../../common/enums';
import { ApiResponseHelper } from '../../common/utils/api-response';

@ApiTags("assessments")
@ApiBearerAuth("JWT-auth")
@Controller('api/members/:memberId/assessments')
@UseGuards(JwtAuthGuard)
export class AssessmentsController {
  constructor(private readonly assessmentsService: AssessmentsService) {}

  @Get()
  @ApiOperation({ summary: '평가 목록 조회', description: '특정 회원의 모든 평가 목록을 조회합니다.' })
  @ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
  @ApiResponse({ status: 200, description: '평가 목록 조회 성공' })
  async findAll(@Param('memberId') memberId: string) {
    const assessments = await this.assessmentsService.findAll(memberId);
    return ApiResponseHelper.success({
      assessments,
      total: assessments.length,
    });
  }

  @Get(':id')
  @ApiOperation({ summary: '평가 상세 조회', description: '특정 평가의 상세 정보를 조회합니다.' })
  @ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
  @ApiParam({ name: 'id', description: '평가 ID (UUID)', type: 'string' })
  @ApiResponse({ status: 200, description: '평가 조회 성공' })
  @ApiResponse({ status: 404, description: '평가를 찾을 수 없습니다.' })
  async findOne(
    @Param('memberId') memberId: string,
    @Param('id') id: string,
  ) {
    const assessment = await this.assessmentsService.findOne(id, memberId);
    return ApiResponseHelper.success(assessment, '평가 조회 성공');
  }

	@Post()
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(JwtRolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({ 
		summary: '평가 생성', 
		description: '새로운 평가를 생성합니다. (ADMIN, TRAINER 권한 필요)\n\n' +
			'**점수 계산**: 백엔드에서 자동으로 등급 → 점수 변환을 수행합니다.\n' +
			'- 하체 근력, 심폐 지구력, 근지구력: 등급(A, B, C 등) → 내부 점수(0-100) 변환\n' +
			'- 유연성: 항목별 등급을 가중치로 변환하여 합산 후 점수 계산\n' +
			'- 체성분: 회원의 age, gender로 연령대별 기준 조회 후 판정\n' +
			'- 안정성: OHSA 등급 + 통증 여부 조합으로 점수 계산\n\n' +
			'**응답**: 생성된 평가와 함께 `items[].score`, `items[].details.internalScore`, `snapshot` 정보가 포함됩니다.\n\n' +
			'자세한 점수 계산 방식은 `점수계산표.md` 문서를 참고하세요.'
	})
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	@ApiBody({ type: CreateAssessmentDto })
	@ApiResponse({ status: 201, description: '평가 생성 성공', type: CreateAssessmentDto })
	@ApiResponse({ status: 400, description: '잘못된 요청 데이터 또는 초기 평가 이미 존재' })
	@ApiResponse({ status: 403, description: '권한 없음' })
	@ApiResponse({ status: 404, description: '회원을 찾을 수 없음' })
	async create(
		@Param("memberId") memberId: string,
		@Body() createAssessmentDto: CreateAssessmentDto,
	) {
		const assessment = await this.assessmentsService.create(
			memberId,
			createAssessmentDto,
		);
		return ApiResponseHelper.success(assessment, "평가 생성 성공");
	}

  @Put(':id')
  @UseGuards(JwtRolesGuard)
  @Roles(Role.ADMIN, Role.TRAINER)
  @ApiOperation({ summary: '평가 수정', description: '기존 평가를 수정합니다. (ADMIN, TRAINER 권한 필요)' })
  @ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
  @ApiParam({ name: 'id', description: '평가 ID (UUID)', type: 'string' })
  @ApiBody({ type: UpdateAssessmentDto })
  @ApiResponse({ status: 200, description: '평가 수정 성공' })
  @ApiResponse({ status: 404, description: '평가를 찾을 수 없습니다.' })
  @ApiResponse({ status: 403, description: '권한 없음' })
  async update(
    @Param('memberId') memberId: string,
    @Param('id') id: string,
    @Body() updateAssessmentDto: UpdateAssessmentDto,
  ) {
    const assessment = await this.assessmentsService.update(
      id,
      memberId,
      updateAssessmentDto,
    );
    return ApiResponseHelper.success(assessment, '평가 수정 성공');
  }

}

