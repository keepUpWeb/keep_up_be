import { Auth } from 'src/auth/entities/auth.entity';
import { ClientPsychologist } from 'src/client_psychologist/entities/client_psychologist.entity';
import { Faculty } from 'src/facultys/entities/faculty.entity';
import { Role } from 'src/roles/entities/role.entity';
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  JoinColumn,
} from 'typeorm';
import { PsikologiStatus } from '../../pyschology/group/psikologiStatus.enum';
import { PreKuisionerUser } from 'src/pre-kuisioner-user/entities/pre-kuisioner-user.entity';
import { SummaryKuisioner } from 'src/sumary_kuisioner/entity/summary-kuisioner.entity';
import { Major } from 'src/major/entities/major.entity';

@Entity('userEminds')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', unique: true })
  email: string;

  @Column({ type: 'varchar' })
  username: string;

  @Column({ type: 'varchar', select: false })
  password: string;

  @Column({ type: 'varchar', nullable: true })
  nim: string;

  @Column({ type: 'date', nullable: true })
  birthDate: Date;

  @Column({ type: 'integer', nullable: true })
  yearEntry: number;

  @ManyToOne(() => Role, (role) => role.users, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  role: Role;

  @OneToOne(() => Auth, (auth) => auth.users)
  @JoinColumn() // Creates the foreign key in the User table
  auth: Auth;

  @OneToOne(() => PreKuisionerUser, (preKuisionerUser) => preKuisionerUser.user)
  @JoinColumn() // Creates the foreign key in the User table
  preKuisioner: PreKuisionerUser;

  @CreateDateColumn({ type: 'timestamp' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updatedAt: Date;

  @ManyToOne(() => Faculty, (faculty) => faculty.users, {
    nullable: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  }) // Assuming a Faculty entity
  faculty: Faculty;

  @ManyToOne(() => Major, (major) => major.users, {
    nullable: true,
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  }) // Assuming a Faculty entity
  major: Major;

  @Column({
    type: 'enum',
    enum: ['Laki-Laki', 'Perempuan'],
    nullable: true,
  })
  gender: 'Laki-Laki' | 'Perempuan';

  // Field to indicate the status of psychologist account approval
  @Column({
    nullable: true,
    type: 'enum',
    enum: PsikologiStatus,
  })
  psikologStatus: PsikologiStatus; // Status for psychologist approval

  // Relation for psychologist having many clients
  @OneToMany(
    () => ClientPsychologist,
    (clientPsychologist) => clientPsychologist.psychologist,
  )
  psychologistClients: ClientPsychologist[]; // A psychologist can have many clients
  @OneToMany(
    () => ClientPsychologist,
    (clientPsychologist) => clientPsychologist.client,
  )
  userPsycholog: ClientPsychologist[]; // A psychologist can have many clients


  @OneToOne(() => SummaryKuisioner, (summaryKuisioner) => summaryKuisioner.user, { nullable: true })
  summaryKuisioner: SummaryKuisioner | null;
}
