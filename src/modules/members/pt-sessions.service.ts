import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PTSession } from '../../entities/pt-session.entity';
import { Member } from '../../entities/member.entity';
import { CreatePTSessionDto } from './dto/create-pt-session.dto';
import { UpdatePTSessionDto } from './dto/update-pt-session.dto';
import { ApiExceptions } from '../../common/exceptions';
import { EntityUpdateHelper } from '../../common/utils/entity-update-helper';
import { RepositoryHelper } from '../../common/utils/repository-helper';

@Injectable()
export class PTSessionsService {
	private readonly logger = new Logger(PTSessionsService.name);

	constructor(
		@InjectRepository(PTSession)
		private ptSessionRepository: Repository<PTSession>,
		@InjectRepository(Member)
		private memberRepository: Repository<Member>,
	) {}

	async findAll(memberId: string): Promise<{
		sessions: PTSession[];
		total: number;
		totalSessions: number;
		completedSessions: number;
	}> {
		await RepositoryHelper.ensureMemberExists(this.memberRepository, memberId, this.logger);
		const member = await this.memberRepository.findOne({ where: { id: memberId } });

		const sessions = await this.ptSessionRepository.find({
			where: { memberId },
			order: { sessionNumber: 'DESC' },
		});

		return {
			sessions,
			total: sessions.length,
			totalSessions: member.totalSessions,
			completedSessions: member.completedSessions,
		};
	}

	async findOne(id: string, memberId: string): Promise<PTSession> {
		return RepositoryHelper.findOneOrFailByMemberId(
			this.ptSessionRepository,
			id,
			memberId,
			this.logger,
			'PT 세션',
		);
	}

	/**
	 * 다음 세션 번호 계산
	 */
	private async getNextSessionNumber(memberId: string): Promise<number> {
		const lastSession = await this.ptSessionRepository.findOne({
			where: { memberId },
			order: { sessionNumber: 'DESC' },
		});

		return lastSession ? lastSession.sessionNumber + 1 : 1;
	}

	async create(
		memberId: string,
		createDto: CreatePTSessionDto,
	): Promise<PTSession> {
		await RepositoryHelper.ensureMemberExists(this.memberRepository, memberId, this.logger);
		const member = await this.memberRepository.findOne({ where: { id: memberId } });

		// 다음 세션 번호 계산
		const sessionNumber = await this.getNextSessionNumber(memberId);

		// 날짜 필드 변환
		const sessionData = EntityUpdateHelper.convertDateFields(
			{
				memberId,
				sessionNumber,
				mainContent: createDto.mainContent,
				trainerComment: createDto.trainerComment,
				sessionDate: createDto.sessionDate,
			},
			['sessionDate'],
		);

		const session = this.ptSessionRepository.create(sessionData);
		const savedSession = await this.ptSessionRepository.save(session);

		// completedSessions 자동 증가
		member.completedSessions += 1;

		// 목표 진행률 자동 업데이트
		if (member.totalSessions > 0) {
			member.goalProgress = Math.round(
				(member.completedSessions / member.totalSessions) * 100,
			);
			// 100% 초과 방지
			if (member.goalProgress > 100) {
				member.goalProgress = 100;
			}
		}

		await this.memberRepository.save(member);

		return savedSession;
	}

	async update(
		id: string,
		memberId: string,
		updateDto: UpdatePTSessionDto,
	): Promise<PTSession> {
		const session = await this.findOne(id, memberId);
		EntityUpdateHelper.updateFieldsWithDateConversion(session, updateDto, ['sessionDate']);
		return this.ptSessionRepository.save(session);
	}

	async remove(id: string, memberId: string): Promise<void> {
		await RepositoryHelper.ensureMemberExists(this.memberRepository, memberId, this.logger);
		const member = await this.memberRepository.findOne({ where: { id: memberId } });

		const session = await this.findOne(id, memberId);
		await this.ptSessionRepository.remove(session);

		// completedSessions 자동 감소
		if (member.completedSessions > 0) {
			member.completedSessions -= 1;

			// 목표 진행률 자동 업데이트
			if (member.totalSessions > 0) {
				member.goalProgress = Math.round(
					(member.completedSessions / member.totalSessions) * 100,
				);
			} else {
				member.goalProgress = 0;
			}

			await this.memberRepository.save(member);
		}
	}
}

