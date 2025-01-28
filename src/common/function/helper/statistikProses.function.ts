import { TakeKuisioner } from "src/take-kuisioner/entities/take-kuisioner.entity";
import { UserAnswerSubKuisioner } from "src/user-answer-sub-kuisioner/entities/user-answer-sub-kuisioner.entity";
import { Level } from "src/user-answer-sub-kuisioner/group/level.enum";
import { SymptomScore } from "src/common/interfaces/StatistikKuisioner.interface";

// Helper function to process Kuisioner data and populate statistics
export function processKuisionerData(data: TakeKuisioner[]): Record<string, { VeryLow?: number, Low: number; Intermediate: number; High: number, VeryHigh: number }[]> {
    // Initialize statistics object with default values
    const statistik: Record<string, { VeryLow?: number, Low: number; Intermediate: number; High: number, VeryHigh: number }[]> = {
        'Depresi': [{ Low: 0, Intermediate: 0, High: 0, VeryHigh: 0 }],
        'Stress': [{ Low: 0, Intermediate: 0, High: 0, VeryHigh: 0 }],
        'Kecemasan': [{ Low: 0, Intermediate: 0, High: 0, VeryHigh: 0 }],
        'Prokrastinasi': [{ VeryLow: 0, Low: 0, Intermediate: 0, High: 0, VeryHigh: 0 }],
        'Kecanduan Ponsel': [{ VeryLow: 0, Low: 0, Intermediate: 0, High: 0, VeryHigh: 0 }],
    };

    // Loop through each TakeKuisioner
    data.forEach((hasilKuisionerUser: TakeKuisioner) => {
        // Loop through each UserAnswerSubKuisioner
        hasilKuisionerUser.userAnswerSubKuisioner.forEach((hasilUser: UserAnswerSubKuisioner) => {
            const symptomName = hasilUser.subKuisioner.symtompId?.name;
            const levelName = hasilUser.level;

            if (symptomName) {
                // Ensure the symptomName exists in the statistik object
                if (!statistik[symptomName]) {
                    statistik[symptomName] = [{ VeryLow: 0, Low: 0, Intermediate: 0, High: 0, VeryHigh: 0 }];
                }

                // Update the statistics based on symptom and level
                if (['Depresi', 'Kecemasan', 'Stress'].includes(symptomName)) {
                    // Primary symptoms scoring
                    switch (levelName) {
                        case Level.SUPERHIGH:
                            statistik[symptomName][0].VeryHigh++;
                            break;
                        case Level.HIGH:
                            statistik[symptomName][0].High++;
                            break;
                        case Level.INTERMEDIATE:
                            statistik[symptomName][0].Intermediate++;
                            break;
                        case Level.LOW:
                            statistik[symptomName][0].Low++;
                            break;
                    }
                } else if (['Kecanduan Ponsel', 'Prokrastinasi'].includes(symptomName)) {
                    // Secondary symptoms scoring
                    switch (levelName) {
                        case Level.SUPERHIGH:
                            statistik[symptomName][0].VeryHigh++;
                            break;
                        case Level.HIGH:
                            statistik[symptomName][0].High++;
                            break;
                        case Level.INTERMEDIATE:
                            statistik[symptomName][0].Intermediate++;
                            break;
                        case Level.LOW:
                            statistik[symptomName][0].Low++;
                            break;
                        case Level.VERYLOW:
                            statistik[symptomName][0].VeryLow++;
                            break;
                    }
                }
            }
        });
    });

    // Set alias for 'Kecanduan Ponsel' as 'Kecanduan'
    statistik['Kecanduan'] = statistik['Kecanduan Ponsel'];

    return statistik;
}

export function calculateSymptomScores(takeKuisioner: TakeKuisioner): Record<string, SymptomScore> {
    const symptomScores: Record<string, { score: number; level: Level | null }> = {
        'Depresi': { score: 0, level: null },
        'Kecemasan': { score: 0, level: null },
        'Stress': { score: 0, level: null },
        'Prokrastinasi': { score: 0, level: null },
        'Kecanduan Ponsel': { score: 0, level: null },
    };

    // Calculate points for each symptom based on hierarchy and level
    takeKuisioner.userAnswerSubKuisioner.forEach((answer) => {
        const symptomName = answer.subKuisioner.symtompId?.name;
        if (symptomName && symptomScores[symptomName]) {
            let score = 0;

            // Apply scoring based on symptom hierarchy and level
            if (['Depresi', 'Kecemasan', 'Stress'].includes(symptomName)) {
                // Primary symptoms scoring
                switch (answer.level) {
                    case Level.SUPERHIGH:
                        score = 1.25;
                        break;
                    case Level.HIGH:
                        score = 1;
                        break;
                    case Level.INTERMEDIATE:
                        score = 0.75;
                        break;
                    case Level.LOW:
                        score = 0.5;
                        break;
                    case Level.VERYLOW:
                        score = 0.25;
                        break;
                }
            } else if (['Kecanduan Ponsel', 'Prokrastinasi'].includes(symptomName)) {
                // Secondary symptoms scoring
                switch (answer.level) {
                    case Level.SUPERHIGH:
                        score = 1;
                        break;
                    case Level.HIGH:
                        score = 0.75;
                        break;
                    case Level.INTERMEDIATE:
                        score = 0.5;
                        break;
                    case Level.LOW:
                        score = 0.25;
                        break;
                    case Level.VERYLOW:
                        score = 0.1;
                        break;
                }
            }

            // Accumulate score and update level
            symptomScores[symptomName].score += score;
            symptomScores[symptomName].level = answer.level; // Retain last level or modify logic if needed
        }

        // console.log(symptomScores)
    });

    // Filter out symptoms with a score of zero
    return Object.fromEntries(
        Object.entries(symptomScores).filter(([_, data]) => data.score > 0)
    );
}

