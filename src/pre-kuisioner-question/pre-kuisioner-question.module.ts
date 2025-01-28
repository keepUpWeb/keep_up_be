import { Module } from '@nestjs/common';
import { PreKuisionerQuestionService } from './pre-kuisioner-question.service';
import { PreKuisionerQuestionController } from './pre-kuisioner-question.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PreKuisionerQuestion } from './entities/pre-kuisioner-question.entity';
import { PreKuisionerCategoryModule } from 'src/pre-kuisioner-category/pre-kuisioner-category.module';
import { PreKuisionerAnswerModule } from 'src/pre-kuisioner-answer/pre-kuisioner-answer.module';

@Module({
  imports: [TypeOrmModule.forFeature([PreKuisionerQuestion]), PreKuisionerCategoryModule, PreKuisionerAnswerModule],
  controllers: [PreKuisionerQuestionController],
  providers: [PreKuisionerQuestionService],
  exports:[PreKuisionerQuestionService]
})
export class PreKuisionerQuestionModule { }
