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
import { ErrorCodes } from "../utils/error-codes";

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
	private readonly logger = new Logger(HttpExceptionFilter.name);

	catch(exception: unknown, host: ArgumentsHost) {
		const ctx = host.switchToHttp();
		const response = ctx.getResponse<Response>();
		const request = ctx.getRequest<Request>();

		let status = HttpStatus.INTERNAL_SERVER_ERROR;
		let errorCode = ErrorCodes.INTERNAL_SERVER_ERROR;
		let message = "서버 오류가 발생했습니다.";

		if (exception instanceof HttpException) {
			status = exception.getStatus();
			const exceptionResponse = exception.getResponse();

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

		// 에러 로깅
		this.logger.error(
			`${request.method} ${request.url} - ${status} - ${message}`,
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

