import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RefreshTokenDto {
	@ApiProperty({
		description: 'Refresh Token',
		example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
	})
	@IsString({ message: 'Refresh Token은 문자열이어야 합니다.' })
	refreshToken: string;
}
