import { PartialType } from '@nestjs/mapped-types';
import { CreatePreKuisionerCategoryDto } from './create-pre-kuisioner-category.dto';

export class UpdatePreKuisionerCategoryDto extends PartialType(CreatePreKuisionerCategoryDto) {}
