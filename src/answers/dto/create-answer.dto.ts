import { IsNotEmpty, IsString } from 'class-validator';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';

export class CreateAnswerDto {
  @IsString({ message: 'answer must be a string' })
  @IsNotEmpty({ message: 'answer is required' })
  @isNotBlank({ message: 'answer cannot be blank' })
  answer: string;

  @IsNotEmpty({ message: 'score is required' }) // Add validation for score
  score: number;
}
