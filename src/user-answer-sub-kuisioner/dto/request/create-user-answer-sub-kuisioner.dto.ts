import { Type } from 'class-transformer';
import { IsArray, IsNotEmpty, ValidateNested } from 'class-validator';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';
import { CreateUserAnswerKuisionerDto } from 'src/user-answer-kuisioner/dto/create-user-answer-kuisioner.dto';

export class CreateUserAnswerSubKuisionerDTO {
  @IsNotEmpty({ message: 'subKuisionerId is required' })
  @isNotBlank({ message: 'subKuisionerId cannot be blank' })
  subKuisionerId: string;

  @IsArray({ message: 'userAnswers must be an array' }) // Ensures that userAnswers is an array
  @ValidateNested({ each: true }) // Tells the validator to validate each element in the array
  @Type(() => CreateUserAnswerKuisionerDto) // Ensures the proper type transformation
  userAnswers: CreateUserAnswerKuisionerDto[];
}
