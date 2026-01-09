import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { AssessmentGradeConstant } from './assessment-grade-constant.entity';

@Index('idx_flexibility_grade_thresholds_active', ['isActive'], { where: 'is_active = true' })
@Entity('flexibility_grade_thresholds')
export class FlexibilityGradeThreshold {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'weight_sum_min', type: 'decimal', precision: 5, scale: 2 })
  weightSumMin: number;

  @Column({ name: 'weight_sum_max', type: 'decimal', precision: 5, scale: 2 })
  weightSumMax: number;

  @Column({ name: 'final_grade_code', length: 20 })
  finalGradeCode: string; // 'STABLE', 'NORMAL', 'LIMITED', 'PREPARE'

  @ManyToOne(() => AssessmentGradeConstant, { nullable: false })
  @JoinColumn({ name: 'final_grade_code', referencedColumnName: 'gradeCode' })
  finalGrade?: AssessmentGradeConstant;

  @Column({ name: 'internal_score', type: 'int' })
  internalScore: number; // 0-100

  @Column({ length: 50, default: 'v1' })
  version: string;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
