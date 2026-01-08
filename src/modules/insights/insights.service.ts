import { Injectable } from "@nestjs/common";
import { InjectRepository } from "@nestjs/typeorm";
import { Repository, MoreThan, In, IsNull } from "typeorm";
import { AbilitySnapshot } from "../../entities/ability-snapshot.entity";
import { Member } from "../../entities/member.entity";
import { Assessment } from "../../entities/assessment.entity";
import { InjuryHistory } from "../../entities/injury-history.entity";
import { MemberStatus, RecoveryStatus } from "../../common/enums";
import { DateHelper } from "../../common/utils/date-helper";
import { SnapshotNormalizer } from "../../common/utils/snapshot-normalizer";
import { AnalyticsHelper } from "../../common/utils/analytics-helper";

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
		private assessmentRepository: Repository<Assessment>,
		@InjectRepository(InjuryHistory)
		private injuryHistoryRepository: Repository<InjuryHistory>
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

		const validSnapshots = SnapshotNormalizer.normalizeArray(latestSnapshots);

		if (validSnapshots.length === 0) {
			return {
				indicators: [
					{ name: "하체 근력", score: 0 },
					{ name: "심폐 지구력", score: 0 },
					{ name: "근지구력", score: 0 },
					{ name: "유연성", score: 0 },
					{ name: "체성분 밸런스", score: 0 },
					{ name: "부상 안정성", score: 0 },
				],
				assessedAt: DateHelper.getKoreaTimeISOString(),
				version: "v1",
			};
		}

		const averages = AnalyticsHelper.calculateAverages(validSnapshots);

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

		const normalizedThisWeek = SnapshotNormalizer.normalizeArray(thisWeekSnapshots);
		const normalizedLastWeek = SnapshotNormalizer.normalizeArray(lastWeekSnapshots);

		const thisWeek = AnalyticsHelper.calculateAverages(normalizedThisWeek);
		const lastWeek = AnalyticsHelper.calculateAverages(normalizedLastWeek);

		const changes = {
			strengthScore: thisWeek.strengthScore - lastWeek.strengthScore,
			cardioScore: thisWeek.cardioScore - lastWeek.cardioScore,
			enduranceScore: thisWeek.enduranceScore - lastWeek.enduranceScore,
			bodyScore: thisWeek.bodyScore - lastWeek.bodyScore,
			stabilityScore: thisWeek.stabilityScore - lastWeek.stabilityScore,
			totalScore: thisWeek.totalScore - lastWeek.totalScore,
		};

		const percentageChange = {
			strengthScore: lastWeek.strengthScore !== 0 ? (changes.strengthScore / lastWeek.strengthScore) * 100 : 0,
			cardioScore: lastWeek.cardioScore !== 0 ? (changes.cardioScore / lastWeek.cardioScore) * 100 : 0,
			enduranceScore: lastWeek.enduranceScore !== 0 ? (changes.enduranceScore / lastWeek.enduranceScore) * 100 : 0,
			bodyScore: lastWeek.bodyScore !== 0 ? (changes.bodyScore / lastWeek.bodyScore) * 100 : 0,
			stabilityScore: lastWeek.stabilityScore !== 0 ? (changes.stabilityScore / lastWeek.stabilityScore) * 100 : 0,
			totalScore: lastWeek.totalScore !== 0 ? (changes.totalScore / lastWeek.totalScore) * 100 : 0,
		};

		return {
			thisWeek: {
				strengthScore: Math.round(thisWeek.strengthScore),
				cardioScore: Math.round(thisWeek.cardioScore),
				enduranceScore: Math.round(thisWeek.enduranceScore),
				bodyScore: Math.round(thisWeek.bodyScore),
				stabilityScore: Math.round(thisWeek.stabilityScore),
				totalScore: Math.round(thisWeek.totalScore),
			},
			lastWeek: {
				strengthScore: Math.round(lastWeek.strengthScore),
				cardioScore: Math.round(lastWeek.cardioScore),
				enduranceScore: Math.round(lastWeek.enduranceScore),
				bodyScore: Math.round(lastWeek.bodyScore),
				stabilityScore: Math.round(lastWeek.stabilityScore),
				totalScore: Math.round(lastWeek.totalScore),
			},
			changes: {
				strengthScore: Math.round(changes.strengthScore),
				cardioScore: Math.round(changes.cardioScore),
				enduranceScore: Math.round(changes.enduranceScore),
				bodyScore: Math.round(changes.bodyScore),
				stabilityScore: Math.round(changes.stabilityScore),
				totalScore: Math.round(changes.totalScore),
			},
			percentageChange: {
				strengthScore: Math.round(percentageChange.strengthScore * 100) / 100,
				cardioScore: Math.round(percentageChange.cardioScore * 100) / 100,
				enduranceScore: Math.round(percentageChange.enduranceScore * 100) / 100,
				bodyScore: Math.round(percentageChange.bodyScore * 100) / 100,
				stabilityScore: Math.round(percentageChange.stabilityScore * 100) / 100,
				totalScore: Math.round(percentageChange.totalScore * 100) / 100,
			},
		};
	}

	/**
	 * 위험 신호 회원 리스트
	 * 
	 * 쿼리 최적화:
	 * - N+1 문제 해결: 회원 100명 → 4개 쿼리 (병렬 실행)
	 * - 필요한 컬럼만 선택하여 메모리 사용량 감소 및 네트워크 트래픽 감소
	 * - Promise.all로 병렬 쿼리 실행하여 응답 시간 단축 (순차 실행 대비 약 3배 빠름)
	 * - 인덱스 활용: memberId, assessedAt, deletedAt 인덱스로 빠른 조회
	 * 
	 * 중복 제거:
	 * - 한 회원이 여러 위험 신호를 가지면 우선순위에 따라 하나만 반환
	 * - 우선순위: DECLINE > INJURY > INACTIVE
	 */
	async getRiskMembers(): Promise<RiskMember[]> {
		// 1. 활성 회원 조회 (필요한 컬럼만 선택)
		const members = await this.memberRepository.find({
			where: { status: MemberStatus.ACTIVE },
			select: ["id", "name"], // 필요한 컬럼만 선택
		});

		if (members.length === 0) {
			return [];
		}

		const memberIds = members.map(m => m.id);

		// 2-4. 병렬 쿼리 실행 (3개 쿼리를 동시에 실행하여 응답 시간 단축)
		const [snapshotsData, injuriesData, assessmentsData] = await Promise.all([
			// 2. 모든 회원의 최근 2개 스냅샷 조회 (필요한 컬럼만 선택)
			this.abilitySnapshotRepository
				.createQueryBuilder("snapshot")
				.select([
					"snapshot.id",
					"snapshot.memberId",
					"snapshot.assessedAt",
					"snapshot.strengthScore",
					"snapshot.cardioScore",
					"snapshot.enduranceScore",
					"snapshot.flexibilityScore",
					"snapshot.bodyScore",
					"snapshot.stabilityScore",
					"snapshot.totalScore",
					"snapshot.version",
				])
				.where("snapshot.memberId IN (:...memberIds)", { memberIds })
				.orderBy("snapshot.memberId", "ASC")
				.addOrderBy("snapshot.assessedAt", "DESC")
				.getMany(),

			// 3. 모든 회원의 활성 부상 조회 (필요한 컬럼만 선택)
			this.injuryHistoryRepository
				.createQueryBuilder("injury")
				.select([
					"injury.id",
					"injury.memberId",
					"injury.bodyPart",
					"injury.injuryType",
				])
				.where("injury.memberId IN (:...memberIds)", { memberIds })
				.andWhere("injury.recoveryStatus IN (:...statuses)", {
					statuses: [RecoveryStatus.RECOVERING, RecoveryStatus.CHRONIC],
				})
				.andWhere("injury.deletedAt IS NULL")
				.getMany(),

			// 4. 모든 회원의 최근 평가 조회 (필요한 컬럼만 선택)
			this.assessmentRepository
				.createQueryBuilder("assessment")
				.select([
					"assessment.id",
					"assessment.memberId",
					"assessment.assessedAt",
				])
				.where("assessment.memberId IN (:...memberIds)", { memberIds })
				.andWhere("assessment.deletedAt IS NULL")
				.orderBy("assessment.memberId", "ASC")
				.addOrderBy("assessment.assessedAt", "DESC")
				.getMany(),
		]);

		// 메모리에서 효율적으로 그룹화
		// 회원별로 스냅샷 그룹화 (최근 2개만)
		const snapshotsByMember = new Map<string, AbilitySnapshot[]>();
		for (const snapshot of snapshotsData) {
			if (!snapshotsByMember.has(snapshot.memberId)) {
				snapshotsByMember.set(snapshot.memberId, []);
			}
			const memberSnapshots = snapshotsByMember.get(snapshot.memberId)!;
			if (memberSnapshots.length < 2) {
				memberSnapshots.push(snapshot);
			}
		}

		// 회원별로 부상 그룹화
		const injuriesByMember = new Map<string, InjuryHistory[]>();
		for (const injury of injuriesData) {
			if (!injuriesByMember.has(injury.memberId)) {
				injuriesByMember.set(injury.memberId, []);
			}
			injuriesByMember.get(injury.memberId)!.push(injury);
		}

		// 회원별로 최근 평가만 추출
		const lastAssessmentByMember = new Map<string, Assessment>();
		for (const assessment of assessmentsData) {
			if (!lastAssessmentByMember.has(assessment.memberId)) {
				lastAssessmentByMember.set(assessment.memberId, assessment);
			}
		}

		// 5. 각 회원의 위험 신호 분석 및 중복 제거
		const riskMembersMap = new Map<string, RiskMember>();

		for (const member of members) {
			const memberId = member.id;
			const riskSignals: RiskMember[] = [];

			// DECLINE 체크 (우선순위 1)
			const snapshots = snapshotsByMember.get(memberId) || [];
			if (snapshots.length >= 2) {
				const current = SnapshotNormalizer.normalize(snapshots[0], memberId);
				const previous = SnapshotNormalizer.normalize(snapshots[1], memberId);

				const currentTotalScore = current.totalScore;
				const previousTotalScore = previous.totalScore;

				if (currentTotalScore > 0 && previousTotalScore > 0) {
					const declinePercentage = ((previousTotalScore - currentTotalScore) / previousTotalScore) * 100;

					if (declinePercentage >= 10) {
						riskSignals.push({
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

			// INJURY 체크 (우선순위 2)
			const activeInjuries = injuriesByMember.get(memberId) || [];
			if (activeInjuries.length > 0) {
				const injuryTypes = activeInjuries.map(injury => `${injury.bodyPart} ${injury.injuryType}`).join(", ");
				riskSignals.push({
					memberId: member.id,
					memberName: member.name,
					riskType: "INJURY",
					description: `활성 부상이 있습니다: ${injuryTypes}`,
				});
			}

			// INACTIVE 체크 (우선순위 3)
			const lastAssessment = lastAssessmentByMember.get(memberId);
			if (!lastAssessment) {
				riskSignals.push({
					memberId: member.id,
					memberName: member.name,
					riskType: "INACTIVE",
					description: "최근 평가 기록이 없습니다.",
				});
			} else {
				const assessedAtDate = lastAssessment.assessedAt instanceof Date 
					? lastAssessment.assessedAt 
					: new Date(lastAssessment.assessedAt);
					
				const daysSinceLastAssessment = (Date.now() - assessedAtDate.getTime()) / (1000 * 60 * 60 * 24);

				if (daysSinceLastAssessment > 30) {
					riskSignals.push({
						memberId: member.id,
						memberName: member.name,
						riskType: "INACTIVE",
						description: `마지막 평가로부터 ${Math.round(daysSinceLastAssessment)}일이 경과했습니다.`,
					});
				}
			}

			// 우선순위에 따라 하나만 선택: DECLINE > INJURY > INACTIVE
			if (riskSignals.length > 0) {
				const priorityOrder = { DECLINE: 1, INJURY: 2, INACTIVE: 3 };
				const selectedRisk = riskSignals.reduce((prev, current) => {
					return priorityOrder[prev.riskType] < priorityOrder[current.riskType] ? prev : current;
				});
				riskMembersMap.set(memberId, selectedRisk);
			}
		}

		return Array.from(riskMembersMap.values());
	}
}
