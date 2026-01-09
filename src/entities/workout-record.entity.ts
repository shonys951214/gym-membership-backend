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
import { StrengthLevel } from '../common/enums';

export enum WorkoutType {
	PT = 'PT', // PT 세션 참여
	PERSONAL = 'PERSONAL', // 개인 운동
}

@Index('idx_workout_records_member_id', ['memberId'])
@Index('idx_workout_records_workout_date', ['workoutDate'])
@Index('idx_workout_records_workout_type', ['workoutType'])
@Entity('workout_records')
export class WorkoutRecord {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column({ name: 'member_id' })
	memberId: string;

	@ManyToOne(() => Member, (member) => member.workoutRecords, {
		onDelete: 'CASCADE',
	})
	@JoinColumn({ name: 'member_id' })
	member: Member;

	@Column({ type: 'date', name: 'workout_date' })
	workoutDate: Date;

	@Column({ length: 50, name: 'body_part' })
	bodyPart: string; // "하체", "가슴", "등", "어깨", "팔" 등

	@Column({ length: 100, name: 'exercise_name' })
	exerciseName: string; // "스쿼트", "벤치프레스", "데드리프트" 등

	@Column({ type: 'float' })
	weight: number; // 무게 (kg)

	@Column({ type: 'int' })
	reps: number; // 횟수

	@Column({ type: 'int' })
	sets: number; // 세트 수

	@Column({ type: 'float' })
	volume: number; // 볼륨 = weight * reps * sets (자동 계산)

	@Column({ type: 'int', nullable: true })
	duration?: number; // 운동 시간 (분)

	@Column({
		type: 'enum',
		enum: WorkoutType,
		default: WorkoutType.PERSONAL,
		name: 'workout_type',
	})
	workoutType: WorkoutType; // 'PT' | 'PERSONAL' (프론트엔드 요청: sessionType과 동일)

	@Column({ name: 'pt_session_id', nullable: true })
	ptSessionId?: string; // PT 세션 ID (workoutType이 'PT'인 경우)

	@Column({ type: 'text', name: 'trainer_comment', nullable: true })
	trainerComment?: string; // 트레이너 코멘트

	// Strength Level 관련 필드
	@Column({ type: 'float', name: 'one_rep_max', nullable: true })
	oneRepMax?: number; // 1RM (One Rep Max) 계산값 (kg)

	@Column({ type: 'float', name: 'relative_strength', nullable: true })
	relativeStrength?: number; // 상대적 강도 (체중 대비 무게 비율, %)

	@Column({
		type: 'enum',
		enum: StrengthLevel,
		name: 'strength_level',
		nullable: true,
	})
	strengthLevel?: StrengthLevel; // Strength Level 판정 결과

	@CreateDateColumn({ name: 'created_at' })
	createdAt: Date;

	@UpdateDateColumn({ name: 'updated_at' })
	updatedAt: Date;
}

