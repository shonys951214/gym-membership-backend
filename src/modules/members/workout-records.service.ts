import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { WorkoutRecord } from '../../entities/workout-record.entity';
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

	async findAll(memberId: string): Promise<WorkoutRecord[]> {
		await this.memberRepository.findOneOrFail({ where: { id: memberId } });

		return this.workoutRecordRepository.find({
			where: { memberId },
			order: { workoutDate: 'DESC', createdAt: 'DESC' },
		});
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

		// 볼륨 자동 계산
		const volume = createDto.weight * createDto.reps * createDto.sets;

		const record = this.workoutRecordRepository.create({
			memberId,
			workoutDate: new Date(createDto.workoutDate),
			bodyPart: createDto.bodyPart,
			exerciseName: createDto.exerciseName,
			weight: createDto.weight,
			reps: createDto.reps,
			sets: createDto.sets,
			volume,
			workoutType: createDto.workoutType,
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
		if (updateDto.workoutType) {
			record.workoutType = updateDto.workoutType;
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
}

