// user-profile.dto.ts

export class UserProfileDto {
  id: string;
  email: string;
  username: string;
  nim: string;
  yearEntry: number;
  gender: string;
  birthDate?: Date | null;
}
