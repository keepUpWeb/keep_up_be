import { IsNotEmpty } from "class-validator";
import { isNotBlank } from "src/common/validatorCustom/isNotBlank.validator";

export class CreateMajorDTO {
  @isNotBlank()
  @IsNotEmpty()
  name: string;

  // @isNotBlank()
  // @IsNotEmpty()
  // facultyId: string;
}
