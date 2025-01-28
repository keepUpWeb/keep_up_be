import { PartialType } from '@nestjs/mapped-types';
import { CreateUserAnswerKuisionerDto } from './create-user-answer-kuisioner.dto';

export class UpdateUserAnswerKuisionerDto extends PartialType(
  CreateUserAnswerKuisionerDto,
) {}
