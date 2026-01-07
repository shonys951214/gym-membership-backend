import {
	Injectable,
	Logger,
} from "@nestjs/common";
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Member } from '../../entities/member.entity';
import { Membership } from '../../entities/membership.entity';
import { MembershipStatus, MemberStatus } from '../../common/enums';
import { PTUsage } from '../../entities/pt-usage.entity';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { CreateMembershipDto } from './dto/create-membership.dto';
import { UpdatePTUsageDto } from './dto/update-pt-usage.dto';
import { UpdateGoalDto } from './dto/update-goal.dto';
import { WorkoutVolumeQueryDto, VolumePeriod } from './dto/workout-volume-query.dto';
import { ApiExceptions } from '../../common/exceptions';

@Injectable()
export class MembersService {
	private readonly logger = new Logger(MembersService.name);

	constructor(
		@InjectRepository(Member)
		private memberRepository: Repository<Member>,
		@InjectRepository(Membership)
		private membershipRepository: Repository<Membership>,
		@InjectRepository(PTUsage)
		private ptUsageRepository: Repository<PTUsage>,
	) {}

  async findAll(): Promise<Member[]> {
    return this.memberRepository.find({
      relations: ['memberships', 'ptUsages'],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<Member> {
    const member = await this.memberRepository.findOne({
      where: { id },
      relations: ['memberships', 'ptUsages', 'assessments', 'injuries'],
    });

		if (!member) {
			this.logger.warn(`회원을 찾을 수 없습니다. ID: ${id}`);
			throw ApiExceptions.memberNotFound();
		}

    return member;
  }

  async create(createMemberDto: CreateMemberDto): Promise<Member> {
    const existingMember = await this.memberRepository.findOne({
      where: { email: createMemberDto.email },
    });

		if (existingMember) {
			this.logger.warn(
				`이미 등록된 이메일입니다. Email: ${createMemberDto.email}`,
			);
			throw ApiExceptions.memberAlreadyExists();
		}

    const member = this.memberRepository.create({
      ...createMemberDto,
      joinDate: new Date(createMemberDto.joinDate),
      status: createMemberDto.status || MemberStatus.ACTIVE,
    });

    return this.memberRepository.save(member);
  }

  async update(id: string, updateMemberDto: UpdateMemberDto): Promise<Member> {
    const member = await this.findOne(id);

    Object.assign(member, updateMemberDto);

    return this.memberRepository.save(member);
  }

  async remove(id: string): Promise<void> {
    const member = await this.findOne(id);
    await this.memberRepository.softDelete(id);
  }

  // 회원권 관리
  async getMembership(memberId: string): Promise<Membership | null> {
    return this.membershipRepository.findOne({
      where: { memberId, status: MembershipStatus.ACTIVE },
      order: { createdAt: 'DESC' },
    });
  }

  async createMembership(
    memberId: string,
    createMembershipDto: CreateMembershipDto,
  ): Promise<Membership> {
    await this.findOne(memberId); // 회원 존재 확인

    const membership = this.membershipRepository.create({
      memberId,
      ...createMembershipDto,
      purchaseDate: new Date(createMembershipDto.purchaseDate),
      expiryDate: new Date(createMembershipDto.expiryDate),
    });

    return this.membershipRepository.save(membership);
  }

  async updateMembership(
    memberId: string,
    membershipId: string,
    updateData: Partial<CreateMembershipDto>,
  ): Promise<Membership> {
    const membership = await this.membershipRepository.findOne({
      where: { id: membershipId, memberId },
    });

		if (!membership) {
			this.logger.warn(
				`회원권을 찾을 수 없습니다. MemberId: ${memberId}, MembershipId: ${membershipId}`,
			);
			throw ApiExceptions.membershipNotFound();
		}

    Object.assign(membership, updateData);
    if (updateData.purchaseDate) {
      membership.purchaseDate = new Date(updateData.purchaseDate);
    }
    if (updateData.expiryDate) {
      membership.expiryDate = new Date(updateData.expiryDate);
    }

    return this.membershipRepository.save(membership);
  }

  // PT 횟수 관리
  async getPTUsage(memberId: string): Promise<PTUsage | null> {
    return this.ptUsageRepository.findOne({
      where: { memberId },
      order: { createdAt: 'DESC' },
    });
  }

  async createOrUpdatePTUsage(
    memberId: string,
    updatePTUsageDto: UpdatePTUsageDto,
  ): Promise<PTUsage> {
    await this.findOne(memberId); // 회원 존재 확인

    let ptUsage = await this.getPTUsage(memberId);

    if (!ptUsage) {
      ptUsage = this.ptUsageRepository.create({
        memberId,
        totalCount: updatePTUsageDto.totalCount || 0,
        remainingCount: updatePTUsageDto.remainingCount || 0,
        usedCount: updatePTUsageDto.usedCount || 0,
      });
    } else {
      Object.assign(ptUsage, updatePTUsageDto);
      if (updatePTUsageDto.usedCount !== undefined) {
        ptUsage.lastUsedDate = new Date();
      }
    }

		return this.ptUsageRepository.save(ptUsage);
	}

	async deleteMembership(memberId: string, membershipId: string): Promise<void> {
		const membership = await this.membershipRepository.findOne({
			where: { id: membershipId, memberId },
		});

		if (!membership) {
			this.logger.warn(
				`회원권을 찾을 수 없습니다. MemberId: ${memberId}, MembershipId: ${membershipId}`,
			);
			throw ApiExceptions.membershipNotFound();
		}

		await this.membershipRepository.remove(membership);
	}

	// 1차피드백: 목표 관리
	async getGoal(memberId: string): Promise<{
		goal?: string;
		goalProgress: number;
		goalTrainerComment?: string;
		totalSessions: number;
		completedSessions: number;
		progressPercentage: number; // 수업 진행률 (completedSessions / totalSessions * 100)
	}> {
		const member = await this.findOne(memberId);

		const progressPercentage =
			member.totalSessions > 0
				? Math.round((member.completedSessions / member.totalSessions) * 100)
				: 0;

		return {
			goal: member.goal,
			goalProgress: member.goalProgress,
			goalTrainerComment: member.goalTrainerComment,
			totalSessions: member.totalSessions,
			completedSessions: member.completedSessions,
			progressPercentage,
		};
	}

	async updateGoal(memberId: string, updateGoalDto: UpdateGoalDto): Promise<Member> {
		const member = await this.findOne(memberId);

		// goalProgress 범위 검증
		if (updateGoalDto.goalProgress !== undefined) {
			if (updateGoalDto.goalProgress < 0 || updateGoalDto.goalProgress > 100) {
				throw ApiExceptions.validationError('목표 진행률은 0-100 사이의 값이어야 합니다.');
			}
		}

		// completedSessions가 totalSessions를 초과하지 않도록 검증
		if (
			updateGoalDto.completedSessions !== undefined &&
			updateGoalDto.totalSessions !== undefined
		) {
			if (updateGoalDto.completedSessions > updateGoalDto.totalSessions) {
				throw ApiExceptions.validationError(
					'완료된 수업 회차는 총 수업 회차를 초과할 수 없습니다.',
				);
			}
		} else if (updateGoalDto.completedSessions !== undefined) {
			if (updateGoalDto.completedSessions > member.totalSessions) {
				throw ApiExceptions.validationError(
					'완료된 수업 회차는 총 수업 회차를 초과할 수 없습니다.',
				);
			}
		}

		Object.assign(member, updateGoalDto);

		return this.memberRepository.save(member);
	}

	// 1차피드백: 대시보드 통합
	async getDashboard(memberId: string): Promise<{
		goal: {
			goal?: string;
			goalProgress: number;
			goalTrainerComment?: string;
		};
		sessionProgress: {
			totalSessions: number;
			completedSessions: number;
			progressPercentage: number;
		};
		workoutCalendar: Array<{
			date: string;
			ptSessions: Array<{
				id: string;
				sessionNumber: number;
				mainContent: string;
			}>;
			personalWorkouts: Array<{
				id: string;
				exerciseName: string;
				bodyPart: string;
			}>;
		}>;
		workoutAnalysis: {
			period: 'week' | 'month';
			bodyPartVolumes: Array<{
				bodyPart: string;
				volume: number;
			}>;
			totalVolume: number;
		};
	}> {
		const member = await this.findOne(memberId);

		// 목표 정보
		const goal = {
			goal: member.goal,
			goalProgress: member.goalProgress,
			goalTrainerComment: member.goalTrainerComment,
		};

		// 수업 진행률
		const progressPercentage =
			member.totalSessions > 0
				? Math.round((member.completedSessions / member.totalSessions) * 100)
				: 0;

		const sessionProgress = {
			totalSessions: member.totalSessions,
			completedSessions: member.completedSessions,
			progressPercentage,
		};

		// 운동 캘린더 (최근 30일)
		const now = new Date();
		const thirtyDaysAgo = new Date(now);
		thirtyDaysAgo.setDate(now.getDate() - 30);

		// PT 세션과 운동 기록을 함께 조회
		const ptSessions = await this.memberRepository.manager.query(`
			SELECT 
				id,
				session_number as "sessionNumber",
				session_date as "sessionDate",
				main_content as "mainContent"
			FROM pt_sessions
			WHERE member_id = $1
				AND session_date >= $2
				AND session_date <= $3
			ORDER BY session_date DESC
		`, [memberId, thirtyDaysAgo.toISOString().split('T')[0], now.toISOString().split('T')[0]]);

		const workoutRecords = await this.memberRepository.manager.query(`
			SELECT 
				id,
				workout_date as "workoutDate",
				exercise_name as "exerciseName",
				body_part as "bodyPart",
				workout_type as "workoutType"
			FROM workout_records
			WHERE member_id = $1
				AND workout_date >= $2
				AND workout_date <= $3
			ORDER BY workout_date DESC
		`, [memberId, thirtyDaysAgo.toISOString().split('T')[0], now.toISOString().split('T')[0]]);

		// 날짜별로 그룹화
		const calendarMap = new Map<string, {
			date: string;
			ptSessions: any[];
			personalWorkouts: any[];
		}>();

		ptSessions.forEach((session: any) => {
			const date = session.sessionDate;
			if (!calendarMap.has(date)) {
				calendarMap.set(date, {
					date,
					ptSessions: [],
					personalWorkouts: [],
				});
			}
			calendarMap.get(date)!.ptSessions.push({
				id: session.id,
				sessionNumber: session.sessionNumber,
				mainContent: session.mainContent,
			});
		});

		workoutRecords.forEach((record: any) => {
			const date = record.workoutDate;
			if (!calendarMap.has(date)) {
				calendarMap.set(date, {
					date,
					ptSessions: [],
					personalWorkouts: [],
				});
			}
			if (record.workoutType === 'PERSONAL') {
				calendarMap.get(date)!.personalWorkouts.push({
					id: record.id,
					exerciseName: record.exerciseName,
					bodyPart: record.bodyPart,
				});
			}
		});

		const workoutCalendar = Array.from(calendarMap.values())
			.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());

		// 운동 기록 분석 (주간)
		const workoutAnalysis = await this.getWorkoutVolumeAnalysis(memberId, VolumePeriod.WEEK);

		return {
			goal,
			sessionProgress,
			workoutCalendar,
			workoutAnalysis,
		};
	}

	private async getWorkoutVolumeAnalysis(
		memberId: string,
		period: VolumePeriod,
	): Promise<{
		period: 'week' | 'month';
		bodyPartVolumes: Array<{ bodyPart: string; volume: number }>;
		totalVolume: number;
	}> {
		const now = new Date();
		let startDate: Date;

		if (period === VolumePeriod.WEEK) {
			const dayOfWeek = now.getDay();
			const diff = dayOfWeek === 0 ? 6 : dayOfWeek - 1;
			startDate = new Date(now);
			startDate.setDate(now.getDate() - diff);
			startDate.setHours(0, 0, 0, 0);
		} else {
			startDate = new Date(now.getFullYear(), now.getMonth(), 1);
		}

		const endDate = new Date(now);
		endDate.setHours(23, 59, 59, 999);

		const records = await this.memberRepository.manager.query(`
			SELECT 
				body_part as "bodyPart",
				SUM(volume) as volume
			FROM workout_records
			WHERE member_id = $1
				AND workout_date >= $2
				AND workout_date <= $3
			GROUP BY body_part
			ORDER BY volume DESC
		`, [memberId, startDate.toISOString().split('T')[0], endDate.toISOString().split('T')[0]]);

		const bodyPartVolumes = records.map((r: any) => ({
			bodyPart: r.bodyPart,
			volume: Math.round(parseFloat(r.volume) * 100) / 100,
		}));

		const totalVolume = bodyPartVolumes.reduce((sum, item) => sum + item.volume, 0);

		return {
			period,
			bodyPartVolumes,
			totalVolume: Math.round(totalVolume * 100) / 100,
		};
	}
}

