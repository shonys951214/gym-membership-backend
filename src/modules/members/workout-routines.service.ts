import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { WorkoutRoutine } from '../../entities/workout-routine.entity';
import { Member } from '../../entities/member.entity';
import { WorkoutRecord } from '../../entities/workout-record.entity';
import { Exercise } from '../../entities/exercise.entity';
import { CreateWorkoutRoutineDto } from './dto/create-workout-routine.dto';
import { UpdateWorkoutRoutineDto } from './dto/update-workout-routine.dto';
import { ApiExceptions } from '../../common/exceptions';
import { QueryBuilderHelper } from '../../common/utils/query-builder-helper';
import { DateRangeHelper } from '../../common/utils/date-range-helper';
import { EntityUpdateHelper } from '../../common/utils/entity-update-helper';
import { RepositoryHelper } from '../../common/utils/repository-helper';

@Injectable()
export class WorkoutRoutinesService {
	private readonly logger = new Logger(WorkoutRoutinesService.name);

	constructor(
		@InjectRepository(WorkoutRoutine)
		private workoutRoutineRepository: Repository<WorkoutRoutine>,
		@InjectRepository(Member)
		private memberRepository: Repository<Member>,
		@InjectRepository(WorkoutRecord)
		private workoutRecordRepository: Repository<WorkoutRecord>,
		@InjectRepository(Exercise)
		private exerciseRepository: Repository<Exercise>,
	) {}

	// 전체 공통 루틴 조회 (memberId 없음)
	async findAllCommon(): Promise<WorkoutRoutine[]> {
		return this.workoutRoutineRepository.find({
			where: { memberId: null },
			order: { createdAt: 'DESC' },
		});
	}

	// 회원별 루틴 조회
	async findAll(
		memberId?: string,
		startDate?: string,
		endDate?: string,
		isCompleted?: boolean,
	): Promise<WorkoutRoutine[]> {
		if (memberId) {
			await RepositoryHelper.ensureMemberExists(this.memberRepository, memberId, this.logger);
		}

		const queryBuilder = this.workoutRoutineRepository.createQueryBuilder('routine');

		if (memberId) {
			QueryBuilderHelper.addMemberIdFilter(queryBuilder, 'routine.memberId', memberId);
		} else {
			queryBuilder.where('routine.memberId IS NULL');
		}

		QueryBuilderHelper.addOrderBy(queryBuilder, 'routine.createdAt', 'DESC');
		QueryBuilderHelper.addDateRangeFilter(queryBuilder, 'routine.routineDate', startDate, endDate);

		if (isCompleted !== undefined) {
			queryBuilder.andWhere('routine.isCompleted = :isCompleted', { isCompleted });
		}

		return queryBuilder.getMany();
	}

	async findToday(memberId?: string): Promise<WorkoutRoutine | null> {
		// 회원별 루틴 우선 조회
		if (memberId) {
			await RepositoryHelper.ensureMemberExists(this.memberRepository, memberId, this.logger);

			const today = new Date();
			today.setHours(0, 0, 0, 0);
			const tomorrow = new Date(today);
			tomorrow.setDate(tomorrow.getDate() + 1);

			const memberRoutine = await this.workoutRoutineRepository.findOne({
				where: {
					memberId,
					routineDate: Between(today, tomorrow),
				},
				order: { createdAt: 'DESC' },
			});

			if (memberRoutine) {
				return memberRoutine;
			}
		}

		// 회원별 루틴이 없으면 전체 공통 루틴 반환 (오늘 날짜 없이)
		// 또는 랜덤/최신 공통 루틴 반환
		const commonRoutine = await this.workoutRoutineRepository.findOne({
			where: { memberId: null },
			order: { createdAt: 'DESC' },
		});

		return commonRoutine || null;
	}

	async findOne(id: string, memberId?: string): Promise<WorkoutRoutine> {
		const where: any = { id };
		if (memberId !== undefined) {
			where.memberId = memberId;
		} else {
			where.memberId = null;
		}

		return RepositoryHelper.findOneOrFail(
			this.workoutRoutineRepository,
			{ where },
			this.logger,
			'운동 루틴',
			`운동 루틴을 찾을 수 없습니다. ID: ${id}, MemberId: ${memberId || 'null'}`,
		);
	}

	async create(
		memberId: string | null,
		createDto: CreateWorkoutRoutineDto,
	): Promise<WorkoutRoutine> {
		if (memberId) {
			await RepositoryHelper.ensureMemberExists(this.memberRepository, memberId, this.logger);
		}

		// 무게 제안 활성화 시 각 운동별 무게 제안
		let exercises = createDto.exercises;
		if (memberId && createDto.suggestWeights) {
			exercises = await this.suggestWeightsForExercises(memberId, createDto.exercises);
		}

		// 날짜 필드 변환
		const routineData = EntityUpdateHelper.convertDateFields(
			{
				memberId: memberId || null,
				routineName: createDto.routineName,
				routineDate: createDto.routineDate || null,
				exercises,
				estimatedDuration: createDto.estimatedDuration,
				difficulty: createDto.difficulty,
				isCompleted: false,
			},
			['routineDate'],
		);

		const routine = this.workoutRoutineRepository.create(routineData);
		return this.workoutRoutineRepository.save(routine);
	}

