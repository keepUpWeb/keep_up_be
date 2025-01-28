import { PreKuisionerUserAnswer } from 'src/pre-kuisioner-user-answer/entities/pre-kuisioner-user-answer.entity';
import { User } from 'src/user/entities/user.entity';
import {
    Column,
    CreateDateColumn,
    PrimaryGeneratedColumn,
    Entity,
    OneToOne,
    OneToMany,
} from 'typeorm';

@Entity('pre_kuisioner_user')
export class PreKuisionerUser {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ type: 'boolean', default: false, nullable: false })
    isFinish: boolean;


    @CreateDateColumn({ type: 'timestamp' })
    createdAt: Date;

    @OneToOne(() => User, (user) => user.preKuisioner,{onDelete:'CASCADE',onUpdate:'CASCADE'})
    user: User;

    @OneToMany(() => PreKuisionerUserAnswer, (preKuisionerUserAnswer) => preKuisionerUserAnswer.preKuisionerUser)
    preKuisionerUserAnswer: PreKuisionerUserAnswer[]

}
