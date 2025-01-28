import { forwardRef, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SummaryKuisionerService } from './summary-kuisioner.service';
import { SummaryKuisioner } from './entity/summary-kuisioner.entity';
import { StatistikPsychologyModule } from 'src/statistik-psychology/statistik-psychology.module';
import { StatistikSuperadminModule } from 'src/statistik-superadmin/statistik-superadmin.module';
import { AikeepUpModule } from 'src/aikeep-up/aikeep-up.module';
import { User } from 'src/user/entities/user.entity';

@Module({

    imports: [TypeOrmModule.forFeature([SummaryKuisioner,User]), forwardRef(() => StatistikPsychologyModule), forwardRef(() => StatistikSuperadminModule),AikeepUpModule],
    providers: [SummaryKuisionerService],
    exports: [SummaryKuisionerService]

})
export class SumaryKuisionerModule { }
