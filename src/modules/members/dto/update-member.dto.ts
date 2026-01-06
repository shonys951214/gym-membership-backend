import { IsString, IsEmail, IsOptional, IsEnum, MaxLength } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { MemberStatus } from '../../../common/enums';

export class UpdateMemberDto {
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
		description: '전화번호',
		example: '010-1234-5678',
		maxLength: 50,
	})
	@IsOptional()
	@IsString({ message: '전화번호는 문자열이어야 합니다.' })
	@MaxLength(50, { message: '전화번호는 50자 이하여야 합니다.' })
	phone?: string;

	@ApiPropertyOptional({
		description: '이메일 주소',
		example: 'member@example.com',
		maxLength: 255,
	})
	@IsOptional()
	@IsEmail({}, { message: '올바른 이메일 형식이 아닙니다.' })
	@MaxLength(255, { message: '이메일은 255자 이하여야 합니다.' })
	email?: string;

	@ApiPropertyOptional({
		description: '회원 상태',
		enum: MemberStatus,
		example: MemberStatus.ACTIVE,
	})
	@IsOptional()
	@IsEnum(MemberStatus, { message: '올바른 상태가 아닙니다.' })
	status?: MemberStatus;
}

