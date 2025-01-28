import { forwardRef, Module } from '@nestjs/common';
import { QuestionsService } from './questions.service';
import { QuestionsController } from './questions.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Question } from './entities/question.entity';
import { SubKuisionerModule } from 'src/sub-kuisioner/sub-kuisioner.module';
import { AnswersModule } from 'src/answers/answers.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Question]),
    SubKuisionerModule,
    forwardRef(() => AnswersModule),
  ],

  controllers: [QuestionsController],
  providers: [QuestionsService],
  exports: [QuestionsService],
})
export class QuestionsModule {}
