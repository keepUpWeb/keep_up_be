import { IsNotEmpty, IsOptional, IsUUID } from 'class-validator';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';
import { Kuisioner } from 'src/kuisioner/entity/kuisioner.entity';
import { Symtomp } from 'src/symtomps/entities/symtomp.entity';

export class CreateSubKuisionerDto {
  @IsNotEmpty({ message: 'title is required' })
  @isNotBlank({ message: 'title cannot be blank' })
  title: string;

  symtompId: Symtomp;

  kuisionerId: Kuisioner;
}

export class BodyCreateSubKuisionerDto {
  @IsNotEmpty({ message: 'title is required' })
  @isNotBlank({ message: 'title cannot be blank' })
  title: string;

  @IsNotEmpty({ message: 'Sytomp Id is required' })
  @isNotBlank({ message: 'Sytomp Id cannot be blank' })
  @IsUUID('4', { message: 'Invalid UUID format for Kuisioner ID' })
  symtompId: string;
}
