import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { MembersController } from "./members.controller";
import { MembersService } from "./members.service";
import { WorkoutRecordsService } from "./workout-records.service";
import { PTSessionsService } from "./pt-sessions.service";
import { WorkoutRoutinesService } from "./workout-routines.service";
import { InjuriesController } from "./injuries.controller";
import { AbilitiesController } from "./abilities.controller";
import { MemberAnalyticsController } from "./analytics.controller";
import { WorkoutRoutinesController } from "./workout-routines.controller";
import { Member } from "../../entities/member.entity";
import { Membership } from "../../entities/membership.entity";
import { PTUsage } from "../../entities/pt-usage.entity";
import { InjuryHistory } from "../../entities/injury-history.entity";
import { InjuryRestriction } from "../../entities/injury-restriction.entity";
import { AbilitySnapshot } from "../../entities/ability-snapshot.entity";
import { WorkoutRecord } from "../../entities/workout-record.entity";
import { PTSession } from "../../entities/pt-session.entity";
import { WorkoutRoutine } from "../../entities/workout-routine.entity";
import { Exercise } from "../../entities/exercise.entity";
import { StrengthStandard } from "../../entities/strength-standard.entity";
import { AssessmentsModule } from "../assessments/assessments.module";
import { StrengthLevelEvaluator } from "../../common/utils/strength-level-evaluator";

@Module({
	imports: [
		TypeOrmModule.forFeature([
			Member,
			Membership,
			PTUsage,
			InjuryHistory,
			InjuryRestriction,
			AbilitySnapshot,
			WorkoutRecord,
			PTSession,
			WorkoutRoutine,
			Exercise,
			StrengthStandard,
			WorkoutRecord,
		]),
		AssessmentsModule,
	],
	controllers: [
		MembersController,
		InjuriesController,
		AbilitiesController,
		MemberAnalyticsController,
		WorkoutRoutinesController,
	],
	providers: [MembersService, WorkoutRecordsService, PTSessionsService, WorkoutRoutinesService, StrengthLevelEvaluator],
	exports: [MembersService, WorkoutRecordsService, PTSessionsService, WorkoutRoutinesService],
})
export class MembersModule {}

