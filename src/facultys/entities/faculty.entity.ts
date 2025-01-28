import { Major } from 'src/major/entities/major.entity';
import { User } from 'src/user/entities/user.entity';
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';

@Entity('facultys')
export class Faculty {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: false, type: 'varchar', length: 255 })
  name: string;

  @OneToMany(() => User, (user) => user.faculty, { cascade: true })
  users: User[];

  @OneToMany(() => Major, (major) => major.faculty, { cascade: true })
  majors: Major[]; // One Faculty can have many Majors
}
