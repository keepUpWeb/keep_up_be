import { Type } from "class-transformer";
import { IsArray, IsNotEmpty, IsString, IsUUID, ValidateNested } from "class-validator";
import { UUID } from "crypto";
import { isNotBlank } from "src/common/validatorCustom/isNotBlank.validator";
import { CreatePreKuisionerAnswerDto } from "src/pre-kuisioner-answer/dto/create-pre-kuisioner-answer.dto";

export class CreatePreKuisionerQuestionDto {
    @IsString()
    @IsNotEmpty()
    @isNotBlank()
    question: string

    @ValidateNested({ each: true })
    @Type(() => CreatePreKuisionerAnswerDto)
    @IsArray()
    answers: CreatePreKuisionerAnswerDto[];

    @IsUUID('4')
    preKuisionerCategoryId: UUID
}
