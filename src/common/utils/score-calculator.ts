import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AssessmentItem } from '../../entities/assessment-item.entity';
import { Category } from '../enums';
import { AbilitySnapshot } from '../../entities/ability-snapshot.entity';
import { InjuryRestriction } from '../../entities/injury-restriction.entity';

interface CategoryScores {
  strengthScore?: number | null;
  cardioScore?: number | null;
  enduranceScore?: number | null;
  bodyScore?: number | null;
  stabilityScore?: number | null;
}

const CURRENT_VERSION = 'v1';

@Injectable()
export class ScoreCalculator {
  constructor(
    @InjectRepository(AssessmentItem)
    private assessmentItemRepository: Repository<AssessmentItem>,
    @InjectRepository(AbilitySnapshot)
    private abilitySnapshotRepository: Repository<AbilitySnapshot>,
    @InjectRepository(InjuryRestriction)
    private injuryRestrictionRepository: Repository<InjuryRestriction>,
  ) {}

  /**
   * 평가 항목들을 카테고리별로 그룹화하고 평균 점수를 계산
   */
  private calculateCategoryScores(
    items: AssessmentItem[],
  ): CategoryScores {
    const categoryScores: CategoryScores = {};

    // 카테고리별로 그룹화
    const itemsByCategory = items.reduce((acc, item) => {
      if (!acc[item.category]) {
        acc[item.category] = [];
      }
      acc[item.category].push(item);
      return acc;
    }, {} as Record<Category, AssessmentItem[]>);

    // 각 카테고리의 평균 점수 계산
    Object.keys(itemsByCategory).forEach((category) => {
      const categoryItems = itemsByCategory[category as Category];
      if (categoryItems.length > 0) {
        const averageScore =
          categoryItems.reduce((sum, item) => sum + item.score, 0) /
          categoryItems.length;

        switch (category) {
          case Category.STRENGTH:
            categoryScores.strengthScore = averageScore;
            break;
          case Category.CARDIO:
            categoryScores.cardioScore = averageScore;
            break;
          case Category.ENDURANCE:
            categoryScores.enduranceScore = averageScore;
            break;
          case Category.BODY:
            categoryScores.bodyScore = averageScore;
            break;
          case Category.STABILITY:
            categoryScores.stabilityScore = averageScore;
            break;
        }
      }
    });

    return categoryScores;
  }

  /**
   * 부상으로 인해 평가가 제한된 영역을 제외
   */
  private excludeRestrictedCategories(
    categoryScores: CategoryScores,
    restrictions: InjuryRestriction[],
  ): CategoryScores {
    const restrictedCategories = restrictions.map(
      (r) => r.restrictedCategory,
    );
    const adjustedScores = { ...categoryScores };

    // 제한된 영역은 null로 처리 (종합 점수 계산 시 제외)
    restrictedCategories.forEach((category) => {
      switch (category) {
        case Category.STRENGTH:
          adjustedScores.strengthScore = null;
          break;
        case Category.CARDIO:
          adjustedScores.cardioScore = null;
          break;
        case Category.ENDURANCE:
          adjustedScores.enduranceScore = null;
          break;
        case Category.BODY:
          adjustedScores.bodyScore = null;
          break;
        case Category.STABILITY:
          adjustedScores.stabilityScore = null;
          break;
      }
    });

    return adjustedScores;
  }

  /**
   * 종합 점수 계산 (null 값 제외)
   * 가중치: 근력 30%, 심폐 25%, 지구력 20%, 신체 15%, 안정성 10%
   */
  private calculateTotalScore(
    categoryScores: CategoryScores,
  ): number {
    const weights = {
      strength: 0.3,
      cardio: 0.25,
      endurance: 0.2,
      body: 0.15,
      stability: 0.1,
    };

    let totalWeight = 0;
    let weightedSum = 0;

    if (categoryScores.strengthScore !== null && categoryScores.strengthScore !== undefined) {
      weightedSum += categoryScores.strengthScore * weights.strength;
      totalWeight += weights.strength;
    }
    if (categoryScores.cardioScore !== null && categoryScores.cardioScore !== undefined) {
      weightedSum += categoryScores.cardioScore * weights.cardio;
      totalWeight += weights.cardio;
    }
    if (categoryScores.enduranceScore !== null && categoryScores.enduranceScore !== undefined) {
      weightedSum += categoryScores.enduranceScore * weights.endurance;
      totalWeight += weights.endurance;
    }
    if (categoryScores.bodyScore !== null && categoryScores.bodyScore !== undefined) {
      weightedSum += categoryScores.bodyScore * weights.body;
      totalWeight += weights.body;
    }
    if (categoryScores.stabilityScore !== null && categoryScores.stabilityScore !== undefined) {
      weightedSum += categoryScores.stabilityScore * weights.stability;
      totalWeight += weights.stability;
    }

    // 가중치 합이 0이면 0 반환
    if (totalWeight === 0) {
      return 0;
    }

    // 가중 평균 계산
    return weightedSum / totalWeight;
  }

  /**
   * 평가 점수 계산 및 스냅샷 저장
   */
  async calculateAssessmentScore(
    assessmentId: string,
    memberId: string,
  ): Promise<AbilitySnapshot> {
    try {
      // 1. 평가 항목 조회
      const items = await this.assessmentItemRepository.find({
        where: { assessmentId },
      });

      if (items.length === 0) {
        throw new Error('평가 항목이 없습니다.');
      }

      // 2. 표준화 및 점수 계산 (일부 실패 허용)
      const categoryScores = this.calculateCategoryScores(items);

      // 3. 부상 영역 평가 제외 (부상이 있는 영역은 평가 불가)
      const injuryRestrictions =
        await this.injuryRestrictionRepository
          .createQueryBuilder('restriction')
          .leftJoinAndSelect('restriction.injury', 'injury')
          .where('injury.memberId = :memberId', { memberId })
          .andWhere('injury.recoveryStatus IN (:...statuses)', {
            statuses: ['RECOVERING', 'CHRONIC'],
          })
          .getMany();

      const adjustedScores = this.excludeRestrictedCategories(
        categoryScores,
        injuryRestrictions,
      );

      // 4. 종합 점수 계산 (null 제외)
      const totalScore = this.calculateTotalScore(adjustedScores);

      // 5. 스냅샷 저장 (버전 포함)
      const snapshot = this.abilitySnapshotRepository.create({
        assessmentId,
        memberId,
        assessedAt: new Date(),
        version: CURRENT_VERSION,
        strengthScore: adjustedScores.strengthScore ?? undefined,
        cardioScore: adjustedScores.cardioScore ?? undefined,
        enduranceScore: adjustedScores.enduranceScore ?? undefined,
        bodyScore: adjustedScores.bodyScore ?? undefined,
        stabilityScore: adjustedScores.stabilityScore ?? undefined,
        totalScore,
      });

      return await this.abilitySnapshotRepository.save(snapshot);
    } catch (error) {
      console.error(
        `Ability calculation failed for assessment ${assessmentId}:`,
        error,
      );
      throw error;
    }
  }
}

