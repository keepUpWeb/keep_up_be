import * as PDFDocument from 'pdfkit';
import { ExportStrategy } from './export-strategy.interface';

// Abstract class for PDF
export abstract class PDFReportGenerator {
  abstract generate(doc: any, data: any): void;
}

export class PDFExportStrategy implements ExportStrategy {
  private generator: PDFReportGenerator;

  constructor(generator: PDFReportGenerator) {
    this.generator = generator;
  }

  async export(data: any): Promise<Buffer> {
    const doc = new PDFDocument({ margin: 50 });
    const buffers: Buffer[] = [];
    doc.on('data', buffers.push.bind(buffers));

    return new Promise((resolve, reject) => {
      doc.on('end', () => resolve(Buffer.concat(buffers)));
      doc.on('error', reject);

      // Add header and footer with styling
      this.addHeader(doc);
      this.generator.generate(doc, data);
      this.addFooter(doc);

      doc.end();
    });
  }

  private addHeader(doc: any) {
    // Blue bar for header background
    doc
      .rect(0, 0, doc.page.width, 50)
      .fill('#004b93')
      .fillColor('#ffffff')
      .fontSize(16)
      .text('KeepUp Report', 50, 15, { align: 'left', lineBreak: false });
  }

  private addFooter(doc: any) {
    // Blue bar for footer background
    doc
      .rect(0, doc.page.height - 30, doc.page.width, 30)
      .fill('#004b93')
      .fillColor('#ffffff')
      .fontSize(10)
      .text('KeepUp - Confidential', 50, doc.page.height - 20, {
        align: 'center',
        lineBreak: false,
      });
  }
}
