import { PartialType } from '@nestjs/mapped-types';
import { LoginResponseDTO } from './loginResponse.dto';

export class RefreshResponseDTO extends PartialType(LoginResponseDTO) {}
