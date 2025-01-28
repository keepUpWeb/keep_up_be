import { Module } from '@nestjs/common';
import { TakeKuisionerService } from './take-kuisioner.service';
import { TakeKuisionerController } from './take-kuisioner.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TakeKuisioner } from './entities/take-kuisioner.entity';
import { UserModule } from 'src/user/user.module';
import { KuisionerModule } from 'src/kuisioner/kuisioner.module';
import { PreKuisionerUserModule } from 'src/pre-kuisioner-user/pre-kuisioner-user.module';
import { AikeepUpModule } from 'src/aikeep-up/aikeep-up.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([TakeKuisioner]),
    UserModule,
    KuisionerModule,
    PreKuisionerUserModule,
    AikeepUpModule
  ],
  controllers: [TakeKuisionerController],
  providers: [TakeKuisionerService],
  exports: [TakeKuisionerService],
})
export class TakeKuisionerModule {}
