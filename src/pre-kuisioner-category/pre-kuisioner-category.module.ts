import { Module } from '@nestjs/common';
import { PreKuisionerCategoryService } from './pre-kuisioner-category.service';
import { PreKuisionerCategoryController } from './pre-kuisioner-category.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PreKuisionerCategory } from './entities/pre-kuisioner-category.entity';

@Module({
  imports: [TypeOrmModule.forFeature([PreKuisionerCategory]),],
  controllers: [PreKuisionerCategoryController],
  providers: [PreKuisionerCategoryService],
  exports:[PreKuisionerCategoryService]
})
export class PreKuisionerCategoryModule { }
