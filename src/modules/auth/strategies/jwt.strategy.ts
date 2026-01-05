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
		const user = await this.authService.findById(payload.sub);
		if (!user) {
			this.logger.warn(
				`JWT 인증 실패: 사용자를 찾을 수 없습니다. Payload: ${JSON.stringify(payload)}`,
			);
			throw new UnauthorizedException();
		}
    return {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
    };
  }
}

