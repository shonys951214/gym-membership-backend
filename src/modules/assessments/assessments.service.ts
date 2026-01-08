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
		private scoreCalculator: ScoreCalculator,
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

  async findOne(id: string, memberId: string): Promise<Assessment> {
    const assessment = await this.assessmentRepository.findOne({
      where: { id, memberId },
      relations: ['items', 'snapshot'],
    });

		if (!assessment) {
			this.logger.warn(
				`평가를 찾을 수 없습니다. AssessmentId: ${id}, MemberId: ${memberId}`,
			);
			throw ApiExceptions.assessmentNotFound();
		}

    // null 값 정규화 (프론트엔드 toFixed 오류 방지)
    return this.normalizeAssessment(assessment);
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
				throw ApiExceptions.initialAssessmentAlreadyExists(
					"초기 평가는 이미 존재합니다. 정기 평가를 생성해주세요.",
				);
			}
    }

    // 평가 생성
    const assessment = this.assessmentRepository.create({
      memberId,
      assessmentType: createAssessmentDto.assessmentType,
      evaluationType: createAssessmentDto.evaluationType,
      staticEvaluation: createAssessmentDto.staticEvaluation,
      dynamicEvaluation: createAssessmentDto.dynamicEvaluation,
      isInitial: createAssessmentDto.assessmentType === AssessmentType.INITIAL,
      assessedAt: new Date(createAssessmentDto.assessedAt),
      trainerComment: createAssessmentDto.trainerComment,
      bodyWeight: createAssessmentDto.bodyWeight,
      condition: createAssessmentDto.condition,
    });

    const savedAssessment = await this.assessmentRepository.save(assessment);

    // 평가 항목 생성 및 점수 계산
    const items = await Promise.all(
      createAssessmentDto.items.map(async (itemDto) => {
        // TODO: 실제 점수 계산 로직 (표준화 함수 필요)
        // 현재는 임시로 value를 그대로 사용
        const score = itemDto.value; // 실제로는 표준화 함수를 통해 계산

        const assessmentItem = this.assessmentItemRepository.create({
          assessmentId: savedAssessment.id,
          category: itemDto.category,
          name: itemDto.name,
          value: itemDto.value,
          unit: itemDto.unit,
          score,
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

      // 새 항목 생성
      await Promise.all(
        updateAssessmentDto.items.map(async (itemDto) => {
          const score = itemDto.value; // 실제로는 표준화 함수를 통해 계산

          const assessmentItem = this.assessmentItemRepository.create({
            assessmentId: id,
            category: itemDto.category,
            name: itemDto.name,
            value: itemDto.value,
            unit: itemDto.unit,
            score,
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
	async getHexagonData(memberId: string): Promise<{
		indicators: Array<{ name: string; score: number }>;
		assessedAt: string;
		version: string;
	}> {
		const snapshot = await this.getLatestSnapshot(memberId);

		if (!snapshot) {
			this.logger.warn(`능력치 스냅샷이 없습니다. MemberId: ${memberId}`);
			throw ApiExceptions.abilitySnapshotNotFound();
		}

		return {
			indicators: [
				{ name: "하체 근력", score: snapshot.strengthScore ?? 0 },
				{ name: "심폐 지구력", score: snapshot.cardioScore ?? 0 },
				{ name: "근지구력", score: snapshot.enduranceScore ?? 0 },
				{ name: "유연성", score: snapshot.flexibilityScore ?? 0 }, // 1차피드백: 유연성 추가
				{ name: "체성분 밸런스", score: snapshot.bodyScore ?? 0 },
				{ name: "부상 안정성", score: snapshot.stabilityScore ?? 0 },
			],
			assessedAt: DateHelper.toKoreaTimeISOString(snapshot.assessedAt),
			version: snapshot.version || "v1",
		};
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
}

