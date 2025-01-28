import { PartialType } from '@nestjs/mapped-types';
import { CreateTakeKuisionerDto } from './create-take-kuisioner.dto';

export class UpdateTakeKuisionerDto extends PartialType(
  CreateTakeKuisionerDto,
) {}
