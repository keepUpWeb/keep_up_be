import { IsString, IsNotEmpty } from "class-validator";
import { isNotBlank } from "src/common/validatorCustom/isNotBlank.validator";

export class CreatePreKuisionerAnswerDto {
    @IsString({ message: 'answer must be a string' })
    @IsNotEmpty({ message: 'answer is required' })
    @isNotBlank({ message: 'answer cannot be blank' })
    answer: string;

}
