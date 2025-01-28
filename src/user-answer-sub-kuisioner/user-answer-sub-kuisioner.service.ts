import {
  ForbiddenException,
  forwardRef,
  HttpException,
  Inject,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UserAnswerSubKuisioner } from './entities/user-answer-sub-kuisioner.entity';
import { DataSource, Repository } from 'typeorm';
import { TakeKuisionerService } from 'src/take-kuisioner/take-kuisioner.service';
import { SubKuisionerService } from 'src/sub-kuisioner/sub-kuisioner.service';
import { UserAnswerKuisionerService } from 'src/user-answer-kuisioner/user-answer-kuisioner.service';
import { CreateUserAnswerSubKuisionerDTO } from './dto/request/create-user-answer-sub-kuisioner.dto';
import { SYMTOMP } from 'src/symtomps/group/symtomp.enum';
import { Level } from './group/level.enum';

@Injectable()
export class UserAnswerSubKuisionerService {
  constructor(
    @InjectRepository(UserAnswerSubKuisioner)
    private readonly userAnswerSubKuisionerRepository: Repository<UserAnswerSubKuisioner>,

    @Inject(TakeKuisionerService)
    private readonly takeKuisionerService: TakeKuisionerService,

    @Inject(SubKuisionerService)
    private readonly subKuisionerService: SubKuisionerService,

    @Inject(forwardRef(() => UserAnswerKuisionerService))
    private readonly userAnswerKuisionerService: UserAnswerKuisionerService,

    private readonly dataSource: DataSource,
  ) { }

  async create(
    takeKuisionerId: string,
    subKuisionerData: CreateUserAnswerSubKuisionerDTO,
    userId: string,
  ): Promise<any> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // Step 1: Fetch the subKuisioner
      const subKuisioner = await this.subKuisionerService.findOne(
        subKuisionerData.subKuisionerId,
      );

      if (!subKuisioner) {
        throw new NotFoundException('The Sub Kuisioner Is Not Found');
      }

      // Step 2: Fetch the takeKuisioner
      const takeKuisioner = await this.takeKuisionerService.findOne(
        userId,
        takeKuisionerId,
      );
      if (!takeKuisioner) {
        throw new NotFoundException('You Have Not Taken This Kuisioner');
      }

      // Step 3: Check access control
      if (takeKuisioner.user.id != userId) {
        throw new ForbiddenException(
          'You Are Forbidden to Access this Kuisioner',
        );
      }

      const isSubKuisionerAnswered = takeKuisioner.userAnswerSubKuisioner.some(
        (answerId) => {
          return answerId.subKuisioner.id === subKuisionerData.subKuisionerId; // Return true if it matches
        },
      );

      if (isSubKuisionerAnswered) {
        throw new ForbiddenException(
          'You have already taken this Sub Kuisioner',
        );
      }

      if (isSubKuisionerAnswered) {
        throw new ForbiddenException('You Done Take This Sub Kuisioner');
      }

      // Step 4: Prepare data for saving to the repository
      const data = new UserAnswerSubKuisioner();
      data.subKuisioner = subKuisioner;

      // Step 5: Save the UserAnswerSubKuisioner data
      const createTakeSubKuisioner = await queryRunner.manager.save(data);

      // Step 6: Save user answers related to this subKuisioner
      const score = await this.userAnswerKuisionerService.create(
        createTakeSubKuisioner.id,
        subKuisionerData.userAnswers,
        queryRunner,
      );

      // Get the score category
      const levelAkhir = this.getScoreCategory(subKuisioner.symtompId.name, score.score);
      const scoreAkhir = this.getAdjustedScore(subKuisioner.symtompId.name, score.score);

      // Step 7: Update the dataAkhir entity with the score and level
      createTakeSubKuisioner.level = levelAkhir;
      createTakeSubKuisioner.score = scoreAkhir;
      createTakeSubKuisioner.takeKuisioner = takeKuisioner
      // console.log(takeKuisioner)

