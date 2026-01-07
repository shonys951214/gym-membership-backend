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

@Index('idx_workout_routines_member_id', ['memberId'])
@Index('idx_workout_routines_routine_date', ['routineDate'])
@Index('idx_workout_routines_member_date', ['memberId', 'routineDate'])
@Entity('workout_routines')
export class WorkoutRoutine {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column({ name: 'member_id', nullable: true })
	memberId?: string; // null이면 전체 공통 루틴

	@ManyToOne(() => Member, (member) => member.workoutRoutines, {
		onDelete: 'CASCADE',
		nullable: true,
	})
	@JoinColumn({ name: 'member_id' })
	member?: Member;

	@Column({ length: 255, name: 'routine_name' })
	routineName: string; // 루틴 이름

	@Column({ type: 'date', name: 'routine_date', nullable: true })
	routineDate?: Date; // 회원별 루틴인 경우 날짜 지정

	@Column({ type: 'jsonb' })
	exercises: Array<{
		exerciseName: string;
		bodyPart: string;
		sets?: number;
		reps?: number;
		weight?: number;
		duration?: number; // 분
		restTime?: number; // 초
		notes?: string;
	}>;

	@Column({ type: 'int', name: 'estimated_duration' })
	estimatedDuration: number; // 예상 소요 시간 (분)

	@Column({
		type: 'enum',
		enum: ['EASY', 'MEDIUM', 'HARD'],
		default: 'MEDIUM',
	})
	difficulty: 'EASY' | 'MEDIUM' | 'HARD';

	@Column({ type: 'boolean', name: 'is_completed', default: false })
	isCompleted: boolean; // 회원별 루틴인 경우 완료 여부

	@CreateDateColumn({ name: 'created_at' })
	createdAt: Date;

	@UpdateDateColumn({ name: 'updated_at' })
	updatedAt: Date;
}

