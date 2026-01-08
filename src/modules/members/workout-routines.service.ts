import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { WorkoutRoutine } from '../../entities/workout-routine.entity';
import { Member } from '../../entities/member.entity';
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

		// 날짜 필드 변환
		const routineData = EntityUpdateHelper.convertDateFields(
			{
				memberId: memberId || null,
				routineName: createDto.routineName,
				routineDate: createDto.routineDate || null,
				exercises: createDto.exercises,
				estimatedDuration: createDto.estimatedDuration,
				difficulty: createDto.difficulty,
				isCompleted: false,
			},
			['routineDate'],
		);

		const routine = this.workoutRoutineRepository.create(routineData);
		return this.workoutRoutineRepository.save(routine);
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

