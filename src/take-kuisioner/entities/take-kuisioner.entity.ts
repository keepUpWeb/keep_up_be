import { Kuisioner } from 'src/kuisioner/entity/kuisioner.entity';
import { UserAnswerSubKuisioner } from 'src/user-answer-sub-kuisioner/entities/user-answer-sub-kuisioner.entity';
import { User } from 'src/user/entities/user.entity';
import {
  Column,
  CreateDateColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  Entity,
} from 'typeorm';

@Entity()
export class TakeKuisioner {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'boolean', default: false, nullable: false })
  isFinish: boolean;

  @Column({ type: 'text', nullable: true })
  report: string;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @ManyToOne(() => Kuisioner, (kuisioner) => kuisioner.id, {
    cascade: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  kuisioner: Kuisioner;

  @ManyToOne(() => User, (user) => user.id, {
    cascade: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  user: User;

  @OneToMany(
    () => UserAnswerSubKuisioner,
    (userAnswerSubKuisioner) => userAnswerSubKuisioner.takeKuisioner,
  )
  userAnswerSubKuisioner: UserAnswerSubKuisioner[];
}
