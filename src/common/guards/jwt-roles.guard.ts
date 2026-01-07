import { Injectable, ExecutionContext, CanActivate } from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { JwtAuthGuard } from "./jwt-auth.guard";
import { RolesGuard } from "./roles.guard";

/**
 * JWT 인증과 역할 기반 접근 제어를 통합한 Guard
 * JwtAuthGuard와 RolesGuard를 순차적으로 실행합니다.
 */
@Injectable()
export class JwtRolesGuard implements CanActivate {
	constructor(
		private reflector: Reflector,
		private jwtAuthGuard: JwtAuthGuard,
		private rolesGuard: RolesGuard,
	) {}

	async canActivate(context: ExecutionContext): Promise<boolean> {
		// 먼저 JWT 인증 확인
		const isAuthenticated = await this.jwtAuthGuard.canActivate(context);
		if (!isAuthenticated) {
			return false;
		}

		// 역할 기반 접근 제어 확인
		return this.rolesGuard.canActivate(context);
	}
}

