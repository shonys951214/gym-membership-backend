import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  OneToMany,
  Index,
} from 'typeorm';
import { Assessment } from './assessment.entity';
import { InjuryHistory } from './injury-history.entity';
import { Membership } from './membership.entity';
import { PTUsage } from './pt-usage.entity';
import { AbilitySnapshot } from './ability-snapshot.entity';
import { WorkoutRecord } from './workout-record.entity';
import { PTSession } from './pt-session.entity';
import { WorkoutRoutine } from './workout-routine.entity';
import { MemberStatus, Gender } from '../common/enums';

@Index('idx_members_email', ['email'])
@Index('idx_members_status', ['status'])
@Index('idx_members_deleted_at', ['deletedAt'])
@Entity('members')
export class Member {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 255 })
  name: string;

  @Column({ length: 50 })
  phone: string;

  @Column({ length: 255 })
  email: string;

  @Column({ type: 'date', name: 'join_date' })
  joinDate: Date;

  @Column({
    type: 'enum',
    enum: MemberStatus,
    default: MemberStatus.ACTIVE,
  })
  status: MemberStatus;

  // 신체 정보
  @Column({ type: 'float', name: 'height', nullable: true, comment: '키 (cm)' })
  height?: number;

  @Column({ type: 'float', name: 'weight', nullable: true, comment: '몸무게 (kg)' })
  weight?: number;

  @Column({
    type: 'date',
    name: 'birth_date',
    nullable: true,
    comment: '생년월일',
  })
  birthDate?: Date;

  @Column({
    type: 'int',
    name: 'age',
    nullable: true,
    comment: '한국나이 (생년월일로부터 자동 계산)',
  })
  age?: number;

  @Column({
    type: 'enum',
    enum: Gender,
    name: 'gender',
    nullable: true,
    comment: '성별',
  })
  gender?: Gender;

  // 1차피드백: 목표 관리 필드
  @Column({ type: 'text', nullable: true })
  goal?: string; // 회원의 목표 한줄 요약

  @Column({ type: 'int', name: 'goal_progress', default: 0 })
  goalProgress: number; // 진행률 0-100

  @Column({ type: 'text', name: 'goal_trainer_comment', nullable: true })
  goalTrainerComment?: string; // 트레이너 동기부여 코멘트

  @Column({ type: 'int', name: 'total_sessions', default: 0 })
  totalSessions: number; // 총 수업 회차

  @Column({ type: 'int', name: 'completed_sessions', default: 0 })
  completedSessions: number; // 완료된 수업 회차

  @OneToMany(() => Assessment, (assessment) => assessment.member)
  assessments: Assessment[];

  @OneToMany(() => InjuryHistory, (injury) => injury.member)
  injuries: InjuryHistory[];

  @OneToMany(() => Membership, (membership) => membership.member)
  memberships: Membership[];

  @OneToMany(() => PTUsage, (ptUsage) => ptUsage.member)
  ptUsages: PTUsage[];

  @OneToMany(() => AbilitySnapshot, (snapshot) => snapshot.member)
  abilitySnapshots: AbilitySnapshot[];

  // 1차피드백: 운동 기록
  @OneToMany(() => WorkoutRecord, (workoutRecord) => workoutRecord.member)
  workoutRecords: WorkoutRecord[];

  // 1차피드백: PT 세션
  @OneToMany(() => PTSession, (ptSession) => ptSession.member)
  ptSessions: PTSession[];

  // 1차피드백: 추천 운동 루틴
  @OneToMany(() => WorkoutRoutine, (workoutRoutine) => workoutRoutine.member)
  workoutRoutines: WorkoutRoutine[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', nullable: true })
  deletedAt?: Date;
}

