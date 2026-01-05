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
import { MemberStatus } from '../common/enums';

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

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', nullable: true })
  deletedAt?: Date;
}

