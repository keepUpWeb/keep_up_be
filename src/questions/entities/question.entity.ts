import { Answer } from 'src/answers/entities/answer.entity';
import { SubKuisioner } from 'src/sub-kuisioner/entities/sub-kuisioner.entity';
import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('questions')
export class Question {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'question', type: 'text', nullable: false })
  question: string;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  @ManyToOne(() => SubKuisioner, (subKuisioner) => subKuisioner.id, {
    cascade: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  subKuisionerId: SubKuisioner;

  @OneToMany(() => Answer, (answer) => answer.questionId)
  answers: Answer[];
}
