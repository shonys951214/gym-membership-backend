import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { WorkoutRecord, WorkoutType } from '../../entities/workout-record.entity';
import { Member } from '../../entities/member.entity';
import { CreateWorkoutRecordDto } from './dto/create-workout-record.dto';
import { UpdateWorkoutRecordDto } from './dto/update-workout-record.dto';
import { WorkoutVolumeQueryDto, VolumePeriod } from './dto/workout-volume-query.dto';
import { ApiExceptions } from '../../common/exceptions';

@Injectable()
export class WorkoutRecordsService {
	private readonly logger = new Logger(WorkoutRecordsService.name);

	constructor(
		@InjectRepository(WorkoutRecord)
		private workoutRecordRepository: Repository<WorkoutRecord>,
		@InjectRepository(Member)
		private memberRepository: Repository<Member>,
	) {}

	async findAll(
		memberId: string,
		page: number = 1,
		pageSize: number = 10,
		startDate?: string,
		endDate?: string,
	): Promise<{ records: WorkoutRecord[]; total: number }> {
		await this.memberRepository.findOneOrFail({ where: { id: memberId } });

		const queryBuilder = this.workoutRecordRepository
			.createQueryBuilder('record')
			.where('record.memberId = :memberId', { memberId })
			.orderBy('record.workoutDate', 'DESC')
			.addOrderBy('record.createdAt', 'DESC');

		if (startDate) {
			queryBuilder.andWhere('record.workoutDate >= :startDate', {
				startDate,
			});
		}

		if (endDate) {
			queryBuilder.andWhere('record.workoutDate <= :endDate', {
				endDate,
			});
		}

		const total = await queryBuilder.getCount();

		const records = await queryBuilder
			.skip((page - 1) * pageSize)
			.take(pageSize)
			.getMany();

		return { records, total };
	}

	async findOne(id: string, memberId: string): Promise<WorkoutRecord> {
		const record = await this.workoutRecordRepository.findOne({
			where: { id, memberId },
		});

		if (!record) {
			this.logger.warn(
				`운동 기록을 찾을 수 없습니다. ID: ${id}, MemberId: ${memberId}`,
			);
			throw ApiExceptions.memberNotFound('운동 기록을 찾을 수 없습니다.');
		}

		return record;
	}

	async create(
		memberId: string,
		createDto: CreateWorkoutRecordDto,
	): Promise<WorkoutRecord> {
		await this.memberRepository.findOneOrFail({ where: { id: memberId } });

		// workoutType 기본값 처리
		const workoutType = createDto.workoutType ?? WorkoutType.PERSONAL;

		// weight, reps, sets 기본값 처리 (선택적 필드)
		const weight = createDto.weight ?? 0;
		const reps = createDto.reps ?? 1;
		const sets = createDto.sets ?? 1;

		// 볼륨 자동 계산
		const volume = weight * reps * sets;

		const record = this.workoutRecordRepository.create({
			memberId,
			workoutDate: new Date(createDto.workoutDate),
			bodyPart: createDto.bodyPart,
			exerciseName: createDto.exerciseName,
			weight,
			reps,
			sets,
			volume,
			duration: createDto.duration,
			workoutType,
			ptSessionId: createDto.ptSessionId,
			trainerComment: createDto.trainerComment,
		});

		return this.workoutRecordRepository.save(record);
	}

	async update(
		id: string,
		memberId: string,
		updateDto: UpdateWorkoutRecordDto,
	): Promise<WorkoutRecord> {
		const record = await this.findOne(id, memberId);

		// 업데이트할 필드가 있으면 적용
		if (updateDto.workoutType) {
			record.workoutType = updateDto.workoutType;
		}
		if (updateDto.workoutDate) {
			record.workoutDate = new Date(updateDto.workoutDate);
		}
		if (updateDto.bodyPart) {
			record.bodyPart = updateDto.bodyPart;
		}
		if (updateDto.exerciseName) {
			record.exerciseName = updateDto.exerciseName;
		}
		if (updateDto.weight !== undefined) {
			record.weight = updateDto.weight;
		}
		if (updateDto.reps !== undefined) {
			record.reps = updateDto.reps;
		}
		if (updateDto.sets !== undefined) {
			record.sets = updateDto.sets;
		}
		if (updateDto.duration !== undefined) {
			record.duration = updateDto.duration;
		}
		if (updateDto.ptSessionId !== undefined) {
			record.ptSessionId = updateDto.ptSessionId;
		}
		if (updateDto.trainerComment !== undefined) {
			record.trainerComment = updateDto.trainerComment;
		}

		// 볼륨 재계산
		record.volume = record.weight * record.reps * record.sets;

		return this.workoutRecordRepository.save(record);
	}

