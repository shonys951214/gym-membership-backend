import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository, MoreThan } from "typeorm";
import { AbilitySnapshot } from "../../entities/ability-snapshot.entity";
import { Member } from "../../entities/member.entity";
import { Assessment } from "../../entities/assessment.entity";
import { MemberStatus } from "../../common/enums";
import { DateHelper } from "../../common/utils/date-helper";

export interface HexagonData {
	indicators: Array<{
		name: string;
		score: number;
	}>;
	assessedAt: string;
	version: string;
}

export interface WeeklySummary {
	thisWeek: {
		strengthScore: number;
		cardioScore: number;
		enduranceScore: number;
		bodyScore: number;
		stabilityScore: number;
		totalScore: number;
	};
	lastWeek: {
		strengthScore: number;
		cardioScore: number;
		enduranceScore: number;
		bodyScore: number;
		stabilityScore: number;
		totalScore: number;
	};
	changes: {
		strengthScore: number;
		cardioScore: number;
		enduranceScore: number;
		bodyScore: number;
		stabilityScore: number;
		totalScore: number;
	};
	percentageChange: {
		strengthScore: number;
		cardioScore: number;
		enduranceScore: number;
		bodyScore: number;
		stabilityScore: number;
		totalScore: number;
	};
}

export interface RiskMember {
	memberId: string;
	memberName: string;
	riskType: "DECLINE" | "INJURY" | "INACTIVE";
	description: string;
	currentScore?: number;
	previousScore?: number;
	declinePercentage?: number;
}

@Injectable()
export class InsightsService {
	constructor(
		@InjectRepository(AbilitySnapshot)
		private abilitySnapshotRepository: Repository<AbilitySnapshot>,
		@InjectRepository(Member)
		private memberRepository: Repository<Member>,
		@InjectRepository(Assessment)
		private assessmentRepository: Repository<Assessment>
	) {}

	/**
	 * 운영 능력치 헥사곤 (전체 회원 평균)
	 */
	async getHexagon(): Promise<HexagonData> {
		const members = await this.memberRepository.find({
			where: { status: MemberStatus.ACTIVE },
		});

		if (members.length === 0) {
			return {
				indicators: [
					{ name: "하체 근력", score: 0 },
					{ name: "심폐 지구력", score: 0 },
					{ name: "근지구력", score: 0 },
					{ name: "유연성", score: 0 }, // 1차피드백: 유연성 추가
					{ name: "체성분 밸런스", score: 0 },
					{ name: "부상 안정성", score: 0 },
				],
				assessedAt: DateHelper.getKoreaTimeISOString(),
				version: "v1",
			};
		}

		const latestSnapshots = await Promise.all(
			members.map(async (member) => {
				return this.abilitySnapshotRepository.findOne({
					where: { memberId: member.id },
					order: { assessedAt: "DESC" },
				});
			})
		);

		const validSnapshots = latestSnapshots.filter((snapshot) => snapshot !== null) as AbilitySnapshot[];

		if (validSnapshots.length === 0) {
			return {
				indicators: [
					{ name: "하체 근력", score: 0 },
					{ name: "심폐 지구력", score: 0 },
					{ name: "근지구력", score: 0 },
					{ name: "유연성", score: 0 }, // 1차피드백: 유연성 추가
					{ name: "체성분 밸런스", score: 0 },
					{ name: "부상 안정성", score: 0 },
				],
				assessedAt: DateHelper.getKoreaTimeISOString(),
				version: "v1",
			};
		}

		const averages = {
			strengthScore: 0,
			cardioScore: 0,
			enduranceScore: 0,
			flexibilityScore: 0, // 1차피드백: 유연성 추가
			bodyScore: 0,
			stabilityScore: 0,
		};

		validSnapshots.forEach((snapshot) => {
			averages.strengthScore += snapshot.strengthScore || 0;
			averages.cardioScore += snapshot.cardioScore || 0;
			averages.enduranceScore += snapshot.enduranceScore || 0;
			averages.flexibilityScore += snapshot.flexibilityScore || 0; // 1차피드백: 유연성 추가
			averages.bodyScore += snapshot.bodyScore || 0;
			averages.stabilityScore += snapshot.stabilityScore || 0;
		});

		const count = validSnapshots.length;
		Object.keys(averages).forEach((key) => {
			averages[key] = averages[key] / count;
		});

		const latestDate = validSnapshots.reduce((latest, snapshot) => {
			return snapshot.assessedAt > latest ? snapshot.assessedAt : latest;
		}, validSnapshots[0].assessedAt);

		return {
			indicators: [
				{ name: "하체 근력", score: Math.round(averages.strengthScore) },
				{ name: "심폐 지구력", score: Math.round(averages.cardioScore) },
				{ name: "근지구력", score: Math.round(averages.enduranceScore) },
				{ name: "유연성", score: Math.round(averages.flexibilityScore) }, // 1차피드백: 유연성 추가
				{ name: "체성분 밸런스", score: Math.round(averages.bodyScore) },
				{ name: "부상 안정성", score: Math.round(averages.stabilityScore) },
			],
			assessedAt: DateHelper.toKoreaTimeISOString(latestDate),
			version: validSnapshots[0].version || "v1",
		};
	}

