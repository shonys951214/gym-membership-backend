import { NestFactory } from "@nestjs/core";
import { ValidationPipe } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { SwaggerModule, DocumentBuilder } from "@nestjs/swagger";
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

	// Swagger 설정
	const config = new DocumentBuilder()
		.setTitle("헬스장 회원관리 시스템 API")
		.setDescription("헬스장 회원의 신체 능력을 수치화·평균화·시각화하고 시간에 따른 변화를 추적하는 API")
		.setVersion("1.0")
		.addBearerAuth(
			{
				type: "http",
				scheme: "bearer",
				bearerFormat: "JWT",
				name: "JWT",
				description: "JWT 토큰을 입력하세요",
				in: "header",
			},
			"JWT-auth"
		)
		.addTag("auth", "인증 관련 API")
		.addTag("members", "회원 관리 API")
		.addTag("assessments", "평가 시스템 API")
		.addTag("abilities", "능력치 API")
		.addTag("injuries", "부상 관리 API")
		.addTag("analytics", "분석 API")
		.addTag("insights", "인사이트 API (대시보드용)")
		.build();

	const document = SwaggerModule.createDocument(app, config);
	SwaggerModule.setup("api", app, document, {
		swaggerOptions: {
			persistAuthorization: true, // 새로고침 시에도 인증 정보 유지
		},
	});

	const port = configService.get<number>("PORT") || 3001;
	await app.listen(port);
	console.log(`Application is running on: http://localhost:${port}`);
	console.log(`Swagger documentation: http://localhost:${port}/api`);
}
bootstrap();
