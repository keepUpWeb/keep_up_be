import { PreKuisionerQuestion } from 'src/pre-kuisioner-question/entities/pre-kuisioner-question.entity';
import {
    Column,
    PrimaryGeneratedColumn,
    Entity,
    OneToMany,
} from 'typeorm';

@Entity('pre_kuisioner_category')
export class PreKuisionerCategory {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ type: 'varchar', nullable: false })
    name: string


    @OneToMany(() => PreKuisionerQuestion, (preKuisionerQuestion) => preKuisionerQuestion.category)
    preKuisionerQuestion: PreKuisionerQuestion[]


}
