import { Question } from 'src/questions/entities/question.entity';
import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';

@Entity('answers')
export class Answer {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'answer', type: 'text', nullable: false })
  answer: string;

  @Column({ name: 'score', type: 'int', nullable: false })
  score: number;

  @ManyToOne(() => Question, (question) => question.id, {
    cascade: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  questionId: Question;
}
