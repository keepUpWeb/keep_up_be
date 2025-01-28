
import { BadRequestException, Injectable } from '@nestjs/common';
import { ExcelExportStrategy } from './strategy/excel-export.strategy';
import { PDFExportStrategy } from './strategy/pdf-export.strategy';
import { PersonalPDFReportGenerator, PsychologistPDFReportGenerator } from './strategy/pdf-generator';
import { ExportStrategy, ExportType, ReportType } from './strategy/export-strategy.interface';
import { ClientExportReportGenerator, SuperAdminExportReportGenerator } from './strategy/excel-generator';

@Injectable()
export class ExportStrategyFactory {
    static create(exportType: ExportType, reportType?: ReportType): ExportStrategy {
        switch (exportType) {
            case ExportType.PDF:
                switch (reportType) {
                    case ReportType.PERSONAL_PDF:
                        return new PDFExportStrategy(new PersonalPDFReportGenerator());
                    case ReportType.PSYCHOLOGIST_PDF:
                        return new PDFExportStrategy(new PsychologistPDFReportGenerator());
                    default:
                        throw new Error('Invalid report type for PDF');
                }
            case ExportType.EXCEL:
                switch (reportType) {
                    case ReportType.SUPERADMIN_EXCEL:
                        return new ExcelExportStrategy(new SuperAdminExportReportGenerator())
                    case ReportType.PERSONAL_EXCEL:
                        return new ExcelExportStrategy(new ClientExportReportGenerator())
                    default:
                        throw new BadRequestException('Invalid report type for PDF');
                }
            default:
                throw new Error('Invalid export type');
        }
    }
}
