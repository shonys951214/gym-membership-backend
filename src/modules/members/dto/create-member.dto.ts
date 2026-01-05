import { IsString, IsEmail, IsDateString, IsOptional, IsEnum, MaxLength } from 'class-validator';
import { MemberStatus } from '../../../common/enums';

export class CreateMemberDto {
  @IsString({ message: '이름은 문자열이어야 합니다.' })
  @MaxLength(255, { message: '이름은 255자 이하여야 합니다.' })
  name: string;

  @IsString({ message: '전화번호는 문자열이어야 합니다.' })
  @MaxLength(50, { message: '전화번호는 50자 이하여야 합니다.' })
  phone: string;

  @IsEmail({}, { message: '올바른 이메일 형식이 아닙니다.' })
  @MaxLength(255, { message: '이메일은 255자 이하여야 합니다.' })
  email: string;

  @IsDateString({}, { message: '올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)' })
  joinDate: string;

  @IsOptional()
  @IsEnum(MemberStatus, { message: '올바른 상태가 아닙니다.' })
  status?: MemberStatus;
}

