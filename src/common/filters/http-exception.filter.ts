import { ExceptionFilter, Catch, ArgumentsHost, HttpException, HttpStatus, Logger } from "@nestjs/common";
import { Request, Response } from "express";
import { ApiResponseHelper } from "../utils/api-response";
import { ErrorCodes, ErrorCode } from "../utils/error-codes";
import { DateHelper } from "../utils/date-helper";
import { ApiException } from "../exceptions/api.exception";

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

		// ApiException인 경우 (에러 코드 포함)
		if (exception instanceof ApiException) {
			status = exception.getStatus();
			const exceptionResponse = exception.getResponse() as { errorCode: ErrorCode; message: string; details?: any };
			errorCode = exceptionResponse.errorCode;
			message = exceptionResponse.message;
			// details가 있으면 에러 응답에 포함
			if (exceptionResponse.details) {
				// details를 에러 응답에 포함하도록 처리
				(exceptionResponse as any).details = exceptionResponse.details;
			}
		} else if (exception instanceof HttpException) {
			status = exception.getStatus();
			const exceptionResponse = exception.getResponse();

			// HTTP 상태 코드에 따른 기본 에러 코드 설정
			if (status === HttpStatus.UNAUTHORIZED) {
				errorCode = ErrorCodes.UNAUTHORIZED;
			} else if (status === HttpStatus.FORBIDDEN) {
				errorCode = ErrorCodes.FORBIDDEN;
			} else if (status === HttpStatus.NOT_FOUND) {
				errorCode = ErrorCodes.MEMBER_NOT_FOUND; // 기본값
			}

			if (typeof exceptionResponse === "string") {
				message = exceptionResponse;
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
			timestamp: DateHelper.getKoreaTimeISOString(),
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
		this.logger.error(`${request.method} ${request.url} - ${status} - ${message}`, JSON.stringify(errorContext, null, 2), exception instanceof Error ? exception.stack : undefined);

		// 에러 응답 반환
		const errorDetails: any = {
			path: request.url,
			method: request.method,
			timestamp: DateHelper.getKoreaTimeISOString(),
		};

		// ApiException의 details가 있으면 포함
		if (exception instanceof ApiException && exception.details) {
			Object.assign(errorDetails, exception.details);
		}

		response.status(status).json(
			ApiResponseHelper.error(errorCode, message, errorDetails)
		);
	}
}
