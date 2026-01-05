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
  Index,
} from 'typeorm';
import { Member } from './member.entity';
import { InjuryRestriction } from './injury-restriction.entity';
import { Severity, RecoveryStatus } from '../common/enums';

@Index('idx_injury_histories_member_id', ['memberId'])
@Index('idx_injury_histories_recovery_status', ['recoveryStatus'])
@Index('idx_injury_histories_deleted_at', ['deletedAt'])
@Entity('injury_histories')
export class InjuryHistory {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'member_id' })
  memberId: string;

  @ManyToOne(() => Member, (member) => member.injuries, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'member_id' })
  member: Member;

  @Column({ name: 'injury_type', length: 255 })
  injuryType: string;

  @Column({ name: 'body_part', length: 255 })
  bodyPart: string;

  @Column({ type: 'date' })
  date: Date;

  @Column({
    type: 'enum',
    enum: Severity,
  })
  severity: Severity;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({
    type: 'enum',
    enum: RecoveryStatus,
    name: 'recovery_status',
  })
  recoveryStatus: RecoveryStatus;

  @OneToMany(() => InjuryRestriction, (restriction) => restriction.injury)
  restrictions: InjuryRestriction[];

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', nullable: true })
  deletedAt?: Date;
}

