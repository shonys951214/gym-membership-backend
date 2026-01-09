import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Index('idx_flexibility_item_weights_item_name', ['itemName'])
@Index('idx_flexibility_item_weights_active', ['isActive'], { where: 'is_active = true' })
@Entity('flexibility_item_weights')
export class FlexibilityItemWeight {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'item_name', length: 100, unique: true })
  itemName: string; // 'shoulder', 'hip', 'sitAndReach', 'hamstring'

  @Column({ name: 'item_name_kr', length: 100 })
  itemNameKr: string; // '어깨 가동성', '고관절 가동성', '좌전굴', '햄스트링'

  @Column({ type: 'decimal', precision: 5, scale: 2 })
  weight: number; // 1.30, 1.20, 1.00, 0.80

  @Column({ length: 50, nullable: true })
  importance?: string; // '중요', '기준', '보조'

  @Column({ length: 50, default: 'v1' })
  version: string;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
