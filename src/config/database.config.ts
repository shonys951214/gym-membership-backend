import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { User } from '../entities/user.entity';
import { Member } from '../entities/member.entity';
import { Membership } from '../entities/membership.entity';
import { PTUsage } from '../entities/pt-usage.entity';
import { Assessment } from '../entities/assessment.entity';
import { AssessmentItem } from '../entities/assessment-item.entity';
import { AbilitySnapshot } from '../entities/ability-snapshot.entity';
import { InjuryHistory } from '../entities/injury-history.entity';
import { InjuryRestriction } from '../entities/injury-restriction.entity';
import { WorkoutRecord } from '../entities/workout-record.entity';
import { PTSession } from '../entities/pt-session.entity';
import { WorkoutRoutine } from '../entities/workout-routine.entity';
import { AssessmentGradeConstant } from '../entities/assessment-grade-constant.entity';
import { AssessmentCategoryScore } from '../entities/assessment-category-score.entity';
import { FlexibilityItemWeight } from '../entities/flexibility-item-weight.entity';
import { FlexibilityGradeThreshold } from '../entities/flexibility-grade-threshold.entity';
import { BodyCompositionStandard } from '../entities/body-composition-standard.entity';

export const getDatabaseConfig = (configService: ConfigService): TypeOrmModuleOptions => {
	const nodeEnv = configService.get<string>('NODE_ENV') || 'development';
	const isDevelopment = nodeEnv === 'development';

	// 공통 설정
	const commonConfig = {
		type: 'postgres' as const,
		entities: [
			User,
			Member,
			Membership,
			PTUsage,
			Assessment,
			AssessmentItem,
			AbilitySnapshot,
			InjuryHistory,
			InjuryRestriction,
			WorkoutRecord,
			PTSession,
			WorkoutRoutine,
			AssessmentGradeConstant,
			AssessmentCategoryScore,
			FlexibilityItemWeight,
			FlexibilityGradeThreshold,
			BodyCompositionStandard,
		],
		migrations: [__dirname + '/../migrations/*{.ts,.js}'],
		synchronize: configService.get<string>('DB_SYNCHRONIZE') === 'true',
		logging: configService.get<string>('DB_LOGGING') === 'true' || isDevelopment,
	};

	// DATABASE_URL이 있으면 사용
	const databaseUrl = configService.get<string>('DATABASE_URL');
	if (databaseUrl) {
		const isProduction = databaseUrl.includes('render.com') || databaseUrl.includes('amazonaws.com');
		return {
			...commonConfig,
			url: databaseUrl,
			ssl: isProduction ? { rejectUnauthorized: false } : false,
		};
	}

	// 개별 설정 사용
	const host = configService.get<string>('DB_HOST') || 'localhost';
	const port = parseInt(configService.get<string>('DB_PORT') || '5432', 10);
	const username = configService.get<string>('DB_USERNAME') || 'postgres';
	const password = configService.get<string>('DB_PASSWORD') || 'postgres';
	const database = configService.get<string>('DB_NAME') || 'gym_membership_db';
	const isProduction = host.includes('render.com') || host.includes('amazonaws.com');

	return {
		...commonConfig,
		host,
		port,
		username,
		password,
		database,
		ssl: isProduction ? { rejectUnauthorized: false } : false,
	};
};

