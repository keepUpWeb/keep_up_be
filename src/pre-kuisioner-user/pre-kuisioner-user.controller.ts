import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, HttpStatus } from '@nestjs/common';
import { PreKuisionerUserService } from './pre-kuisioner-user.service';
import { CreatePreKuisionerUserDto } from './dto/create-pre-kuisioner-user.dto';
import { UpdatePreKuisionerUserDto } from './dto/update-pre-kuisioner-user.dto';
import { UserId } from 'src/user/decorator/userId.decorator';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { transformPreKuisionerUserAnswerFromEntity } from 'src/common/function/helper/preKuisionerUserProses.function';

@Controller({ path: 'pre-kuisioner/user', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class PreKuisionerUserController {
  constructor(private readonly preKuisionerUserService: PreKuisionerUserService) { }

  @Post()
  create(@Body() createPreKuisionerUserDto: CreatePreKuisionerUserDto) {
    return this.preKuisionerUserService.create(createPreKuisionerUserDto);
  }

  // @Get()
  // findAll() {
  //   return this.preKuisionerUserService.findAll();
  // }

  @Get()
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async findUserAnswerPreKuisioner(
    @UserId() id: string
  ) {
    const responsePayload = await this.preKuisionerUserService.findOne(id);

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Created Category Pre Kuisioner',
      transformPreKuisionerUserAnswerFromEntity(responsePayload),
    );


  }

  // @Get(':id')
  // findOne(@Param('id') id: string) {
  //   return this.preKuisionerUserService.findOne(+id);
  // }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updatePreKuisionerUserDto: UpdatePreKuisionerUserDto) {
    return this.preKuisionerUserService.update(+id, updatePreKuisionerUserDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.preKuisionerUserService.remove(+id);
  }
}
