import { NestFactory } from "@nestjs/core";
import { ValidationPipe } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { AppModule } from "./app.module";
import { getCorsConfig } from "./config/cors.config";
import { HttpExceptionFilter } from "./common/filters/http-exception.filter";
import { LoggingInterceptor, TransformInterceptor, TimeoutInterceptor } from "./common/interceptors";

async function bootstrap() {
	const app = await NestFactory.create(AppModule);
	const configService = app.get(ConfigService);

	// CORS 설정
	app.enableCors(getCorsConfig(configService));

	// 전역 예외 필터
	app.useGlobalFilters(new HttpExceptionFilter());

	// 전역 인터셉터
	app.useGlobalInterceptors(new LoggingInterceptor(), new TransformInterceptor(), new TimeoutInterceptor(configService.get<number>("REQUEST_TIMEOUT") || 30000));

	// 전역 검증 파이프
	app.useGlobalPipes(
		new ValidationPipe({
			whitelist: true,
			forbidNonWhitelisted: true,
			transform: true,
			transformOptions: {
				enableImplicitConversion: true,
			},
		})
	);

	const port = configService.get<number>("PORT") || 3001;
	await app.listen(port);
	console.log(`Application is running on: http://localhost:${port}`);
}
bootstrap();
