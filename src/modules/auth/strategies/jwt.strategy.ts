import {
	Injectable,
	UnauthorizedException,
	Logger,
} from "@nestjs/common";
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
	private readonly logger = new Logger(JwtStrategy.name);

	constructor(
		private configService: ConfigService,
		private authService: AuthService,
	) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET'),
    });
  }

	async validate(payload: any) {
		this.logger.debug(`JWT 토큰 검증 시작: userId=${payload.sub}, email=${payload.email}`);
		
		// 토큰 만료 시간 확인
		if (payload.exp) {
			const now = Math.floor(Date.now() / 1000);
			const expiresIn = payload.exp - now;
			if (expiresIn <= 0) {
				this.logger.warn(
					`JWT 토큰 만료: userId=${payload.sub}, 만료 시간=${new Date(payload.exp * 1000).toISOString()}, 현재 시간=${new Date().toISOString()}`,
				);
				throw new UnauthorizedException('토큰이 만료되었습니다. 다시 로그인해주세요.');
			}
			this.logger.debug(`JWT 토큰 만료까지 ${expiresIn}초 남음`);
		}

		const user = await this.authService.findById(payload.sub);
		if (!user) {
			this.logger.warn(
				`JWT 인증 실패: 사용자를 찾을 수 없습니다. Payload: ${JSON.stringify(payload)}`,
			);
			throw new UnauthorizedException('사용자를 찾을 수 없습니다.');
		}
		
		this.logger.debug(`JWT 토큰 검증 성공: userId=${user.id}, email=${user.email}, role=${user.role}`);
		
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      isApproved: user.isApproved, // 프론트엔드에서 승인 상태 확인용
    };
  }
}

