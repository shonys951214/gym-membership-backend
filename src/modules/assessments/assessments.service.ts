import {
	Injectable,
	Logger,
} from "@nestjs/common";
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, IsNull } from 'typeorm';
import { Assessment } from '../../entities/assessment.entity';
import { AssessmentItem } from '../../entities/assessment-item.entity';
import { AssessmentType, Condition, Category, EvaluationType } from '../../common/enums';
import { AbilitySnapshot } from '../../entities/ability-snapshot.entity';
import { ScoreCalculator } from '../../common/utils/score-calculator';
import { CreateAssessmentDto } from './dto/create-assessment.dto';
import { UpdateAssessmentDto } from './dto/update-assessment.dto';
import { CreateAssessmentItemDto } from './dto/create-assessment-item.dto';
import { ApiExceptions } from '../../common/exceptions';
import { DateHelper } from '../../common/utils/date-helper';
import { SnapshotNormalizer } from '../../common/utils/snapshot-normalizer';
import { EntityUpdateHelper } from '../../common/utils/entity-update-helper';
import { RepositoryHelper } from '../../common/utils/repository-helper';
import { GradeScoreConverter } from '../../common/utils/grade-score-converter';
import { Member } from '../../entities/member.entity';
import { Exercise } from '../../entities/exercise.entity';
import { StrengthStandard } from '../../entities/strength-standard.entity';
import { OneRepMaxCalculator, OneRepMaxFormula } from '../../common/utils/one-rep-max-calculator';
import { RelativeStrengthCalculator } from '../../common/utils/relative-strength-calculator';
// TODO: 추후 구현 예정 - Strength Level 판정 기능
// import { StrengthLevelEvaluator } from '../../common/utils/strength-level-evaluator';

@Injectable()
export class AssessmentsService {
	private readonly logger = new Logger(AssessmentsService.name);

	constructor(
		@InjectRepository(Assessment)
		private assessmentRepository: Repository<Assessment>,
		@InjectRepository(AssessmentItem)
		private assessmentItemRepository: Repository<AssessmentItem>,
		@InjectRepository(AbilitySnapshot)
		private abilitySnapshotRepository: Repository<AbilitySnapshot>,
		@InjectRepository(Member)
		private memberRepository: Repository<Member>,
		@InjectRepository(Exercise)
		private exerciseRepository: Repository<Exercise>,
		@InjectRepository(StrengthStandard)
		private strengthStandardRepository: Repository<StrengthStandard>,
		private scoreCalculator: ScoreCalculator,
		private gradeScoreConverter: GradeScoreConverter,
	) {}

  async findAll(memberId: string): Promise<Assessment[]> {
    const assessments = await this.assessmentRepository.find({
      where: { memberId },
      relations: ['items', 'snapshot'],
      order: { assessedAt: 'DESC' },
    });
    
    // null 값 정규화 (프론트엔드 toFixed 오류 방지)
    return assessments.map(assessment => this.normalizeAssessment(assessment));
  }

  /**
   * 초기 평가 존재 여부 확인
   */
  async hasInitialAssessment(memberId: string): Promise<boolean> {
    const initialAssessment = await this.assessmentRepository.findOne({
      where: { 
        memberId, 
        isInitial: true,
        deletedAt: IsNull(),
      },
    });
    return !!initialAssessment;
  }

  /**
   * 초기 평가 조회
   */
  async getInitialAssessment(memberId: string): Promise<Assessment | null> {
    return await this.assessmentRepository.findOne({
      where: { 
        memberId, 
        isInitial: true,
        deletedAt: IsNull(),
      },
      relations: ['items', 'snapshot'],
      order: { assessedAt: 'ASC' }, // 가장 오래된 초기 평가
    });
  }

  async findOne(id: string, memberId: string): Promise<Assessment> {
    const assessment = await RepositoryHelper.findOneOrFailByMemberId(
      this.assessmentRepository,
      id,
      memberId,
      this.logger,
      '평가',
    );

    // relations 로드
    const assessmentWithRelations = await this.assessmentRepository.findOne({
      where: { id, memberId },
      relations: ['items', 'snapshot'],
    });

    if (!assessmentWithRelations) {
      // 이미 findOneOrFailByMemberId에서 에러를 던졌지만, relations가 필요한 경우를 대비
      return assessment as Assessment;
    }

    // null 값 정규화 (프론트엔드 toFixed 오류 방지)
    return this.normalizeAssessment(assessmentWithRelations);
  }