	async remove(id: string, memberId: string): Promise<void> {
		const record = await this.findOne(id, memberId);
		await this.workoutRecordRepository.remove(record);
	}

	/**
	 * 부위별 볼륨 조회 (주간/월간)
	 */
	async getVolumeByBodyPart(
		memberId: string,
		query: WorkoutVolumeQueryDto,
	): Promise<{
		period: VolumePeriod;
		bodyPartVolumes: Array<{ bodyPart: string; volume: number }>;
		totalVolume: number;
	}> {
		await this.memberRepository.findOneOrFail({ where: { id: memberId } });

		const period = query.period || VolumePeriod.WEEK;
		const now = new Date();
		let startDate: Date;

		if (period === VolumePeriod.WEEK) {
			// 이번 주 시작 (월요일)
			const dayOfWeek = now.getDay();
			const diff = dayOfWeek === 0 ? 6 : dayOfWeek - 1; // 일요일이면 6일 전, 아니면 dayOfWeek - 1
			startDate = new Date(now);
			startDate.setDate(now.getDate() - diff);
			startDate.setHours(0, 0, 0, 0);
		} else {
			// 이번 달 시작
			startDate = new Date(now.getFullYear(), now.getMonth(), 1);
		}

		const endDate = new Date(now);
		endDate.setHours(23, 59, 59, 999);

		const records = await this.workoutRecordRepository.find({
			where: {
				memberId,
				workoutDate: Between(startDate, endDate),
			},
		});

		// 부위별 볼륨 집계
		const volumeMap = new Map<string, number>();

		records.forEach((record) => {
			const currentVolume = volumeMap.get(record.bodyPart) || 0;
			volumeMap.set(record.bodyPart, currentVolume + record.volume);
		});

		const bodyPartVolumes = Array.from(volumeMap.entries())
			.map(([bodyPart, volume]) => ({
				bodyPart,
				volume: Math.round(volume * 100) / 100, // 소수점 2자리
			}))
			.sort((a, b) => b.volume - a.volume); // 볼륨 내림차순 정렬

		const totalVolume = bodyPartVolumes.reduce((sum, item) => sum + item.volume, 0);

		return {
			period,
			bodyPartVolumes,
			totalVolume: Math.round(totalVolume * 100) / 100,
		};
	}

