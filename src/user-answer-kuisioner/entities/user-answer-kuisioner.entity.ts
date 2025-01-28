import { Answer } from 'src/answers/entities/answer.entity';
import { UserAnswerSubKuisioner } from 'src/user-answer-sub-kuisioner/entities/user-answer-sub-kuisioner.entity';
import { ManyToOne, PrimaryGeneratedColumn, Entity } from 'typeorm';

@Entity()
export class UserAnswerKuisioner {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(
    () => UserAnswerSubKuisioner,
    (userAnswerSubKuisioner) => userAnswerSubKuisioner.userAnswerKuisioners, // Updated
    {
      cascade: true,
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
  )
  userAnswerSubKuisioner: UserAnswerSubKuisioner;

  @ManyToOne(() => Answer, (answer) => answer.id, {
    // Updated
    cascade: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  answer: Answer;
}
