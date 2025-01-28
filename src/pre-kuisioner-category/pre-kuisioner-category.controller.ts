import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, HttpStatus } from '@nestjs/common';
import { PreKuisionerCategoryService } from './pre-kuisioner-category.service';
import { CreatePreKuisionerCategoryDto } from './dto/create-pre-kuisioner-category.dto';
import { UpdatePreKuisionerCategoryDto } from './dto/update-pre-kuisioner-category.dto';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ResponseApi } from 'src/common/response/responseApi.format';

@Controller({ path: 'pre-kuisioner/category', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class PreKuisionerCategoryController {
  constructor(private readonly preKuisionerCategoryService: PreKuisionerCategoryService) { }

  @Post()
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async create(@Body() createPreKuisionerCategoryDto: CreatePreKuisionerCategoryDto) {
    const responsePayload = await this.preKuisionerCategoryService.create(createPreKuisionerCategoryDto);

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Created Category Pre Kuisioner',
      responsePayload,
    );
  }

  @Get()
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async findAll() {
    const responsePayload = await this.preKuisionerCategoryService.findAll();

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully get ALl Category Pre Kuisioner',
      responsePayload,
    );
  }

  @Get(':id')
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async findOne(@Param('id') id: string) {
    const responsePayload = await this.preKuisionerCategoryService.findOne(id);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully get One Category Pre Kuisioner',
      responsePayload,
    );
  }

  // @Patch(':id')
  // update(@Param('id') id: string, @Body() updatePreKuisionerCategoryDto: UpdatePreKuisionerCategoryDto) {
  //   return this.preKuisionerCategoryService.update(+id, updatePreKuisionerCategoryDto);
  // }

  // @Delete(':id')
  // remove(@Param('id') id: string) {
  //   return this.preKuisionerCategoryService.remove(+id);
  // }
}
