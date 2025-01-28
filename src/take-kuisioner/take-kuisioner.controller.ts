import {
  Controller,
  Get,
  Post,
  Param,
  UseGuards,
  ParseUUIDPipe,
  HttpStatus,
} from '@nestjs/common';
import { TakeKuisionerService } from './take-kuisioner.service';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { UserId } from 'src/user/decorator/userId.decorator';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { CreateTakeKuisionerResponseDTO } from './dto/response/create-kuisioner-response.dto';
import { TakeKuisioner } from './entities/take-kuisioner.entity';

@Controller({ path: 'take/kuisioner', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class TakeKuisionerController {
  constructor(private readonly takeKuisionerService: TakeKuisionerService) { }

  @Post(':kuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async createTakeKuisioner(
    @Param('kuisionerId', new ParseUUIDPipe()) kuisionerId: string,
    @UserId() userId: string,
  ): Promise<ResponseApi<CreateTakeKuisionerResponseDTO>> {
    const newTakeKuisionerId = await this.takeKuisionerService.create(
      kuisionerId,
      userId,
    );

    const responsePayload = new CreateTakeKuisionerResponseDTO();
    responsePayload.id_takeKuisioner = newTakeKuisionerId.id_takeKuisioner;
    responsePayload.createdAt = newTakeKuisionerId.createdAt

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Created Take Kuisioner',
      responsePayload,
    );
  }

  @Get(':kuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async getTakeKuisioner(
    @Param('kuisionerId', new ParseUUIDPipe()) kuisionerId: string,
    @UserId() userId: string,
  ): Promise<ResponseApi<TakeKuisioner>> {
    const takeKuisionerData = await this.takeKuisionerService.findOne(
      userId,
      kuisionerId,
    );

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Fetched Take Kuisioner',
      takeKuisionerData,
    );
  }

  @Post('result/:kuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async resyltTakeKuisioner(
    @Param('kuisionerId', new ParseUUIDPipe()) kuisionerId: string,
    @UserId() userId: string,
  ): Promise<ResponseApi<CreateTakeKuisionerResponseDTO>> {
    const newTakeKuisionerId = await this.takeKuisionerService.createResult(
      kuisionerId,
      userId,
    );

    const responsePayload = new CreateTakeKuisionerResponseDTO();
    responsePayload.id_takeKuisioner = newTakeKuisionerId.id_takeKuisioner;
    responsePayload.createdAt = newTakeKuisionerId.createdAt;
    responsePayload.report = newTakeKuisionerId.report

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Created Result Take Kuisioner',
      newTakeKuisionerId,
    );
  }


  @Get('history/user')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async getKuisionerHistory(
    @UserId() userId: string,
  ): Promise<ResponseApi<TakeKuisioner[]>> {
    const kuisionerHistory = await this.takeKuisionerService.findHistory(userId);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Fetched Kuisioner History',
      kuisionerHistory,
    );
  }

  @Get('latest/user')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async getLatestKuisioner(
    @UserId() userId: string,
  ): Promise<ResponseApi<TakeKuisioner>> {
    const latestTakeKuisioner =
      await this.takeKuisionerService.findLatest(userId);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Fetched Latest Take Kuisioner',
      latestTakeKuisioner,
    );
  }
}
