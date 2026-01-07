import {
	Controller,
	Get,
	Post,
	Put,
	Delete,
	Body,
	Param,
	Query,
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
import { WorkoutRecordsService } from './workout-records.service';
import { PTSessionsService } from './pt-sessions.service';
import { WorkoutRoutinesService } from './workout-routines.service';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { CreateMembershipDto } from './dto/create-membership.dto';
import { UpdateMembershipDto } from './dto/update-membership.dto';
import { UpdatePTUsageDto } from './dto/update-pt-usage.dto';
import { UpdateGoalDto } from './dto/update-goal.dto';
import { CreateGoalDto } from './dto/create-goal.dto';
import { CreateWorkoutRecordDto } from './dto/create-workout-record.dto';
import { UpdateWorkoutRecordDto } from './dto/update-workout-record.dto';
import { WorkoutVolumeQueryDto } from './dto/workout-volume-query.dto';
import { CreatePTSessionDto } from './dto/create-pt-session.dto';
import { UpdatePTSessionDto } from './dto/update-pt-session.dto';
import { CreateWorkoutRoutineDto } from './dto/create-workout-routine.dto';
import { UpdateWorkoutRoutineDto } from './dto/update-workout-routine.dto';
import { DashboardResponseDto } from './dto/dashboard-response.dto';
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
  constructor(
    private readonly membersService: MembersService,
    private readonly workoutRecordsService: WorkoutRecordsService,
    private readonly ptSessionsService: PTSessionsService,
    private readonly workoutRoutinesService: WorkoutRoutinesService,
  ) {}

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

	// 1차피드백: 목표 관리
	@Get(':id/goal')
	@ApiOperation({
		summary: '회원 목표 조회',
		description: '회원의 목표, 진행률, 트레이너 코멘트, 수업 진행률을 조회합니다.',
	})
	@ApiResponse({ status: 200, description: '목표 조회 성공' })
	@ApiResponse({ status: 404, description: '회원을 찾을 수 없습니다' })
	async getGoal(@Param('id') id: string) {
		const goal = await this.membersService.getGoal(id);
		return ApiResponseHelper.success(goal, '목표 조회 성공');
	}

	@Put(':id/goal')
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: '회원 목표 수정',
		description: '회원의 목표, 진행률, 트레이너 코멘트, 수업 회차를 수정합니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 200, description: '목표 수정 성공' })
	@ApiResponse({ status: 404, description: '회원을 찾을 수 없습니다' })
	@ApiResponse({ status: 400, description: '잘못된 요청 (진행률 범위 초과, 완료 회차 초과 등)' })
	@ApiResponse({ status: 403, description: '권한 없음' })
	async updateGoal(
		@Param('id') id: string,
		@Body() updateGoalDto: UpdateGoalDto,
	) {
		const member = await this.membersService.updateGoal(id, updateGoalDto);
		return ApiResponseHelper.success(member, '목표 수정 성공');
	}

	// 1차피드백: 운동 기록 (프론트엔드 요청사항 반영)
	@Get(':id/workout-records')
	@ApiOperation({
		summary: '운동 기록 목록 조회',
		description: '회원의 운동 기록을 조회합니다. 페이지네이션 및 날짜 필터링 지원.',
	})
	@ApiResponse({ status: 200, description: '운동 기록 목록 조회 성공' })
	async getWorkoutRecords(
		@Param('id') id: string,
		@Query('page') page?: string,
		@Query('pageSize') pageSize?: string,
		@Query('startDate') startDate?: string,
		@Query('endDate') endDate?: string,
	) {
		const pageNum = page ? parseInt(page, 10) : 1;
		const pageSizeNum = pageSize ? parseInt(pageSize, 10) : 10;
		const result = await this.workoutRecordsService.findAll(
			id,
			pageNum,
			pageSizeNum,
			startDate,
			endDate,
		);
		return ApiResponseHelper.success(result, '운동 기록 목록 조회 성공');
	}

	@Get(':id/workout-records/:recordId')
	@ApiOperation({
		summary: '운동 기록 상세 조회',
		description: '특정 운동 기록의 상세 정보를 조회합니다.',
	})
	@ApiResponse({ status: 200, description: '운동 기록 상세 조회 성공' })
	async getWorkoutRecord(
		@Param('id') id: string,
		@Param('recordId') recordId: string,
	) {
		const record = await this.workoutRecordsService.findOne(recordId, id);
		return ApiResponseHelper.success(record, '운동 기록 상세 조회 성공');
	}

	@Get(':id/workout-records/volume-analysis')
	@ApiOperation({
		summary: '운동 기록 볼륨 분석',
		description: '회원의 부위별 운동 볼륨을 주간/월간으로 분석합니다.',
	})
	@ApiResponse({ status: 200, description: '볼륨 분석 조회 성공' })
	async getWorkoutVolumeAnalysis(
		@Param('id') id: string,
		@Query('period') period?: 'WEEKLY' | 'MONTHLY',
		@Query('startDate') startDate?: string,
		@Query('endDate') endDate?: string,
	) {
		const analysis = await this.workoutRecordsService.getVolumeAnalysis(
			id,
			period,
			startDate,
			endDate,
		);
		return ApiResponseHelper.success(analysis, '볼륨 분석 조회 성공');
	}

	@Get(':id/workout-records/calendar')
	@ApiOperation({
		summary: '운동 캘린더 조회',
		description: '지정된 기간의 운동 캘린더를 조회합니다.',
	})
	@ApiResponse({ status: 200, description: '운동 캘린더 조회 성공' })
	async getWorkoutCalendar(
		@Param('id') id: string,
		@Query('startDate') startDate: string,
		@Query('endDate') endDate: string,
	) {
		const calendar = await this.workoutRecordsService.getCalendar(id, startDate, endDate);
		return ApiResponseHelper.success(calendar, '운동 캘린더 조회 성공');
	}

	@Get(':id/workout-records/volume')
	@ApiOperation({
		summary: '부위별 볼륨 조회 (하위 호환성)',
		description: '회원의 부위별 운동 볼륨을 주간/월간으로 조회합니다. (기존 API 유지)',
	})
	@ApiResponse({ status: 200, description: '부위별 볼륨 조회 성공' })
	async getWorkoutVolume(
		@Param('id') id: string,
		@Query() query: WorkoutVolumeQueryDto,
	) {
		const volume = await this.workoutRecordsService.getVolumeByBodyPart(id, query);
		return ApiResponseHelper.success(volume, '부위별 볼륨 조회 성공');
	}

	@Post(':id/workout-records')
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: '운동 기록 생성',
		description: '새로운 운동 기록을 생성합니다. 볼륨은 자동 계산됩니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 201, description: '운동 기록 생성 성공' })
	async createWorkoutRecord(
		@Param('id') id: string,
		@Body() createDto: CreateWorkoutRecordDto,
	) {
		const record = await this.workoutRecordsService.create(id, createDto);
		return ApiResponseHelper.success(record, '운동 기록 생성 성공');
	}

	@Put(':id/workout-records/:recordId')
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: '운동 기록 수정',
		description: '기존 운동 기록을 수정합니다. 볼륨은 자동 재계산됩니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 200, description: '운동 기록 수정 성공' })
	async updateWorkoutRecord(
		@Param('id') id: string,
		@Param('recordId') recordId: string,
		@Body() updateDto: UpdateWorkoutRecordDto,
	) {
		const record = await this.workoutRecordsService.update(recordId, id, updateDto);
		return ApiResponseHelper.success(record, '운동 기록 수정 성공');
	}

	@Delete(':id/workout-records/:recordId')
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: '운동 기록 삭제',
		description: '운동 기록을 삭제합니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 200, description: '운동 기록 삭제 성공' })
	async deleteWorkoutRecord(
		@Param('id') id: string,
		@Param('recordId') recordId: string,
	) {
		await this.workoutRecordsService.remove(recordId, id);
		return ApiResponseHelper.success(null, '운동 기록 삭제 성공');
	}

	// 1차피드백: PT 세션
	@Get(':id/pt-sessions')
	@ApiOperation({
		summary: 'PT 세션 목록 조회',
		description: '회원의 모든 PT 세션을 조회합니다.',
	})
	@ApiResponse({ status: 200, description: 'PT 세션 목록 조회 성공' })
	async getPTSessions(@Param('id') id: string) {
		const result = await this.ptSessionsService.findAll(id);
		return ApiResponseHelper.success(result, 'PT 세션 목록 조회 성공');
	}

	@Get(':id/pt-sessions/:sessionId')
	@ApiOperation({
		summary: 'PT 세션 상세 조회',
		description: '특정 PT 세션의 상세 정보를 조회합니다.',
	})
	@ApiResponse({ status: 200, description: 'PT 세션 상세 조회 성공' })
	async getPTSession(
		@Param('id') id: string,
		@Param('sessionId') sessionId: string,
	) {
		const session = await this.ptSessionsService.findOne(sessionId, id);
		return ApiResponseHelper.success(session, 'PT 세션 상세 조회 성공');
	}

	@Post(':id/pt-sessions')
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: 'PT 세션 생성',
		description: '새로운 PT 세션을 생성합니다. 세션 번호는 자동 계산되고, completedSessions가 자동 증가합니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 201, description: 'PT 세션 생성 성공' })
	async createPTSession(
		@Param('id') id: string,
		@Body() createDto: CreatePTSessionDto,
	) {
		const session = await this.ptSessionsService.create(id, createDto);
		return ApiResponseHelper.success(session, 'PT 세션 생성 성공');
	}

	@Put(':id/pt-sessions/:sessionId')
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: 'PT 세션 수정',
		description: '기존 PT 세션을 수정합니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 200, description: 'PT 세션 수정 성공' })
	async updatePTSession(
		@Param('id') id: string,
		@Param('sessionId') sessionId: string,
		@Body() updateDto: UpdatePTSessionDto,
	) {
		const session = await this.ptSessionsService.update(sessionId, id, updateDto);
		return ApiResponseHelper.success(session, 'PT 세션 수정 성공');
	}

	@Delete(':id/pt-sessions/:sessionId')
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: 'PT 세션 삭제',
		description: 'PT 세션을 삭제합니다. completedSessions가 자동 감소합니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 200, description: 'PT 세션 삭제 성공' })
	async deletePTSession(
		@Param('id') id: string,
		@Param('sessionId') sessionId: string,
	) {
		await this.ptSessionsService.remove(sessionId, id);
		return ApiResponseHelper.success(null, 'PT 세션 삭제 성공');
	}

	// 1차피드백: 추천 운동 루틴
	@Get(':id/workout-routines/today')
	@ApiOperation({
		summary: '오늘의 운동 루틴 조회',
		description: '회원의 오늘 날짜 운동 루틴을 조회합니다.',
	})
	@ApiResponse({ status: 200, description: '오늘의 운동 루틴 조회 성공' })
	@ApiResponse({ status: 404, description: '오늘의 운동 루틴이 없습니다' })
	async getTodayRoutine(@Param('id') id: string) {
		const routine = await this.workoutRoutinesService.findToday(id);
		if (!routine) {
			return ApiResponseHelper.success(null, '오늘의 운동 루틴이 없습니다.');
		}
		return ApiResponseHelper.success(routine, '오늘의 운동 루틴 조회 성공');
	}

	@Get(':id/workout-routines')
	@ApiOperation({
		summary: '운동 루틴 목록 조회',
		description: '회원의 모든 운동 루틴을 조회합니다. 날짜 범위 및 완료 여부로 필터링 가능합니다.',
	})
	@ApiResponse({ status: 200, description: '운동 루틴 목록 조회 성공' })
	async getWorkoutRoutines(
		@Param('id') id: string,
		@Query('startDate') startDate?: string,
		@Query('endDate') endDate?: string,
		@Query('isCompleted') isCompleted?: string,
	) {
		const isCompletedBool = isCompleted === 'true' ? true : isCompleted === 'false' ? false : undefined;
		const routines = await this.workoutRoutinesService.findAll(id, startDate, endDate, isCompletedBool);
		return ApiResponseHelper.success({ routines, total: routines.length }, '운동 루틴 목록 조회 성공');
	}

	@Post(':id/workout-routines')
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: '운동 루틴 생성',
		description: '새로운 운동 루틴을 생성합니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 201, description: '운동 루틴 생성 성공' })
	async createWorkoutRoutine(
		@Param('id') id: string,
		@Body() createDto: CreateWorkoutRoutineDto,
	) {
		const routine = await this.workoutRoutinesService.create(id, createDto);
		return ApiResponseHelper.success(routine, '운동 루틴 생성 성공');
	}

	@Put(':id/workout-routines/:routineId')
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: '운동 루틴 수정',
		description: '기존 운동 루틴을 수정합니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 200, description: '운동 루틴 수정 성공' })
	async updateWorkoutRoutine(
		@Param('id') id: string,
		@Param('routineId') routineId: string,
		@Body() updateDto: UpdateWorkoutRoutineDto,
	) {
		const routine = await this.workoutRoutinesService.update(routineId, id, updateDto);
		return ApiResponseHelper.success(routine, '운동 루틴 수정 성공');
	}

	@Put(':id/workout-routines/:routineId/complete')
	@ApiOperation({
		summary: '운동 루틴 완료 처리',
		description: '운동 루틴을 완료 처리합니다. 모든 인증된 사용자가 가능합니다.',
	})
	@ApiResponse({ status: 200, description: '운동 루틴 완료 처리 성공' })
	async completeWorkoutRoutine(
		@Param('id') id: string,
		@Param('routineId') routineId: string,
	) {
		const routine = await this.workoutRoutinesService.complete(routineId, id);
		return ApiResponseHelper.success(routine, '운동 루틴 완료 처리 성공');
	}

	@Delete(':id/workout-routines/:routineId')
	@UseGuards(RolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: '운동 루틴 삭제',
		description: '운동 루틴을 삭제합니다. (ADMIN, TRAINER 권한 필요)',
	})
	@ApiResponse({ status: 200, description: '운동 루틴 삭제 성공' })
	async deleteWorkoutRoutine(
		@Param('id') id: string,
		@Param('routineId') routineId: string,
	) {
		await this.workoutRoutinesService.remove(routineId, id);
		return ApiResponseHelper.success(null, '운동 루틴 삭제 성공');
	}

	// 1차피드백: 대시보드 통합
	@Get(':id/dashboard')
	@ApiOperation({
		summary: '대시보드 통합 데이터 조회',
		description: '회원의 목표, 수업 진행률, 운동 캘린더, 운동 기록 분석을 통합하여 조회합니다.',
	})
	@ApiResponse({
		status: 200,
		description: '대시보드 데이터 조회 성공',
		type: DashboardResponseDto,
	})
	async getDashboard(@Param('id') id: string) {
		const dashboard = await this.membersService.getDashboard(id);
		return ApiResponseHelper.success(dashboard, '대시보드 데이터 조회 성공');
	}
}