  /**
   * 평가 데이터 정규화 (null 값 처리)
   * 프론트엔드에서 toFixed() 오류 방지를 위해 모든 점수 필드를 0으로 변환
   */
  private normalizeAssessment(assessment: Assessment): Assessment {
    // AssessmentItem의 score 정규화
    if (assessment.items) {
      assessment.items = assessment.items.map(item => ({
        ...item,
        score: item.score ?? 0,
        value: item.value ?? 0,
      }));
    }

    // AbilitySnapshot 정규화 (유틸리티 사용)
    assessment.snapshot = SnapshotNormalizer.normalize(assessment.snapshot, assessment.memberId);

    return assessment;
  }

  async create(
    memberId: string,
    createAssessmentDto: CreateAssessmentDto,
  ): Promise<Assessment> {
    // 초기 평가 중복 체크 (soft delete된 평가는 제외)
    if (createAssessmentDto.assessmentType === AssessmentType.INITIAL) {
      const existingInitial = await this.assessmentRepository.findOne({
        where: { 
          memberId, 
          isInitial: true,
          deletedAt: IsNull(), // soft delete된 평가는 제외
        },
      });

			if (existingInitial) {
				this.logger.warn(
					`초기 평가가 이미 존재합니다. MemberId: ${memberId}, ExistingAssessmentId: ${existingInitial.id}`,
				);
				// 기존 초기 평가 정보를 에러 응답에 포함
				throw ApiExceptions.initialAssessmentAlreadyExists(
					"초기 평가는 이미 존재합니다. 정기 평가를 생성해주세요.",
					{
						id: existingInitial.id,
						assessedAt: existingInitial.assessedAt,
						assessmentType: existingInitial.assessmentType,
					},
				);
			}
    }

    // 날짜 필드 변환
    const assessmentData = EntityUpdateHelper.convertDateFields(
      {
        memberId,
        assessmentType: createAssessmentDto.assessmentType,
        evaluationType: createAssessmentDto.evaluationType,
        staticEvaluation: createAssessmentDto.staticEvaluation,
        dynamicEvaluation: createAssessmentDto.dynamicEvaluation,
        isInitial: createAssessmentDto.assessmentType === AssessmentType.INITIAL,
        assessedAt: createAssessmentDto.assessedAt,
        trainerComment: createAssessmentDto.trainerComment,
        bodyWeight: createAssessmentDto.bodyWeight,
        condition: createAssessmentDto.condition,
      },
      ['assessedAt'],
    );

    // 날짜 필드 변환 (DTO의 string을 Entity의 Date로)
    const convertedAssessmentData = EntityUpdateHelper.convertDateFields(assessmentData, ['assessedAt']);

    // 평가 생성
    const assessment = this.assessmentRepository.create(assessmentData);

    const savedAssessment = await this.assessmentRepository.save(assessment);

    // 회원 정보 조회 (체성분 평가를 위해 age, gender 필요)
    const member = await this.memberRepository.findOne({
      where: { id: memberId },
    });

    if (!member) {
      this.logger.warn(`회원을 찾을 수 없습니다. MemberId: ${memberId}`);
      throw ApiExceptions.memberNotFound('회원을 찾을 수 없습니다.');
    }

    // 평가 항목 생성 및 점수 계산
    const items = await Promise.all(
      createAssessmentDto.items.map(async (itemDto) => {
        let score: number | null = null;

        // 등급 기반 평가인 경우 (details에 등급 정보 존재)
        // 유연성: flexibilityItems, 안정성: ohsa + pain, 체성분: muscleMass 등
        // 기타: grade 필드 존재
        const hasGradeInfo =
          itemDto.details?.grade ||
          itemDto.details?.flexibilityItems ||
          (itemDto.details?.ohsa && itemDto.details?.pain) ||
          (itemDto.details?.muscleMass && itemDto.details?.bodyFatPercentage);

        if (hasGradeInfo) {
          // 체성분 평가의 경우 회원 정보 및 체중 추가
          const detailsForCalculation = itemDto.category === Category.BODY && member
            ? {
                ...itemDto.details,
                age: member.age,
                gender: member.gender,
                bodyWeight: createAssessmentDto.bodyWeight || member.weight || null,
              }
            : itemDto.details;

          score = await this.gradeScoreConverter.convertGradeToScore(
            itemDto.category,
            detailsForCalculation,
          );

          // 점수 계산 실패 시 로깅
          if (score === null) {
            if (itemDto.category === Category.FLEXIBILITY) {
              this.logger.warn(
                `유연성 점수 계산 실패. MemberId: ${memberId}, Details: ${JSON.stringify(detailsForCalculation)}`,
              );
            } else if (itemDto.category === Category.BODY) {
              this.logger.warn(
                `체성분 점수 계산 실패. MemberId: ${memberId}, Details: ${JSON.stringify(detailsForCalculation)}`,
              );
            }
          }

          // 내부 점수를 details에 저장
          if (score !== null && itemDto.details) {
            itemDto.details.internalScore = score;
          }
        } else if (itemDto.value !== undefined && itemDto.value !== null) {
          // 수치 기반 평가인 경우 (기존 로직)
          score = itemDto.value;
        }

        // TODO: 추후 구현 예정 - Strength Level 계산
        // STRENGTH 카테고리이고 무게와 횟수가 있으면 Strength Level 계산
        let detailsWithStrength = itemDto.details || {};
        /*
        if (
          itemDto.category === Category.STRENGTH &&
          itemDto.value !== undefined &&
          itemDto.value !== null &&
          itemDto.unit &&
          member
        ) {
          try {
            const strengthInfo = await this.calculateStrengthLevelForAssessment(
              itemDto.name,
              itemDto.value,
              itemDto.unit,
              member,
            );
            if (strengthInfo) {
              detailsWithStrength = {
                ...detailsWithStrength,
                strengthLevel: strengthInfo.level,
                oneRepMax: strengthInfo.oneRepMax,
                relativeStrength: strengthInfo.relativeStrength,
              };
            }
          } catch (error) {
            this.logger.warn(
              `Strength Level 계산 실패: ${error.message} (ExerciseName: ${itemDto.name})`,
            );
          }
        }
        */

        const assessmentItem = this.assessmentItemRepository.create({
          assessmentId: savedAssessment.id,
          category: itemDto.category,
          name: itemDto.name,
          value: itemDto.value,
          unit: itemDto.unit,
          score,
          details: detailsWithStrength, // 등급, 내부 점수, 관찰 포인트, Strength Level 등 상세 정보
        });

        return this.assessmentItemRepository.save(assessmentItem);
      }),
    );

    // 능력치 스냅샷 생성
    await this.scoreCalculator.calculateAssessmentScore(
      savedAssessment.id,
      memberId,
    );

    // 스냅샷 포함하여 반환
    return this.findOne(savedAssessment.id, memberId);
  }

