import {
	ExceptionFilter,
	Catch,
	ArgumentsHost,
	HttpException,
	HttpStatus,
	Logger,
} from "@nestjs/common";
import { Request, Response } from "express";
import { ApiResponseHelper } from "../utils/api-response";
import { ErrorCodes, ErrorCode } from "../utils/error-codes";

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
	private readonly logger = new Logger(HttpExceptionFilter.name);

	catch(exception: unknown, host: ArgumentsHost) {
		const ctx = host.switchToHttp();
		const response = ctx.getResponse<Response>();
		const request = ctx.getRequest<Request>();

		let status = HttpStatus.INTERNAL_SERVER_ERROR;
		let errorCode: ErrorCode = ErrorCodes.INTERNAL_SERVER_ERROR;
		let message = "서버 오류가 발생했습니다.";

		if (exception instanceof HttpException) {
			status = exception.getStatus();
			const exceptionResponse = exception.getResponse();

			if (typeof exceptionResponse === "string") {
				message = exceptionResponse;
				// NotFoundException, BadRequestException 등의 기본 메시지에서 에러 코드 추출 시도
				if (message.includes("회원을 찾을 수 없습니다")) {
					errorCode = ErrorCodes.MEMBER_NOT_FOUND;
				} else if (message.includes("평가를 찾을 수 없습니다")) {
					errorCode = ErrorCodes.ASSESSMENT_NOT_FOUND;
				} else if (message.includes("부상 이력을 찾을 수 없습니다")) {
					errorCode = ErrorCodes.INJURY_NOT_FOUND;
				} else if (message.includes("회원권을 찾을 수 없습니다")) {
					errorCode = ErrorCodes.MEMBER_NOT_FOUND;
				} else if (message.includes("능력치 스냅샷이 없습니다")) {
					errorCode = ErrorCodes.ASSESSMENT_NOT_FOUND;
				} else if (message.includes("이미 등록된 이메일")) {
					errorCode = ErrorCodes.MEMBER_ALREADY_EXISTS;
				} else if (message.includes("초기 평가는 이미 존재합니다")) {
					errorCode = ErrorCodes.INITIAL_ASSESSMENT_ALREADY_EXISTS;
				} else if (message.includes("찾을 수 없습니다")) {
					errorCode = ErrorCodes.MEMBER_NOT_FOUND;
				} else if (message.includes("이미 존재합니다")) {
					errorCode = ErrorCodes.MEMBER_ALREADY_EXISTS;
				}
			} else if (typeof exceptionResponse === "object" && exceptionResponse !== null) {
				const responseObj = exceptionResponse as any;
				message = responseObj.message || message;
				errorCode = responseObj.errorCode || errorCode;
			}
		} else if (exception instanceof Error) {
			message = exception.message;
		}

		// 상세 에러 로깅
		const errorContext = {
			method: request.method,
			url: request.url,
			statusCode: status,
			errorCode,
			message,
			user: (request as any).user || null,
			body: request.body || null,
			query: request.query || null,
			params: request.params || null,
			timestamp: new Date().toISOString(),
			ip: request.ip || request.socket.remoteAddress,
			userAgent: request.headers["user-agent"] || null,
		};

		// 콘솔에 상세 정보 출력
		console.error("=".repeat(80));
		console.error("🚨 API 에러 발생");
		console.error("=".repeat(80));
		console.error("📋 요청 정보:");
		console.error(`   Method: ${errorContext.method}`);
		console.error(`   URL: ${errorContext.url}`);
		console.error(`   IP: ${errorContext.ip}`);
		console.error(`   User-Agent: ${errorContext.userAgent}`);
		console.error(`   Timestamp: ${errorContext.timestamp}`);
		if (errorContext.user) {
			console.error(`   User: ${JSON.stringify(errorContext.user, null, 2)}`);
		}
		console.error("\n📝 요청 데이터:");
		if (errorContext.body && Object.keys(errorContext.body).length > 0) {
			console.error(JSON.stringify(errorContext.body, null, 2));
		}
		if (errorContext.query && Object.keys(errorContext.query).length > 0) {
			console.error("Query:", JSON.stringify(errorContext.query, null, 2));
		}
		if (errorContext.params && Object.keys(errorContext.params).length > 0) {
			console.error("Params:", JSON.stringify(errorContext.params, null, 2));
		}
		console.error("\n❌ 에러 정보:");
		console.error(`   Status Code: ${errorContext.statusCode}`);
		console.error(`   Error Code: ${errorContext.errorCode}`);
		console.error(`   Message: ${errorContext.message}`);
		if (exception instanceof Error && exception.stack) {
			console.error("\n📚 Stack Trace:");
			console.error(exception.stack);
		}
		console.error("=".repeat(80));

		// Logger에도 기록 (프로덕션 로깅 시스템용)
		this.logger.error(
			`${request.method} ${request.url} - ${status} - ${message}`,
			JSON.stringify(errorContext, null, 2),
			exception instanceof Error ? exception.stack : undefined,
		);

		// 에러 응답 반환
		response.status(status).json(
			ApiResponseHelper.error(errorCode, message, {
				path: request.url,
				method: request.method,
				timestamp: new Date().toISOString(),
			}),
		);
	}
}

