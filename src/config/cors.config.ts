import { CorsOptions } from '@nestjs/common/interfaces/external/cors-options.interface';
import { ConfigService } from '@nestjs/config';

export const getCorsConfig = (configService: ConfigService): CorsOptions => {
	const frontendUrl = configService.get<string>('FRONTEND_URL');
	const allowedOrigins = frontendUrl
		? frontendUrl.split(',').map((url) => url.trim())
		: ['http://localhost:3000'];

	const nodeEnv = configService.get<string>('NODE_ENV') || 'development';

	return {
		origin: (origin, callback) => {
			// 개발 환경에서는 모든 origin 허용 (옵션)
			if (nodeEnv === 'development' && !origin) {
				return callback(null, true);
			}

			// 허용된 origin 목록 확인
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

