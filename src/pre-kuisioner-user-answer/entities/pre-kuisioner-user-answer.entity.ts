import { PreKuisionerAnswer } from "src/pre-kuisioner-answer/entities/pre-kuisioner-answer.entity";
import { PreKuisionerUser } from "src/pre-kuisioner-user/entities/pre-kuisioner-user.entity";
import { Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";


@Entity('pre_kuisioner_user_answer')
export class PreKuisionerUserAnswer {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @ManyToOne(() => PreKuisionerUser, (preKuisionerUser) => preKuisionerUser.preKuisionerUserAnswer,{onDelete:'CASCADE',onUpdate:'CASCADE'})
    preKuisionerUser: PreKuisionerUser

    @ManyToOne(() => PreKuisionerAnswer, (preKuisionerAnswer) => preKuisionerAnswer.preKuisionerUserAnswer,{onDelete:'CASCADE',onUpdate:'CASCADE'})
    preKuisionerAnswer: PreKuisionerAnswer

}
