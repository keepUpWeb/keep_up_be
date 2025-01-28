import { Module } from '@nestjs/common';
import { KuisionerService } from './kuisioner.service';
import { KuisionerController } from './kuisioner.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Kuisioner } from './entity/kuisioner.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Kuisioner])],
  providers: [KuisionerService],
  controllers: [KuisionerController],
  exports: [KuisionerService],
})
export class KuisionerModule {}
