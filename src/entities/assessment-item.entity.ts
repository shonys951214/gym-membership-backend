import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Assessment } from './assessment.entity';
import { Category } from '../common/enums';

@Index('idx_assessment_items_assessment_id', ['assessmentId'])
@Index('idx_assessment_items_category', ['category'])
@Entity('assessment_items')
export class AssessmentItem {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'assessment_id' })
  assessmentId: string;

  @ManyToOne(() => Assessment, (assessment) => assessment.items, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'assessment_id' })
  assessment: Assessment;

  @Column({
    type: 'enum',
    enum: Category,
  })
  category: Category;

  @Column({ length: 255 })
  name: string;

  @Column({ type: 'float' })
  value: number;

  @Column({ length: 50 })
  unit: string;

  @Column({ type: 'float' })
  score: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}

