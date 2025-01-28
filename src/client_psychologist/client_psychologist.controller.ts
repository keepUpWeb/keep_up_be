import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  HttpStatus,
} from '@nestjs/common';
import { ClientPsychologistService } from './client_psychologist.service';
import { CreateClientPsychologistDto } from './dto/create-client_psychologist.dto';
import { UpdateClientPsychologistDto } from './dto/update-client_psychologist.dto';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { ClientPsychologist } from './entities/client_psychologist.entity';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { UserId } from 'src/user/decorator/userId.decorator';

@Controller({ path: 'client', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class ClientPsychologistController {
  constructor(
    private readonly clientPsychologistService: ClientPsychologistService,
  ) {}

  // @Post()
  // create(@Body() createClientPsychologistDto: CreateClientPsychologistDto) {
  //   return this.clientPsychologistService.create(createClientPsychologistDto);
  // }

  // @Get()
  // findAll() {
  //   return this.clientPsychologistService.findAll();
  // }

  @Get('psychology')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async findOne(
    @UserId() userId: string,
  ): Promise<ResponseApi<ClientPsychologist>> {
    const data = await this.clientPsychologistService.findOne(userId);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully get psychologist',
      data,
    );
  }

  @Get('psychology/admin')
  @IsVerificationRequired(true)
  @Roles(ROLES.ADMIN)
  async findOneAsPsychology(
    @UserId() userId: string,
  ): Promise<ResponseApi<ClientPsychologist[]>> {
    const data =
      await this.clientPsychologistService.findOneAsPsychology(userId);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully get client psychologist',
      data,
    );
  }
  @Get('superAdmin')
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async findOneAsSuperAdmin(): Promise<ResponseApi<ClientPsychologist[]>> {
    const data =
      await this.clientPsychologistService.findAll();

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully get client psychologist',
      data,
    );
  }


}
