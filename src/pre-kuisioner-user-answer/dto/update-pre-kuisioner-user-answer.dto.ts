import { PartialType } from '@nestjs/mapped-types';
import { CreatePreKuisionerUserAnswerDto } from './create-pre-kuisioner-user-answer.dto';

export class UpdatePreKuisionerUserAnswerDto extends PartialType(CreatePreKuisionerUserAnswerDto) {}
