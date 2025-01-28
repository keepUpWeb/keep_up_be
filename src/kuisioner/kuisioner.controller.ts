import {
  Body,
  Controller,
  Delete,
  Get,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { KuisionerService } from './kuisioner.service';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { Kuisioner } from './entity/kuisioner.entity';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { CreateKuisionerDTO } from './dto/request/createKuisioner.dto';
import { UpdateKuisionerDTO } from './dto/request/updateKuisioner.dto';

@Controller({ path: 'kuisioner', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class KuisionerController {
  constructor(private readonly kuisionerService: KuisionerService) {}

  @Get()
  @IsVerificationRequired(true)
  @Roles(ROLES.USER, ROLES.ADMIN, ROLES.SUPERADMIN)
  async getAllKuisionerController(): Promise<ResponseApi<Kuisioner[]>> {
    const payload = await this.kuisionerService.getAllKuisioner();
    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get All Kuisioner',
      payload,
    );
  }

  @Get(':kuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER, ROLES.ADMIN, ROLES.SUPERADMIN)
  async getOneKuisionerController(
    @Param('kuisionerId', new ParseUUIDPipe()) kuisionerId: string,
  ): Promise<ResponseApi<Kuisioner>> {
    const payload =
      await this.kuisionerService.getOneKuisionerById(kuisionerId);
    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Kuisioner',
      payload,
    );
  }

  @Post()
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async createKuisionerController(
    @Body() createKuisionerDTO: CreateKuisionerDTO,
  ): Promise<ResponseApi<string>> {
      await this.kuisionerService.createKuisioner(createKuisionerDTO);
    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Kuisioner',
      'berhasil',
    );
  }

  @Patch(':kuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async updateKuisionerController(
    @Param('kuisionerId', new ParseUUIDPipe()) kuisionerId: string,
    @Body() updateKuisionerDTO: UpdateKuisionerDTO,
  ): Promise<ResponseApi<Kuisioner>> {
    const payload = await this.kuisionerService.updateKuisioner(
      kuisionerId,
      updateKuisionerDTO,
    );
    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Kuisioner',
      payload,
    );
  }

  @Delete(':kuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  remove(@Param('kuisionerId', new ParseUUIDPipe()) kuisionerId: string) {
    return this.kuisionerService.remove(kuisionerId);
  }
}
