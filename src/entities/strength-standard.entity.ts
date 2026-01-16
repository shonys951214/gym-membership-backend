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
@Index('idx_strength_standards_standard_type', ['standardType'])
@Index('idx_strength_standards_age', ['ageMin', 'ageMax'])
@Index('idx_strength_standards_lookup', ['exerciseId', 'gender', 'level', 'standardType', 'bodyweightMin', 'bodyweightMax', 'ageMin', 'ageMax'])
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

	@Column({ type: 'varchar', length: 20, name: 'standard_type', default: 'BODYWEIGHT' })
	standardType: 'BODYWEIGHT' | 'AGE'; // 기준 타입: BODYWEIGHT(체중별), AGE(나이별)

	@Column({ type: 'float', name: 'bodyweight_min', nullable: true })
	bodyweightMin?: number; // 체중 최소값 (kg) - 나이별 데이터는 NULL

	@Column({ type: 'float', name: 'bodyweight_max', nullable: true })
	bodyweightMax?: number; // 체중 최대값 (kg) - 나이별 데이터는 NULL

	@Column({ type: 'int', name: 'age_min', nullable: true })
	ageMin?: number; // 나이 최소값 - 체중별 데이터는 NULL

	@Column({ type: 'int', name: 'age_max', nullable: true })
	ageMax?: number; // 나이 최대값 - 체중별 데이터는 NULL

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
