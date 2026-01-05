import {
  Controller,
  Post,
  Body,
  Get,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { Public } from '../../common/decorators';
import { ApiResponseHelper } from '../../common/utils/api-response';

@Controller('api/auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @Public()
  async login(@Body() loginDto: LoginDto) {
    const result = await this.authService.login(loginDto);
    return ApiResponseHelper.success(result, '로그인 성공');
  }

  @Post('register')
  @Public()
  async register(@Body() registerDto: RegisterDto) {
    const result = await this.authService.register(registerDto);
    return ApiResponseHelper.success(result, '회원가입 성공');
  }

	@Get("session")
	@UseGuards(JwtAuthGuard)
	async getSession(@Request() req) {
		return ApiResponseHelper.success(req.user, "세션 확인 성공");
	}

	@Post("logout")
	@UseGuards(JwtAuthGuard)
	async logout() {
		// JWT는 stateless이므로 클라이언트에서 토큰 삭제
		// 필요시 토큰 블랙리스트 구현 가능
		return ApiResponseHelper.success(null, "로그아웃 성공");
	}
}

