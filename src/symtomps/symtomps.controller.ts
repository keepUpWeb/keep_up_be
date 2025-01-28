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
import { SymtompsService } from './symtomps.service';
import { CreateSymtompDto } from './dto/create-symtomp.dto';
import { UpdateSymtompDto } from './dto/update-symtomp.dto';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { Symtomp } from './entities/symtomp.entity';

@Controller({ path: 'symtomp', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class SymtompsController {
  constructor(private readonly symtompsService: SymtompsService) {}

  @Post()
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async create(
    @Body() createSymtompDto: CreateSymtompDto,
  ): Promise<ResponseApi<Symtomp>> {
    const payload = await this.symtompsService.create(createSymtompDto);

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Add New Symtomp',
      payload,
    );
  }

  @Get()
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async findAll(): Promise<ResponseApi<Symtomp[]>> {
    const payload = await this.symtompsService.findAll();

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get All Symtomp',
      payload,
    );
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.symtompsService.findOneById(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateSymtompDto: UpdateSymtompDto) {
    return this.symtompsService.update(+id, updateSymtompDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.symtompsService.remove(+id);
  }
}