  async update(
    id: string,
    memberId: string,
    updateAssessmentDto: UpdateAssessmentDto,
  ): Promise<Assessment> {
    const assessment = await this.findOne(id, memberId);

    // 평가 삭제는 금지 (데이터 무결성)
    // 수정만 가능
    EntityUpdateHelper.updateFieldsWithDateConversion(
      assessment,
      updateAssessmentDto,
      ['assessedAt'],
    );

    const savedAssessment = await this.assessmentRepository.save(assessment);

    // 항목 업데이트
    if (updateAssessmentDto.items) {
      // 기존 항목 삭제
      await this.assessmentItemRepository.delete({
        assessmentId: id,
      });

      // 회원 정보 조회 (체성분 평가를 위해 age, gender 필요)
      const member = await this.memberRepository.findOne({
        where: { id: memberId },
      });

      if (!member) {
        this.logger.warn(`회원을 찾을 수 없습니다. MemberId: ${memberId}`);
        throw ApiExceptions.memberNotFound('회원을 찾을 수 없습니다.');
      }

      // 새 항목 생성 및 점수 계산
      await Promise.all(
        updateAssessmentDto.items.map(async (itemDto) => {
          let score: number | null = null;

          // 등급 기반 평가인 경우 (details에 등급 정보 존재)
          // 유연성: flexibilityItems, 안정성: ohsa + pain, 체성분: muscleMass 등
          // 기타: grade 필드 존재
          const hasGradeInfo =
            itemDto.details?.grade ||
            itemDto.details?.flexibilityItems ||
            (itemDto.details?.ohsa && itemDto.details?.pain) ||
            (itemDto.details?.muscleMass && itemDto.details?.bodyFatPercentage);

          if (hasGradeInfo) {
            // 체성분 평가의 경우 회원 정보 및 체중 추가
            const assessment = await this.assessmentRepository.findOne({
              where: { id },
            });
            const detailsForCalculation = itemDto.category === Category.BODY && member
              ? {
                  ...itemDto.details,
                  age: member.age,
                  gender: member.gender,
                  bodyWeight: updateAssessmentDto.bodyWeight || assessment?.bodyWeight || member.weight || null,
                }
              : itemDto.details;

            score = await this.gradeScoreConverter.convertGradeToScore(
              itemDto.category,
              detailsForCalculation,
            );

            // 내부 점수를 details에 저장
            if (score !== null && itemDto.details) {
              itemDto.details.internalScore = score;
            }
          } else if (itemDto.value !== undefined && itemDto.value !== null) {
            // 수치 기반 평가인 경우 (기존 로직)
            score = itemDto.value;
          }

          // TODO: 추후 구현 예정 - Strength Level 계산
          // STRENGTH 카테고리이고 무게와 횟수가 있으면 Strength Level 계산
          let detailsWithStrength = itemDto.details || {};
          /*
          if (
            itemDto.category === Category.STRENGTH &&
            itemDto.value !== undefined &&
            itemDto.value !== null &&
            itemDto.unit &&
            member
          ) {
            try {
              const strengthInfo = await this.calculateStrengthLevelForAssessment(
                itemDto.name,
                itemDto.value,
                itemDto.unit,
                member,
              );
              if (strengthInfo) {
                detailsWithStrength = {
                  ...detailsWithStrength,
                  strengthLevel: strengthInfo.level,
                  oneRepMax: strengthInfo.oneRepMax,
                  relativeStrength: strengthInfo.relativeStrength,
                };
              }
            } catch (error) {
              this.logger.warn(
                `Strength Level 계산 실패: ${error.message} (ExerciseName: ${itemDto.name})`,
              );
            }
          }
          */

          const assessmentItem = this.assessmentItemRepository.create({
            assessmentId: id,
            category: itemDto.category,
            name: itemDto.name,
            value: itemDto.value,
            unit: itemDto.unit,
            score,
            details: detailsWithStrength, // 등급, 내부 점수, 관찰 포인트, Strength Level 등 상세 정보
          });

          return this.assessmentItemRepository.save(assessmentItem);
        }),
      );

      // 스냅샷 재계산
      await this.scoreCalculator.calculateAssessmentScore(id, memberId);
    }

    return this.findOne(id, memberId);
  }

