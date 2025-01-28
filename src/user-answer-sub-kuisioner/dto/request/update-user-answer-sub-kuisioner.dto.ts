import { PartialType } from '@nestjs/mapped-types';
import { CreateUserAnswerSubKuisionerDTO } from './create-user-answer-sub-kuisioner.dto';

export class UpdateUserAnswerSubKuisionerDto extends PartialType(
  CreateUserAnswerSubKuisionerDTO,
) {}
