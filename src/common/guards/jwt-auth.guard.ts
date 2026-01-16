import { Injectable, ExecutionContext, Logger, UnauthorizedException } from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";
import { Reflector } from "@nestjs/core";

@Injectable()
export class JwtAuthGuard extends AuthGuard("jwt") {
	private readonly logger = new Logger(JwtAuthGuard.name);

	constructor(protected reflector: Reflector) {
		super();
	}

	canActivate(context: ExecutionContext) {
		// @Public() 데코레이터가 있으면 인증 없이 접근 가능
		const isPublic = this.reflector.getAllAndOverride<boolean>("isPublic", [
			context.getHandler(),
			context.getClass(),
		]);

		if (isPublic) {
			return true;
		}

		return super.canActivate(context);
	}

	handleRequest(err: any, user: any, info: any, context: ExecutionContext) {
		const request = context.switchToHttp().getRequest();
		
		if (err || !user) {
			// 토큰 관련 에러 상세 로깅
			if (info) {
				this.logger.error(
					`JWT 인증 실패: ${info.message || '알 수 없는 오류'}`,
					JSON.stringify({
						url: request.url,
						method: request.method,
						error: info.name || info.constructor?.name,
						message: info.message,
						token: request.headers.authorization ? 
							request.headers.authorization.substring(0, 20) + '...' : 
							'토큰 없음',
					}, null, 2)
				);
			}
			
			if (err) {
				this.logger.error(`JWT 인증 에러: ${err.message}`, err.stack);
			}
			
			throw err || new UnauthorizedException(
				info?.message || '인증에 실패했습니다. 토큰을 확인해주세요.'
			);
		}
		
		return user;
	}
}

