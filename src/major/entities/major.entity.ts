import { Faculty } from 'src/facultys/entities/faculty.entity';
import { User } from 'src/user/entities/user.entity';
import { Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';

@Entity('majors')
export class Major {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ nullable: false, type: 'varchar', length: 255 })
  name: string;

  @OneToMany(() => User, (user) => user.major, { cascade: true })
  users: User[];

  @ManyToOne(() => Faculty, (faculty) => faculty.majors, { nullable: false })
  faculty: Faculty; // Each Major belongs to one Faculty

  
}
