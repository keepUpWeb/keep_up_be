import { IsNotEmpty, IsString, IsUUID, Length } from 'class-validator';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';
import { LoginRequestDTO } from './loginRequest.dto';

export class RegisterRequestDTO extends LoginRequestDTO {
  @IsString({ message: 'Username must be a string' })
  @IsNotEmpty({ message: 'Username is required' })
  @Length(3, 50, { message: 'Username must be between 3 and 50 characters' })
  @isNotBlank({ message: 'Username cannot be blank' })
  username: string;

  @IsNotEmpty({ message: 'Password confirmation is required' })
  @isNotBlank({ message: 'Password confirmation cannot be blank' })
  retypedpassword: string;

  
}
