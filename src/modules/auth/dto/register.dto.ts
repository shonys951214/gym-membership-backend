import { IsEmail, IsString, MinLength, IsOptional, IsEnum } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Role } from '../../../common/enums';

export class RegisterDto {
	@ApiProperty({
		description: '이메일 주소',
		example: 'user@example.com',
	})
	@IsEmail({}, { message: '올바른 이메일 형식이 아닙니다.' })
	email: string;

	@ApiProperty({
		description: '비밀번호 (최소 6자)',
		example: 'password123',
		minLength: 6,
	})
	@IsString({ message: '비밀번호는 문자열이어야 합니다.' })
	@MinLength(6, { message: '비밀번호는 최소 6자 이상이어야 합니다.' })
	password: string;

	@ApiProperty({
		description: '이름',
		example: '홍길동',
	})
	@IsString({ message: '이름은 문자열이어야 합니다.' })
	name: string;

	@ApiPropertyOptional({
		description: '사용자 역할',
		enum: Role,
		example: Role.MEMBER,
		default: Role.MEMBER,
	})
	@IsOptional()
	@IsEnum(Role, { message: '올바른 역할이 아닙니다.' })
	role?: Role;
}

