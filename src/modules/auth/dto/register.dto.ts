import { IsString, IsOptional, IsEnum } from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { Role } from "../../../common/enums";
import { IsEmailOrTest } from "../../../common/decorators/is-email-or-test.decorator";

export class RegisterDto {
	@ApiProperty({
		description: "이메일 주소 (test 계정은 예외)",
		example: "user@example.com",
	})
	@IsString({ message: "이메일은 문자열이어야 합니다." })
	@IsEmailOrTest({ message: "유효한 이메일 형식이어야 합니다. (test 계정은 예외)" })
	email: string;

	@ApiProperty({
		description: "비밀번호",
		example: "password123",
	})
	@IsString({ message: "비밀번호는 문자열이어야 합니다." })
	password: string;

	@ApiProperty({
		description: "이름",
		example: "홍길동",
	})
	@IsString({ message: "이름은 문자열이어야 합니다." })
	name: string;

	@ApiPropertyOptional({
		description: "사용자 역할",
		enum: Role,
		example: Role.MEMBER,
		default: Role.MEMBER,
	})
	@IsOptional()
	@IsEnum(Role, { message: "올바른 역할이 아닙니다." })
	role?: Role;
}
