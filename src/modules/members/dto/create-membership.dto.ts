import { IsEnum, IsDateString, IsNumber, Min } from 'class-validator';
import { MembershipType, MembershipStatus } from '../../../common/enums';

export class CreateMembershipDto {
  @IsEnum(MembershipType, { message: '올바른 회원권 타입이 아닙니다.' })
  membershipType: MembershipType;

  @IsDateString({}, { message: '올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)' })
  purchaseDate: string;

  @IsDateString({}, { message: '올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)' })
  expiryDate: string;

  @IsEnum(MembershipStatus, { message: '올바른 회원권 상태가 아닙니다.' })
  status?: MembershipStatus;

  @IsNumber({}, { message: '가격은 숫자여야 합니다.' })
  @Min(0, { message: '가격은 0 이상이어야 합니다.' })
  price: number;
}

