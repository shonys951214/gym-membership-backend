import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { StrengthStandard } from '../../entities/strength-standard.entity';
import { Gender, StrengthLevel, StrengthLevelOrder } from '../common/enums';

/**
 * Strength Level 판정 결과
 */
export interface StrengthLevelEvaluationResult {
	level: StrengthLevel | null; // 판정된 레벨 (기준 데이터가 없으면 null)
	oneRepMax: number; // 1RM (kg)
	relativeStrength: number; // 상대적 강도 (%)
	bodyWeight: number; // 체중 (kg)
	standardWeight?: number; // 기준 무게 (kg)
	matchedStandard?: StrengthStandard; // 매칭된 기준 데이터
}

/**
 * Strength Level 판정기 클래스
 */
@Injectable()
export class StrengthLevelEvaluator {
	constructor(
		@InjectRepository(StrengthStandard)
		private strengthStandardRepository: Repository<StrengthStandard>,
	) {}

	/**
	 * Strength Level 판정
	 * @param exerciseId 운동 ID
	 * @param oneRepMax 1RM (kg)
	 * @param bodyWeight 체중 (kg)
	 * @param gender 성별
	 * @returns Strength Level 판정 결과
	 */
	async evaluate(
		exerciseId: string,
		oneRepMax: number,
		bodyWeight: number,
		gender: Gender,
	): Promise<StrengthLevelEvaluationResult> {
		// 체중에 해당하는 기준 데이터 조회
		const standards = await this.strengthStandardRepository.find({
			where: {
				exerciseId,
				gender,
				bodyweightMin: Between(0, bodyWeight),
				bodyweightMax: Between(bodyWeight, 9999),
			},
			order: {
				bodyweightMin: 'ASC',
			},
		});

		// 체중 구간에 맞는 기준 찾기
		const matchedStandard = standards.find(
			(standard) => bodyWeight >= standard.bodyweightMin && bodyWeight <= standard.bodyweightMax,
		);

		if (!matchedStandard) {
			// 기준 데이터가 없으면 레벨 판정 불가
			const relativeStrength = (oneRepMax / bodyWeight) * 100;
			return {
				level: null,
				oneRepMax,
				relativeStrength: Math.round(relativeStrength * 100) / 100,
				bodyWeight,
			};
		}

		// 해당 체중 구간의 모든 레벨 기준 조회
		const allLevelStandards = await this.strengthStandardRepository.find({
			where: {
				exerciseId,
				gender,
				bodyweightMin: matchedStandard.bodyweightMin,
				bodyweightMax: matchedStandard.bodyweightMax,
			},
			order: {
				// 레벨 순서대로 정렬
			},
		});

		// 레벨 순서대로 정렬
		const sortedStandards = allLevelStandards.sort((a, b) => {
			const aIndex = StrengthLevelOrder.indexOf(a.level);
			const bIndex = StrengthLevelOrder.indexOf(b.level);
			return aIndex - bIndex;
		});

		// 1RM이 기준 무게를 초과하는 가장 높은 레벨 찾기
		let evaluatedLevel: StrengthLevel | null = null;

		for (const standard of sortedStandards) {
			if (oneRepMax >= standard.weightKg) {
				evaluatedLevel = standard.level;
			} else {
				break;
			}
		}

		// 1RM이 가장 낮은 레벨(BEGINNER) 기준보다 낮으면 BEGINNER
		if (evaluatedLevel === null && sortedStandards.length > 0) {
			const beginnerStandard = sortedStandards.find((s) => s.level === StrengthLevel.BEGINNER);
			if (beginnerStandard && oneRepMax < beginnerStandard.weightKg) {
				evaluatedLevel = StrengthLevel.BEGINNER;
			}
		}

		const relativeStrength = (oneRepMax / bodyWeight) * 100;
		const matchedStandardForLevel = sortedStandards.find((s) => s.level === evaluatedLevel);

		return {
			level: evaluatedLevel,
			oneRepMax,
			relativeStrength: Math.round(relativeStrength * 100) / 100,
			bodyWeight,
			standardWeight: matchedStandardForLevel?.weightKg,
			matchedStandard: matchedStandardForLevel,
		};
	}

	/**
	 * 운동명으로 Strength Level 판정 (운동명으로 exercise 찾기)
	 * @param exerciseName 운동명 (한글 또는 영문)
	 * @param oneRepMax 1RM (kg)
	 * @param bodyWeight 체중 (kg)
	 * @param gender 성별
	 * @returns Strength Level 판정 결과
	 */
	async evaluateByExerciseName(
		exerciseName: string,
		oneRepMax: number,
		bodyWeight: number,
		gender: Gender,
	): Promise<StrengthLevelEvaluationResult | null> {
		// Exercise 엔티티를 동적으로 import
		const { Exercise } = await import('../../entities/exercise.entity');

		// 운동명으로 Exercise 찾기 (한글명 또는 영문명)
		const exercise = await this.strengthStandardRepository.manager
			.getRepository(Exercise)
			.findOne({
				where: [
					{ name: exerciseName },
					{ nameEn: exerciseName },
				],
			});

		if (!exercise) {
			return null;
		}

		return this.evaluate(exercise.id, oneRepMax, bodyWeight, gender);
	}
}
