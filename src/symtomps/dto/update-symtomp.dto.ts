import { PartialType } from '@nestjs/mapped-types';
import { CreateSymtompDto } from './create-symtomp.dto';

export class UpdateSymtompDto extends PartialType(CreateSymtompDto) {}
