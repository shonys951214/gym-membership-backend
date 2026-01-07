import { Injectable, Logger } from "@nestjs/common";
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AbilitySnapshot } from '../../entities/ability-snapshot.entity';
import { Member } from '../../entities/member.entity';
import { ApiExceptions } from '../../common/exceptions';

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
    flexibilityScore: number; // 1차피드백: 유연성 추가
    bodyScore: number;
    stabilityScore: number;
    totalScore: number;
    totalMembers: number;
  }> {
    // 각 회원의 최신 스냅샷만 가져오기
    const members = await this.memberRepository.find();
    const latestSnapshots = await Promise.all(
      members.map(async (member) => {
        return this.abilitySnapshotRepository.findOne({
          where: { memberId: member.id },
          order: { assessedAt: 'DESC' },
        });
      }),
    );

    const validSnapshots = latestSnapshots.filter(
      (snapshot) => snapshot !== null,
    ) as AbilitySnapshot[];

    if (validSnapshots.length === 0) {
      return {
        strengthScore: 0,
        cardioScore: 0,
        enduranceScore: 0,
        flexibilityScore: 0, // 1차피드백: 유연성 추가
        bodyScore: 0,
        stabilityScore: 0,
        totalScore: 0,
        totalMembers: 0,
      };
    }

    const averages = {
      strengthScore: 0,
      cardioScore: 0,
      enduranceScore: 0,
      flexibilityScore: 0, // 1차피드백: 유연성 추가
      bodyScore: 0,
      stabilityScore: 0,
      totalScore: 0,
    };

    validSnapshots.forEach((snapshot) => {
      averages.strengthScore += snapshot.strengthScore || 0;
      averages.cardioScore += snapshot.cardioScore || 0;
      averages.enduranceScore += snapshot.enduranceScore || 0;
      averages.flexibilityScore += snapshot.flexibilityScore || 0; // 1차피드백: 유연성 추가
      averages.bodyScore += snapshot.bodyScore || 0;
      averages.stabilityScore += snapshot.stabilityScore || 0;
      averages.totalScore += snapshot.totalScore || 0;
    });

    const count = validSnapshots.length;
    Object.keys(averages).forEach((key) => {
      averages[key] = averages[key] / count;
    });

    return {
      ...averages,
      totalMembers: count,
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
      flexibilityScore: number; // 1차피드백: 유연성 추가
      bodyScore: number;
      stabilityScore: number;
      totalScore: number;
    };
    percentile: {
      strengthScore: number;
      cardioScore: number;
      enduranceScore: number;
      flexibilityScore: number; // 1차피드백: 유연성 추가
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

    // 백분위 계산 (간단한 버전)
    const percentile = {
      strengthScore: this.calculatePercentile(
        memberSnapshot.strengthScore || 0,
        averages.strengthScore,
      ),
      cardioScore: this.calculatePercentile(
        memberSnapshot.cardioScore || 0,
        averages.cardioScore,
      ),
      enduranceScore: this.calculatePercentile(
        memberSnapshot.enduranceScore || 0,
        averages.enduranceScore,
      ),
      flexibilityScore: this.calculatePercentile(
        memberSnapshot.flexibilityScore || 0,
        averages.flexibilityScore,
      ), // 1차피드백: 유연성 추가
      bodyScore: this.calculatePercentile(
        memberSnapshot.bodyScore || 0,
        averages.bodyScore,
      ),
      stabilityScore: this.calculatePercentile(
        memberSnapshot.stabilityScore || 0,
        averages.stabilityScore,
      ),
      totalScore: this.calculatePercentile(
        memberSnapshot.totalScore,
        averages.totalScore,
      ),
    };

    return {
      member: memberSnapshot,
      average: {
        strengthScore: averages.strengthScore,
        cardioScore: averages.cardioScore,
        enduranceScore: averages.enduranceScore,
        flexibilityScore: averages.flexibilityScore, // 1차피드백: 유연성 추가
        bodyScore: averages.bodyScore,
        stabilityScore: averages.stabilityScore,
        totalScore: averages.totalScore,
      },
      percentile,
    };
  }

  /**
   * 간단한 백분위 계산 (실제로는 더 정교한 계산 필요)
   */
  private calculatePercentile(
    memberValue: number,
    averageValue: number,
  ): number {
    if (averageValue === 0) return 50;
    const ratio = memberValue / averageValue;
    // 평균 대비 비율을 백분위로 변환 (간단한 버전)
    return Math.min(100, Math.max(0, (ratio - 0.5) * 100 + 50));
  }
}

