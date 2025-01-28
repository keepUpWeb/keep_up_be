import * as ExcelJS from 'exceljs';
import { ExportStrategy } from './export-strategy.interface';
import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';


export abstract class ExcelReportGenerator {
  abstract generate(doc: any, data: any): Promise<ExcelJS.Buffer>;
}

export class ExcelExportStrategy implements ExportStrategy {
  private generator: ExcelReportGenerator;

  constructor(generator: ExcelReportGenerator) {
    this.generator = generator;
  }

  async export(data: TakeKuisioner): Promise<ExcelJS.Buffer> {
    // Call the generate method from ClientExportReportGenerator
    const doc = {}; // Assuming some document context is passed
    const buffer = this.generator.generate(doc, data);
    return buffer;
  }
}