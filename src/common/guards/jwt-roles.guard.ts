import { Injectable, ExecutionContext } from "@nestjs/common";
import { Reflector } from "@nestjs/core";
import { JwtAuthGuard } from "./jwt-auth.guard";
import { Role } from "../enums";
import { ROLES_KEY } from "./roles.guard";

/**
 * JWT 인증과 역할 기반 접근 제어를 통합한 Guard
 * JwtAuthGuard를 상속받고, RolesGuard의 로직을 직접 구현합니다.
 */
@Injectable()
export class JwtRolesGuard extends JwtAuthGuard {
	constructor(protected reflector: Reflector) {
		super(reflector);
	}

	async canActivate(context: ExecutionContext): Promise<boolean> {
		// 먼저 JWT 인증 확인 (부모 클래스의 canActivate 호출)
		const isAuthenticated = await super.canActivate(context);
		if (!isAuthenticated) {
			return false;
		}

		// 역할 기반 접근 제어 확인
		const requiredRoles = this.reflector.getAllAndOverride<Role[]>(ROLES_KEY, [
			context.getHandler(),
			context.getClass(),
		]);

		if (!requiredRoles) {
			return true; // 역할 제한이 없으면 통과
		}

		const { user } = context.switchToHttp().getRequest();
		if (!user) {
			return false;
		}

		return requiredRoles.some((role) => user.role === role);
	}
}

