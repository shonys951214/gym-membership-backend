import {
	Injectable,
	NestInterceptor,
	ExecutionContext,
	CallHandler,
} from "@nestjs/common";
import { Observable } from "rxjs";
import { map } from "rxjs/operators";

@Injectable()
export class TransformInterceptor implements NestInterceptor {
	intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
		return next.handle().pipe(
			map((data) => {
				// 이미 ApiResponse 형식이면 그대로 반환
				if (data && typeof data === "object" && "success" in data) {
					return data;
				}

				// 그 외의 경우 성공 응답으로 래핑
				return {
					success: true,
					data,
				};
			}),
		);
	}
}

