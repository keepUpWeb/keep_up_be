import { PartialType } from '@nestjs/mapped-types';
import { CreatePyschologyDto } from './create-pyschology.dto';
import { PsikologiStatus } from '../group/psikologiStatus.enum';

export class UpdatePyschologyDto extends PartialType(CreatePyschologyDto) {
  status: PsikologiStatus;
}
