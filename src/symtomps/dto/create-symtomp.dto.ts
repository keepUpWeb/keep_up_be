import { IsNotEmpty } from 'class-validator';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';

export class CreateSymtompDto {
  @IsNotEmpty({ message: 'name confirmation is required' })
  @isNotBlank({ message: 'name confirmation cannot be blank' })
  name: string;
}
