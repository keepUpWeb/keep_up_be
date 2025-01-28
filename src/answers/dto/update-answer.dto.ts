import { PartialType } from '@nestjs/mapped-types';
import { CreateAnswerDto } from './create-answer.dto';
import { IsOptional, IsString } from 'class-validator';

export class UpdateAnswerDto extends PartialType(CreateAnswerDto) {
  @IsOptional()
  @IsString()
  id: string;
}
