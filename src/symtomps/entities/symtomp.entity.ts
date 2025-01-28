import { SubKuisioner } from 'src/sub-kuisioner/entities/sub-kuisioner.entity';
import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';

@Entity('symtomps')
export class Symtomp {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'name', nullable: false, type: 'varchar', length: 255 })
  name: string;

  @OneToMany(() => SubKuisioner, (subkuisioner) => subkuisioner.symtompId)
  subKuisioners: SubKuisioner[];
}
