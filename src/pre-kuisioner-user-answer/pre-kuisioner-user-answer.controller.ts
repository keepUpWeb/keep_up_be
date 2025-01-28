import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, ParseUUIDPipe, HttpStatus } from '@nestjs/common';
import { PreKuisionerUserAnswerService } from './pre-kuisioner-user-answer.service';
import { BodyCreatePreKuisionerUserAnswerDto, } from './dto/create-pre-kuisioner-user-answer.dto';
import { UpdatePreKuisionerUserAnswerDto } from './dto/update-pre-kuisioner-user-answer.dto';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { UserId } from 'src/user/decorator/userId.decorator';

@Controller({ path: 'pre-kuisioner/user/answer', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class PreKuisionerUserAnswerController {
  constructor(private readonly preKuisionerUserAnswerService: PreKuisionerUserAnswerService) { }

  @Post()
  @IsVerificationRequired(true)
  @Roles(ROLES.USER)
  async create(@UserId() id:string, @Body() createPreKuisionerUserAnswerDto: BodyCreatePreKuisionerUserAnswerDto) {
    const responsePayload = await this.preKuisionerUserAnswerService.create(id, createPreKuisionerUserAnswerDto);

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Created Category Pre Kuisioner',
      responsePayload,
    );
  }

  // @Get()
  // findAll() {
  //   return this.preKuisionerUserAnswerService.findAll();
  // }

  // @Get(':id')
  // @IsVerificationRequired(true)
  // @Roles(ROLES.USER, ROLES.ADMIN)
  // findOne(@Param('id', ParseUUIDPipe) id: string) {
  //   return this.preKuisionerUserAnswerService.findOne(+id);
  // }

  // @Patch(':id')
  // update(@Param('id') id: string, @Body() updatePreKuisionerUserAnswerDto: UpdatePreKuisionerUserAnswerDto) {
  //   return this.preKuisionerUserAnswerService.update(+id, updatePreKuisionerUserAnswerDto);
  // }

  // @Delete(':id')
  // remove(@Param('id') id: string) {
  //   return this.preKuisionerUserAnswerService.remove(+id);
  // }
}
