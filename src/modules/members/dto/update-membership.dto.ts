import { IsEnum, IsDateString, IsNumber, IsOptional, Min } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { MembershipType, MembershipStatus } from '../../../common/enums';

export class UpdateMembershipDto {
	@ApiPropertyOptional({
		description: '회원권 타입',
		enum: MembershipType,
		example: MembershipType.MONTHLY,
	})
	@IsOptional()
	@IsEnum(MembershipType, { message: '올바른 회원권 타입이 아닙니다.' })
	membershipType?: MembershipType;

	@ApiPropertyOptional({
		description: '구매일 (YYYY-MM-DD 형식)',
		example: '2024-01-01',
	})
	@IsOptional()
	@IsDateString({}, { message: '올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)' })
	purchaseDate?: string;

	@ApiPropertyOptional({
		description: '만료일 (YYYY-MM-DD 형식)',
		example: '2024-12-31',
	})
	@IsOptional()
	@IsDateString({}, { message: '올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)' })
	expiryDate?: string;

	@ApiPropertyOptional({
		description: '회원권 상태',
		enum: MembershipStatus,
		example: MembershipStatus.ACTIVE,
	})
	@IsOptional()
	@IsEnum(MembershipStatus, { message: '올바른 회원권 상태가 아닙니다.' })
	status?: MembershipStatus;

	@ApiPropertyOptional({
		description: '가격',
		example: 100000,
		minimum: 0,
	})
	@IsOptional()
	@IsNumber({}, { message: '가격은 숫자여야 합니다.' })
	@Min(0, { message: '가격은 0 이상이어야 합니다.' })
	price?: number;
}

