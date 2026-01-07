import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface';
import { ConfigService } from '@nestjs/config';

export const getCorsConfig = (configService: ConfigService): CorsOptions => {
	const frontendUrl = configService.get<string>('FRONTEND_URL');
	
	// 기본 허용 origin 목록 (프론트엔드 배포 주소 포함)
	const defaultOrigins = [
		'http://localhost:3000',
		'https://gym-admin-mu.vercel.app', // 프론트엔드 배포 주소
	];
	
	const allowedOrigins = frontendUrl
		? [...defaultOrigins, ...frontendUrl.split(',').map((url) => url.trim())]
		: defaultOrigins;

	const nodeEnv = configService.get<string>('NODE_ENV') || 'development';

	return {
		origin: (origin, callback) => {
			// 개발 환경에서는 모든 origin 허용
			if (nodeEnv === 'development') {
				return callback(null, true);
			}

			// 프로덕션 환경에서는 허용된 origin만 허용
			if (!origin || allowedOrigins.includes(origin)) {
				callback(null, true);
			} else {
				callback(new Error('CORS 정책에 의해 차단되었습니다.'));
			}
		},
		credentials: true,
		methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
		allowedHeaders: ['Content-Type', 'Authorization'],
	};
};

