import { PreKuisionerAnswer } from "src/pre-kuisioner-answer/entities/pre-kuisioner-answer.entity";
import { PreKuisionerCategory } from "src/pre-kuisioner-category/entities/pre-kuisioner-category.entity";
import { Column, CreateDateColumn, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity('pre_kuisioner_question')
export class PreKuisionerQuestion {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ type: 'varchar', nullable: false })
    question: string

    @CreateDateColumn({ type: 'timestamp' })
    createdAt: Date;

    @UpdateDateColumn({ type: 'timestamp' })
    updateAt: Date

    @ManyToOne(() => PreKuisionerCategory, (preKuisionerCategory) => preKuisionerCategory.preKuisionerQuestion)
    category: PreKuisionerCategory


    @OneToMany(
        () => PreKuisionerAnswer,
        (preKuisionerAnswer) => preKuisionerAnswer.preQuestionId,
    )
    preKuisionerAnswer: PreKuisionerAnswer[];



    // @ManyToOne(() => User, (user) => user.id, {
    //     cascade: true,
    //     onDelete: 'CASCADE',
    //     onUpdate: 'CASCADE',
    //   })
    //   user: User;

}
