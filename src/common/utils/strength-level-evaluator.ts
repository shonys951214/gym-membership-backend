/**
 * Strength Level Evaluator
 * StrengthLevel.com 기준으로 운동별 상대적 강도 레벨을 판정합니다.
 */

import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull } from 'typeorm';
import { StrengthStandard } from '../../entities/strength-standard.entity';
import { Gender, StrengthLevel, StrengthLevelOrder } from '../enums';

/**
 * Strength Level 평가 결과
 */
export interface StrengthLevelEvaluationResult {
	level: StrengthLevel | null; // 판정된 레벨 (기준에 맞는 것이 없으면 null)
	currentWeight: number; // 현재 1RM (kg)
	bodyWeight: number; // 체중 (kg)
	nextLevel?: {
		level: StrengthLevel;
		targetWeight: number; // 다음 레벨까지 필요한 무게 (kg)
		progressPercentage: number; // 현재 레벨 대비 진행률 (%)
	};
}

/**
 * Strength Level Evaluator 클래스
 */
@Injectable()
export class StrengthLevelEvaluator {
	constructor(
		@InjectRepository(StrengthStandard)
		private strengthStandardRepository: Repository<StrengthStandard>,
	) {}

	/**
	 * Strength Level 평가
	 * @param exerciseId 운동 ID
	 * @param oneRepMax 1RM (kg)
	 * @param bodyWeight 체중 (kg)
	 * @param gender 성별
	 * @param age 나이 (선택적, 나이별 데이터 조회 시 사용)
	 * @returns Strength Level 평가 결과
	 */
	async evaluate(
		exerciseId: string,
		oneRepMax: number,
		bodyWeight: number,
		gender: Gender,
		age?: number,
	): Promise<StrengthLevelEvaluationResult> {
		// 1단계: 체중별 데이터 조회 (우선순위 1)
		const bodyweightStandards = await this.strengthStandardRepository.find({
			where: {
				exerciseId,
				gender,
				standardType: 'BODYWEIGHT',
			},
			order: {
				level: 'ASC',
				bodyweightMin: 'ASC',
			},
		});

		// 체중 범위에 맞는 기준 찾기
		let matchingStandards = bodyweightStandards.filter(
			(standard) =>
				standard.bodyweightMin !== null &&
				standard.bodyweightMax !== null &&
				bodyWeight >= standard.bodyweightMin &&
				bodyWeight <= standard.bodyweightMax,
		);

		// 2단계: 체중별 데이터가 없으면 나이별 데이터 조회 (우선순위 2)
		if (matchingStandards.length === 0 && age !== undefined && age !== null) {
			const ageStandards = await this.strengthStandardRepository.find({
				where: {
					exerciseId,
					gender,
					standardType: 'AGE',
				},
				order: {
					level: 'ASC',
					ageMin: 'ASC',
				},
			});

			matchingStandards = ageStandards.filter(
				(standard) =>
					standard.ageMin !== null &&
					standard.ageMax !== null &&
					age >= standard.ageMin &&
					age <= standard.ageMax,
			);
		}

		if (matchingStandards.length === 0) {
			// 기준이 없으면 가장 가까운 범위의 기준 사용 (체중별 우선)
			const closestStandard = this.findClosestStandard(
				bodyweightStandards.length > 0 ? bodyweightStandards : [],
				bodyWeight,
			);
			if (!closestStandard) {
				return {
					level: null,
					currentWeight: oneRepMax,
					bodyWeight,
				};
			}
			return this.evaluateWithStandard(closestStandard, oneRepMax, bodyWeight);
		}

		// 1RM이 기준 무게보다 크거나 같은 레벨 찾기
		let matchedLevel: StrengthLevel | null = null;
		let matchedStandard: StrengthStandard | null = null;

		for (const standard of matchingStandards) {
			if (oneRepMax >= standard.weightKg) {
				matchedLevel = standard.level;
				matchedStandard = standard;
			} else {
				// 기준 무게보다 작으면 이전 레벨이 최대 레벨
				break;
			}
		}

		// 레벨이 없으면 BEGINNER 미만 (레벨 없음)
		if (!matchedLevel || !matchedStandard) {
			const beginnerStandard = matchingStandards.find(
				(s) => s.level === StrengthLevel.BEGINNER,
			);
			if (beginnerStandard) {
				return {
					level: null,
					currentWeight: oneRepMax,
					bodyWeight,
					nextLevel: {
						level: StrengthLevel.BEGINNER,
						targetWeight: beginnerStandard.weightKg,
						progressPercentage: (oneRepMax / beginnerStandard.weightKg) * 100,
					},
				};
			}
			return {
				level: null,
				currentWeight: oneRepMax,
				bodyWeight,
			};
		}

		// 다음 레벨 정보 계산
		const nextLevelInfo = this.calculateNextLevel(
			matchingStandards,
			matchedLevel,
			oneRepMax,
		);

		return {
			level: matchedLevel,
			currentWeight: oneRepMax,
			bodyWeight,
			nextLevel: nextLevelInfo,
		};
	}

