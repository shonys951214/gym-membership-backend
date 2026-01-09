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
import { Exercise } from './exercise.entity';
import { Gender, StrengthLevel } from '../common/enums';

@Index('idx_strength_standards_exercise_id', ['exerciseId'])
@Index('idx_strength_standards_gender', ['gender'])
@Index('idx_strength_standards_level', ['level'])
@Index('idx_strength_standards_bodyweight', ['bodyweightMin', 'bodyweightMax'])
@Index('idx_strength_standards_lookup', ['exerciseId', 'gender', 'level', 'bodyweightMin', 'bodyweightMax'])
@Entity('strength_standards')
export class StrengthStandard {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column({ name: 'exercise_id' })
	exerciseId: string;

	@ManyToOne(() => Exercise, (exercise) => exercise.standards, {
		onDelete: 'CASCADE',
	})
	@JoinColumn({ name: 'exercise_id' })
	exercise: Exercise;

	@Column({ type: 'float', name: 'bodyweight_min' })
	bodyweightMin: number; // 체중 최소값 (kg)

	@Column({ type: 'float', name: 'bodyweight_max' })
	bodyweightMax: number; // 체중 최대값 (kg)

	@Column({
		type: 'enum',
		enum: Gender,
	})
	gender: Gender; // MALE | FEMALE

	@Column({
		type: 'enum',
		enum: StrengthLevel,
	})
	level: StrengthLevel; // BEGINNER | NOVICE | INTERMEDIATE | ADVANCED | ELITE

	@Column({ type: 'float', name: 'weight_kg' })
	weightKg: number; // 기준 무게 (kg)

	@CreateDateColumn({ name: 'created_at' })
	createdAt: Date;

	@UpdateDateColumn({ name: 'updated_at' })
	updatedAt: Date;
}
