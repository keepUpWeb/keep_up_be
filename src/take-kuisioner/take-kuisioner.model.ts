import { User } from "src/user/entities/user.entity";

export interface PreKuisionerAnswer {
    answer:string
    question:string
    // Define this based on the structure of data inside preKuisionerAnswer
}

export interface Background {
    categoryName: string;
    preKuisionerAnswer: PreKuisionerAnswer[];
}

export interface SymptomResult {
    nameSymtomp: string;
    level: string;
    score: number;
}

export interface ReportData {
    background: Background[];
    result: SymptomResult[];
    report?:string
    user:User
}