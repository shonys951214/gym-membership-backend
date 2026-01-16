import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { ConfigModule, ConfigService } from "@nestjs/config";
import { AppController } from "./app.controller";
import { AppService } from "./app.service";
import { AuthModule } from "./modules/auth/auth.module";
import { MembersModule } from "./modules/members/members.module";
import { AssessmentsModule } from "./modules/assessments/assessments.module";
import { AnalyticsModule } from "./modules/analytics/analytics.module";
import { InsightsModule } from "./modules/insights/insights.module";
import { ExercisesModule } from "./modules/exercises/exercises.module";
import { getDatabaseConfig } from "./config/database.config";

@Module({
	imports: [
		ConfigModule.forRoot({
			isGlobal: true,
		}),
		TypeOrmModule.forRootAsync({
			imports: [ConfigModule],
			useFactory: getDatabaseConfig,
			inject: [ConfigService],
		}),
		AuthModule,
		MembersModule,
		AssessmentsModule,
		AnalyticsModule,
		InsightsModule,
		ExercisesModule,
	],
	controllers: [AppController],
	providers: [AppService],
})
export class AppModule {}
