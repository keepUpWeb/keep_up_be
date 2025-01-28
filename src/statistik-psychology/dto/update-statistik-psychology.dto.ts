import { PartialType } from '@nestjs/mapped-types';
import { CreateStatistikPsychologyDto } from './create-statistik-psychology.dto';

export class UpdateStatistikPsychologyDto extends PartialType(CreateStatistikPsychologyDto) {}
