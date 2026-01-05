import {
	Controller,
	Get,
	Post,
	Put,
	Delete,
	Param,
	Body,
	UseGuards,
	NotFoundException,
	HttpCode,
	HttpStatus,
} from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository } from "typeorm";
import { JwtAuthGuard } from "../../common/guards/jwt-auth.guard";
import { RolesGuard } from "../../common/guards/roles.guard";
import { Roles } from "../auth/decorators/roles.decorator";
import { Role } from "../../common/enums";
import { InjuryHistory } from "../../entities/injury-history.entity";
import { InjuryRestriction } from "../../entities/injury-restriction.entity";
import { CreateInjuryDto } from "./dto/create-injury.dto";
import { CreateInjuryRestrictionDto } from "./dto/create-injury-restriction.dto";
import { ApiResponseHelper } from "../../common/utils/api-response";

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
  async findAll(@Param('memberId') memberId: string) {
    const injuries = await this.injuryRepository.find({
      where: { memberId },
      relations: ['restrictions'],
      order: { date: 'DESC' },
    });
    return ApiResponseHelper.success({ injuries, total: injuries.length });
  }

	@Get(":id")
	async findOne(
		@Param("memberId") memberId: string,
		@Param("id") id: string,
	) {
		const injury = await this.injuryRepository.findOne({
			where: { id, memberId },
			relations: ["restrictions"],
		});

		if (!injury) {
			throw new NotFoundException("부상 이력을 찾을 수 없습니다.");
		}

		return ApiResponseHelper.success(injury, "부상 이력 조회 성공");
	}

	@Post()
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	async create(
		@Param("memberId") memberId: string,
		@Body() createInjuryDto: CreateInjuryDto,
	) {
		const injury = this.injuryRepository.create({
			memberId,
			...createInjuryDto,
			date: new Date(createInjuryDto.date),
		});

		const savedInjury = await this.injuryRepository.save(injury);
		return ApiResponseHelper.success(savedInjury, "부상 이력 등록 성공");
	}

	@Put(":id")
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	async update(
		@Param("memberId") memberId: string,
		@Param("id") id: string,
		@Body() updateData: Partial<CreateInjuryDto>,
	) {
		const injury = await this.injuryRepository.findOne({
			where: { id, memberId },
		});

		if (!injury) {
			throw new NotFoundException("부상 이력을 찾을 수 없습니다.");
		}

		Object.assign(injury, updateData);
		if (updateData.date) {
			injury.date = new Date(updateData.date);
		}

		const savedInjury = await this.injuryRepository.save(injury);
		return ApiResponseHelper.success(savedInjury, "부상 이력 수정 성공");
	}

	@Post(":id/restrictions")
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	async createRestriction(
		@Param("memberId") memberId: string,
		@Param("id") id: string,
		@Body() createRestrictionDto: CreateInjuryRestrictionDto,
	) {
		const injury = await this.injuryRepository.findOne({
			where: { id, memberId },
		});

		if (!injury) {
			throw new NotFoundException("부상 이력을 찾을 수 없습니다.");
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

