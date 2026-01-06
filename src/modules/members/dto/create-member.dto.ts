import { IsString, IsEmail, IsDateString, IsOptional, IsEnum, MaxLength } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";
import { MemberStatus } from "../../../common/enums";
import { IsPhoneNumber } from "../../../common/decorators/is-phone-number.decorator";

export class CreateMemberDto {
	@ApiProperty({
		description: "회원 이름",
		example: "홍길동",
		maxLength: 255,
	})
	@IsString({ message: "이름은 문자열이어야 합니다." })
	@MaxLength(255, { message: "이름은 255자 이하여야 합니다." })
	name: string;

	@ApiProperty({
		description: "전화번호 (한국 형식)",
		example: "010-1234-5678",
		maxLength: 50,
	})
	@IsString({ message: "전화번호는 문자열이어야 합니다." })
	@IsPhoneNumber({ message: "유효한 전화번호 형식이어야 합니다. (예: 010-1234-5678, 02-1234-5678)" })
	@MaxLength(50, { message: "전화번호는 50자 이하여야 합니다." })
	phone: string;

	@ApiProperty({
		description: "이메일 주소",
		example: "member@example.com",
		maxLength: 255,
	})
	@IsEmail({}, { message: "올바른 이메일 형식이 아닙니다." })
	@MaxLength(255, { message: "이메일은 255자 이하여야 합니다." })
	email: string;

	@ApiProperty({
		description: "가입일 (YYYY-MM-DD 형식)",
		example: "2024-01-01",
	})
	@IsDateString({}, { message: "올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)" })
	joinDate: string;

	@ApiProperty({
		description: "회원 상태",
		enum: MemberStatus,
		example: MemberStatus.ACTIVE,
		required: false,
	})
	@IsOptional()
	@IsEnum(MemberStatus, { message: "올바른 상태가 아닙니다." })
	status?: MemberStatus;
}