  // 평가 삭제는 금지
  // async remove(id: string, memberId: string): Promise<void> {
  //   throw new BadRequestException('평가 삭제는 불가능합니다.');
  // }

  // 능력치 관련 메서드
  async getLatestSnapshot(memberId: string): Promise<AbilitySnapshot | null> {
    const snapshot = await this.abilitySnapshotRepository.findOne({
      where: { memberId },
      order: { assessedAt: 'DESC' },
      relations: ['assessment'],
    });
    
    if (!snapshot) {
      return null;
    }
    
    // null 값 정규화
    return this.normalizeSnapshot(snapshot);
  }

  /**
   * 스냅샷 데이터 정규화 (null 값 처리)
   */
  private normalizeSnapshot(snapshot: AbilitySnapshot): AbilitySnapshot {
    return {
      ...snapshot,
      strengthScore: snapshot.strengthScore ?? 0,
      cardioScore: snapshot.cardioScore ?? 0,
      enduranceScore: snapshot.enduranceScore ?? 0,
      flexibilityScore: snapshot.flexibilityScore ?? 0,
      bodyScore: snapshot.bodyScore ?? 0,
      stabilityScore: snapshot.stabilityScore ?? 0,
      totalScore: snapshot.totalScore ?? 0,
    };
  }

  async getSnapshots(memberId: string): Promise<AbilitySnapshot[]> {
    const snapshots = await this.abilitySnapshotRepository.find({
      where: { memberId },
      order: { assessedAt: 'DESC' },
      relations: ['assessment'],
    });
    
    // null 값 정규화
    return snapshots.map(snapshot => this.normalizeSnapshot(snapshot));
  }

