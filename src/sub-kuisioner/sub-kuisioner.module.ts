import { Module } from '@nestjs/common';
import { SubKuisionerService } from './sub-kuisioner.service';
import { SubKuisionerController } from './sub-kuisioner.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SubKuisioner } from './entities/sub-kuisioner.entity';
import { KuisionerModule } from 'src/kuisioner/kuisioner.module';
import { SymtompsModule } from 'src/symtomps/symtomps.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([SubKuisioner]),
    KuisionerModule,
    SymtompsModule,
  ],
  controllers: [SubKuisionerController],
  providers: [SubKuisionerService],
  exports: [SubKuisionerService],
})
export class SubKuisionerModule {}
