import { PartialType } from '@nestjs/mapped-types';
import { CreateClientPsychologistDto } from './create-client_psychologist.dto';

export class UpdateClientPsychologistDto extends PartialType(
  CreateClientPsychologistDto,
) {}
