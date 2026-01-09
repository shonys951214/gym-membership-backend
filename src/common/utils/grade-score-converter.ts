import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { AssessmentCategoryScore } from '../../entities/assessment-category-score.entity';
import { FlexibilityItemWeight } from '../../entities/flexibility-item-weight.entity';
import { FlexibilityGradeThreshold } from '../../entities/flexibility-grade-threshold.entity';
import { BodyCompositionStandard } from '../../entities/body-composition-standard.entity';
import { Category } from '../enums';

interface FlexibilityItems {
	sitAndReach?: 'A' | 'B' | 'C';
	shoulder?: 'A' | 'B' | 'C';
	hip?: 'A' | 'B' | 'C';
	hamstring?: 'A' | 'B' | 'C';
}

interface AssessmentItemDetails {
	grade?: string;
	internalScore?: number;
	recoverySpeed?: string[];
	flexibilityItems?: FlexibilityItems;
	ohsa?: 'A' | 'B' | 'C';
	pain?: 'none' | 'present';
	muscleMass?: number; // 골격근량 (kg 또는 %)
	fatMass?: number; // 체지방량 (kg)
	bodyFatPercentage?: number; // 체지방률 (%)
	bodyWeight?: number; // 체중 (kg) - 골격근량 퍼센트 계산용
	age?: number; // 나이 - 체성분 평가용
	gender?: 'MALE' | 'FEMALE'; // 성별 - 체성분 평가용
	[key: string]: any;
}

@Injectable()
export class GradeScoreConverter {
	private readonly logger = new Logger(GradeScoreConverter.name);

	constructor(
		@InjectRepository(AssessmentCategoryScore)
		private categoryScoreRepository: Repository<AssessmentCategoryScore>,
		@InjectRepository(FlexibilityItemWeight)
		private flexibilityWeightRepository: Repository<FlexibilityItemWeight>,
		@InjectRepository(FlexibilityGradeThreshold)
		private flexibilityThresholdRepository: Repository<FlexibilityGradeThreshold>,
		@InjectRepository(BodyCompositionStandard)
		private bodyCompositionStandardRepository: Repository<BodyCompositionStandard>,
	) {}

	/**
	 * 등급을 내부 점수로 변환
	 * @param category 평가 카테고리
	 * @param details 평가 항목 상세 정보
	 * @returns 내부 점수 (0-100)
	 */
	async convertGradeToScore(
		category: Category,
		details: AssessmentItemDetails,
	): Promise<number | null> {
		switch (category) {
			case Category.STRENGTH:
				if (!details.grade) return null;
				return this.convertStrengthScore(details);
			case Category.CARDIO:
				if (!details.grade) return null;
				return this.convertCardioScore(details);
			case Category.ENDURANCE:
				if (!details.grade) return null;
				return this.convertEnduranceScore(details);
			case Category.FLEXIBILITY:
				if (!details.flexibilityItems) return null;
				return await this.convertFlexibilityScore(details);
			case Category.BODY:
				// 체성분은 grade가 없어도 muscleMass, bodyFatPercentage 등으로 계산
				return await this.convertBodyCompositionScore(details);
			case Category.STABILITY:
				// 안정성은 grade가 없어도 ohsa와 pain으로 계산
				return this.convertStabilityScore(details);
			default:
				return null;
		}
	}

	/**
	 * 하체 근력 점수 변환
	 * 등급: A, B, C, D-1, D-2
	 */
	private convertStrengthScore(details: AssessmentItemDetails): number | null {
		const grade = details.grade;
		if (!grade) {
			this.logger.warn('하체 근력 점수 계산 실패: grade가 없습니다.');
			return null;
		}

		const scoreMap: Record<string, number> = {
			A: 80,
			B: 60,
			C: 45,
			'D-1': 30,
			'D-2': 20,
		};

		const score = scoreMap[grade];
		if (score === undefined) {
			this.logger.warn(`하체 근력 점수 계산 실패: 알 수 없는 등급 '${grade}'. 허용된 등급: A, B, C, D-1, D-2`);
			return null;
		}

		return score;
	}

	/**
	 * 심폐 지구력 점수 변환
	 * 등급: A, B (회복 속도 조건), C, IMPOSSIBLE
	 */
	private convertCardioScore(details: AssessmentItemDetails): number | null {
		const grade = details.grade;
		if (!grade) {
			this.logger.warn('심폐 지구력 점수 계산 실패: grade가 없습니다.');
			return null;
		}

		// B 등급인 경우 회복 속도 조건 확인
		if (grade === 'B') {
			const recoverySpeed = details.recoverySpeed || [];
			if (recoverySpeed.includes('fast')) {
				return 65; // B + 회복 빠름
			} else if (recoverySpeed.includes('slow')) {
				return 55; // B + 회복 느림
			}
			// recoverySpeed가 없으면 기본값 (평균)
			return 60;
		}

		const scoreMap: Record<string, number> = {
			A: 80,
			C: 40,
			IMPOSSIBLE: 20,
		};

		const score = scoreMap[grade];
		if (score === undefined) {
			this.logger.warn(`심폐 지구력 점수 계산 실패: 알 수 없는 등급 '${grade}'. 허용된 등급: A, B, C, IMPOSSIBLE`);
			return null;
		}

		return score;
	}

