import { PreKuisionerQuestion } from "src/pre-kuisioner-question/entities/pre-kuisioner-question.entity";
import { PreKuisionerUserAnswer } from "src/pre-kuisioner-user-answer/entities/pre-kuisioner-user-answer.entity";
import { Column, CreateDateColumn, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";


@Entity('pre_kuisioner_answer')
export class PreKuisionerAnswer {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ type: 'varchar', nullable: false })
    answer: string

    @CreateDateColumn({ type: 'timestamp' })
    createdAt: Date;

    @UpdateDateColumn({ type: 'timestamp' })
    updateAt: Date

    @ManyToOne(() => PreKuisionerQuestion, (PreKuisionerQuestion) => PreKuisionerQuestion.preKuisionerAnswer)
    preQuestionId: PreKuisionerQuestion

    @OneToMany(() => PreKuisionerUserAnswer, (preKuisionerUserAnswer) => preKuisionerUserAnswer.preKuisionerAnswer)
    preKuisionerUserAnswer: PreKuisionerUserAnswer[]

}
