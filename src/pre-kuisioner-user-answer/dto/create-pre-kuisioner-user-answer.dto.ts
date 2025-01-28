import { IsUUID, IsArray, ValidateNested } from "class-validator";
import { Type } from "class-transformer";

export class CreatePreKuisionerUserAnswerDto {
    @IsUUID('4')
    id_answer: string;
}

export class BodyCreatePreKuisionerUserAnswerDto {
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => CreatePreKuisionerUserAnswerDto)
    preKuisionerAnswers: CreatePreKuisionerUserAnswerDto[];
}
