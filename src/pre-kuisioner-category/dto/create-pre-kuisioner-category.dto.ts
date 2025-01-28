import { IsNotEmpty, IsString } from "class-validator";
import { isNotBlank } from "src/common/validatorCustom/isNotBlank.validator";

export class CreatePreKuisionerCategoryDto {
    @IsString({ message: 'Invalid email format' })
    @IsNotEmpty({ message: 'Email is required' })
    @isNotBlank({ message: 'Email cannot be blank' })
    name: string;
}
