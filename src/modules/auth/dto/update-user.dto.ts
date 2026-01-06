import { IsString, IsOptional, IsEnum, MinLength, MaxLength } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { Role } from '../../../common/enums';
import { IsEmailOrTest } from '../../../common/decorators/is-email-or-test.decorator';

export class UpdateUserDto {
	@ApiPropertyOptional({
		description: '이름',
		example: '홍길동',
		maxLength: 255,
	})
	@IsOptional()
	@IsString({ message: '이름은 문자열이어야 합니다.' })
	@MaxLength(255, { message: '이름은 255자 이하여야 합니다.' })
	name?: string;

	@ApiPropertyOptional({
		description: '이메일 주소 (test 계정은 예외)',
		example: 'user@example.com',
		maxLength: 255,
	})
	@IsOptional()
	@IsString({ message: '이메일은 문자열이어야 합니다.' })
	@IsEmailOrTest({ message: '유효한 이메일 형식이어야 합니다. (test 계정은 예외)' })
	@MaxLength(255, { message: '이메일은 255자 이하여야 합니다.' })
	email?: string;

	@ApiPropertyOptional({
		description: '비밀번호 (최소 6자)',
		example: 'newpassword123',
		minLength: 6,
	})
	@IsOptional()
	@IsString({ message: '비밀번호는 문자열이어야 합니다.' })
	@MinLength(6, { message: '비밀번호는 최소 6자 이상이어야 합니다.' })
	password?: string;

	@ApiPropertyOptional({
		description: '사용자 역할 (ADMIN만 변경 가능)',
		enum: Role,
		example: Role.MEMBER,
	})
	@IsOptional()
	@IsEnum(Role, { message: '올바른 역할이 아닙니다.' })
	role?: Role;
}

