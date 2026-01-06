import {
	registerDecorator,
	ValidationOptions,
	ValidatorConstraint,
	ValidatorConstraintInterface,
	ValidationArguments,
} from 'class-validator';

/**
 * 한국 전화번호 형식 검증
 * 허용 형식:
 * - 010-1234-5678
 * - 01012345678
 * - 02-1234-5678
 * - 02-123-4567
 * - 031-123-4567
 * - 1588-1234
 * - 02-123-4567
 * - 070-1234-5678
 */
@ValidatorConstraint({ async: false })
export class IsPhoneNumberConstraint implements ValidatorConstraintInterface {
	validate(phone: any, args: ValidationArguments) {
		if (typeof phone !== 'string') {
			return false;
		}

		// 한국 전화번호 정규식
		// 허용 형식:
		// - 010-1234-5678, 010-123-4567
		// - 01012345678
		// - 02-1234-5678, 02-123-4567
		// - 031-123-4567
		// - 1588-1234, 1544-1234
		// - 070-1234-5678
		const phoneRegex = /^(?:(?:02|0[3-9]{1,2})[-.\s]?)?[0-9]{3,4}[-.\s]?[0-9]{4}$|^01[0-9]{1}[-.\s]?[0-9]{3,4}[-.\s]?[0-9]{4}$|^1[5-9]{1}[0-9]{2,3}[-.\s]?[0-9]{4}$/;

		// 하이픈, 공백, 점 제거 후 숫자만 남기기
		const cleanedPhone = phone.replace(/[-.\s]/g, '');

		// 숫자만 있는지 확인
		if (!/^\d+$/.test(cleanedPhone)) {
			return false;
		}

		// 길이 체크 (최소 9자, 최대 11자)
		if (cleanedPhone.length < 9 || cleanedPhone.length > 11) {
			return false;
		}

		// 정규식으로 형식 검증
		return phoneRegex.test(phone);
	}

	defaultMessage(args: ValidationArguments) {
		return '유효한 한국 전화번호 형식이어야 합니다. (예: 010-1234-5678, 02-1234-5678)';
	}
}

export function IsPhoneNumber(validationOptions?: ValidationOptions) {
	return function (object: Record<string, any>, propertyName: string) {
		registerDecorator({
			target: object.constructor,
			propertyName: propertyName,
			options: validationOptions,
			constraints: [],
			validator: IsPhoneNumberConstraint,
		});
	};
}

