import { PartialType } from '@nestjs/mapped-types';
import { CreatePreKuisionerAnswerDto } from './create-pre-kuisioner-answer.dto';

export class UpdatePreKuisionerAnswerDto extends PartialType(CreatePreKuisionerAnswerDto) {}
