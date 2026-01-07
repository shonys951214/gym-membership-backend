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

	@Column({
		type: 'enum',
		enum: WorkoutType,
		default: WorkoutType.PERSONAL,
		name: 'workout_type',
	})
	workoutType: WorkoutType; // 'PT' | 'PERSONAL'

	@CreateDateColumn({ name: 'created_at' })
	createdAt: Date;

	@UpdateDateColumn({ name: 'updated_at' })
	updatedAt: Date;
}

