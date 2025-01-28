import { PartialType } from '@nestjs/mapped-types';
import { CreatePreKuisionerQuestionDto } from './create-pre-kuisioner-question.dto';

export class UpdatePreKuisionerQuestionDto extends PartialType(CreatePreKuisionerQuestionDto) {}
