import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  Index,
} from 'typeorm';
import { Role } from '../common/enums';

@Index('idx_users_email', ['email'])
@Index('idx_users_provider_providerId', ['provider', 'providerId'])
@Index('idx_users_deleted_at', ['deletedAt'])
@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

	@Column({ unique: true, length: 255 })
	email: string;

	@Column({ length: 255, nullable: true })
	password: string;

	@Column({ length: 255 })
	name: string;

	@Column({ length: 50, nullable: true, default: 'LOCAL' })
	provider: string; // 'LOCAL', 'KAKAO', 'GOOGLE' 등

	@Column({ name: 'provider_id', length: 255, nullable: true })
	providerId: string; // 소셜 로그인 제공자의 사용자 ID

	@Column({ name: 'refresh_token', length: 500, nullable: true })
	refreshToken: string; // Refresh Token (DB에 저장)

  @Column({
    type: 'enum',
    enum: Role,
    default: Role.MEMBER,
  })
  role: Role;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', nullable: true })
  deletedAt?: Date;
}

