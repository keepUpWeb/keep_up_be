import { BadRequestException, Inject, Injectable } from '@nestjs/common';
import { BodyCreatePreKuisionerUserAnswerDto, CreatePreKuisionerUserAnswerDto } from './dto/create-pre-kuisioner-user-answer.dto';
import { UpdatePreKuisionerUserAnswerDto } from './dto/update-pre-kuisioner-user-answer.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { PreKuisionerUserAnswer } from './entities/pre-kuisioner-user-answer.entity';
import { Repository } from 'typeorm';
import { PreKuisionerAnswerService } from 'src/pre-kuisioner-answer/pre-kuisioner-answer.service';
import { PreKuisionerAnswer } from 'src/pre-kuisioner-answer/entities/pre-kuisioner-answer.entity';
import { PreKuisionerUserService } from 'src/pre-kuisioner-user/pre-kuisioner-user.service';
import { PreKuisionerQuestionService } from 'src/pre-kuisioner-question/pre-kuisioner-question.service';

@Injectable()
export class PreKuisionerUserAnswerService {

  constructor(
    @InjectRepository(PreKuisionerUserAnswer)
    private readonly preKuisionerUserAnswerRepository: Repository<PreKuisionerUserAnswer>,

    @Inject(PreKuisionerAnswerService)
    private readonly preKuisionerAnswerService: PreKuisionerAnswerService,

    @Inject(PreKuisionerUserService)
    private readonly preKuisionerUserService: PreKuisionerUserService,

    @Inject(PreKuisionerQuestionService)
    private readonly preKuisionerQuestionService: PreKuisionerQuestionService
  ) { }

  async create(idPreKuisionerUser: string, createPreKuisionerUserAnswerDto: BodyCreatePreKuisionerUserAnswerDto) {


    // Get the related PreKuisionerUser entity
    const getPreKuisionerUser = await this.preKuisionerUserService.findOne(idPreKuisionerUser);

    if (!getPreKuisionerUser) {
      throw new BadRequestException("Your Pre Kuisioner User Is Wrong");
    }


    const allquestion = await this.preKuisionerQuestionService.countQuestion()

    if (getPreKuisionerUser.preKuisionerUserAnswer.length >= allquestion) {
      throw new BadRequestException("Your Are Done Answer this");

    }
    // Get all answers using the service
    const getAllAnswer = await this.preKuisionerAnswerService.findAllUserAnswer(createPreKuisionerUserAnswerDto);



    if (getAllAnswer.count !== createPreKuisionerUserAnswerDto.preKuisionerAnswers.length || allquestion !== getAllAnswer.count) {
      throw new BadRequestException("You Are Not Complete this Pre Kuisioner");
    }

    // Create new user answers
    const newUserAnswers = getAllAnswer.answers.map((answer: PreKuisionerAnswer) => {
      return this.preKuisionerUserAnswerRepository.create({
        preKuisionerUser: getPreKuisionerUser,
        preKuisionerAnswer: answer,
      });
    });

    // Save all new user answers
    await this.preKuisionerUserAnswerRepository.save(newUserAnswers);

    await this.preKuisionerUserService.finishPreKuisioner(getPreKuisionerUser.id)

    return { preKuisionerId: idPreKuisionerUser, created_at: Date.now() };
  }



  findAll() {
    return `This action returns all preKuisionerUserAnswer`;
  }

  findOne(id: number) {
    return `This action returns a #${id} preKuisionerUserAnswer`;
  }

  update(id: number, updatePreKuisionerUserAnswerDto: UpdatePreKuisionerUserAnswerDto) {
    return `This action updates a #${id} preKuisionerUserAnswer`;
  }

  remove(id: number) {
    return `This action removes a #${id} preKuisionerUserAnswer`;
  }
}
