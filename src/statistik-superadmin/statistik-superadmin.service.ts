import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { calculateSymptomScores, processKuisionerData } from 'src/common/function/helper/statistikProses.function';
import { Gender } from 'src/common/group/gender.enum';
import { StatistikKuisioner } from 'src/common/interfaces/StatistikKuisioner.interface';
import { ROLES } from 'src/roles/group/role.enum';
import { RolesService } from 'src/roles/roles.service';
import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';
import { UserAnswerSubKuisioner } from 'src/user-answer-sub-kuisioner/entities/user-answer-sub-kuisioner.entity';
import { Level } from 'src/user-answer-sub-kuisioner/group/level.enum';
import { User } from 'src/user/entities/user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class StatistikSuperadminService {
    constructor(
        @InjectRepository(TakeKuisioner)
        private readonly takeKuisionerRepository: Repository<TakeKuisioner>,

        @InjectRepository(User)
        private readonly userRepository: Repository<User>,

        @Inject(RolesService)
        private readonly rolesService: RolesService
    ) { }

    //untuk kotak-kotak yang ada di atas dashboard superadmin
    async getAllTakeKuisionerStatistik() {
        const AllDataKuisioner = await this.takeKuisionerRepository
            .createQueryBuilder('take_kuisioner')
            .leftJoinAndSelect('take_kuisioner.user', 'userEminds')
            .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
            .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
            .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
            .where(
                `take_kuisioner."createdAt" = (
                SELECT MAX(tk."createdAt")
                FROM take_kuisioner tk
                WHERE tk."userId" = take_kuisioner."userId"
            )`
            ).andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
            .getMany();

        // Initialize statistics object with default values
        const statistik: Record<string, number> = {
            'Normal': 0,
            'Depresi': 0,
            'Stress': 0,
            'Kecemasan': 0,
            'Prokrastinasi': 0,
            'Kecanduan Ponsel': 0,
        };

        // console.log(AllDataKuisioner)

        // Loop through each TakeKuisioner
        AllDataKuisioner.forEach((hasilKuisionerUser: TakeKuisioner) => {
            let normalCount = 0; // Counter to track how many 'Normal' answers the user has

            // Loop through each UserAnswerSubKuisioner
            hasilKuisionerUser.userAnswerSubKuisioner.forEach((hasilUser: UserAnswerSubKuisioner) => {
                const symptomName = hasilUser.subKuisioner.symtompId.name;
                const levelName = hasilUser.level;

                if (levelName === Level.NORMAL) {
                    normalCount++;
                } else if (symptomName) {
                    if (!statistik[symptomName]) {
                        statistik[symptomName] = 1; // Initialize if it's the first occurrence
                    } else {
                        statistik[symptomName]++; // Increment for subsequent occurrences
                    }
                }
            });

            // If the user has 5 or more 'Normal' answers, increment the 'Normal' statistic
            if (normalCount >= 5) {
                statistik['Normal']++;
            }
        });

        statistik['Kecanduan'] = statistik['Kecanduan Ponsel']

        // Return the result in the desired format
        return {
            StatistikKuisioner: statistik,
        };
    }

    //untuk barchart and chart yang ada di halamana laporan
    async getAllTakeKuisionerStatistikSymtomp() {
        const AllDataKuisioner = await this.takeKuisionerRepository
            .createQueryBuilder('take_kuisioner')
            .leftJoinAndSelect('take_kuisioner.user', 'userEminds')
            .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
            .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
            .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
            .where(
                `take_kuisioner."createdAt" = (
                SELECT MAX(tk."createdAt")
                FROM take_kuisioner tk
                WHERE tk."userId" = take_kuisioner."userId"
            )`
            ).andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
            .getMany();

        const statistik = processKuisionerData(AllDataKuisioner);
        // Return the result in the desired format
        return {
            StatistikKuisioner: statistik,
        };
    }

    //untuk chart user gender statistik
    async getAllUserGenderStatistik() {

        const roleUser = await this.rolesService.getRoleById(ROLES.USER)

        // Fetch users with the specific roleId
        const allUsers = await this.userRepository.find({
            where: { role: roleUser },
        });

        // Initialize the gender statistics object
        const genderStatistik: Record<string, number> = {
            'laki-laki': 0,
            'perempuan': 0,
        };

        // Iterate through users and count genders
        allUsers.forEach(user => {
            if (user.gender === Gender.LakiLaki) {
                genderStatistik['laki-laki']++;
            } else if (user.gender === Gender.Perempuan) {
                genderStatistik['perempuan']++;
            }
        });

        // Return the gender statistics
        return {
            StatistikGender: genderStatistik,
        };
    }

    //untuk list mahasiswa yang urgent
    async getAllUserKuisionerStatistik():Promise<StatistikKuisioner> {
        const AllDataKuisioner = await this.takeKuisionerRepository
            .createQueryBuilder('take_kuisioner')
            .leftJoinAndSelect('take_kuisioner.user', 'userEminds')
            .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
            .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
            .leftJoinAndSelect('take_kuisioner.kuisioner', 'kuisoner')
            .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
            .where(
                `take_kuisioner."createdAt" = (
                    SELECT MAX(tk."createdAt")
                    FROM take_kuisioner tk
                    WHERE tk."userId" = take_kuisioner."userId"
                )`
            ).andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
            .getMany();

        // Initialize user symptom data
        const userSymptomData = AllDataKuisioner.map((takeKuisioner) => {
            const symptomScores = calculateSymptomScores(takeKuisioner);

            return {
                takeKuisionerId: takeKuisioner.id,
                userId: takeKuisioner.user.id,
                kuisionerId: takeKuisioner.kuisioner.id,
                kuisionerName: takeKuisioner.kuisioner.title,
                userName: takeKuisioner.user.username,
                contact: `https://mail.google.com/mail/u/3/?fs=1&to=${takeKuisioner.user.email}&tf=cm`,
                symptomScores: symptomScores,
                totalScore: Object.values(symptomScores).reduce((acc, score) => acc + score.score, 0),
            };
        });

        // Sort users by total score (descending)
        const sortedUserSymptomData = userSymptomData.sort((a, b) => b.totalScore - a.totalScore);

        // Return the sorted data with user name and symptom scores
        return {
            UserSymptomStatistics: sortedUserSymptomData.map((user) => ({
                takeKuisionerId: user.takeKuisionerId,
                userId: user.userId,
                kuisionerId: user.kuisionerId,
                kuisionerName: user.kuisionerName,
                userName: user.userName,
                symptoms: user.symptomScores,
                contact: user.contact
            })),
        };
    }


    async countAllUserKuisionerStatistik() {
        const userCount = await this.userRepository.count({
            where: { role: { id: ROLES.USER } }
        })

        const userCountDoneKuisioner = await this.takeKuisionerRepository
            .createQueryBuilder('take_kuisioner')
            .leftJoinAndSelect('take_kuisioner.user', 'userEminds')
            .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
            .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
            .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
            .where(
                `take_kuisioner."createdAt" = (
            SELECT MAX(tk."createdAt")
            FROM take_kuisioner tk
            WHERE tk."userId" = take_kuisioner."userId"
        )`
            ).andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
            .getCount();

        return {
            allUser: userCount,
            userDoneKuisioner: userCountDoneKuisioner
        }
    }

    async countAllUserKuisionerByFacultyStatistik(idFaculty: string) {
        const userCountDoneKuisioner = await this.takeKuisionerRepository
            .createQueryBuilder('take_kuisioner')
            .leftJoinAndSelect('take_kuisioner.user', 'userEminds')
            .leftJoin('userEminds.major', 'major') // Join with the `major` table
            .select('major.id', 'majorId') // Select the `majorId`
            .addSelect('major.name', 'majorName') // Select the `majorName`
            .addSelect('COUNT(DISTINCT take_kuisioner.userId)', 'userDoneKuisioner') // Count unique users
            .where(
                `take_kuisioner."createdAt" = (
                    SELECT MAX(tk."createdAt")
                    FROM take_kuisioner tk
                    WHERE tk."userId" = take_kuisioner."userId"
                )`
            )
            .andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
            .andWhere('userEminds.facultyId = :facultyId', { facultyId: idFaculty })
            .groupBy('major.id')
            .addGroupBy('major.name') // Group by major name
            .getRawMany();
    
        // Return the formatted results
        return userCountDoneKuisioner.map(row => ({
            majorId: row.majorId,
            majorName: row.majorName,
            userDoneKuisioner: parseInt(row.userDoneKuisioner, 10),
        }));
    }    
    



}
