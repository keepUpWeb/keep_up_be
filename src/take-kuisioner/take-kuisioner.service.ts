import {
  BadRequestException,
  ForbiddenException,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { TakeKuisioner } from './entities/take-kuisioner.entity';
import { Between, Repository } from 'typeorm';
import { UserService } from 'src/user/user.service';
import { KuisionerService } from 'src/kuisioner/kuisioner.service';
import { UserAnswerSubKuisioner } from 'src/user-answer-sub-kuisioner/entities/user-answer-sub-kuisioner.entity';
import { CreateTakeKuisionerResponseDTO } from './dto/response/create-kuisioner-response.dto';
import { SYMTOMP } from 'src/symtomps/group/symtomp.enum';
import { PreKuisionerUserService } from 'src/pre-kuisioner-user/pre-kuisioner-user.service';
import { AikeepUpService } from 'src/aikeep-up/aikeep-up.service';
import { Background, ReportData, SymptomResult } from './take-kuisioner.model';
import { transformPreKuisionerUserAnswerFromEntity } from 'src/common/function/helper/preKuisionerUserProses.function';
import { transformPreKuisionerUserAnswer, transformUserAnswerSubKuisioner } from 'src/common/function/helper/exportProses.function';

@Injectable()
export class TakeKuisionerService {
  constructor(
    @InjectRepository(TakeKuisioner)
    private readonly takeKuisionerRepository: Repository<TakeKuisioner>,

    @Inject(UserService)
    private readonly userService: UserService,

    @Inject(KuisionerService)
    private readonly kuisionerService: KuisionerService,

    @Inject(PreKuisionerUserService)
    private readonly preKuisionerUserService: PreKuisionerUserService,

    @Inject(AikeepUpService)
    private readonly aiKeepUpService: AikeepUpService
  ) { }

  async create(kuisionerId: string, userId: string): Promise<CreateTakeKuisionerResponseDTO> {
    const user = await this.userService.findById(userId);

    if (!user.preKuisioner.isFinish) {
      throw new ForbiddenException("Your Pre Kuisioner Not Answered")
    }

    const kuisioner =
      await this.kuisionerService.getOneKuisionerById(kuisionerId);

    const newTakeKuisioner = {
      isFinish: false,
      user: user,
      kuisioner: kuisioner,
    };

    const savedTakeKuisioner =
      await this.takeKuisionerRepository.save(newTakeKuisioner);

    return { id_takeKuisioner: savedTakeKuisioner.id, createdAt: Date.now() };
  }



  async findHistory(userId: string): Promise<TakeKuisioner[]> {

    const userExists = await this.userService.findOne(userId);
    if (!userExists) {
      throw new NotFoundException('User not found');
    }
    // Fetch all records for the user, ordered by createdAt (descending)
    const takeKuisionerList = await this.takeKuisionerRepository.find({
      where: {
        user: { id: userId },
        isFinish: true,
      },
      order: { createdAt: 'DESC' },
      relations: [
        'user',
        'userAnswerSubKuisioner',
        'userAnswerSubKuisioner.subKuisioner',
        'userAnswerSubKuisioner.userAnswerKuisioners',
        'userAnswerSubKuisioner.userAnswerKuisioners.answer',
        'userAnswerSubKuisioner.userAnswerKuisioners.answer.questionId',
        'userAnswerSubKuisioner.subKuisioner.symtompId',
      ],
    });
  
    // If there are no records, return an empty array
    if (!takeKuisionerList || takeKuisionerList.length === 0) {
      return []; // Return an empty array instead of throwing an error
    }
  
    // Group by date and ensure we get the latest record for each unique day
    const latestEntries: TakeKuisioner[] = [];
    const processedDates: Set<string> = new Set(); // To track processed dates
  
    // Loop through the sorted list (most recent first)
    for (const entry of takeKuisionerList) {
      const entryDate = entry.createdAt.toISOString().split('T')[0]; // Get only YYYY-MM-DD
  
      // If this date is not already processed, add the record
      if (!processedDates.has(entryDate)) {
        latestEntries.push(entry);
        processedDates.add(entryDate); // Mark this date as processed
      }
    }
  
    return latestEntries;
  }
  


  async findAll(): Promise<TakeKuisioner[]> {
    const latestTakeKuisioner = await this.takeKuisionerRepository
      .createQueryBuilder('take_kuisioner')
      .leftJoinAndSelect('take_kuisioner.user', 'userEminds')
      .leftJoinAndSelect('userEminds.faculty', 'faculty') // Include user.faculty
      .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
      .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
      .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId') // Include subKuisioner.symtompId
      .leftJoinAndSelect('userAnswerSubKuisioner.userAnswerKuisioners', 'userAnswerKuisioners')
      .leftJoinAndSelect('userAnswerKuisioners.answer', 'answer') // Include userAnswerKuisioners.answer
      .leftJoinAndSelect('answer.questionId', 'questionId') // Include answer.questionId
      .where(
        `take_kuisioner."createdAt" = (
        SELECT MAX(tk."createdAt")
        FROM take_kuisioner tk
        WHERE tk."userId" = take_kuisioner."userId"
      )`
      )
      .andWhere('take_kuisioner.isFinish = :isFinish', { isFinish: true })
      .getMany();


    if (!latestTakeKuisioner) {
      throw new NotFoundException('No Kuisioner Found');
    }

    return latestTakeKuisioner;
  }

  async findAllForPsychologist(psychologist_id: string): Promise<TakeKuisioner[]> {
    const findAllTakeKuisionerForPsychologist = await this.takeKuisionerRepository
      .createQueryBuilder('take_kuisioner')
      .leftJoinAndSelect('take_kuisioner.user', 'userEminds') // Join with userEminds (the User table)
      .leftJoinAndSelect('userEminds.faculty', 'faculty') // Include user.faculty
      .leftJoinAndSelect('take_kuisioner.userAnswerSubKuisioner', 'userAnswerSubKuisioner')
      .leftJoinAndSelect('userAnswerSubKuisioner.subKuisioner', 'subKuisioner')
      .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId') // Include subKuisioner.symtompId
      .leftJoinAndSelect('userAnswerSubKuisioner.userAnswerKuisioners', 'userAnswerKuisioners')
      .leftJoinAndSelect('userAnswerKuisioners.answer', 'answer') // Include userAnswerKuisioners.answer
      .leftJoinAndSelect('answer.questionId', 'questionId') // Include answer.questionId
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
      .andWhere('psychologist.id = :psychologistId', { psychologistId: psychologist_id }).getMany();

    if (!findAllTakeKuisionerForPsychologist) {
      throw new NotFoundException('No Kuisioner Found');
    }

    return findAllTakeKuisionerForPsychologist;
  }

  async findLatest(userId: string): Promise<TakeKuisioner> {
    const latestTakeKuisioner = await this.takeKuisionerRepository.findOne({
      where: { user: { id: userId }, isFinish: true },
      order: { createdAt: 'DESC' }, // Order by createdAt in descending order
      relations: [
        'user',
        'user.faculty',
        'user.userPsycholog',
        'user.userPsycholog.psychologist',
        'user.preKuisioner',
        'user.preKuisioner.preKuisionerUserAnswer',
        'user.preKuisioner.preKuisionerUserAnswer.preKuisionerAnswer',
        'user.preKuisioner.preKuisionerUserAnswer.preKuisionerAnswer.preQuestionId',
        'user.preKuisioner.preKuisionerUserAnswer.preKuisionerAnswer.preQuestionId.category',
        'userAnswerSubKuisioner',
        'userAnswerSubKuisioner.subKuisioner',
        'userAnswerSubKuisioner.subKuisioner.symtompId',
        'userAnswerSubKuisioner.userAnswerKuisioners',
        'userAnswerSubKuisioner.userAnswerKuisioners.answer',
        'userAnswerSubKuisioner.userAnswerKuisioners.answer.questionId'
      ],
    });



    if (!latestTakeKuisioner) {
      throw new NotFoundException('No Kuisioner Found');
    }

    return latestTakeKuisioner;
  }

  async findOne(userId: string, kuisionerId: string): Promise<TakeKuisioner> {
    const takeKuisioner = await this.takeKuisionerRepository.findOne({
      where: { id: kuisionerId },
      relations: [
        'user',
        'userAnswerSubKuisioner',
        'userAnswerSubKuisioner.userAnswerKuisioners',
        'userAnswerSubKuisioner.userAnswerKuisioners.answer',
        'userAnswerSubKuisioner.userAnswerKuisioners.answer.questionId',
        'userAnswerSubKuisioner.subKuisioner',
      ],
    });

    if (!takeKuisioner) {
      throw new NotFoundException('Kuisioner History Not Found');
    }

    if (takeKuisioner.user.id !== userId) {
      throw new ForbiddenException('Access Denied: This is Not Your Kuisioner');
    }

    return takeKuisioner;
  }

  async createResult(kuisionerId: string, userId: string): Promise<CreateTakeKuisionerResponseDTO> {
    const takeKuisionerFinal = await this.takeKuisionerRepository.findOne({
      where: { id: kuisionerId, isFinish: false },
      relations: [
        'user',
        'user.preKuisioner',
        'user.preKuisioner.preKuisionerUserAnswer',
        'user.preKuisioner.preKuisionerUserAnswer.preKuisionerAnswer',
        'user.preKuisioner.preKuisionerUserAnswer.preKuisionerAnswer.preQuestionId',
        'user.preKuisioner.preKuisionerUserAnswer.preKuisionerAnswer.preQuestionId.category',
        'userAnswerSubKuisioner',
        'userAnswerSubKuisioner.subKuisioner',
        'userAnswerSubKuisioner.subKuisioner.symtompId'
      ],
    });

    // Check if the kuisioner exists and is unfinished
    if (!takeKuisionerFinal) {
      throw new BadRequestException('Kuisioner Is Done Generate Report');
    }

    // Check if the user has access to this kuisioner
    if (takeKuisionerFinal.user.id !== userId) {
      throw new ForbiddenException('Access Denied: This is Not Your Kuisioner');
    }

    // Initialize an object to hold the result to be passed to GPT
    const dataHasil: Record<string, any> = {};

    // Loop through each user answer in the sub-kuisioner
    takeKuisionerFinal.userAnswerSubKuisioner.forEach(
      (subKuisioner: UserAnswerSubKuisioner) => {
        // Extract relevant information, such as the symptom name
        const symptomName = subKuisioner.subKuisioner.symtompId.name;

        // Collect data, associating it with the symptom name
        dataHasil[subKuisioner.subKuisioner.id] = {
          symptomName: symptomName,
          userSymtompLevel: subKuisioner.level, // User's response level
          userSymtompScore: subKuisioner.score, // User's score
        };
      },
    );

    // List of required symptoms based on the SYMTOMP enum
    const requiredSymptoms = Object.values(SYMTOMP);

    // Check if all required symptoms have been answered
    const answeredSymptoms = Object.values(dataHasil).map(
      (entry) => entry.symptomName
    );

    const missingSymptoms = requiredSymptoms.filter(
      (symptom) => !answeredSymptoms.includes(symptom)
    );

    if (missingSymptoms.length > 0) {
      throw new BadRequestException(`The following symptoms have not been answered: ${missingSymptoms.join(', ')}`);
    }

    const preKuisionerData = transformPreKuisionerUserAnswerFromEntity(takeKuisionerFinal.user.preKuisioner)

    // console.log(preKuisionerData)

    const preKuisionerDataFinal = transformPreKuisionerUserAnswer(preKuisionerData.preKuisionerUserAnswer)

    const subKuisionerFinalData = transformUserAnswerSubKuisioner(takeKuisionerFinal.userAnswerSubKuisioner)

    const DataGenerateAIReport: ReportData = { background: preKuisionerDataFinal, result: subKuisionerFinalData, user: takeKuisionerFinal.user }

    const report = await this.aiKeepUpService.generateReport(DataGenerateAIReport)

    DataGenerateAIReport.report = report

    // console.log(DataGenerateAIReport)



    // Mark the kuisioner as finished
    takeKuisionerFinal.isFinish = true;
    takeKuisionerFinal.report = report

    //made the report to gpt by the dataAkhir

    // Save the updated kuisioner status
    const dataAkhir = await this.takeKuisionerRepository.save(takeKuisionerFinal);

    // Return the response
    return { id_takeKuisioner: dataAkhir.id, createdAt: Date.now(), report: DataGenerateAIReport };
    // return subKuisionerFinalData
  }


}
