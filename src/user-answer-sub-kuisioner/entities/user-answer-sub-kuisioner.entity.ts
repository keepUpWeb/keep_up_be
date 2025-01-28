import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';
import {
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  Entity,
} from 'typeorm';
import { Level } from '../group/level.enum';
import { SubKuisioner } from 'src/sub-kuisioner/entities/sub-kuisioner.entity';
import { UserAnswerKuisioner } from 'src/user-answer-kuisioner/entities/user-answer-kuisioner.entity';

@Entity()
export class UserAnswerSubKuisioner {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({
    type: 'enum',
    enum: Level,
    enumName: 'level_enum', // Optional: for defining the enum name in the database
    nullable: true,
  })
  level: Level;

  @Column({ type: 'int', nullable: true })
  score: number;

  @ManyToOne(() => SubKuisioner, (subKuisioner) => subKuisioner.id, {
    cascade: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  subKuisioner: SubKuisioner;

  @ManyToOne(
    () => TakeKuisioner,
    (takeKuisioner) => takeKuisioner.userAnswerSubKuisioner,
    {
      cascade: true,
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    },
  )
  takeKuisioner: TakeKuisioner;

  @OneToMany(
    () => UserAnswerKuisioner,
    (userAnswerKuisioner) => userAnswerKuisioner.userAnswerSubKuisioner,
  )
  userAnswerKuisioners: UserAnswerKuisioner[]; // Updated
}
