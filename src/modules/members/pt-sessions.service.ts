import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PTSession } from '../../entities/pt-session.entity';
import { Member } from '../../entities/member.entity';
import { CreatePTSessionDto } from './dto/create-pt-session.dto';
import { UpdatePTSessionDto } from './dto/update-pt-session.dto';
import { ApiExceptions } from '../../common/exceptions';

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
		const member = await this.memberRepository.findOneOrFail({
			where: { id: memberId },
		});

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
		const session = await this.ptSessionRepository.findOne({
			where: { id, memberId },
		});

		if (!session) {
			this.logger.warn(
				`PT 세션을 찾을 수 없습니다. ID: ${id}, MemberId: ${memberId}`,
			);
			throw ApiExceptions.memberNotFound('PT 세션을 찾을 수 없습니다.');
		}

		return session;
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
		const member = await this.memberRepository.findOneOrFail({
			where: { id: memberId },
		});

		// 다음 세션 번호 계산
		const sessionNumber = await this.getNextSessionNumber(memberId);

		const session = this.ptSessionRepository.create({
			memberId,
			sessionNumber,
			sessionDate: new Date(createDto.sessionDate),
			mainContent: createDto.mainContent,
			trainerComment: createDto.trainerComment,
		});

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

		if (updateDto.sessionDate) {
			session.sessionDate = new Date(updateDto.sessionDate);
		}
		if (updateDto.mainContent) {
			session.mainContent = updateDto.mainContent;
		}
		if (updateDto.trainerComment !== undefined) {
			session.trainerComment = updateDto.trainerComment;
		}

		return this.ptSessionRepository.save(session);
	}

	async remove(id: string, memberId: string): Promise<void> {
		const member = await this.memberRepository.findOneOrFail({
			where: { id: memberId },
		});

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

