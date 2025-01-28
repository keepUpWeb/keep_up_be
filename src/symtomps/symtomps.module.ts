import { Module } from '@nestjs/common';
import { SymtompsService } from './symtomps.service';
import { SymtompsController } from './symtomps.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Symtomp } from './entities/symtomp.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Symtomp])],
  controllers: [SymtompsController],
  providers: [SymtompsService],
  exports: [SymtompsService],
})
export class SymtompsModule {}
