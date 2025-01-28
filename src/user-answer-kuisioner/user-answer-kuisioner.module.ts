import { forwardRef, Module } from '@nestjs/common';
import { UserAnswerKuisionerService } from './user-answer-kuisioner.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserAnswerKuisioner } from './entities/user-answer-kuisioner.entity';
import { UserAnswerSubKuisionerModule } from 'src/user-answer-sub-kuisioner/user-answer-sub-kuisioner.module';
import { AnswersModule } from 'src/answers/answers.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([UserAnswerKuisioner]),
    AnswersModule,
    forwardRef(() => UserAnswerSubKuisionerModule),
  ],
  providers: [UserAnswerKuisionerService],
  exports: [UserAnswerKuisionerService],
})
export class UserAnswerKuisionerModule {}
