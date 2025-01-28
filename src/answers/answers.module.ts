import { forwardRef, Module } from '@nestjs/common';
import { AnswersService } from './answers.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Answer } from './entities/answer.entity';
import { QuestionsModule } from 'src/questions/questions.module';
import { AnswersController } from './answers.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([Answer]),
    forwardRef(() => QuestionsModule),
  ],
  providers: [AnswersService],
  exports: [AnswersService],
  controllers: [AnswersController],
})
export class AnswersModule {}
