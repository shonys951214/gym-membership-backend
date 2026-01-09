import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AssessmentsController } from './assessments.controller';
import { AssessmentsService } from './assessments.service';
import { Assessment } from '../../entities/assessment.entity';
import { AssessmentItem } from '../../entities/assessment-item.entity';
import { AbilitySnapshot } from '../../entities/ability-snapshot.entity';
import { InjuryRestriction } from '../../entities/injury-restriction.entity';
import { InjuryHistory } from '../../entities/injury-history.entity';
import { AssessmentGradeConstant } from '../../entities/assessment-grade-constant.entity';
import { AssessmentCategoryScore } from '../../entities/assessment-category-score.entity';
import { FlexibilityItemWeight } from '../../entities/flexibility-item-weight.entity';
import { FlexibilityGradeThreshold } from '../../entities/flexibility-grade-threshold.entity';
import { BodyCompositionStandard } from '../../entities/body-composition-standard.entity';
import { Member } from '../../entities/member.entity';
import { ScoreCalculator } from '../../common/utils/score-calculator';
import { GradeScoreConverter } from '../../common/utils/grade-score-converter';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Assessment,
      AssessmentItem,
      AbilitySnapshot,
      InjuryRestriction,
      InjuryHistory,
      AssessmentGradeConstant,
      AssessmentCategoryScore,
      FlexibilityItemWeight,
      FlexibilityGradeThreshold,
      BodyCompositionStandard,
      Member,
    ]),
  ],
  controllers: [AssessmentsController],
  providers: [AssessmentsService, ScoreCalculator, GradeScoreConverter],
	exports: [AssessmentsService],
})
export class AssessmentsModule {}

