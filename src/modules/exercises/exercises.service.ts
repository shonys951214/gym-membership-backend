import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, ILike, LessThanOrEqual } from 'typeorm';
import { Exercise } from '../../entities/exercise.entity';
import { WorkoutRecord } from '../../entities/workout-record.entity';
import { GetExercisesDto } from './dto/get-exercises.dto';
import { ExerciseCategory } from '../../entities/exercise.entity';

@Injectable()
export class ExercisesService {
	private readonly logger = new Logger(ExercisesService.name);

	constructor(
		@InjectRepository(Exercise)
		private exerciseRepository: Repository<Exercise>,
		@InjectRepository(WorkoutRecord)
		private workoutRecordRepository: Repository<WorkoutRecord>,
	) {}

	/**
	 * 운동 목록 조회 (플랜 Phase 6 - 응답 구조 개선)
	 * 필요한 필드만 선택적으로 조회 가능
	 */
	async findAll(query: GetExercisesDto): Promise<{
		data: Array<{
			id: string;
			name: string;
			nameEn: string;
			category: ExerciseCategory;
			bodyPart?: string;
			recentCount?: number;
		}>;
		total: number;
		page: number;
		limit: number;
	}> {
		const queryBuilder = this.exerciseRepository.createQueryBuilder('exercise');

		// 필터 적용
		if (query.category) {
			queryBuilder.andWhere('exercise.category = :category', { category: query.category });
		}

		if (query.bodyPart) {
			queryBuilder.andWhere('exercise.bodyPart = :bodyPart', { bodyPart: query.bodyPart });
		}

		if (query.search) {
			queryBuilder.andWhere(
				'(exercise.name ILIKE :search OR exercise.nameEn ILIKE :search)',
				{ search: `%${query.search}%` },
			);
		}

		// 활성화 필터 (기본: true)
		const isActive = query.isActive !== undefined ? query.isActive : true;
		queryBuilder.andWhere('exercise.isActive = :isActive', { isActive });

		// 전체 개수 조회 (페이징용)
		const total = await queryBuilder.getCount();

		// 페이징 적용
		const page = query.page || 1;
		const limit = query.limit || 50;
		const skip = (page - 1) * limit;

		queryBuilder.skip(skip).take(limit);

		// 정렬
		queryBuilder.orderBy('exercise.name', 'ASC');

		const exercises = await queryBuilder.getMany();

		// 각 운동별로 bodyPart 집계 및 recentCount 계산
		const result = await Promise.all(
			exercises.map(async (exercise) => {
				// 운동 기록에서 가장 많이 사용된 bodyPart 집계
				const bodyPartCounts = await this.workoutRecordRepository
					.createQueryBuilder('wr')
					.select('wr.bodyPart', 'bodyPart')
					.addSelect('COUNT(*)', 'count')
					.where(
						'(wr.exerciseName = :name OR wr.exerciseName = :nameEn)',
						{ name: exercise.name, nameEn: exercise.nameEn },
					)
					.groupBy('wr.bodyPart')
					.orderBy('count', 'DESC')
					.limit(1)
					.getRawOne();

				const bodyPart = bodyPartCounts?.bodyPart || exercise.bodyPart || undefined;

				// 최근 기록 횟수 계산 (최근 30일)
				let recentCount: number | undefined = undefined;
				if (query.memberId) {
					const thirtyDaysAgo = new Date();
					thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

					const count = await this.workoutRecordRepository.count({
						where: {
							memberId: query.memberId,
							exerciseName: exercise.name,
							workoutDate: LessThanOrEqual(new Date()),
						},
					});

					// 최근 30일 이내 기록만 카운트
					const recentRecords = await this.workoutRecordRepository.find({
						where: {
							memberId: query.memberId,
							exerciseName: exercise.name,
						},
						order: {
							workoutDate: 'DESC',
						},
					});

					recentCount = recentRecords.filter(
						(r) => r.workoutDate >= thirtyDaysAgo,
					).length;
				}

				return {
					id: exercise.id,
					name: exercise.name,
					nameEn: exercise.nameEn,
					category: exercise.category,
					bodyPart,
					recentCount,
				};
			}),
		);

		// 최근 운동 우선 정렬 (recentCount가 있는 경우)
		if (query.memberId) {
			result.sort((a, b) => {
				if (a.recentCount && b.recentCount) {
					return b.recentCount - a.recentCount;
				}
				if (a.recentCount) return -1;
				if (b.recentCount) return 1;
				return a.name.localeCompare(b.name);
			});
		}

		return {
			data: result,
			total,
			page,
			limit,
		};
	}

	/**
	 * 운동 상세 조회
	 */
	async findOne(id: string): Promise<Exercise> {
		return this.exerciseRepository.findOneOrFail({
			where: { id },
		});
	}
}
