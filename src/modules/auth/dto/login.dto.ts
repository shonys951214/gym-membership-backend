import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { IsEmailOrTest } from '../../../common/decorators/is-email-or-test.decorator';

export class LoginDto {
	@ApiProperty({
		description: '이메일 주소 (test 계정은 예외)',
		example: 'user@example.com',
	})
	@IsString({ message: '이메일은 문자열이어야 합니다.' })
	@IsEmailOrTest({ message: '유효한 이메일 형식이어야 합니다. (test 계정은 예외)' })
	email: string;

	@ApiProperty({
		description: '비밀번호',
		example: 'password123',
	})
	@IsString({ message: '비밀번호는 문자열이어야 합니다.' })
	password: string;
}

