import { Module } from '@nestjs/common';
import { PreKuisionerUserAnswerService } from './pre-kuisioner-user-answer.service';
import { PreKuisionerUserAnswerController } from './pre-kuisioner-user-answer.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PreKuisionerUserAnswer } from './entities/pre-kuisioner-user-answer.entity';
import { PreKuisionerAnswerModule } from 'src/pre-kuisioner-answer/pre-kuisioner-answer.module';
import { PreKuisionerUserModule } from 'src/pre-kuisioner-user/pre-kuisioner-user.module';
import { PreKuisionerQuestionModule } from 'src/pre-kuisioner-question/pre-kuisioner-question.module';

@Module({
  imports: [TypeOrmModule.forFeature([PreKuisionerUserAnswer]), PreKuisionerAnswerModule, PreKuisionerUserModule, PreKuisionerQuestionModule],
  controllers: [PreKuisionerUserAnswerController],
  providers: [PreKuisionerUserAnswerService],
  exports: [PreKuisionerUserAnswerService]
})
export class PreKuisionerUserAnswerModule { }
