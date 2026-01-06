import {
	Controller,
	Get,
	Post,
	Put,
	Delete,
	Body,
	Param,
	UseGuards,
	HttpCode,
	HttpStatus,
} from "@nestjs/common";
import {
	ApiTags,
	ApiOperation,
	ApiResponse,
	ApiBearerAuth,
} from "@nestjs/swagger";
import { MembersService } from './members.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { CreateMembershipDto } from './dto/create-membership.dto';
import { UpdateMembershipDto } from './dto/update-membership.dto';
import { UpdatePTUsageDto } from './dto/update-pt-usage.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '../../common/enums';
import { ApiResponseHelper } from '../../common/utils/api-response';

@ApiTags("members")
@ApiBearerAuth("JWT-auth")
@Controller('api/members')
@UseGuards(JwtAuthGuard)
export class MembersController {
  constructor(private readonly membersService: MembersService) {}

  @Get()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.TRAINER)
  async findAll() {
    const members = await this.membersService.findAll();
    return ApiResponseHelper.success({ members, total: members.length });
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const member = await this.membersService.findOne(id);
    return ApiResponseHelper.success(member, '회원 정보 조회 성공');
  }

	@Post()
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	async create(@Body() createMemberDto: CreateMemberDto) {
		const member = await this.membersService.create(createMemberDto);
		return ApiResponseHelper.success(member, "회원 등록 성공");
	}

	@Put(':id')
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({ summary: '회원 정보 수정', description: '회원 정보를 수정합니다. (ADMIN, TRAINER 권한 필요)' })
	@ApiResponse({ status: 200, description: '회원 정보 수정 성공' })
	@ApiResponse({ status: 404, description: '회원을 찾을 수 없습니다' })
	@ApiResponse({ status: 403, description: '권한 없음' })
	async update(
		@Param('id') id: string,
		@Body() updateMemberDto: UpdateMemberDto,
	) {
		const member = await this.membersService.update(id, updateMemberDto);
		return ApiResponseHelper.success(member, '회원 정보 수정 성공');
	}

  @Delete(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  async remove(@Param('id') id: string) {
    await this.membersService.remove(id);
    return ApiResponseHelper.success(null, '회원 삭제 성공');
  }

  // 회원권 관리
  @Get(':id/membership')
  async getMembership(@Param('id') id: string) {
    const membership = await this.membersService.getMembership(id);
    return ApiResponseHelper.success(membership, '회원권 조회 성공');
  }

	@Post(":id/membership")
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	async createMembership(
		@Param("id") id: string,
		@Body() createMembershipDto: CreateMembershipDto,
	) {
		const membership = await this.membersService.createMembership(
			id,
			createMembershipDto,
		);
		return ApiResponseHelper.success(membership, "회원권 등록 성공");
	}

  @Put(':id/membership/:membershipId')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.TRAINER)
  async updateMembership(
    @Param('id') id: string,
    @Param('membershipId') membershipId: string,
    @Body() updateData: UpdateMembershipDto,
  ) {
    const membership = await this.membersService.updateMembership(
      id,
      membershipId,
      updateData,
    );
    return ApiResponseHelper.success(membership, '회원권 수정 성공');
  }

  // PT 횟수 관리
  @Get(':id/pt-count')
  async getPTUsage(@Param('id') id: string) {
    const ptUsage = await this.membersService.getPTUsage(id);
    return ApiResponseHelper.success(ptUsage, 'PT 횟수 조회 성공');
  }

	@Post(":id/pt-count")
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	async createOrUpdatePTUsage(
		@Param("id") id: string,
		@Body() updatePTUsageDto: UpdatePTUsageDto,
	) {
		const ptUsage = await this.membersService.createOrUpdatePTUsage(
			id,
			updatePTUsageDto,
		);
		return ApiResponseHelper.success(ptUsage, "PT 횟수 업데이트 성공");
	}

	@Put(":id/pt-count")
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	async updatePTUsage(
		@Param("id") id: string,
		@Body() updatePTUsageDto: UpdatePTUsageDto,
	) {
		const ptUsage = await this.membersService.createOrUpdatePTUsage(
			id,
			updatePTUsageDto,
		);
		return ApiResponseHelper.success(ptUsage, "PT 횟수 수정 성공");
	}

	@Delete(":id/membership/:membershipId")
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN)
	async deleteMembership(
		@Param("id") id: string,
		@Param("membershipId") membershipId: string,
	) {
		await this.membersService.deleteMembership(id, membershipId);
		return ApiResponseHelper.success(null, "회원권 삭제 성공");
	}
}

