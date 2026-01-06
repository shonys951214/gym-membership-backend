import {
	Controller,
	Post,
	Body,
	Get,
	UseGuards,
	Request,
} from "@nestjs/common";
import {
	ApiTags,
	ApiOperation,
	ApiResponse,
	ApiBearerAuth,
} from "@nestjs/swagger";
import { AuthService } from "./auth.service";
import { LoginDto } from "./dto/login.dto";
import { RegisterDto } from "./dto/register.dto";
import { JwtAuthGuard } from "../../common/guards/jwt-auth.guard";
import { Public } from "../../common/decorators";
import { ApiResponseHelper } from "../../common/utils/api-response";
// 카카오 로그인 구현 시 주석 해제
// import { AuthGuard } from '@nestjs/passport';

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
	@ApiOperation({ summary: '로그아웃', description: '로그아웃합니다. (클라이언트에서 토큰 삭제 필요)' })
	@ApiResponse({ status: 200, description: '로그아웃 성공' })
	@ApiResponse({ status: 401, description: '인증 필요' })
	async logout() {
		// JWT는 stateless이므로 클라이언트에서 토큰 삭제
		// 필요시 토큰 블랙리스트 구현 가능
		return ApiResponseHelper.success(null, "로그아웃 성공");
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
	 * 카카오 로그인 구현 시 주석 해제
	 */
	// @Get('kakao')
	// @Public()
	// @UseGuards(AuthGuard('kakao'))
	// async kakaoLogin() {
	//   // Passport가 자동으로 카카오 로그인 페이지로 리다이렉트
	// }

	/**
	 * 카카오 로그인 콜백
	 * 카카오 로그인 구현 시 주석 해제
	 */
	// @Get('kakao/callback')
	// @Public()
	// @UseGuards(AuthGuard('kakao'))
	// async kakaoCallback(@Request() req) {
	//   // req.user에 validateOrCreateSocialUser에서 반환한 값이 들어있음
	//   return ApiResponseHelper.success(req.user, '카카오 로그인 성공');
	// }
}

