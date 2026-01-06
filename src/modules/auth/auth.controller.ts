import {
	Controller,
	Post,
	Body,
	Get,
	Put,
	Delete,
	Param,
	UseGuards,
	Request,
} from "@nestjs/common";
import {
	ApiTags,
	ApiOperation,
	ApiResponse,
	ApiBearerAuth,
	ApiParam,
	ApiBody,
} from "@nestjs/swagger";
import { AuthService } from "./auth.service";
import { LoginDto } from "./dto/login.dto";
import { RegisterDto } from "./dto/register.dto";
import { RefreshTokenDto } from "./dto/refresh-token.dto";
import { UpdateUserDto } from "./dto/update-user.dto";
import { JwtAuthGuard } from "../../common/guards/jwt-auth.guard";
import { RolesGuard } from "../../common/guards/roles.guard";
import { Roles } from "./decorators/roles.decorator";
import { Role } from "../../common/enums";
import { Public } from "../../common/decorators";
import { ApiResponseHelper } from "../../common/utils/api-response";
import { AuthGuard } from '@nestjs/passport';

@ApiTags("auth")
@Controller('api/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

	@Post('login')
	@Public()
	@ApiOperation({ summary: '로그인', description: '이메일과 비밀번호로 로그인합니다.' })
	@ApiResponse({ status: 200, description: '로그인 성공' })
	@ApiResponse({ status: 401, description: '인증 실패' })
	async login(@Body() loginDto: LoginDto) {
		const result = await this.authService.login(loginDto);
		return ApiResponseHelper.success(result, '로그인 성공');
	}

	@Post('register')
	@Public()
	@ApiOperation({ summary: '회원가입', description: '새로운 사용자를 등록합니다.' })
	@ApiResponse({ status: 201, description: '회원가입 성공' })
	@ApiResponse({ status: 400, description: '이미 등록된 이메일' })
	async register(@Body() registerDto: RegisterDto) {
		const result = await this.authService.register(registerDto);
		return ApiResponseHelper.success(result, '회원가입 성공');
	}

	@Get("session")
	@UseGuards(JwtAuthGuard)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: '세션 확인', description: '현재 로그인한 사용자 정보를 조회합니다.' })
	@ApiResponse({ status: 200, description: '세션 확인 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	async getSession(@Request() req) {
		return ApiResponseHelper.success(req.user, "세션 확인 성공");
	}

	@Post("logout")
	@UseGuards(JwtAuthGuard)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: '로그아웃', description: '로그아웃합니다. DB에서 refreshToken을 삭제합니다.' })
	@ApiResponse({ status: 200, description: '로그아웃 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	async logout(@Request() req) {
		await this.authService.logout(req.user.id);
		return ApiResponseHelper.success(null, "로그아웃 성공");
	}

	@Post("refresh")
	@Public()
	@ApiOperation({ summary: '토큰 갱신', description: 'refreshToken으로 새로운 accessToken과 refreshToken을 발급받습니다.' })
	@ApiResponse({ status: 200, description: '토큰 갱신 성공' })
	@ApiResponse({ status: 401, description: '유효하지 않은 refreshToken' })
	async refresh(@Body() refreshTokenDto: RefreshTokenDto) {
		const result = await this.authService.refreshToken(refreshTokenDto.refreshToken);
		return ApiResponseHelper.success(result, '토큰 갱신 성공');
	}

	@Post("create-test-account")
	@Public()
	@ApiOperation({
		summary: '테스트 계정 생성',
		description: '테스트용 계정을 생성합니다. (email: test, password: test, 권한: ADMIN) - 개발 환경 전용',
	})
	@ApiResponse({ status: 201, description: '테스트 계정 생성 성공' })
	@ApiResponse({ status: 200, description: '기존 테스트 계정으로 로그인 성공' })
	async createTestAccount() {
		const result = await this.authService.createTestAccount();
		return ApiResponseHelper.success(result, "테스트 계정 생성 성공");
	}

	/**
	 * 카카오 로그인 시작
	 */
	@Get('kakao')
	@Public()
	@UseGuards(AuthGuard('kakao'))
	@ApiOperation({ summary: '카카오 로그인 시작', description: '카카오 로그인 페이지로 리다이렉트합니다.' })
	@ApiResponse({ status: 302, description: '카카오 로그인 페이지로 리다이렉트' })
	async kakaoLogin() {
		// Passport가 자동으로 카카오 로그인 페이지로 리다이렉트
	}

	/**
	 * 카카오 로그인 콜백
	 */
	@Get('kakao/callback')
	@Public()
	@UseGuards(AuthGuard('kakao'))
	@ApiOperation({ summary: '카카오 로그인 콜백', description: '카카오 인증 후 콜백을 처리하고 JWT 토큰을 반환합니다.' })
	@ApiResponse({ status: 200, description: '카카오 로그인 성공' })
	@ApiResponse({ status: 401, description: '인증 실패' })
	async kakaoCallback(@Request() req) {
		// req.user에 validateOrCreateSocialUser에서 반환한 값이 들어있음
		return ApiResponseHelper.success(req.user, '카카오 로그인 성공');
	}

	/**
	 * 본인 정보 수정
	 */
	@Put('profile')
	@UseGuards(JwtAuthGuard)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: '본인 정보 수정', description: '현재 로그인한 사용자의 정보를 수정합니다. (이름, 이메일, 비밀번호)' })
	@ApiBody({ type: UpdateUserDto })
	@ApiResponse({ status: 200, description: '사용자 정보 수정 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	@ApiResponse({ status: 400, description: '이미 등록된 이메일 또는 소셜 로그인 사용자의 비밀번호 변경 시도' })
	async updateProfile(@Request() req, @Body() updateUserDto: UpdateUserDto) {
		// role 변경은 제외 (본인 정보 수정에서는 role 변경 불가)
		const { role, ...updateData } = updateUserDto;
		const updatedUser = await this.authService.updateUser(req.user.id, updateData, req.user);
		
		// 비밀번호 제외하고 반환
		const { password, refreshToken, ...userResponse } = updatedUser;
		return ApiResponseHelper.success(userResponse, '사용자 정보 수정 성공');
	}

	/**
	 * 사용자 정보 수정 (관리자용)
	 */
	@Put('users/:id')
	@UseGuards(JwtAuthGuard, RolesGuard)
	@Roles(Role.ADMIN)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: '사용자 정보 수정 (관리자)', description: '관리자가 다른 사용자의 정보를 수정합니다. (이름, 이메일, 비밀번호, 역할)' })
	@ApiParam({ name: 'id', description: '사용자 ID (UUID)', type: 'string' })
	@ApiBody({ type: UpdateUserDto })
	@ApiResponse({ status: 200, description: '사용자 정보 수정 성공' })
	@ApiResponse({ status: 401, description: '인증 필요 또는 권한 부족' })
	@ApiResponse({ status: 404, description: '사용자를 찾을 수 없습니다.' })
	@ApiResponse({ status: 400, description: '이미 등록된 이메일 또는 소셜 로그인 사용자의 비밀번호 변경 시도' })
	async updateUser(
		@Param('id') id: string,
		@Request() req,
		@Body() updateUserDto: UpdateUserDto,
	) {
		const updatedUser = await this.authService.updateUser(id, updateUserDto, req.user);
		
		// 비밀번호 제외하고 반환
		const { password, refreshToken, ...userResponse } = updatedUser;
		return ApiResponseHelper.success(userResponse, '사용자 정보 수정 성공');
	}

	/**
	 * 승인 대기 중인 TRAINER 목록 조회 (ADMIN만)
	 */
	@Get('pending-trainers')
	@UseGuards(JwtAuthGuard, RolesGuard)
	@Roles(Role.ADMIN)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: '승인 대기 TRAINER 목록', description: 'ADMIN 승인을 기다리는 TRAINER 목록을 조회합니다. (ADMIN만)' })
	@ApiResponse({ status: 200, description: '승인 대기 TRAINER 목록 조회 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	@ApiResponse({ status: 403, description: '권한 없음 (ADMIN만 가능)' })
	async getPendingTrainers() {
		const pendingTrainers = await this.authService.getPendingTrainers();
		
		// 비밀번호 제외하고 반환
		const trainers = pendingTrainers.map(({ password, refreshToken, ...trainer }) => trainer);
		
		return ApiResponseHelper.success(
			{ trainers, total: trainers.length },
			'승인 대기 TRAINER 목록 조회 성공'
		);
	}

	/**
	 * 전체 TRAINER 목록 조회 (ADMIN만) - 승인됨, 대기중 모두 포함
	 */
	@Get('trainers')
	@UseGuards(JwtAuthGuard, RolesGuard)
	@Roles(Role.ADMIN)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: '전체 TRAINER 목록 조회', description: '모든 TRAINER 목록을 조회합니다. (승인됨, 대기중 모두 포함, ADMIN만)' })
	@ApiResponse({ status: 200, description: '전체 TRAINER 목록 조회 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	@ApiResponse({ status: 403, description: '권한 없음 (ADMIN만 가능)' })
	async getAllTrainers() {
		const trainers = await this.authService.getAllTrainers();
		
		// 비밀번호 제외하고 반환
		const trainerList = trainers.map(({ password, refreshToken, ...trainer }) => trainer);
		
		return ApiResponseHelper.success(
			{ trainers: trainerList, total: trainerList.length },
			'전체 TRAINER 목록 조회 성공'
		);
	}

	/**
	 * TRAINER 승인 (ADMIN만)
	 */
	@Post('approve-trainer/:id')
	@UseGuards(JwtAuthGuard, RolesGuard)
	@Roles(Role.ADMIN)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: 'TRAINER 승인', description: '승인 대기 중인 TRAINER를 승인합니다. (ADMIN만)' })
	@ApiParam({ name: 'id', description: 'TRAINER ID (UUID)', type: 'string' })
	@ApiResponse({ status: 200, description: 'TRAINER 승인 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	@ApiResponse({ status: 403, description: '권한 없음 (ADMIN만 가능)' })
	@ApiResponse({ status: 404, description: 'TRAINER를 찾을 수 없습니다.' })
	async approveTrainer(@Param('id') id: string, @Request() req) {
		const approvedTrainer = await this.authService.approveTrainer(id, req.user.id);
		
		// 비밀번호 제외하고 반환
		const { password, refreshToken, ...trainerResponse } = approvedTrainer;
		
		return ApiResponseHelper.success(trainerResponse, 'TRAINER 승인 성공');
	}

	/**
	 * TRAINER 승인 취소 (ADMIN만) - 이미 승인된 TRAINER를 다시 막기
	 */
	@Post('disapprove-trainer/:id')
	@UseGuards(JwtAuthGuard, RolesGuard)
	@Roles(Role.ADMIN)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: 'TRAINER 승인 취소', description: '이미 승인된 TRAINER의 승인을 취소합니다. (ADMIN만)' })
	@ApiParam({ name: 'id', description: 'TRAINER ID (UUID)', type: 'string' })
	@ApiResponse({ status: 200, description: 'TRAINER 승인 취소 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	@ApiResponse({ status: 403, description: '권한 없음 (ADMIN만 가능)' })
	@ApiResponse({ status: 404, description: 'TRAINER를 찾을 수 없습니다.' })
	@ApiResponse({ status: 400, description: '이미 승인되지 않은 TRAINER입니다.' })
	async disapproveTrainer(@Param('id') id: string, @Request() req) {
		const disapprovedTrainer = await this.authService.disapproveTrainer(id, req.user.id);
		
		// 비밀번호 제외하고 반환
		const { password, refreshToken, ...trainerResponse } = disapprovedTrainer;
		
		return ApiResponseHelper.success(trainerResponse, 'TRAINER 승인 취소 성공');
	}

	/**
	 * TRAINER 거부 (ADMIN만) - 승인된 TRAINER를 거부 (isApproved를 false로 변경)
	 */
	@Delete('reject-trainer/:id')
	@UseGuards(JwtAuthGuard, RolesGuard)
	@Roles(Role.ADMIN)
	@ApiBearerAuth("JWT-auth")
	@ApiOperation({ summary: 'TRAINER 거부', description: '승인된 TRAINER를 거부합니다. (isApproved를 false로 변경, 계정은 삭제하지 않음, ADMIN만)' })
	@ApiParam({ name: 'id', description: 'TRAINER ID (UUID)', type: 'string' })
	@ApiResponse({ status: 200, description: 'TRAINER 거부 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	@ApiResponse({ status: 403, description: '권한 없음 (ADMIN만 가능)' })
	@ApiResponse({ status: 404, description: 'TRAINER를 찾을 수 없습니다.' })
	@ApiResponse({ status: 400, description: '이미 거부된 TRAINER입니다.' })
	async rejectTrainer(@Param('id') id: string, @Request() req) {
		const rejectedTrainer = await this.authService.rejectTrainer(id, req.user.id);
		
		// 비밀번호 제외하고 반환
		const { password, refreshToken, ...trainerResponse } = rejectedTrainer;
		
		return ApiResponseHelper.success(trainerResponse, 'TRAINER 거부 성공');
	}
}

