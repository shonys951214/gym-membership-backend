import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { MembersController } from "./members.controller";
import { MembersService } from "./members.service";
import { InjuriesController } from "./injuries.controller";
import { AbilitiesController } from "./abilities.controller";
import { MemberAnalyticsController } from "./analytics.controller";
import { Member } from "../../entities/member.entity";
import { Membership } from "../../entities/membership.entity";
import { PTUsage } from "../../entities/pt-usage.entity";
import { InjuryHistory } from "../../entities/injury-history.entity";
import { InjuryRestriction } from "../../entities/injury-restriction.entity";
import { AbilitySnapshot } from "../../entities/ability-snapshot.entity";
import { AssessmentsModule } from "../assessments/assessments.module";

@Module({
	imports: [
		TypeOrmModule.forFeature([
			Member,
			Membership,
			PTUsage,
			InjuryHistory,
			InjuryRestriction,
			AbilitySnapshot,
		]),
		AssessmentsModule,
	],
	controllers: [
		MembersController,
		InjuriesController,
		AbilitiesController,
		MemberAnalyticsController,
	],
	providers: [MembersService],
	exports: [MembersService],
})
export class MembersModule {}

