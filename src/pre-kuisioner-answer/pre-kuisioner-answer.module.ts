import { Module } from '@nestjs/common';
import { PreKuisionerAnswerService } from './pre-kuisioner-answer.service';
import { PreKuisionerAnswerController } from './pre-kuisioner-answer.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PreKuisionerAnswer } from './entities/pre-kuisioner-answer.entity';

@Module({
  imports:[TypeOrmModule.forFeature([PreKuisionerAnswer])],
  controllers: [PreKuisionerAnswerController],
  providers: [PreKuisionerAnswerService],
  exports:[PreKuisionerAnswerService]
})
export class PreKuisionerAnswerModule {}
