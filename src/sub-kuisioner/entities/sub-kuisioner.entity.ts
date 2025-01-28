import { Kuisioner } from 'src/kuisioner/entity/kuisioner.entity';
import { Question } from 'src/questions/entities/question.entity';
import { Symtomp } from 'src/symtomps/entities/symtomp.entity';
import {
  Column,
  CreateDateColumn,
  Entity,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('subkuisioners')
export class SubKuisioner {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'title', nullable: false, type: 'varchar', length: 255 })
  title: string;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  @ManyToOne(() => Symtomp, (symtomp) => symtomp.subKuisioners, {
    cascade: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  symtompId: Symtomp;

  @ManyToOne(() => Kuisioner, (kuisioner) => kuisioner.id, {
    cascade: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  kuisionerId: Kuisioner;

  @OneToMany(() => Question, (question) => question.subKuisionerId)
  questions: Question[];
}
