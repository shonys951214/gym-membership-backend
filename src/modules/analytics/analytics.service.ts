import { Injectable, Logger } from "@nestjs/common";
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AbilitySnapshot } from '../../entities/ability-snapshot.entity';
import { Member } from '../../entities/member.entity';
import { ApiExceptions } from '../../common/exceptions';
import { SnapshotNormalizer } from '../../common/utils/snapshot-normalizer';
import { AnalyticsHelper } from '../../common/utils/analytics-helper';

@Injectable()
export class AnalyticsService {
	private readonly logger = new Logger(AnalyticsService.name);

	constructor(
		@InjectRepository(AbilitySnapshot)
		private abilitySnapshotRepository: Repository<AbilitySnapshot>,
		@InjectRepository(Member)
		private memberRepository: Repository<Member>,
	) {}

  /**
   * 전체 회원 평균 능력치 계산
   */
  async getAverages(): Promise<{
    strengthScore: number;
    cardioScore: number;
    enduranceScore: number;
    flexibilityScore: number;
    bodyScore: number;
    stabilityScore: number;
    totalScore: number;
    totalMembers: number;
  }> {
    const members = await this.memberRepository.find();
    const latestSnapshots = await Promise.all(
      members.map((member) =>
        this.abilitySnapshotRepository.findOne({
          where: { memberId: member.id },
          order: { assessedAt: 'DESC' },
        }),
      ),
    );

    const averages = AnalyticsHelper.calculateAverages(latestSnapshots);
    const validCount = SnapshotNormalizer.normalizeArray(latestSnapshots).length;

    return {
      ...averages,
      totalMembers: validCount,
    };
  }

  /**
   * 개별 회원 vs 평균 비교
   */
  async compareWithAverage(memberId: string): Promise<{
    member: AbilitySnapshot;
    average: {
      strengthScore: number;
      cardioScore: number;
      enduranceScore: number;
      flexibilityScore: number;
      bodyScore: number;
      stabilityScore: number;
      totalScore: number;
    };
    percentile: {
      strengthScore: number;
      cardioScore: number;
      enduranceScore: number;
      flexibilityScore: number;
      bodyScore: number;
      stabilityScore: number;
      totalScore: number;
    };
  }> {
    const memberSnapshot = await this.abilitySnapshotRepository.findOne({
      where: { memberId },
      order: { assessedAt: 'DESC' },
    });

		if (!memberSnapshot) {
			this.logger.warn(
				`회원의 능력치 스냅샷을 찾을 수 없습니다. MemberId: ${memberId}`,
			);
			throw ApiExceptions.abilitySnapshotNotFound("회원의 능력치 스냅샷을 찾을 수 없습니다.");
		}

    const averages = await this.getAverages();
    const normalizedMember = SnapshotNormalizer.normalize(memberSnapshot, memberId);
    const percentile = AnalyticsHelper.calculatePercentiles(normalizedMember, averages);

    return {
      member: normalizedMember,
      average: {
        strengthScore: averages.strengthScore,
        cardioScore: averages.cardioScore,
        enduranceScore: averages.enduranceScore,
        flexibilityScore: averages.flexibilityScore,
        bodyScore: averages.bodyScore,
        stabilityScore: averages.stabilityScore,
        totalScore: averages.totalScore,
      },
      percentile,
    };
  }
}

