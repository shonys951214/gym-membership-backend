import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  JoinColumn,
  OneToMany,
  OneToOne,
  Index,
} from 'typeorm';
import { Member } from './member.entity';
import { AssessmentItem } from './assessment-item.entity';
import { AbilitySnapshot } from './ability-snapshot.entity';
import { AssessmentType, Condition } from '../common/enums';

@Index('idx_assessments_member_id', ['memberId'])
@Index('idx_assessments_assessed_at', ['assessedAt'])
@Index('idx_assessments_is_initial', ['isInitial'])
@Index('idx_assessments_deleted_at', ['deletedAt'])
@Entity('assessments')
export class Assessment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'member_id' })
  memberId: string;

  @ManyToOne(() => Member, (member) => member.assessments, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'member_id' })
  member: Member;

  @Column({
    type: 'enum',
    enum: AssessmentType,
    name: 'assessment_type',
  })
  assessmentType: AssessmentType;

  @Column({ name: 'is_initial', default: false })
  isInitial: boolean;

  @Column({ type: 'date', name: 'assessed_at' })
  assessedAt: Date;

  @Column({ type: 'text', name: 'trainer_comment', nullable: true })
  trainerComment?: string;

  @Column({ type: 'float', name: 'body_weight', nullable: true })
  bodyWeight?: number;

  @Column({
    type: 'enum',
    enum: Condition,
    nullable: true,
  })
  condition?: Condition;

  @OneToMany(() => AssessmentItem, (item) => item.assessment)
  items: AssessmentItem[];

  @OneToOne(() => AbilitySnapshot, (snapshot) => snapshot.assessment)
  snapshot?: AbilitySnapshot;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', nullable: true })
  deletedAt?: Date;
}