      // Save the updated entity back to the database
      await queryRunner.manager.save(createTakeSubKuisioner);

      // Step 7: Commit the transaction
      await queryRunner.commitTransaction();

      const createdAt = new Date();

      // Step 7: Return the created subKuisioner ID
      return { createdAt: createdAt };
    } catch (error) {
      // Roll back the transaction in case of any failure
      await queryRunner.rollbackTransaction();

      if (error instanceof HttpException) {
        throw error;
      }

      throw new InternalServerErrorException(error.message);
    } finally {
      // Release the query runner after the transaction
      await queryRunner.release();
    }
  }

  findAll() {
    return `This action returns all userAnswerSubKuisioner`;
  }

  async findOne(id: string): Promise<UserAnswerSubKuisioner> {
    const data = await this.userAnswerSubKuisionerRepository.findOne({
      where: { id: id },
    });

    if (!data) {
      throw new NotFoundException('Take Sub Kuisioner Not Found');
    }

    return data;
  }

  update(id: number) {
    return `This action updates a #${id} userAnswerSubKuisioner`;
  }

  remove(id: number) {
    return `This action removes a #${id} userAnswerSubKuisioner`;
  }



  getScoreCategory(symptomName: string, score: number): Level {
    // Multiply score by 2 for specific symptoms
    if (
      symptomName === SYMTOMP.KECEMASAN ||
      symptomName === SYMTOMP.STRESS ||
      symptomName === SYMTOMP.DEPRESI
    ) {
      score *= 2; // Double the score for these symptoms
    }

    switch (symptomName) {
      case SYMTOMP.KECEMASAN:
        if (score >= 0 && score <= 7) return Level.NORMAL;
        if (score >= 8 && score <= 9) return Level.LOW;
        if (score >= 10 && score <= 14) return Level.INTERMEDIATE;
        if (score >= 15 && score <= 19) return Level.HIGH;
        if (score > 19) return Level.SUPERHIGH;
        break;

      case SYMTOMP.STRESS:
        if (score >= 0 && score <= 14) return Level.NORMAL;
        if (score >= 15 && score <= 18) return Level.LOW;
        if (score >= 19 && score <= 25) return Level.INTERMEDIATE;
        if (score >= 26 && score <= 33) return Level.HIGH;
        if (score > 33) return Level.SUPERHIGH;
        break;

      case SYMTOMP.DEPRESI:
        if (score >= 0 && score <= 9) return Level.NORMAL;
        if (score >= 10 && score <= 13) return Level.LOW;
        if (score >= 14 && score <= 20) return Level.INTERMEDIATE;
        if (score >= 21 && score <= 27) return Level.HIGH;
        if (score > 27) return Level.SUPERHIGH;
        break;

      case SYMTOMP.PROKRASTINASI:
        if (score >= 5 && score <= 9) return Level.VERYLOW;
        if (score >= 10 && score <= 13) return Level.LOW;
        if (score >= 14 && score <= 17) return Level.INTERMEDIATE;
        if (score >= 18 && score <= 21) return Level.HIGH;
        if (score >= 22) return Level.SUPERHIGH;
        break;

      case SYMTOMP.KECANDUAN_PONSEL:
        if (score >= 6 && score <= 11) return Level.VERYLOW;
        if (score >= 12 && score <= 17) return Level.LOW;
        if (score >= 18 && score <= 23) return Level.INTERMEDIATE;
        if (score >= 24 && score <= 29) return Level.HIGH;
        if (score >= 30) return Level.SUPERHIGH;
        break;

      default:
        return Level.NORMAL; // Default if the symptom type is unknown
    }
  }

  getAdjustedScore(symptomName: string, score: number): number {
    // Double the score for specified symptoms
    if (
      symptomName === SYMTOMP.KECEMASAN ||
      symptomName === SYMTOMP.STRESS ||
      symptomName === SYMTOMP.DEPRESI
    ) {
      return score * 2;
    }
    return score;
  }



}
