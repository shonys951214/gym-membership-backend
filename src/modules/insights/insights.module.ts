import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { InsightsController } from "./insights.controller";
import { InsightsService } from "./insights.service";
import { AbilitySnapshot } from "../../entities/ability-snapshot.entity";
import { Member } from "../../entities/member.entity";
import { Assessment } from "../../entities/assessment.entity";

@Module({
	imports: [
		TypeOrmModule.forFeature([AbilitySnapshot, Member, Assessment]),
	],
	controllers: [InsightsController],
	providers: [InsightsService],
	exports: [InsightsService],
})
export class InsightsModule {}