	async compareSnapshots(
		memberId: string,
		prevCount: number = 1,
	): Promise<{
		current: AbilitySnapshot;
		previous: AbilitySnapshot | null;
		delta: Record<string, number>;
		percentageChange: Record<string, number>;
	}> {
		const snapshots = await this.abilitySnapshotRepository.find({
			where: { memberId },
			order: { assessedAt: "DESC" },
			take: prevCount + 1,
		});

		if (snapshots.length === 0) {
			this.logger.warn(`능력치 스냅샷이 없습니다. MemberId: ${memberId}`);
			throw ApiExceptions.abilitySnapshotNotFound();
		}

		// null 값 정규화
		const current = this.normalizeSnapshot(snapshots[0]);
		const previous = snapshots.length > 1 ? this.normalizeSnapshot(snapshots[prevCount]) : null;

		const delta: Record<string, number> = {};
		const percentageChange: Record<string, number> = {};

		if (previous) {
			const fields = [
				"strengthScore",
				"cardioScore",
				"enduranceScore",
				"flexibilityScore", // 1차피드백: 유연성 추가
				"bodyScore",
				"stabilityScore",
				"totalScore",
			];

			fields.forEach((field) => {
				const currentValue = current[field] ?? 0;
				const previousValue = previous[field] ?? 0;
				delta[field] = currentValue - previousValue;
				percentageChange[field] =
					previousValue !== 0
						? ((currentValue - previousValue) / previousValue) * 100
						: 0;
			});
		}

		return {
			current,
			previous,
			delta,
			percentageChange,
		};
	}

	/**
	 * 능력치 헥사곤 데이터 (6개 지표)
	 */
	/**
	 * 레이더 차트용 헥사곤 데이터 조회
	 * @param memberId 회원 ID
	 * @param includeInitial 초기 평가 포함 여부 (기본값: false)
	 */
	async getHexagonData(
		memberId: string,
		includeInitial: boolean = false,
	): Promise<{
		indicators: Array<{ name: string; score: number }>;
		assessedAt: string;
		version: string;
		initial?: {
			indicators: Array<{ name: string; score: number }>;
			assessedAt: string;
			version: string;
		} | null;
	}> {
		const snapshot = await this.getLatestSnapshot(memberId);

		if (!snapshot) {
			this.logger.warn(`능력치 스냅샷이 없습니다. MemberId: ${memberId}`);
			throw ApiExceptions.abilitySnapshotNotFound();
		}

		const current = {
			indicators: [
				{ name: "하체 근력", score: snapshot.strengthScore ?? 0 },
				{ name: "심폐 지구력", score: snapshot.cardioScore ?? 0 },
				{ name: "근지구력", score: snapshot.enduranceScore ?? 0 },
				{ name: "유연성", score: snapshot.flexibilityScore ?? 0 },
				{ name: "체성분 밸런스", score: snapshot.bodyScore ?? 0 },
				{ name: "부상 안정성", score: snapshot.stabilityScore ?? 0 },
			],
			assessedAt: DateHelper.toKoreaTimeISOString(snapshot.assessedAt),
			version: snapshot.version || "v1",
		};

		// 초기 평가 포함 요청 시
		if (includeInitial) {
			const initialSnapshot = await this.getInitialSnapshot(memberId);
			const initial = initialSnapshot
				? {
						indicators: [
							{ name: "하체 근력", score: initialSnapshot.strengthScore ?? 0 },
							{ name: "심폐 지구력", score: initialSnapshot.cardioScore ?? 0 },
							{ name: "근지구력", score: initialSnapshot.enduranceScore ?? 0 },
							{ name: "유연성", score: initialSnapshot.flexibilityScore ?? 0 },
							{ name: "체성분 밸런스", score: initialSnapshot.bodyScore ?? 0 },
							{ name: "부상 안정성", score: initialSnapshot.stabilityScore ?? 0 },
						],
						assessedAt: DateHelper.toKoreaTimeISOString(initialSnapshot.assessedAt),
						version: initialSnapshot.version || "v1",
					}
				: null;

			return {
				...current,
				initial,
			};
		}

		return current;
	}

