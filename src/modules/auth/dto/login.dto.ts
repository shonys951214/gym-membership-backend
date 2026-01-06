import { IsEmail, IsString, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class LoginDto {
	@ApiProperty({
		description: '이메일 주소 또는 사용자명',
		example: 'user@example.com',
	})
	@IsString({ message: '이메일은 문자열이어야 합니다.' })
	email: string;

	@ApiProperty({
		description: '비밀번호',
		example: 'password123',
	})
	@IsString({ message: '비밀번호는 문자열이어야 합니다.' })
	password: string;
}

