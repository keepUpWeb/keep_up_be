import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { PreKuisionerAnswerService } from './pre-kuisioner-answer.service';
import { CreatePreKuisionerAnswerDto } from './dto/create-pre-kuisioner-answer.dto';
import { UpdatePreKuisionerAnswerDto } from './dto/update-pre-kuisioner-answer.dto';

@Controller('pre-kuisioner-answer')
export class PreKuisionerAnswerController {
  constructor(private readonly preKuisionerAnswerService: PreKuisionerAnswerService) {}

  // @Post()
  // create(@Body() createPreKuisionerAnswerDto: CreatePreKuisionerAnswerDto) {
  //   return this.preKuisionerAnswerService.create(createPreKuisionerAnswerDto);
  // }

  // @Get()
  // findAll() {
  //   return this.preKuisionerAnswerService.findAll();
  // }

  // @Get(':id')
  // findOne(@Param('id') id: string) {
  //   return this.preKuisionerAnswerService.findOne(+id);
  // }

  // @Patch(':id')
  // update(@Param('id') id: string, @Body() updatePreKuisionerAnswerDto: UpdatePreKuisionerAnswerDto) {
  //   return this.preKuisionerAnswerService.update(+id, updatePreKuisionerAnswerDto);
  // }

  // @Delete(':id')
  // remove(@Param('id') id: string) {
  //   return this.preKuisionerAnswerService.remove(+id);
  // }
}
