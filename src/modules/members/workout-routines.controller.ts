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
	ApiParam,
	ApiQuery,
} from "@nestjs/swagger";
import { WorkoutRoutinesService } from "./workout-routines.service";
import { CreateWorkoutRoutineDto } from "./dto/create-workout-routine.dto";
import { UpdateWorkoutRoutineDto } from "./dto/update-workout-routine.dto";
import { JwtAuthGuard, JwtRolesGuard } from "../../common/guards";
import { Roles } from "../auth/decorators/roles.decorator";
import { Role } from "../../common/enums";
import { ApiResponseHelper } from "../../common/utils/api-response";
import { ApiExceptions } from "../../common/exceptions";

@ApiTags("workout-routines")
@ApiBearerAuth("JWT-auth")
@Controller("api/workout-routines")
@UseGuards(JwtAuthGuard)
export class WorkoutRoutinesController {
	constructor(private readonly workoutRoutinesService: WorkoutRoutinesService) {}

	@Get()
	@ApiOperation({
		summary: "공통 운동 루틴 목록 조회",
		description: "전체 공통 운동 루틴 목록을 조회합니다. 날짜 범위 및 완료 여부로 필터링 가능합니다.",
	})
	@ApiQuery({ name: "startDate", required: false, description: "시작 날짜 (YYYY-MM-DD)" })
	@ApiQuery({ name: "endDate", required: false, description: "종료 날짜 (YYYY-MM-DD)" })
	@ApiQuery({ name: "isCompleted", required: false, description: "완료 여부 (true/false)" })
	@ApiResponse({ status: 200, description: "공통 운동 루틴 목록 조회 성공" })
	async getCommonRoutines(
		@Query("startDate") startDate?: string,
		@Query("endDate") endDate?: string,
		@Query("isCompleted") isCompleted?: string,
	) {
		const isCompletedBool = isCompleted === "true" ? true : isCompleted === "false" ? false : undefined;
		const routines = await this.workoutRoutinesService.findAll(
			undefined,
			startDate,
			endDate,
			isCompletedBool,
		);
		return ApiResponseHelper.success({ routines, total: routines.length }, "공통 운동 루틴 목록 조회 성공");
	}

	@Get("today")
	@ApiOperation({
		summary: "오늘의 공통 운동 루틴 조회",
		description: "오늘 날짜의 공통 운동 루틴을 조회합니다.",
	})
	@ApiResponse({ status: 200, description: "오늘의 공통 운동 루틴 조회 성공" })
	@ApiResponse({ status: 404, description: "오늘의 공통 운동 루틴이 없습니다" })
	async getTodayCommonRoutine() {
		const routine = await this.workoutRoutinesService.findToday();
		if (!routine) {
			throw ApiExceptions.routineNotFound("오늘의 공통 운동 루틴이 없습니다.");
		}
		return ApiResponseHelper.success(routine, "오늘의 공통 운동 루틴 조회 성공");
	}

	@Get(":routineId")
	@ApiOperation({
		summary: "공통 운동 루틴 상세 조회",
		description: "특정 공통 운동 루틴의 상세 정보를 조회합니다.",
	})
	@ApiParam({ name: "routineId", description: "루틴 ID (UUID)", type: "string" })
	@ApiResponse({ status: 200, description: "공통 운동 루틴 상세 조회 성공" })
	@ApiResponse({ status: 404, description: "공통 운동 루틴을 찾을 수 없습니다" })
	async getCommonRoutine(@Param("routineId") routineId: string) {
		const routine = await this.workoutRoutinesService.findOne(routineId);
		return ApiResponseHelper.success(routine, "공통 운동 루틴 상세 조회 성공");
	}

	@Post()
	@HttpCode(HttpStatus.CREATED)
	@UseGuards(JwtRolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: "공통 운동 루틴 생성",
		description: "새로운 공통 운동 루틴을 생성합니다. (ADMIN, TRAINER 권한 필요)",
	})
	@ApiResponse({ status: 201, description: "공통 운동 루틴 생성 성공" })
	async createCommonRoutine(@Body() createDto: CreateWorkoutRoutineDto) {
		const routine = await this.workoutRoutinesService.create(null, createDto);
		return ApiResponseHelper.success(routine, "공통 운동 루틴 생성 성공");
	}

	@Put(":routineId")
	@UseGuards(JwtRolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: "공통 운동 루틴 수정",
		description: "기존 공통 운동 루틴을 수정합니다. (ADMIN, TRAINER 권한 필요)",
	})
	@ApiParam({ name: "routineId", description: "루틴 ID (UUID)", type: "string" })
	@ApiResponse({ status: 200, description: "공통 운동 루틴 수정 성공" })
	async updateCommonRoutine(
		@Param("routineId") routineId: string,
		@Body() updateDto: UpdateWorkoutRoutineDto,
	) {
		const routine = await this.workoutRoutinesService.update(routineId, null, updateDto);
		return ApiResponseHelper.success(routine, "공통 운동 루틴 수정 성공");
	}

	@Delete(":routineId")
	@UseGuards(JwtRolesGuard)
	@Roles(Role.ADMIN, Role.TRAINER)
	@ApiOperation({
		summary: "공통 운동 루틴 삭제",
		description: "공통 운동 루틴을 삭제합니다. (ADMIN, TRAINER 권한 필요)",
	})
	@ApiParam({ name: "routineId", description: "루틴 ID (UUID)", type: "string" })
	@ApiResponse({ status: 200, description: "공통 운동 루틴 삭제 성공" })
	async deleteCommonRoutine(@Param("routineId") routineId: string) {
		await this.workoutRoutinesService.remove(routineId, null);
		return ApiResponseHelper.success(null, "공통 운동 루틴 삭제 성공");
	}
}

