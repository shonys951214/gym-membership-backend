import { HttpException, HttpStatus } from '@nestjs/common';
import { ErrorCode } from '../utils/error-codes';

/**
 * API 에러를 위한 커스텀 Exception 클래스
 * 에러 코드를 포함하여 HttpExceptionFilter에서 자동으로 처리
 */
export class ApiException extends HttpException {
	public readonly details?: any;

	constructor(
		public readonly errorCode: ErrorCode,
		message: string,
		statusCode: HttpStatus = HttpStatus.BAD_REQUEST,
		details?: any,
	) {
		super(
			{
				errorCode,
				message,
				...(details && { details }),
			},
			statusCode,
		);
		this.details = details;
	}
}

/**
 * 자주 사용되는 Exception 팩토리 함수들
 */
export class ApiExceptions {
	// 인증 관련
	static unauthorized(message: string = '인증이 필요합니다.'): ApiException {
		return new ApiException('UNAUTHORIZED', message, HttpStatus.UNAUTHORIZED);
	}

	static forbidden(message: string = '권한이 없습니다.'): ApiException {
		return new ApiException('FORBIDDEN', message, HttpStatus.FORBIDDEN);
	}

	// 회원 관련
	static memberNotFound(message: string = '회원을 찾을 수 없습니다.'): ApiException {
		return new ApiException('MEMBER_NOT_FOUND', message, HttpStatus.NOT_FOUND);
	}

	static memberAlreadyExists(message: string = '이미 등록된 이메일입니다.'): ApiException {
		return new ApiException('MEMBER_ALREADY_EXISTS', message, HttpStatus.BAD_REQUEST);
	}

	// TRAINER 관련
	static trainerNotFound(message: string = 'TRAINER를 찾을 수 없습니다.'): ApiException {
		return new ApiException('MEMBER_NOT_FOUND', message, HttpStatus.NOT_FOUND);
	}

	static notATrainer(message: string = '해당 사용자는 TRAINER가 아닙니다.'): ApiException {
		return new ApiException('VALIDATION_ERROR', message, HttpStatus.BAD_REQUEST);
	}

	static trainerAlreadyApproved(message: string = '이미 승인된 TRAINER입니다.'): ApiException {
		return new ApiException('VALIDATION_ERROR', message, HttpStatus.BAD_REQUEST);
	}

	// 평가 관련
	static assessmentNotFound(message: string = '평가를 찾을 수 없습니다.'): ApiException {
		return new ApiException('ASSESSMENT_NOT_FOUND', message, HttpStatus.NOT_FOUND);
	}

	static initialAssessmentAlreadyExists(
		message: string = '초기 평가는 이미 존재합니다.',
		existingAssessment?: { id: string; assessedAt: Date | string; assessmentType: string },
	): ApiException {
		return new ApiException(
			'INITIAL_ASSESSMENT_ALREADY_EXISTS',
			message,
			HttpStatus.BAD_REQUEST,
			existingAssessment ? { existingInitialAssessment: existingAssessment } : undefined,
		);
	}

	// 부상 관련
	static injuryNotFound(message: string = '부상 이력을 찾을 수 없습니다.'): ApiException {
		return new ApiException('INJURY_NOT_FOUND', message, HttpStatus.NOT_FOUND);
	}

	// 목표 관련
	static goalNotFound(message: string = '목표를 찾을 수 없습니다.'): ApiException {
		return new ApiException('GOAL_NOT_FOUND', message, HttpStatus.NOT_FOUND);
	}

	// 운동 루틴 관련
	static routineNotFound(message: string = '운동 루틴을 찾을 수 없습니다.'): ApiException {
		return new ApiException('ROUTINE_NOT_FOUND', message, HttpStatus.NOT_FOUND);
	}

	// 회원권 관련
	static membershipNotFound(message: string = '회원권을 찾을 수 없습니다.'): ApiException {
		return new ApiException('MEMBER_NOT_FOUND', message, HttpStatus.NOT_FOUND);
	}

	// 능력치 관련
	static abilitySnapshotNotFound(message: string = '능력치 스냅샷이 없습니다.'): ApiException {
		return new ApiException('ASSESSMENT_NOT_FOUND', message, HttpStatus.NOT_FOUND);
	}

	// 검증 관련
	static validationError(message: string = '입력 데이터가 유효하지 않습니다.'): ApiException {
		return new ApiException('VALIDATION_ERROR', message, HttpStatus.BAD_REQUEST);
	}

	static badRequest(message: string = '잘못된 요청입니다.'): ApiException {
		return new ApiException('BAD_REQUEST', message, HttpStatus.BAD_REQUEST);
	}

	// 서버 관련
	static internalServerError(message: string = '서버 오류가 발생했습니다.'): ApiException {
		return new ApiException('INTERNAL_SERVER_ERROR', message, HttpStatus.INTERNAL_SERVER_ERROR);
	}
}