	/**
	 * 이번 주 vs 지난 주 비교
	 */
	async getWeeklySummary(): Promise<WeeklySummary> {
		const now = new Date();
		const thisWeekStart = new Date(now);
		thisWeekStart.setDate(now.getDate() - 7);
		const lastWeekStart = new Date(thisWeekStart);
		lastWeekStart.setDate(thisWeekStart.getDate() - 7);

		const thisWeekSnapshots = await this.abilitySnapshotRepository.find({
			where: {
				assessedAt: MoreThan(thisWeekStart),
			},
			order: { assessedAt: "DESC" },
		});

		const lastWeekSnapshots = await this.abilitySnapshotRepository.find({
			where: {
				assessedAt: MoreThan(lastWeekStart),
			},
			order: { assessedAt: "DESC" },
		});

		const calculateAverage = (snapshots: AbilitySnapshot[]) => {
			if (snapshots.length === 0) {
				return {
					strengthScore: 0,
					cardioScore: 0,
					enduranceScore: 0,
					bodyScore: 0,
					stabilityScore: 0,
					totalScore: 0,
				};
			}

			const sum = snapshots.reduce(
				(acc, snapshot) => ({
					strengthScore: acc.strengthScore + (snapshot.strengthScore || 0),
					cardioScore: acc.cardioScore + (snapshot.cardioScore || 0),
					enduranceScore: acc.enduranceScore + (snapshot.enduranceScore || 0),
					bodyScore: acc.bodyScore + (snapshot.bodyScore || 0),
					stabilityScore: acc.stabilityScore + (snapshot.stabilityScore || 0),
					totalScore: acc.totalScore + (snapshot.totalScore ?? 0),
				}),
				{
					strengthScore: 0,
					cardioScore: 0,
					enduranceScore: 0,
					bodyScore: 0,
					stabilityScore: 0,
					totalScore: 0,
				}
			);

			const count = snapshots.length;
			return {
				strengthScore: sum.strengthScore / count,
				cardioScore: sum.cardioScore / count,
				enduranceScore: sum.enduranceScore / count,
				bodyScore: sum.bodyScore / count,
				stabilityScore: sum.stabilityScore / count,
				totalScore: sum.totalScore / count,
			};
		};

		const thisWeek = calculateAverage(thisWeekSnapshots);
		const lastWeek = calculateAverage(lastWeekSnapshots);

		const changes = {
			strengthScore: thisWeek.strengthScore - lastWeek.strengthScore,
			cardioScore: thisWeek.cardioScore - lastWeek.cardioScore,
			enduranceScore: thisWeek.enduranceScore - lastWeek.enduranceScore,
			bodyScore: thisWeek.bodyScore - lastWeek.bodyScore,
			stabilityScore: thisWeek.stabilityScore - lastWeek.stabilityScore,
			totalScore: (thisWeek.totalScore ?? 0) - (lastWeek.totalScore ?? 0),
		};

		const percentageChange = {
			strengthScore: lastWeek.strengthScore !== 0 ? (changes.strengthScore / lastWeek.strengthScore) * 100 : 0,
			cardioScore: lastWeek.cardioScore !== 0 ? (changes.cardioScore / lastWeek.cardioScore) * 100 : 0,
			enduranceScore: lastWeek.enduranceScore !== 0 ? (changes.enduranceScore / lastWeek.enduranceScore) * 100 : 0,
			bodyScore: lastWeek.bodyScore !== 0 ? (changes.bodyScore / lastWeek.bodyScore) * 100 : 0,
			stabilityScore: lastWeek.stabilityScore !== 0 ? (changes.stabilityScore / lastWeek.stabilityScore) * 100 : 0,
			totalScore: (lastWeek.totalScore ?? 0) !== 0 ? (changes.totalScore / (lastWeek.totalScore ?? 0)) * 100 : 0,
		};

		return {
			thisWeek: {
				strengthScore: Math.round(thisWeek.strengthScore),
				cardioScore: Math.round(thisWeek.cardioScore),
				enduranceScore: Math.round(thisWeek.enduranceScore),
				bodyScore: Math.round(thisWeek.bodyScore),
				stabilityScore: Math.round(thisWeek.stabilityScore),
				totalScore: Math.round(thisWeek.totalScore ?? 0),
			},
			lastWeek: {
				strengthScore: Math.round(lastWeek.strengthScore),
				cardioScore: Math.round(lastWeek.cardioScore),
				enduranceScore: Math.round(lastWeek.enduranceScore),
				bodyScore: Math.round(lastWeek.bodyScore),
				stabilityScore: Math.round(lastWeek.stabilityScore),
				totalScore: Math.round(lastWeek.totalScore ?? 0),
			},
			changes: {
				strengthScore: Math.round(changes.strengthScore),
				cardioScore: Math.round(changes.cardioScore),
				enduranceScore: Math.round(changes.enduranceScore),
				bodyScore: Math.round(changes.bodyScore),
				stabilityScore: Math.round(changes.stabilityScore),
				totalScore: Math.round(changes.totalScore ?? 0),
			},
			percentageChange: {
				strengthScore: Math.round(percentageChange.strengthScore * 100) / 100,
				cardioScore: Math.round(percentageChange.cardioScore * 100) / 100,
				enduranceScore: Math.round(percentageChange.enduranceScore * 100) / 100,
				bodyScore: Math.round(percentageChange.bodyScore * 100) / 100,
				stabilityScore: Math.round(percentageChange.stabilityScore * 100) / 100,
				totalScore: Math.round((percentageChange.totalScore ?? 0) * 100) / 100,
			},
		};
	}

