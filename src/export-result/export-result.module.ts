import { Module } from '@nestjs/common';
import { ExportResultController } from './export-result.controller';
import { ExportResultService } from './export-result.service';
import { TakeKuisionerModule } from 'src/take-kuisioner/take-kuisioner.module';

@Module({
  imports:[TakeKuisionerModule],
  providers: [ExportResultService],
  controllers: [ExportResultController],
})
export class ExportResultModule { }