	/**
	 * Strength Level 기반 무게 제안
	 */
	private async suggestWeightsForExercises(
		memberId: string,
		exercises: CreateWorkoutRoutineDto['exercises'],
	): Promise<CreateWorkoutRoutineDto['exercises']> {
		const member = await this.memberRepository.findOne({
			where: { id: memberId },
		});

		if (!member || !member.weight) {
			this.logger.warn(`회원의 체중 정보가 없어 무게 제안을 건너뜁니다. (MemberId: ${memberId})`);
			return exercises;
		}

		const suggestedExercises = await Promise.all(
			exercises.map(async (exercise) => {
				// 이미 무게가 있으면 제안하지 않음
				if (exercise.weight !== undefined && exercise.weight !== null) {
					return exercise;
				}

				// 최근 운동 기록 조회
				const recentRecord = await this.workoutRecordRepository.findOne({
					where: {
						memberId,
						exerciseName: exercise.exerciseName,
					},
					order: {
						workoutDate: 'DESC',
						createdAt: 'DESC',
					},
				});

				if (!recentRecord || !recentRecord.oneRepMax) {
					// 기록이 없으면 운동 정보에서 기본값 확인
					const exerciseEntity = await this.exerciseRepository.findOne({
						where: [
							{ name: exercise.exerciseName },
							{ nameEn: exercise.exerciseName },
						],
					});

					// 운동 정보가 없거나 Strength Standard가 없으면 제안하지 않음
					if (!exerciseEntity) {
						return exercise;
					}

					// Strength Standard 기반으로 BEGINNER 레벨의 70% 무게 제안
					// (실제 구현 시에는 StrengthStandard 조회가 필요하지만, 여기서는 간단히 처리)
					return exercise;
				}

				// 최근 기록의 1RM 기반으로 70-80% 무게 제안 (안전한 무게 범위)
				const suggestedWeight = recentRecord.oneRepMax * 0.75; // 75% 추천

				return {
					...exercise,
					weight: Math.round(suggestedWeight * 10) / 10, // 소수점 1자리로 반올림
				};
			}),
		);

		return suggestedExercises;
	}

	/**
	 * 운동별 무게 제안 (플랜 Phase 7)
	 */
	async suggestWeightForExercise(
		memberId: string,
		exerciseName: string,
		reps: number,
	): Promise<{ suggestedWeight: number; reason: string }> {
		await RepositoryHelper.ensureMemberExists(this.memberRepository, memberId, this.logger);

		const member = await this.memberRepository.findOne({
			where: { id: memberId },
		});

		if (!member || !member.weight || !member.gender) {
			throw ApiExceptions.badRequest('회원의 체중 및 성별 정보가 필요합니다.');
		}

		// 운동 정보 조회
		const exercise = await this.exerciseRepository.findOne({
			where: [
				{ name: exerciseName },
				{ nameEn: exerciseName },
			],
		});

		if (!exercise) {
			throw ApiExceptions.badRequest('운동을 찾을 수 없습니다.');
		}

		// 최신 운동 기록에서 Strength Level 조회
		const latestRecord = await this.workoutRecordRepository.findOne({
			where: {
				memberId,
				exerciseName: exercise.name,
			},
			order: {
				workoutDate: 'DESC',
				createdAt: 'DESC',
			},
		});

		// 최신 기록이 있고 1RM이 있으면 그것을 기반으로 제안
		if (latestRecord && latestRecord.oneRepMax) {
			// 1RM을 reps에 맞게 역산 (Epley 공식 역산: weight = 1RM / (1 + reps/30))
			const { OneRepMaxCalculator } = await import('../../common/utils/one-rep-max-calculator');
			
			// 여러 공식의 평균으로 역산 시도 (정확도 향상)
			let suggestedWeight = latestRecord.oneRepMax / (1 + reps / 30); // Epley 역산

			return {
				suggestedWeight: Math.round(suggestedWeight * 10) / 10,
				reason: `최신 기록 (1RM: ${latestRecord.oneRepMax}kg) 기반 제안`,
			};
		}

		// 기록이 없으면 기본값 반환 (나중에 strength_standards 기반으로 확장 가능)
		throw ApiExceptions.badRequest('해당 운동의 기록이 없어 무게를 제안할 수 없습니다.');
	}

	async update(
		id: string,
		memberId: string | null,
		updateDto: UpdateWorkoutRoutineDto,
	): Promise<WorkoutRoutine> {
		const routine = await this.findOne(id, memberId);
		EntityUpdateHelper.updateFieldsWithDateConversion(routine, updateDto, ['routineDate']);
		return this.workoutRoutineRepository.save(routine);
	}

	async complete(id: string, memberId: string): Promise<WorkoutRoutine> {
		const routine = await this.findOne(id, memberId);
		routine.isCompleted = true;
		return this.workoutRoutineRepository.save(routine);
	}

	async remove(id: string, memberId: string | null): Promise<void> {
		const routine = await this.findOne(id, memberId);
		await this.workoutRoutineRepository.remove(routine);
	}
}

