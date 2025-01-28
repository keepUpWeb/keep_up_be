import { Module } from '@nestjs/common';
import { ClientPsychologistService } from './client_psychologist.service';
import { ClientPsychologistController } from './client_psychologist.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ClientPsychologist } from './entities/client_psychologist.entity';
import { PyschologyModule } from 'src/pyschology/pyschology.module';

@Module({
  imports: [TypeOrmModule.forFeature([ClientPsychologist]), PyschologyModule],
  controllers: [ClientPsychologistController],
  providers: [ClientPsychologistService],
  exports: [ClientPsychologistService],
})
export class ClientPsychologistModule {}
