import { PartialType } from '@nestjs/mapped-types';
import { CreateSubKuisionerDto } from './create-sub-kuisioner.dto';

export class UpdateSubKuisionerDto extends PartialType(CreateSubKuisionerDto) {}
