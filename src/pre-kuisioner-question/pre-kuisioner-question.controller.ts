import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe, UseGuards, HttpStatus } from '@nestjs/common';
import { PreKuisionerQuestionService } from './pre-kuisioner-question.service';
import { CreatePreKuisionerQuestionDto } from './dto/create-pre-kuisioner-question.dto';
import { UpdatePreKuisionerQuestionDto } from './dto/update-pre-kuisioner-question.dto';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { ResponseApi } from 'src/common/response/responseApi.format';

@Controller({ path: 'pre-kuisioner/question', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class PreKuisionerQuestionController {
  constructor(private readonly preKuisionerQuestionService: PreKuisionerQuestionService) { }

  @Post()
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async create(@Body() createPreKuisionerQuestionDto: CreatePreKuisionerQuestionDto) {
    const responsePayload = await this.preKuisionerQuestionService.create(createPreKuisionerQuestionDto);


    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Created Category Pre Kuisioner',
      responsePayload,
    );
  }

  @Get()
  @IsVerificationRequired(true)
  @Roles(ROLES.USER, ROLES.SUPERADMIN)
  async findAll() {


    const responsePayload = await this.preKuisionerQuestionService.findAll();


    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Created Category Pre Kuisioner',
      responsePayload,
    );
  }

  @Get(':id_category')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER, ROLES.SUPERADMIN)
  async findOne(@Param('id_category', new ParseUUIDPipe()) id: string) {
    const responsePayload = await this.preKuisionerQuestionService.findOne(id);


    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Created Category Pre Kuisioner',
      responsePayload,
    );
  }

  // @Patch(':id')
  // update(@Param('id') id: string, @Body() updatePreKuisionerQuestionDto: UpdatePreKuisionerQuestionDto) {
  //   return this.preKuisionerQuestionService.update(+id, updatePreKuisionerQuestionDto);
  // }

  // @Delete(':id')
  // remove(@Param('id') id: string) {
  //   return this.preKuisionerQuestionService.remove(+id);
  // }
}
