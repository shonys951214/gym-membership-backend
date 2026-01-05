import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { Member } from './member.entity';
import { MembershipType, MembershipStatus } from '../common/enums';

@Index('idx_memberships_member_id', ['memberId'])
@Index('idx_memberships_status', ['status'])
@Index('idx_memberships_expiry_date', ['expiryDate'])
@Entity('memberships')
export class Membership {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'member_id' })
  memberId: string;

  @ManyToOne(() => Member, (member) => member.memberships, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'member_id' })
  member: Member;

  @Column({
    type: 'enum',
    enum: MembershipType,
    name: 'membership_type',
  })
  membershipType: MembershipType;

  @Column({ type: 'date', name: 'purchase_date' })
  purchaseDate: Date;

  @Column({ type: 'date', name: 'expiry_date' })
  expiryDate: Date;

  @Column({
    type: 'enum',
    enum: MembershipStatus,
    default: MembershipStatus.ACTIVE,
  })
  status: MembershipStatus;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}

