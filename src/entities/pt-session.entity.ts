import {
	Entity,
	PrimaryGeneratedColumn,
	Column,
	CreateDateColumn,
	UpdateDateColumn,
	ManyToOne,
	JoinColumn,
	Index,
} from 'typeorm';
import { Member } from './member.entity';

@Index('idx_pt_sessions_member_id', ['memberId'])
@Index('idx_pt_sessions_session_date', ['sessionDate'])
@Index('idx_pt_sessions_session_number', ['memberId', 'sessionNumber'])
@Entity('pt_sessions')
export class PTSession {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column({ name: 'member_id' })
	memberId: string;

	@ManyToOne(() => Member, (member) => member.ptSessions, {
		onDelete: 'CASCADE',
	})
	@JoinColumn({ name: 'member_id' })
	member: Member;

	@Column({ type: 'int', name: 'session_number' })
	sessionNumber: number; // 수업 회차: 1, 2, 3... (자동 계산)

	@Column({ type: 'date', name: 'session_date' })
	sessionDate: Date;

	@Column({ type: 'text', name: 'main_content' })
	mainContent: string; // 주요 수업 내용

	@Column({ type: 'text', name: 'trainer_comment', nullable: true })
	trainerComment?: string; // 트레이너 코멘트

	@CreateDateColumn({ name: 'created_at' })
	createdAt: Date;

	@UpdateDateColumn({ name: 'updated_at' })
	updatedAt: Date;
}

