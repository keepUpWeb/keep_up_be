import { IsNotEmpty } from 'class-validator';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';

export class CreateUserAnswerKuisionerDto {
  @IsNotEmpty({ message: 'subKuisionerId is required' })
  @isNotBlank({ message: 'subKuisionerId cannot be blank' })
  answerId: string;
}
