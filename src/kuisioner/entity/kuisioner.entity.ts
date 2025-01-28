import { SubKuisioner } from 'src/sub-kuisioner/entities/sub-kuisioner.entity';
import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('kuisioners')
export class Kuisioner {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'title', nullable: false, type: 'varchar', length: 255 })
  title: string;

  @Column({ name: 'isActive', nullable: false, type: 'boolean' })
  isActive: boolean;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  @OneToMany(() => SubKuisioner, (subkuisioner) => subkuisioner.kuisionerId)
  subKuisioners: SubKuisioner[];
}
