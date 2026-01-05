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

@Index('idx_pt_usages_member_id', ['memberId'])
@Entity('pt_usages')
export class PTUsage {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'member_id' })
  memberId: string;

  @ManyToOne(() => Member, (member) => member.ptUsages, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'member_id' })
  member: Member;

  @Column({ type: 'int', name: 'total_count', default: 0 })
  totalCount: number;

  @Column({ type: 'int', name: 'remaining_count', default: 0 })
  remainingCount: number;

  @Column({ type: 'int', name: 'used_count', default: 0 })
  usedCount: number;

  @Column({ type: 'date', name: 'last_used_date', nullable: true })
  lastUsedDate?: Date;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}