	/**
	 * 근지구력 점수 변환
	 * 등급: A, B, C, IMPOSSIBLE
	 */
	private convertEnduranceScore(details: AssessmentItemDetails): number | null {
		const grade = details.grade;
		if (!grade) {
			this.logger.warn('근지구력 점수 계산 실패: grade가 없습니다.');
			return null;
		}

		const scoreMap: Record<string, number> = {
			A: 80,
			B: 60,
			C: 40,
			IMPOSSIBLE: 20,
		};

		const score = scoreMap[grade];
		if (score === undefined) {
			this.logger.warn(`근지구력 점수 계산 실패: 알 수 없는 등급 '${grade}'. 허용된 등급: A, B, C, IMPOSSIBLE`);
			return null;
		}

		return score;
	}

	/**
	 * 유연성 점수 변환
	 * flexibilityItems의 각 항목별 등급(C만)을 가중치로 변환하여 합산
	 */
	private async convertFlexibilityScore(
		details: AssessmentItemDetails,
	): Promise<number | null> {
		const flexibilityItems = details.flexibilityItems;
		if (!flexibilityItems) {
			this.logger.warn('유연성 점수 계산 실패: flexibilityItems가 없습니다.');
			return null;
		}

		try {
			// 가중치 조회
			const weights = await this.flexibilityWeightRepository.find({
				where: { isActive: true },
			});

			if (weights.length === 0) {
				this.logger.warn('유연성 점수 계산 실패: 가중치 데이터가 없습니다. (flexibility_item_weights 테이블 확인 필요)');
				return null;
			}

			// 가중치 맵 생성
			const weightMap = new Map<string, number>();
			weights.forEach((w) => {
				weightMap.set(w.itemName, Number(w.weight));
			});

			// 가중치 합 계산 (C 등급만 가중치 합산)
			let weightSum = 0;
			Object.entries(flexibilityItems).forEach(([itemName, grade]) => {
				if (grade === 'C') {
					const weight = weightMap.get(itemName);
					if (weight === undefined) {
						this.logger.warn(`유연성 항목 가중치 없음: ${itemName}. flexibility_item_weights 테이블 확인 필요.`);
					}
					weightSum += weight || 0;
				}
			});

			// 등급 판정 기준 조회 (범위 매칭)
			const thresholds = await this.flexibilityThresholdRepository.find({
				where: { isActive: true },
				order: { weightSumMin: 'ASC' },
			});

			if (thresholds.length === 0) {
				this.logger.warn('유연성 점수 계산 실패: 등급 판정 기준 데이터가 없습니다. (flexibility_grade_thresholds 테이블 확인 필요)');
				// 매칭되지 않으면 기본값 (가중치 합 0 = C 없음 = 안정적)
				return weightSum === 0 ? 80 : null;
			}

			// 가중치 합에 해당하는 등급 판정 기준 찾기
			for (const threshold of thresholds) {
				const min = Number(threshold.weightSumMin);
				const max = Number(threshold.weightSumMax);
				if (weightSum >= min && weightSum <= max) {
					return threshold.internalScore;
				}
			}

			// 매칭되지 않으면 기본값 (가중치 합 0 = C 없음 = 안정적)
			if (weightSum === 0) {
				return 80;
			}

			this.logger.warn(`유연성 점수 계산 실패: 가중치 합 ${weightSum}에 해당하는 등급 판정 기준을 찾을 수 없습니다.`);
			return null;
		} catch (error) {
			this.logger.error(`유연성 점수 계산 중 오류 발생: ${error.message}`, error.stack);
			return null;
		}
	}

