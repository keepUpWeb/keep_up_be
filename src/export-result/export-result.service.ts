import { Injectable } from '@nestjs/common';
import { ExportStrategyFactory } from './export-strategy.factory';
import { ExportType, ReportType } from './strategy/export-strategy.interface';
import * as ExcelJS from 'exceljs';

@Injectable()
export class ExportResultService {
  async exportResult(
    exportType: ExportType, // Use enum here
    data: any,
    reportType: ReportType // Use enum here
  ): Promise<Buffer | ExcelJS.Buffer> {

    const exportStrategy = ExportStrategyFactory.create(exportType, reportType);
    return exportStrategy.export(data);
  }
}
