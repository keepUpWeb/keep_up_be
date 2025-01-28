import { PartialType } from '@nestjs/mapped-types';
import { CreatePreKuisionerUserDto } from './create-pre-kuisioner-user.dto';

export class UpdatePreKuisionerUserDto extends PartialType(CreatePreKuisionerUserDto) {}
