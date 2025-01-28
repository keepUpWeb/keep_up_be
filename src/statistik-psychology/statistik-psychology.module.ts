import { forwardRef, Module } from '@nestjs/common';
import { StatistikPsychologyService } from './statistik-psychology.service';
import { StatistikPsychologyController } from './statistik-psychology.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from 'src/user/entities/user.entity';
import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';
import { RolesModule } from 'src/roles/roles.module';
import { SumaryKuisionerModule } from 'src/sumary_kuisioner/sumary_kuisioner.module';

@Module({
  imports: [TypeOrmModule.forFeature([User, TakeKuisioner]), RolesModule,forwardRef(() => SumaryKuisionerModule)],
  controllers: [StatistikPsychologyController],
  providers: [StatistikPsychologyService],
  exports:[StatistikPsychologyService]
})
export class StatistikPsychologyModule { }
