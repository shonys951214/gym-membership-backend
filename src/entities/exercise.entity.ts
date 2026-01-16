import {
	Entity,
	PrimaryGeneratedColumn,
	Column,
	CreateDateColumn,
	UpdateDateColumn,
	OneToMany,
	Index,
} from 'typeorm';
import { StrengthStandard } from './strength-standard.entity';

export enum ExerciseCategory {
	UPPER = 'UPPER', // 상체
	LOWER = 'LOWER', // 하체
	FULL_BODY = 'FULL_BODY', // 전신
}

@Index('idx_exercises_name', ['name'])
@Index('idx_exercises_name_en', ['nameEn'])
@Index('idx_exercises_category', ['category'])
@Index('idx_exercises_body_part', ['bodyPart'])
@Index('idx_exercises_is_active', ['isActive'])
@Entity('exercises')
export class Exercise {
	@PrimaryGeneratedColumn('uuid')
	id: string;

	@Column({ length: 255, nullable: true })
	name?: string; // "벤치프레스", "스쿼트" 등 (한글명이 없으면 NULL)

	@Column({ length: 255, name: 'name_en' })
	nameEn: string; // "Bench Press", "Squat" 등

	@Column({
		type: 'enum',
		enum: ExerciseCategory,
		default: ExerciseCategory.FULL_BODY,
	})
	category: ExerciseCategory; // "UPPER", "LOWER", "FULL_BODY"

	@Column({ length: 50, name: 'body_part', nullable: true })
	bodyPart?: string; // "가슴", "등", "어깨", "팔", "하체" 등

	@Column({ length: 50, default: 'kg' })
	unit: string; // "kg", "lb" 등

	@Column({ name: 'is_active', default: true })
	isActive: boolean; // 활성화 여부

	@OneToMany(() => StrengthStandard, (standard) => standard.exercise)
	standards: StrengthStandard[];

	@CreateDateColumn({ name: 'created_at' })
	createdAt: Date;

	@UpdateDateColumn({ name: 'updated_at' })
	updatedAt: Date;
}