	/**
	 * 체성분 점수 변환
	 * 회원의 age, gender로 연령대별 기준 조회 후 판정
	 * 
	 * @param details 평가 항목 상세 정보
	 *   - bodyFatPercentage: 체지방률 (%)
	 *   - muscleMass: 골격근량 (kg) - 필요시 퍼센트로 변환
	 *   - fatMass: 체지방량 (kg)
	 *   - bodyWeight: 체중 (kg) - 골격근량 퍼센트 계산용
	 *   - age: 나이
	 *   - gender: 성별
	 */
	private async convertBodyCompositionScore(
		details: AssessmentItemDetails,
	): Promise<number | null> {
		const { bodyFatPercentage, muscleMass, fatMass, bodyWeight, age, gender } = details;
		
		// 필수 필드 검증
		if (bodyFatPercentage === undefined || bodyFatPercentage === null) {
			this.logger.warn('체성분 점수 계산 실패: bodyFatPercentage가 없습니다.');
			return null;
		}
		if (muscleMass === undefined || muscleMass === null) {
			this.logger.warn('체성분 점수 계산 실패: muscleMass가 없습니다.');
			return null;
		}
		if (age === undefined || age === null) {
			this.logger.warn('체성분 점수 계산 실패: age가 없습니다.');
			return null;
		}
		if (!gender) {
			this.logger.warn('체성분 점수 계산 실패: gender가 없습니다.');
			return null;
		}

		try {
			// 연령대별 기준 조회
			const standards = await this.bodyCompositionStandardRepository.find({
				where: {
					gender: gender as 'MALE' | 'FEMALE',
					isActive: true,
				},
				order: { ageMin: 'ASC' },
			});

			if (standards.length === 0) {
				this.logger.warn(`체성분 점수 계산 실패: ${gender}의 연령대별 기준 데이터가 없습니다. (body_composition_standards 테이블 확인 필요)`);
				return null;
			}

			// 회원의 나이에 해당하는 기준 찾기
			let standard: BodyCompositionStandard | null = null;
			for (const s of standards) {
				if (age >= Number(s.ageMin) && age <= Number(s.ageMax)) {
					standard = s;
					break;
				}
			}

			if (!standard) {
				this.logger.warn(`체성분 점수 계산 실패: ${age}세 ${gender}에 해당하는 연령대별 기준을 찾을 수 없습니다.`);
				return null;
			}

		const bodyFatMin = Number(standard.bodyFatPercentageMin);
		const bodyFatMax = Number(standard.bodyFatPercentageMax);
		const muscleMassPercentageMin = Number(standard.muscleMassPercentageMin);

		// 골격근량 퍼센트 계산 (kg → %)
		// muscleMass가 이미 퍼센트인 경우도 있으므로, bodyWeight가 있으면 계산, 없으면 그대로 사용
		let muscleMassPercentage: number;
		if (bodyWeight && bodyWeight > 0) {
			muscleMassPercentage = (muscleMass / bodyWeight) * 100;
		} else {
			// bodyWeight가 없으면 muscleMass를 퍼센트로 가정
			muscleMassPercentage = muscleMass;
		}

		// 체성분 판정 로직 (문서 기준)
		// 근육 충분 + 지방 적정: 80점
		const isBodyFatNormal =
			bodyFatPercentage >= bodyFatMin && bodyFatPercentage <= bodyFatMax;
		const isMuscleMassSufficient = muscleMassPercentage >= muscleMassPercentageMin;

		if (isBodyFatNormal && isMuscleMassSufficient) {
			return 80; // 근육 충분 + 지방 적정
		}
		// 한 요소 관리 필요: 60점
		else if (isBodyFatNormal || isMuscleMassSufficient) {
			return 60; // 한 요소 관리 필요
		}
		// 지방 과다 또는 근육 부족: 40점
		else if (bodyFatPercentage > bodyFatMax || muscleMassPercentage < muscleMassPercentageMin) {
			return 40; // 지방 과다 또는 근육 부족
		}
		// 둘 다 불리: 20점
		else {
			return 20; // 둘 다 불리
		}
		} catch (error) {
			this.logger.error(`체성분 점수 계산 중 오류 발생: ${error.message}`, error.stack);
			return null;
		}
	}

	/**
	 * 안정성 점수 변환
	 * OHSA 등급 + 통증 여부 조합
	 */
	private convertStabilityScore(details: AssessmentItemDetails): number | null {
		const { ohsa, pain } = details;
		
		if (!ohsa) {
			this.logger.warn('안정성 점수 계산 실패: ohsa가 없습니다.');
			return null;
		}
		if (!pain) {
			this.logger.warn('안정성 점수 계산 실패: pain이 없습니다.');
			return null;
		}

		// OHSA A + 통증 없음: 80
		if (ohsa === 'A' && pain === 'none') return 80;
		// OHSA B + 통증 없음: 60
		if (ohsa === 'B' && pain === 'none') return 60;
		// OHSA C + 통증 없음: 40
		if (ohsa === 'C' && pain === 'none') return 40;
		// OHSA A + 통증 있음: 50
		if (ohsa === 'A' && pain === 'present') return 50;
		// OHSA B + 통증 있음: 45
		if (ohsa === 'B' && pain === 'present') return 45;
		// OHSA C + 통증 있음: 20
		if (ohsa === 'C' && pain === 'present') return 20;

		this.logger.warn(`안정성 점수 계산 실패: 알 수 없는 조합. OHSA: '${ohsa}', Pain: '${pain}'. 허용된 값: OHSA(A, B, C), Pain(none, present)`);
		return null;
	}
}