	/**
	 * 위험 신호 회원 리스트
	 */
	async getRiskMembers(): Promise<RiskMember[]> {
		const members = await this.memberRepository.find({
			where: { status: MemberStatus.ACTIVE },
		});

		const riskMembers: RiskMember[] = [];

		for (const member of members) {
			const snapshots = await this.abilitySnapshotRepository.find({
				where: { memberId: member.id },
				order: { assessedAt: "DESC" },
				take: 2,
			});

			if (snapshots.length >= 2) {
				const current = snapshots[0];
				const previous = snapshots[1];

				// totalScore가 undefined일 수 있으므로 nullish coalescing 사용
				const currentTotalScore = current.totalScore ?? 0;
				const previousTotalScore = previous.totalScore ?? 0;

				if (currentTotalScore > 0 && previousTotalScore > 0) {
					const declinePercentage = ((previousTotalScore - currentTotalScore) / previousTotalScore) * 100;

					// 10% 이상 하락 시 위험 신호
					if (declinePercentage >= 10) {
						riskMembers.push({
							memberId: member.id,
							memberName: member.name,
							riskType: "DECLINE",
							description: `능력치가 ${Math.round(declinePercentage)}% 하락했습니다.`,
							currentScore: currentTotalScore,
							previousScore: previousTotalScore,
							declinePercentage: Math.round(declinePercentage),
						});
					}
				}
			}

			// 부상 이력 확인
			const recentInjuries = await this.assessmentRepository
				.createQueryBuilder("assessment")
				.leftJoinAndSelect("assessment.member", "member")
				.where("member.id = :memberId", { memberId: member.id })
				.andWhere("assessment.deletedAt IS NULL")
				.orderBy("assessment.assessedAt", "DESC")
				.getMany();

			// 최근 평가가 없거나 오래된 경우
			const lastAssessment = recentInjuries[0];
			if (!lastAssessment) {
				riskMembers.push({
					memberId: member.id,
					memberName: member.name,
					riskType: "INACTIVE",
					description: "최근 평가 기록이 없습니다.",
				});
			} else {
				const daysSinceLastAssessment = (Date.now() - lastAssessment.assessedAt.getTime()) / (1000 * 60 * 60 * 24);

				if (daysSinceLastAssessment > 30) {
					riskMembers.push({
						memberId: member.id,
						memberName: member.name,
						riskType: "INACTIVE",
						description: `마지막 평가로부터 ${Math.round(daysSinceLastAssessment)}일이 경과했습니다.`,
					});
				}
			}
		}

		return riskMembers;
	}
}
