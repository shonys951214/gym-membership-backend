import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AssessmentsController } from './assessments.controller';
import { AssessmentsService } from './assessments.service';
import { Assessment } from '../../entities/assessment.entity';
import { AssessmentItem } from '../../entities/assessment-item.entity';
import { AbilitySnapshot } from '../../entities/ability-snapshot.entity';
import { InjuryRestriction } from '../../entities/injury-restriction.entity';
import { InjuryHistory } from '../../entities/injury-history.entity';
import { ScoreCalculator } from '../../common/utils/score-calculator';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Assessment,
      AssessmentItem,
      AbilitySnapshot,
      InjuryRestriction,
      InjuryHistory,
    ]),
  ],
  controllers: [AssessmentsController],
  providers: [AssessmentsService, ScoreCalculator],
	exports: [AssessmentsService],
})
export class AssessmentsModule {}

