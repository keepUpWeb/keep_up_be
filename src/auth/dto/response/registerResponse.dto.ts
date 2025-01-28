import { LoginResponseDTO } from './loginResponse.dto';

export class RegisterResponseDTO extends LoginResponseDTO {
  created_at: Date;
}
