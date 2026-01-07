import { DataSource, DataSourceOptions } from "typeorm";
import { User } from "../entities/user.entity";
import { Member } from "../entities/member.entity";
import { Membership } from "../entities/membership.entity";
import { PTUsage } from "../entities/pt-usage.entity";
import { Assessment } from "../entities/assessment.entity";
import { AssessmentItem } from "../entities/assessment-item.entity";
import { AbilitySnapshot } from "../entities/ability-snapshot.entity";
import { InjuryHistory } from "../entities/injury-history.entity";
import { InjuryRestriction } from "../entities/injury-restriction.entity";
import { WorkoutRecord } from "../entities/workout-record.entity";
import { PTSession } from "../entities/pt-session.entity";
import { WorkoutRoutine } from "../entities/workout-routine.entity";

// DATABASE_URL이 있으면 사용, 없으면 개별 설정 사용
const getDatabaseConfig = () => {
	// DATABASE_URL 우선 사용
	if (process.env.DATABASE_URL) {
		return {
			url: process.env.DATABASE_URL,
		};
	}

	// 개별 설정 사용 (Render 등 외부 DB 호환)
	const host = process.env.DB_HOST;
	const ssl = host && (host.includes("render.com") || host.includes("amazonaws.com")) ? { rejectUnauthorized: false } : false;

	return {
		host: process.env.DB_HOST,
		port: parseInt(process.env.DB_PORT || "5432", 10),
		username: process.env.DB_USERNAME,
		password: process.env.DB_PASSWORD,
		database: process.env.DB_NAME,
		ssl: ssl as any,
	};
};

export const dataSourceOptions: DataSourceOptions = {
	type: "postgres",
	...getDatabaseConfig(),
	entities: [User, Member, Membership, PTUsage, Assessment, AssessmentItem, AbilitySnapshot, InjuryHistory, InjuryRestriction, WorkoutRecord, PTSession, WorkoutRoutine],
	migrations: [__dirname + "/../migrations/*{.ts,.js}"],
	synchronize: process.env.DB_SYNCHRONIZE === "true" || process.env.NODE_ENV === "development",
	logging: process.env.DB_LOGGING === "true" || process.env.NODE_ENV === "development",
	ssl: process.env.DB_HOST?.includes("render.com") || process.env.DB_HOST?.includes("amazonaws.com") ? { rejectUnauthorized: false } : false,
};

export const dataSource = new DataSource(dataSourceOptions);
