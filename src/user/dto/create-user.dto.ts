import { Auth } from 'src/auth/entities/auth.entity';
import { Faculty } from 'src/facultys/entities/faculty.entity';
import {
  IsEmail,
  IsNotEmpty,
  IsString,
  IsInt,
  IsOptional,
  Length,
  IsEnum,
  IsDateString,
} from 'class-validator';
import { Gender } from 'src/common/group/gender.enum';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';
import { Role } from 'src/roles/entities/role.entity';
import { PreKuisionerUser } from 'src/pre-kuisioner-user/entities/pre-kuisioner-user.entity';

export class CreateUserDto {
  @IsEmail({}, { message: 'Invalid email format' })
  @IsNotEmpty({ message: 'Email is required' })
  @isNotBlank({ message: 'Email cannot be blank' })
  email: string;

  @IsString({ message: 'Username must be a string' })
  @IsNotEmpty({ message: 'Username is required' })
  @Length(3, 50, { message: 'Username must be between 3 and 50 characters' })
  @isNotBlank({ message: 'Username cannot be blank' })
  username: string;

  @IsString({ message: 'Password must be a string' })
  @IsNotEmpty({ message: 'Password is required' })
  @Length(8, 32, { message: 'Password must be between 8 and 32 characters' })
  @isNotBlank({ message: 'Password cannot be blank' })
  password: string;

  @IsNotEmpty({ message: 'auth is required' })
  auth: Auth;

  preKuisioner:PreKuisionerUser

  @IsNotEmpty({ message: 'role is required' })
  role: Role;
}
