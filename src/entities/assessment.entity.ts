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
import { AssessmentType, Condition, EvaluationType } from '../common/enums';

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

  // 1차피드백: 평가 위계 구조 - 정적/동적 평가 구분
  @Column({
    type: 'enum',
    enum: EvaluationType,
    name: 'evaluation_type',
    nullable: true, // 기존 데이터 호환성을 위해 nullable
  })
  evaluationType?: EvaluationType;

  // 정적평가 데이터 (설문조사, 체성분 평가, 육안체형평가)
  @Column({ type: 'jsonb', name: 'static_evaluation', nullable: true })
  staticEvaluation?: {
    survey?: {
      // 설문조사 데이터
      [key: string]: any;
    };
    bodyComposition?: {
      // 체성분 평가 (인바디)
      muscleMass?: number; // 근육량 (kg)
      bodyFatPercentage?: number; // 체지방률 (%)
      bodyFatMass?: number; // 체지방량 (kg)
      boneMass?: number; // 골격근량 (kg)
      bmr?: number; // 기초대사량 (kcal)
      [key: string]: any;
    };
    visualAssessment?: {
      // 육안체형평가 (앞, 옆, 뒷 모습)
      frontPhoto?: string; // 사진 URL 또는 base64
      sidePhoto?: string;
      backPhoto?: string;
      notes?: string; // 불균형 체크 메모
      [key: string]: any;
    };
  };

  // 동적평가 데이터 (유연성, 근력, 밸런스, 유산소성 평가)
  @Column({ type: 'jsonb', name: 'dynamic_evaluation', nullable: true })
  dynamicEvaluation?: {
    flexibility?: {
      // 유연성 평가
      [key: string]: any;
    };
    strength?: {
      // 근력 평가
      [key: string]: any;
    };
    balance?: {
      // 밸런스 평가
      [key: string]: any;
    };
    cardio?: {
      // 유산소성 평가
      [key: string]: any;
    };
  };

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

