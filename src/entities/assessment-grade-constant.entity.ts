import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Index('idx_assessment_grade_constants_code', ['gradeCode'])
@Index('idx_assessment_grade_constants_active', ['isActive'], { where: 'is_active = true' })
@Entity('assessment_grade_constants')
export class AssessmentGradeConstant {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'grade_code', length: 20, unique: true })
  gradeCode: string; // 'STABLE', 'NORMAL', 'LIMITED', 'PREPARE'

  @Column({ name: 'grade_name_kr', length: 50 })
  gradeNameKr: string; // '안정적', '무난함', '제한 있음', '준비 필요'

  @Column({ name: 'grade_name_en', length: 50 })
  gradeNameEn: string; // 'Stable', 'Normal', 'Limited', 'Prepare'

  @Column({ name: 'internal_score', type: 'int' })
  internalScore: number; // 0-100

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