	/**
	 * 부위별 볼륨 분석 (주간/월간) - 프론트엔드 요청사항 반영
	 */
	async getVolumeAnalysis(
		memberId: string,
		period?: 'WEEKLY' | 'MONTHLY',
		startDate?: string,
		endDate?: string,
	): Promise<{
		weekly?: {
			period: 'WEEKLY';
			startDate: string;
			endDate: string;
			bodyPartVolumes: Array<{
				bodyPart: string;
				totalVolume: number;
				totalSets: number;
				totalReps: number;
				recordCount: number;
			}>;
		};
		monthly?: {
			period: 'MONTHLY';
			startDate: string;
			endDate: string;
			bodyPartVolumes: Array<{
				bodyPart: string;
				totalVolume: number;
				totalSets: number;
				totalReps: number;
				recordCount: number;
			}>;
		};
	}> {
		await this.memberRepository.findOneOrFail({ where: { id: memberId } });

		const result: any = {};

		// 주간 분석
		if (!period || period === 'WEEKLY') {
			const now = new Date();
			const dayOfWeek = now.getDay();
			const diff = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
			const weekStart = new Date(now);
			weekStart.setDate(now.getDate() - diff);
			weekStart.setHours(0, 0, 0, 0);
			const weekEnd = new Date(now);
			weekEnd.setHours(23, 59, 59, 999);

			const weeklyRecords = await this.workoutRecordRepository.find({
				where: {
					memberId,
					workoutDate: Between(weekStart, weekEnd),
				},
			});

			const weeklyMap = new Map<
				string,
				{ volume: number; sets: number; reps: number; count: number }
			>();

			weeklyRecords.forEach((record) => {
				const existing = weeklyMap.get(record.bodyPart) || {
					volume: 0,
					sets: 0,
					reps: 0,
					count: 0,
				};
				weeklyMap.set(record.bodyPart, {
					volume: existing.volume + record.volume,
					sets: existing.sets + record.sets,
					reps: existing.reps + record.reps,
					count: existing.count + 1,
				});
			});

			result.weekly = {
				period: 'WEEKLY',
				startDate: weekStart.toISOString().split('T')[0],
				endDate: weekEnd.toISOString().split('T')[0],
				bodyPartVolumes: Array.from(weeklyMap.entries()).map(
					([bodyPart, data]) => ({
						bodyPart,
						totalVolume: Math.round(data.volume * 100) / 100,
						totalSets: data.sets,
						totalReps: data.reps,
						recordCount: data.count,
					}),
				),
			};
		}

		// 월간 분석
		if (!period || period === 'MONTHLY') {
			const now = new Date();
			const monthStart = new Date(now.getFullYear(), now.getMonth(), 1);
			monthStart.setHours(0, 0, 0, 0);
			const monthEnd = new Date(now.getFullYear(), now.getMonth() + 1, 0);
			monthEnd.setHours(23, 59, 59, 999);

			const monthlyRecords = await this.workoutRecordRepository.find({
				where: {
					memberId,
					workoutDate: Between(monthStart, monthEnd),
				},
			});

			const monthlyMap = new Map<
				string,
				{ volume: number; sets: number; reps: number; count: number }
			>();

			monthlyRecords.forEach((record) => {
				const existing = monthlyMap.get(record.bodyPart) || {
					volume: 0,
					sets: 0,
					reps: 0,
					count: 0,
				};
				monthlyMap.set(record.bodyPart, {
					volume: existing.volume + record.volume,
					sets: existing.sets + record.sets,
					reps: existing.reps + record.reps,
					count: existing.count + 1,
				});
			});

			result.monthly = {
				period: 'MONTHLY',
				startDate: monthStart.toISOString().split('T')[0],
				endDate: monthEnd.toISOString().split('T')[0],
				bodyPartVolumes: Array.from(monthlyMap.entries()).map(
					([bodyPart, data]) => ({
						bodyPart,
						totalVolume: Math.round(data.volume * 100) / 100,
						totalSets: data.sets,
						totalReps: data.reps,
						recordCount: data.count,
					}),
				),
			};
		}

		return result;
	}

	/**
	 * 운동 캘린더 조회 - 프론트엔드 요청사항 반영
	 */
	async getCalendar(
		memberId: string,
		startDate: string,
		endDate: string,
	): Promise<{
		events: Array<{
			date: string;
			ptSessions: number;
			selfWorkouts: number;
		}>;
		startDate: string;
		endDate: string;
	}> {
		await this.memberRepository.findOneOrFail({ where: { id: memberId } });

		// PT 세션 조회
		const ptSessions = await this.memberRepository.manager.query(
			`
			SELECT 
				session_date as "sessionDate",
				COUNT(*) as count
			FROM pt_sessions
			WHERE member_id = $1
				AND session_date >= $2
				AND session_date <= $3
			GROUP BY session_date
		`,
			[memberId, startDate, endDate],
		);

		// 개인 운동 조회
		const selfWorkouts = await this.memberRepository.manager.query(
			`
			SELECT 
				workout_date as "workoutDate",
				COUNT(*) as count
			FROM workout_records
			WHERE member_id = $1
				AND workout_type = 'PERSONAL'
				AND workout_date >= $2
				AND workout_date <= $3
			GROUP BY workout_date
		`,
			[memberId, startDate, endDate],
		);

		// 날짜별로 그룹화
		const dateMap = new Map<string, { ptSessions: number; selfWorkouts: number }>();

		ptSessions.forEach((item: any) => {
			const date = item.sessionDate;
			if (!dateMap.has(date)) {
				dateMap.set(date, { ptSessions: 0, selfWorkouts: 0 });
			}
			dateMap.get(date)!.ptSessions = parseInt(item.count);
		});

		selfWorkouts.forEach((item: any) => {
			const date = item.workoutDate;
			if (!dateMap.has(date)) {
				dateMap.set(date, { ptSessions: 0, selfWorkouts: 0 });
			}
			dateMap.get(date)!.selfWorkouts = parseInt(item.count);
		});

		const events = Array.from(dateMap.entries()).map(([date, data]) => ({
			date,
			ptSessions: data.ptSessions,
			selfWorkouts: data.selfWorkouts,
		}));

		return {
			events,
			startDate,
			endDate,
		};
	}
}

