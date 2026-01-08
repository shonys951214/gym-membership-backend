import {
	Controller,
	Get,
	Post,
	Put,
	Delete,
	Param,
	Body,
	UseGuards,
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
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { JwtAuthGuard, JwtRolesGuard } from "../../common/guards";
import { Roles } from "../auth/decorators/roles.decorator";
import { Role } from "../../common/enums";
import { InjuryHistory } from "../../entities/injury-history.entity";
import { InjuryRestriction } from "../../entities/injury-restriction.entity";
import { CreateInjuryDto } from "./dto/create-injury.dto";
import { UpdateInjuryDto } from "./dto/update-injury.dto";
import { CreateInjuryRestrictionDto } from "./dto/create-injury-restriction.dto";
import { ApiResponseHelper } from "../../common/utils/api-response";
import { ApiExceptions } from "../../common/exceptions";
import { EntityUpdateHelper } from "../../common/utils/entity-update-helper";

@ApiTags("injuries")
@ApiBearerAuth("JWT-auth")
@Controller('api/members/:memberId/injuries')
@UseGuards(JwtAuthGuard)
export class InjuriesController {
  constructor(
    @InjectRepository(InjuryHistory)
    private injuryRepository: Repository<InjuryHistory>,
    @InjectRepository(InjuryRestriction)
    private restrictionRepository: Repository<InjuryRestriction>,
  ) {}

  @Get()
  @ApiOperation({ summary: '부상 이력 목록 조회', description: '특정 회원의 모든 부상 이력을 조회합니다.' })
  @ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
  @ApiResponse({ status: 200, description: '부상 이력 목록 조회 성공' })
  async findAll(@Param('memberId') memberId: string) {
    const injuries = await this.injuryRepository.find({
      where: { memberId },
      relations: ['restrictions'],
      order: { date: 'DESC' },
    });
    return ApiResponseHelper.success({ injuries, total: injuries.length });
  }

	@Get(":id")
	@ApiOperation({ summary: '부상 이력 상세 조회', description: '특정 부상 이력의 상세 정보를 조회합니다.' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	@ApiParam({ name: 'id', description: '부상 이력 ID (UUID)', type: 'string' })
	@ApiResponse({ status: 200, description: '부상 이력 조회 성공' })
	@ApiResponse({ status: 404, description: '부상 이력을 찾을 수 없습니다.' })
	async findOne(
		@Param("memberId") memberId: string,
		@Param("id") id: string,
	) {
		const injury = await this.injuryRepository.findOne({
			where: { id, memberId },
			relations: ["restrictions"],
		});

		if (!injury) {
			throw ApiExceptions.injuryNotFound();
		}

		return ApiResponseHelper.success(injury, "부상 이력 조회 성공");
	}

	@Post()
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(JwtRolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({ summary: '부상 이력 등록', description: '새로운 부상 이력을 등록합니다. (ADMIN, TRAINER 권한 필요)' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	@ApiBody({ type: CreateInjuryDto })
	@ApiResponse({ status: 201, description: '부상 이력 등록 성공' })
	@ApiResponse({ status: 400, description: '잘못된 요청 데이터' })
	@ApiResponse({ status: 403, description: '권한 없음' })
	async create(
		@Param("memberId") memberId: string,
		@Body() createInjuryDto: CreateInjuryDto,
	) {
		// 날짜 필드 변환
		const injuryData = EntityUpdateHelper.convertDateFields(
			{
				memberId,
				...createInjuryDto,
				date: createInjuryDto.date,
			},
			['date'],
		);

		const injury = this.injuryRepository.create(injuryData);

		const savedInjury = await this.injuryRepository.save(injury);
		return ApiResponseHelper.success(savedInjury, "부상 이력 등록 성공");
	}

	@Put(":id")
	@UseGuards(JwtRolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({ summary: '부상 이력 수정', description: '기존 부상 이력을 수정합니다. (ADMIN, TRAINER 권한 필요)' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	@ApiParam({ name: 'id', description: '부상 이력 ID (UUID)', type: 'string' })
	@ApiBody({ type: UpdateInjuryDto })
	@ApiResponse({ status: 200, description: '부상 이력 수정 성공' })
	@ApiResponse({ status: 404, description: '부상 이력을 찾을 수 없습니다.' })
	@ApiResponse({ status: 403, description: '권한 없음' })
	async update(
		@Param("memberId") memberId: string,
		@Param("id") id: string,
		@Body() updateData: UpdateInjuryDto,
	) {
		const injury = await this.injuryRepository.findOne({
			where: { id, memberId },
		});

		if (!injury) {
			throw ApiExceptions.injuryNotFound();
		}

		EntityUpdateHelper.updateFieldsWithDateConversion(injury, updateData, ['date']);

		const savedInjury = await this.injuryRepository.save(injury);
		return ApiResponseHelper.success(savedInjury, "부상 이력 수정 성공");
	}

	@Post(":id/restrictions")
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(JwtRolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({ summary: '평가 제한 설정', description: '부상에 대한 평가 제한을 설정합니다. (ADMIN, TRAINER 권한 필요)' })
	@ApiParam({ name: 'memberId', description: '회원 ID (UUID)', type: 'string' })
	@ApiParam({ name: 'id', description: '부상 이력 ID (UUID)', type: 'string' })
	@ApiBody({ type: CreateInjuryRestrictionDto })
	@ApiResponse({ status: 201, description: '평가 제한 설정 성공' })
	@ApiResponse({ status: 404, description: '부상 이력을 찾을 수 없습니다.' })
	@ApiResponse({ status: 403, description: '권한 없음' })
	async createRestriction(
		@Param("memberId") memberId: string,
		@Param("id") id: string,
		@Body() createRestrictionDto: CreateInjuryRestrictionDto,
	) {
		const injury = await this.injuryRepository.findOne({
			where: { id, memberId },
		});

		if (!injury) {
			throw ApiExceptions.injuryNotFound();
		}

		const restriction = this.restrictionRepository.create({
			injuryId: id,
			restrictedCategory: createRestrictionDto.restrictedCategory,
		});

		const savedRestriction = await this.restrictionRepository.save(restriction);
		return ApiResponseHelper.success(
			savedRestriction,
			"평가 제한 설정 성공",
		);
	}
}

