import { IsBoolean, IsNotEmpty } from 'class-validator';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';

export class CreateKuisionerDTO {
  @IsNotEmpty({ message: 'title is required' })
  @isNotBlank({ message: 'title cannot be blank' })
  title: string;

  @IsBoolean({ message: 'isActive must be a boolean' })
  isActive: boolean;
}
