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
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
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
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({ summary: '평가 생성', description: '새로운 평가를 생성합니다. (ADMIN, TRAINER 권한 필요)' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	@ApiBody({ type: CreateAssessmentDto })
	@ApiResponse({ status: 201, description: '평가 생성 성공' })
	@ApiResponse({ status: 400, description: '잘못된 요청 데이터 또는 초기 평가 이미 존재' })
	@ApiResponse({ status: 403, description: '권한 없음' })
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
  @UseGuards(RolesGuard)
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