	/**
	 * 초기 평가 스냅샷 조회
	 */
	async getInitialSnapshot(memberId: string): Promise<AbilitySnapshot | null> {
		const initialAssessment = await this.assessmentRepository.findOne({
			where: {
				memberId,
				isInitial: true,
				deletedAt: IsNull(),
			},
			relations: ['snapshot'],
		});

		if (!initialAssessment || !initialAssessment.snapshot) {
			return null;
		}

		// null 값 정규화
		return this.normalizeSnapshot(initialAssessment.snapshot);
	}

	/**
	 * 체력 테스트 히스토리
	 */
	async getHistory(memberId: string): Promise<{
		history: Array<{
			assessedAt: string;
			indicators: Array<{ name: string; score: number }>;
			version: string;
		}>;
	}> {
		const snapshots = await this.getSnapshots(memberId);

		return {
			history: snapshots.map((snapshot) => ({
				assessedAt: DateHelper.toKoreaTimeISOString(snapshot.assessedAt),
				indicators: [
					{ name: "하체 근력", score: snapshot.strengthScore ?? 0 },
					{ name: "심폐 지구력", score: snapshot.cardioScore ?? 0 },
					{ name: "근지구력", score: snapshot.enduranceScore ?? 0 },
					{ name: "유연성", score: snapshot.flexibilityScore ?? 0 }, // 1차피드백: 유연성 추가
					{ name: "체성분 밸런스", score: snapshot.bodyScore ?? 0 },
					{ name: "부상 안정성", score: snapshot.stabilityScore ?? 0 },
				],
				version: snapshot.version || "v1",
			})),
		};
	}

	/**
	 * AssessmentItem의 Strength Level 계산
	 * TODO: 추후 구현 예정 - Strength Level 판정 기능
	 * @param exerciseName 운동명
	 * @param value 측정값 (무게)
	 * @param unit 단위 (kg, lb 등)
	 * @param member 회원 정보
	 * @returns Strength Level 정보
	 */
	/*
	private async calculateStrengthLevelForAssessment(
		exerciseName: string,
		value: number,
		unit: string,
		member: Member,
	): Promise<{
		level: string | null;
		oneRepMax: number;
		relativeStrength: number;
	} | null> {
		// 체중이나 성별이 없으면 계산 불가
		if (!member.weight || !member.gender) {
			return null;
		}

			// 단위 변환 (lb → kg)
			const { UnitConverter } = await import('../../common/utils/unit-converter');
			let weightKg = value;
			if (unit.toLowerCase() === 'lb' || unit.toLowerCase() === 'lbs') {
				weightKg = UnitConverter.lbToKg(value);
			}

		// 운동명으로 Exercise 찾기
		const exercise = await this.exerciseRepository.findOne({
			where: [
				{ name: exerciseName },
				{ nameEn: exerciseName },
			],
		});

		if (!exercise) {
			return null;
		}

		// 횟수는 기본값으로 1회 (1RM 계산을 위해)
		// 실제로는 평가 항목에 횟수 정보가 있어야 하지만, 여기서는 1RM으로 가정
		const reps = 1; // 1RM이므로 1회

		// 1RM 계산 (이미 1RM이면 그대로 사용)
		const oneRepMaxResult = OneRepMaxCalculator.calculate(
			weightKg,
			reps,
			OneRepMaxFormula.EPLEY,
		);

		// 상대적 강도 계산
		const relativeStrengthResult = RelativeStrengthCalculator.calculate(
			oneRepMaxResult.oneRepMax,
			member.weight,
		);

		// Strength Level 판정
		const evaluator = new StrengthLevelEvaluator(this.strengthStandardRepository);
		const evaluationResult = await evaluator.evaluate(
			exercise.id,
			oneRepMaxResult.oneRepMax,
			member.weight,
			member.gender,
			member.age, // 나이 파라미터 추가
		);

		return {
			level: evaluationResult.level || null,
			oneRepMax: oneRepMaxResult.oneRepMax,
			relativeStrength: relativeStrengthResult.relativeStrength,
		};
	}
	*/
}

