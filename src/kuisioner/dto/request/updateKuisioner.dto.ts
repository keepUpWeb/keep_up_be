import { PartialType } from '@nestjs/mapped-types';
import { CreateKuisionerDTO } from './createKuisioner.dto';

export class UpdateKuisionerDTO extends PartialType(CreateKuisionerDTO) {}
