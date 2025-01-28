import { User } from 'src/user/entities/user.entity';
import { Entity, PrimaryGeneratedColumn, Column, OneToOne, JoinColumn, CreateDateColumn } from 'typeorm';

@Entity('summary_kuisioner')
export class SummaryKuisioner {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('text')
  sumarize: string;

  @Column('int', { default: 0 })
  kuisionerFinished: number;

  @CreateDateColumn()
  createdAt: Date;

  @OneToOne(() => User, (user) => user.summaryKuisioner, { onDelete: 'CASCADE', nullable: true })
  @JoinColumn({ name: 'user_id' }) // Join column for one-to-one relationship
  user: User;
}
