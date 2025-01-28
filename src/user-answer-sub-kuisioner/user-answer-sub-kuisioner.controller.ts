import {
  Controller,
  Post,
  Body,
  Param,
  UseGuards,
  ParseUUIDPipe,
  HttpStatus,
} from '@nestjs/common';
import { UserAnswerSubKuisionerService } from './user-answer-sub-kuisioner.service';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { UserId } from 'src/user/decorator/userId.decorator';
import { CreateUserAnswerSubKuisionerDTO } from './dto/request/create-user-answer-sub-kuisioner.dto';
import { ResponseApi } from 'src/common/response/responseApi.format';

@Controller({ path: 'take/subKuisioner', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class UserAnswerSubKuisionerController {
  constructor(
    private readonly userAnswerSubKuisionerService: UserAnswerSubKuisionerService,
  ) {}

  @Post(':takeKuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async create(
    @Param('takeKuisionerId', new ParseUUIDPipe()) takeKuisionerId: string,
    @UserId() userId: string,
    @Body() createUserAnswerSubKuisionerDto: CreateUserAnswerSubKuisionerDTO,
  ): Promise<ResponseApi<any>> {
    const data = await this.userAnswerSubKuisionerService.create(
      takeKuisionerId,
      createUserAnswerSubKuisionerDto,
      userId,
    );

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully take sub Kuisioner and save Answer',
      data,
    );
  }
}
