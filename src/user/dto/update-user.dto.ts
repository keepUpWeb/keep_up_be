import { PartialType } from '@nestjs/mapped-types';
import { CreateUserDto } from './create-user.dto';
import {
  IsDateString,
  IsEnum,
  IsInt,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Length,
} from 'class-validator';
import { isNotBlank } from 'src/common/validatorCustom/isNotBlank.validator';
import { Gender } from 'src/common/group/gender.enum';
import { Faculty } from 'src/facultys/entities/faculty.entity';
import { Major } from 'src/major/entities/major.entity';

export class UpdateUserDto extends PartialType(CreateUserDto) {
  @IsUUID('4', { message: 'Faculty Id Must be a UUID' })
  @IsOptional()
  facultyId: string;

  @IsUUID('4', { message: 'Major Id Must be a UUID' })
  @IsOptional()
  majorId: string;

  @IsString({ message: 'Nim must be a string' })
  @IsNotEmpty({ message: 'Nim is required' })
  @Length(2, 32, { message: 'Nim must be between 2 and 32 characters' })
  @isNotBlank({ message: 'Nim cannot be blank' })
  @IsOptional()
  nim: string;

  @IsNotEmpty({ message: 'Year of entry is required' })
  @IsInt({ message: 'Year of entry must be an integer' })
  @IsOptional()
  yearEntry: number;

  @IsNotEmpty({ message: 'Birth date is required' })
  @isNotBlank({ message: 'Birth date cannot be blank' })
  @IsDateString({}, { message: 'Birth date must be a valid date string' }) // Ensures it's a valid date string (ISO format)
  @IsOptional()
  birthDate: Date;

  @IsNotEmpty({ message: 'Faculty is required' })
  @IsOptional()
  faculty: Faculty;

  @IsNotEmpty({ message: 'Major is required' })
  @IsOptional()
  major: Major;

  @IsNotEmpty({ message: 'Gender is required' })
  @isNotBlank({ message: 'Gender cannot be blank' })
  @IsOptional()
  @IsEnum(Gender, {
    message: 'Gender must be either "Laki-Laki" or "Perempuan"',
  })
  gender: Gender;
}
