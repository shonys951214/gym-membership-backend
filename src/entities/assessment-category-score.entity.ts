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
import { Category } from '../common/enums';
import { AssessmentGradeConstant } from './assessment-grade-constant.entity';

@Index('idx_assessment_category_scores_category', ['category'])
@Index('idx_assessment_category_scores_input_grade', ['inputGrade'])
@Index('idx_assessment_category_scores_active', ['isActive'], { where: '"is_active" = true' })
@Entity('assessment_category_scores')
export class AssessmentCategoryScore {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({
    type: 'enum',
    enum: Category,
  })
  category: Category;

  @Column({ name: 'input_grade', length: 20 })
  inputGrade: string; // 'A', 'B', 'C', 'D', 'D-1', 'D-2', etc.

  @Column({ type: 'jsonb', nullable: true })
  conditions?: {
    recoverySpeed?: string[];
    ohsa?: string;
    pain?: 'none' | 'present';
    [key: string]: any;
  };

  @Column({ name: 'internal_score', type: 'int' })
  internalScore: number; // 0-100

  @Column({ name: 'final_grade_code', length: 20 })
  finalGradeCode: string; // 'STABLE', 'NORMAL', 'LIMITED', 'PREPARE'

  @ManyToOne(() => AssessmentGradeConstant, { nullable: false })
  @JoinColumn({ name: 'final_grade_code', referencedColumnName: 'gradeCode' })
  finalGrade?: AssessmentGradeConstant;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ length: 50, default: 'v1' })
  version: string;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
