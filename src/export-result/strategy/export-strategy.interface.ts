import * as ExcelJS from 'exceljs';
export interface ExportStrategy {
    export(data: any): Promise<Buffer> | Promise<ExcelJS.Buffer>;
}

// export-types.enum.ts
export enum ExportType {
    PDF = 'pdf',
    EXCEL = 'excel',
}

// report-types.enum.ts
export enum ReportType {
    PERSONAL_PDF = 'personal',
    PSYCHOLOGIST_PDF = 'psychologist',
    SUPERADMIN_EXCEL = 'superAdminExcel',
    PERSONAL_EXCEL = 'personalExcel',
}

// export enum ReportTypeExcel {
//     SUPERADMIN = 'superadmin',
//     PSYCHOLOGIST = 'psychologist',
// }