import { PartialType } from '@nestjs/mapped-types';
import {
  BodyCreateQuestionDto,
  CreateQuestionDto,
} from './create-question.dto';
import { Type } from 'class-transformer';
import { ValidateNested, IsArray, IsOptional } from 'class-validator';
import { CreateAnswerDto } from 'src/answers/dto/create-answer.dto';
import { UpdateAnswerDto } from 'src/answers/dto/update-answer.dto';

export class UpdateQuestionDto extends PartialType(CreateQuestionDto) {}

export class BodyUpdateQuestionDto extends PartialType(BodyCreateQuestionDto) {
  @ValidateNested({ each: true })
  @Type(() => UpdateAnswerDto)
  @IsArray()
  @IsOptional()
  updateAnswers: UpdateAnswerDto[];
}
