import { Module } from '@nestjs/common';
import { MajorService } from './major.service';
import { MajorController } from './major.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Major } from './entities/major.entity';
import { FacultysModule } from 'src/facultys/facultys.module';

@Module({
  imports:[TypeOrmModule.forFeature([Major]),FacultysModule],
  providers: [MajorService],
  controllers: [MajorController],
  exports:[MajorService]
})
export class MajorModule {}
