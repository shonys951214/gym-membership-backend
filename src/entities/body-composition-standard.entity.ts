import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';

@Index('idx_body_composition_standards_gender_age', ['gender', 'ageMin', 'ageMax'])
@Index('idx_body_composition_standards_active', ['isActive'], { where: 'is_active = true' })
@Entity('body_composition_standards')
export class BodyCompositionStandard {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 10 })
  gender: 'MALE' | 'FEMALE';

  @Column({ name: 'age_min', type: 'int' })
  ageMin: number;

  @Column({ name: 'age_max', type: 'int' })
  ageMax: number;

  @Column({ name: 'body_fat_percentage_min', type: 'decimal', precision: 5, scale: 2 })
  bodyFatPercentageMin: number;

  @Column({ name: 'body_fat_percentage_max', type: 'decimal', precision: 5, scale: 2 })
  bodyFatPercentageMax: number;

  @Column({ name: 'muscle_mass_percentage_min', type: 'decimal', precision: 5, scale: 2 })
  muscleMassPercentageMin: number;

  @Column({ length: 50, default: 'v1' })
  version: string;

  @Column({ name: 'is_active', type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
