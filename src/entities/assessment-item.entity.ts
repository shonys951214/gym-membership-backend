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

  @Column({ type: 'float', nullable: true })
  value?: number;

  @Column({ length: 50, nullable: true })
  unit?: string;

  @Column({ type: 'float', nullable: true })
  score?: number;

  @Column({ type: 'jsonb', nullable: true })
  details?: {
    // 등급 정보
    grade?: string; // 'A', 'B', 'C', 'D', 'D-1', 'D-2' 등
    internalScore?: number; // 내부 점수 (0-100, UI 비노출)
    
    // 대체 항목 정보
    isReplacement?: boolean;
    isImpossible?: boolean;
    weight?: number; // 항목별 비중
    
    // 심폐 지구력 회복 속도
    recoverySpeed?: string[]; // ['fast', 'slow']
    
    // 유연성 항목별 평가
    flexibilityItems?: {
      sitAndReach?: 'A' | 'B' | 'C';
      shoulder?: 'A' | 'B' | 'C';
      hip?: 'A' | 'B' | 'C';
      hamstring?: 'A' | 'B' | 'C';
    };
    
    // 안정성 평가
    ohsa?: 'A' | 'B' | 'C';
    pain?: 'none' | 'present';
    
    // 체성분 데이터
    muscleMass?: number;
    fatMass?: number;
    bodyFatPercentage?: number;
    
    // 관찰 포인트
    observations?: {
      [key: string]: any;
    };
    
    // 좌우 차이
    leftRightDifference?: {
      left?: number;
      right?: number;
    };
    
    // 기타 상세 정보
    [key: string]: any;
  };

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;
}

