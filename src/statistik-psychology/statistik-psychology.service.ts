import { Inject, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';
import { User } from 'src/user/entities/user.entity';
import { Repository } from 'typeorm';
import { RolesService } from 'src/roles/roles.service';
import { calculateSymptomScores, processKuisionerData } from 'src/common/function/helper/statistikProses.function';
import { Gender } from 'src/common/group/gender.enum';
import { ROLES } from 'src/roles/group/role.enum';
import { UserAnswerSubKuisioner } from 'src/user-answer-sub-kuisioner/entities/user-answer-sub-kuisioner.entity';
import { Level } from 'src/user-answer-sub-kuisioner/group/level.enum';
import { StatistikKuisioner } from 'src/common/interfaces/StatistikKuisioner.interface';

@Injectable()
export class StatistikPsychologyService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,

    @InjectRepository(TakeKuisioner)
    private takeKuisionerRepository: Repository<TakeKuisioner>,

    @Inject(RolesService)
    private readonly rolesService: RolesService,

  ) { }

  async findClientsSymtopmStatistikForPsychologist(psychologistId: string) {
    // console.log('Psychologist ID:', psychologistId); // Log the psychologist ID

    // Log the raw SQL query that will be executed
    const query = this.takeKuisionerRepository
      .createQueryBuilder('take_kuisioner')
      .leftJoinAndSelect('take_kuisioner.user', 'userEminds') // Join with userEminds (the User table)
      .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
      .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
      .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
      .leftJoinAndSelect('userEminds.psychologistClients', 'clientPsychologist')
      .leftJoinAndSelect('userEminds.userPsycholog', 'userPsycholog')
      .leftJoinAndSelect('userPsycholog.psychologist', 'psychologist')
      .where(
        `take_kuisioner."createdAt" = (
          SELECT MAX(tk."createdAt")
          FROM take_kuisioner tk
          WHERE tk."userId" = take_kuisioner."userId"
        )`
      )
      .andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
      .andWhere('psychologist.id = :psychologistId', { psychologistId: psychologistId })


    // Execute the query and log the results
    const AllDataKuisionerClient = await query.getMany();

    const statistik = processKuisionerData(AllDataKuisionerClient)
    // Return the result in the desired format
    return {
      StatistikKuisioner: statistik,
    };
  }

  async findClientsUserStatistikForPsychologist(psychologistId: string):Promise<StatistikKuisioner> {
    console.log('Psychologist ID:', psychologistId); // Log the psychologist ID

    // Log the raw SQL query that will be executed
    const query = this.takeKuisionerRepository
      .createQueryBuilder('take_kuisioner')
      .leftJoinAndSelect('take_kuisioner.user', 'userEminds') // Join with userEminds (the User table)
      .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
      .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
      .leftJoinAndSelect('take_kuisioner.kuisioner', 'kuisoner')
      .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
      .leftJoinAndSelect('userEminds.psychologistClients', 'clientPsychologist')
      .leftJoinAndSelect('userEminds.userPsycholog', 'userPsycholog')
      .leftJoinAndSelect('userPsycholog.psychologist', 'psychologist')
      .where(
        `take_kuisioner."createdAt" = (
          SELECT MAX(tk."createdAt")
          FROM take_kuisioner tk
          WHERE tk."userId" = take_kuisioner."userId"
        )`
      )
      .andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
      .andWhere('psychologist.id = :psychologistId', { psychologistId: psychologistId })


    // Execute the query and log the results
    const AllDataKuisionerClient = await query.getMany();
    // console.log(AllDataKuisionerClient)

    const userSymptomData = AllDataKuisionerClient.map((takeKuisioner) => {

      const symptomScores = calculateSymptomScores(takeKuisioner);
      console.log(symptomScores)


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

  async getAllTakeKuisionerStatistikPsychology(psychologistId: string) {
    const AllDataKuisioner = await this.takeKuisionerRepository
      .createQueryBuilder('take_kuisioner')
      .leftJoinAndSelect('take_kuisioner.user', 'userEminds') // Join with userEminds (the User table)
      .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
      .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
      .leftJoinAndSelect('take_kuisioner.kuisioner', 'kuisoner')
      .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
      .leftJoinAndSelect('userEminds.psychologistClients', 'clientPsychologist')
      .leftJoinAndSelect('userEminds.userPsycholog', 'userPsycholog')
      .leftJoinAndSelect('userPsycholog.psychologist', 'psychologist')
      .where(
        `take_kuisioner."createdAt" = (
            SELECT MAX(tk."createdAt")
            FROM take_kuisioner tk
            WHERE tk."userId" = take_kuisioner."userId"
        )`
      ).andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
      .andWhere('psychologist.id = :psychologistId', { psychologistId: psychologistId })
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
  //untuk chart user gender statistik
  async getAllUserGenderStatistikPsychology(idPsychology: string) {

    const roleUser = await this.rolesService.getRoleById(ROLES.USER)

    // Fetch users with the specific roleId
    const allUsers = await this.userRepository.find({
      where: { role: roleUser, userPsycholog: { psychologist: { id: idPsychology } } },
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

  async countAllUserKuisionerStatistikPsychology(psychologistId: string) {
    const userCount = await this.userRepository.count({
      where: { role: { id: ROLES.USER }, userPsycholog: { psychologist: { id: psychologistId } } }
    })

    const userCountDoneKuisioner = await this.takeKuisionerRepository

      .createQueryBuilder('take_kuisioner')
      .leftJoinAndSelect('take_kuisioner.user', 'userEminds') // Join with userEminds (the User table)
      .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
      .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
      .leftJoinAndSelect('take_kuisioner.kuisioner', 'kuisoner')
      .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
      .leftJoinAndSelect('userEminds.psychologistClients', 'clientPsychologist')
      .leftJoinAndSelect('userEminds.userPsycholog', 'userPsycholog')
      .leftJoinAndSelect('userPsycholog.psychologist', 'psychologist')
      .where(
        `take_kuisioner."createdAt" = (
              SELECT MAX(tk."createdAt")
              FROM take_kuisioner tk
              WHERE tk."userId" = take_kuisioner."userId"
          )`
      ).andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
      .andWhere('psychologist.id = :psychologistId', { psychologistId: psychologistId })
      .getCount();
    return {
      allUser: userCount,
      userDoneKuisioner: userCountDoneKuisioner
    }


  }
}