	/**
	 * 가장 가까운 체중 범위의 기준 찾기
	 */
	private findClosestStandard(
		standards: StrengthStandard[],
		bodyWeight: number,
	): StrengthStandard | null {
		if (standards.length === 0) return null;

		// BEGINNER 레벨의 기준 중에서 가장 가까운 것 찾기
		const beginnerStandards = standards.filter(
			(s) => s.level === StrengthLevel.BEGINNER,
		);

		if (beginnerStandards.length === 0) {
			return standards[0];
		}

		// 체중별 데이터인 경우에만 체중 중심 계산
		const bodyweightStandards = beginnerStandards.filter(
			(s) => s.standardType === 'BODYWEIGHT' && s.bodyweightMin !== null && s.bodyweightMax !== null,
		);

		if (bodyweightStandards.length > 0) {
			let closest = bodyweightStandards[0];
			let minDistance = Math.abs(
				bodyWeight - ((closest.bodyweightMin || 0) + (closest.bodyweightMax || 0)) / 2,
			);

			for (const standard of bodyweightStandards) {
				const center = ((standard.bodyweightMin || 0) + (standard.bodyweightMax || 0)) / 2;
				const distance = Math.abs(bodyWeight - center);
				if (distance < minDistance) {
					minDistance = distance;
					closest = standard;
				}
			}

			return closest;
		}

		// 체중별 데이터가 없으면 첫 번째 BEGINNER 기준 반환
		return beginnerStandards[0];
	}

	/**
	 * 기준을 사용하여 레벨 평가
	 */
	private evaluateWithStandard(
		standard: StrengthStandard,
		oneRepMax: number,
		bodyWeight: number,
	): StrengthLevelEvaluationResult {
		if (oneRepMax >= standard.weightKg) {
			return {
				level: standard.level,
				currentWeight: oneRepMax,
				bodyWeight,
			};
		} else {
			return {
				level: null,
				currentWeight: oneRepMax,
				bodyWeight,
				nextLevel: {
					level: standard.level,
					targetWeight: standard.weightKg,
					progressPercentage: (oneRepMax / standard.weightKg) * 100,
				},
			};
		}
	}

	/**
	 * 다음 레벨 정보 계산
	 */
	private calculateNextLevel(
		standards: StrengthStandard[],
		currentLevel: StrengthLevel,
		currentOneRepMax: number,
	): { level: StrengthLevel; targetWeight: number; progressPercentage: number } | undefined {
		const currentIndex = StrengthLevelOrder.indexOf(currentLevel);

		// 이미 최고 레벨이면 다음 레벨 없음
		if (currentIndex >= StrengthLevelOrder.length - 1) {
			return undefined;
		}

		const nextLevel = StrengthLevelOrder[currentIndex + 1];
		const nextLevelStandard = standards.find((s) => s.level === nextLevel);

		if (!nextLevelStandard) {
			return undefined;
		}

		const currentLevelStandard = standards.find((s) => s.level === currentLevel);
		if (!currentLevelStandard) {
			return undefined;
		}

		const currentRange = nextLevelStandard.weightKg - currentLevelStandard.weightKg;
		const currentProgress = currentOneRepMax - currentLevelStandard.weightKg;
		const progressPercentage =
			currentRange > 0 ? (currentProgress / currentRange) * 100 : 0;

		return {
			level: nextLevel,
			targetWeight: nextLevelStandard.weightKg,
			progressPercentage: Math.min(100, Math.max(0, progressPercentage)),
		};
	}
}
