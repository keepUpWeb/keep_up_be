import { forwardRef, Module } from '@nestjs/common';
import { StatistikSuperadminService } from './statistik-superadmin.service';
import { StatistikSuperadminController } from './statistik-superadmin.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';
import { User } from 'src/user/entities/user.entity';
import { RolesModule } from 'src/roles/roles.module';
import { SumaryKuisionerModule } from 'src/sumary_kuisioner/sumary_kuisioner.module';

@Module({
  imports: [TypeOrmModule.forFeature([TakeKuisioner,User]), RolesModule,  forwardRef(() => SumaryKuisionerModule)],
  providers: [StatistikSuperadminService],
  controllers: [StatistikSuperadminController],
  exports:[StatistikSuperadminService]
})
export class StatistikSuperadminModule {}
