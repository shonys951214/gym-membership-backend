import { IsEmail, IsString, MinLength, IsOptional, IsEnum } from 'class-validator';
import { Role } from '../../../common/enums';

export class RegisterDto {
  @IsEmail({}, { message: '올바른 이메일 형식이 아닙니다.' })
  email: string;

  @IsString({ message: '비밀번호는 문자열이어야 합니다.' })
  @MinLength(6, { message: '비밀번호는 최소 6자 이상이어야 합니다.' })
  password: string;

  @IsString({ message: '이름은 문자열이어야 합니다.' })
  name: string;

  @IsOptional()
  @IsEnum(Role, { message: '올바른 역할이 아닙니다.' })
  role?: Role;
}

