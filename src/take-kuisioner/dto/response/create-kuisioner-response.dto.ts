import { ReportData } from "src/take-kuisioner/take-kuisioner.model";

export class CreateTakeKuisionerResponseDTO {
  id_takeKuisioner: string;
  createdAt: number;
  report?:ReportData
}
