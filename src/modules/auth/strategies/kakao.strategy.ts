import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-kakao';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class KakaoStrategy extends PassportStrategy(Strategy, 'kakao') {
	constructor(
		private configService: ConfigService,
		private authService: AuthService,
	) {
		const clientSecret = configService.get<string>('KAKAO_CLIENT_SECRET');

		super({
			clientID: configService.get<string>('KAKAO_CLIENT_ID'),
			...(clientSecret && { clientSecret }), // Client Secret이 있을 때만 추가
			callbackURL: configService.get<string>('KAKAO_REDIRECT_URI'),
		});
	}

	async validate(accessToken: string, refreshToken: string, profile: any) {
		const { id, username, _json } = profile;

		// 카카오 사용자 정보 추출
		const kakaoUser = {
			provider: 'KAKAO',
			providerId: id.toString(),
			email: _json.kakao_account?.email,
			name: username || _json.kakao_account?.profile?.nickname || '카카오 사용자',
		};

		// 사용자 검증/생성 및 토큰 반환
		return await this.authService.validateOrCreateSocialUser(kakaoUser);
	}
}

