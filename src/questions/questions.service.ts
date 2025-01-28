import {
  forwardRef,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import {
  BodyCreateQuestionDto,
  CreateQuestionDto,
} from './dto/create-question.dto';
import {
  BodyUpdateQuestionDto,
  UpdateQuestionDto,
} from './dto/update-question.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Question } from './entities/question.entity';
import { Repository } from 'typeorm';
import { SubKuisioner } from 'src/sub-kuisioner/entities/sub-kuisioner.entity';
import { SubKuisionerService } from 'src/sub-kuisioner/sub-kuisioner.service';
import { AnswersService } from 'src/answers/answers.service';
import { CreateQuestionInterface } from './interfaces/createQuestion.interface';

@Injectable()
export class QuestionsService {
  constructor(
    @InjectRepository(Question)
    private questionRepository: Repository<Question>,

    @Inject(SubKuisionerService)
    private subKuisionerService: SubKuisionerService,

    @Inject(forwardRef(() => AnswersService))
    private answersService: AnswersService, // Inject the AnswersService
  ) {}

  async create(
    subKuisionerId: string,
    createQuestionDto: BodyCreateQuestionDto,
  ): Promise<CreateQuestionInterface> {
    // Fetch the SubKuisioner entity based on the provided ID
    const subKuisionerData =
      await this.subKuisionerService.findOne(subKuisionerId);

    // Create and associate the SubKuisioner entity
    const dataQuestion = this.questionRepository.create({
      question: createQuestionDto.question,
      subKuisionerId: subKuisionerData,
    });

    // Save the Question
    const saveQuestion = await this.questionRepository.save(dataQuestion);

    // Create related answers and associate them with the saved Question
    await this.answersService.create(
      saveQuestion.id,
      createQuestionDto.answers,
    );

    // Return the response payload
    const payload: CreateQuestionInterface = {
      id: saveQuestion.id,
      createdAt: saveQuestion.createdAt,
    };

    return payload;
  }

  async findOne(questionId: string): Promise<Question> {
    const payload = await this.questionRepository.findOne({
      where: { id: questionId },
      relations: ['answers','subKuisionerId'],
      order: {
        answers: {
          score: 'ASC',
        },
      },
    });

    if (!payload) {
      throw new NotFoundException('Your Question Is Not Defined');
    }

    return payload;
  }

  async update(
    questionId: string,
    updateQuestionDto: BodyUpdateQuestionDto,
  ): Promise<Question> {
    // Find the existing question by ID
    const dataQuestion = await this.findOne(questionId);

    // Check if the question exists
    if (!dataQuestion) {
      throw new NotFoundException('Question Not Found');
    }

    // Update the question fields (without handling answers)
    Object.assign(dataQuestion, {
      question: updateQuestionDto.question, // update the question text
    });

    // Save the updated question to the database
    await this.questionRepository.save(dataQuestion);

    // Handle the update of the answers using the AnswersService if answers are provided
    if (
      updateQuestionDto.updateAnswers &&
      updateQuestionDto.updateAnswers.length > 0
    ) {
      await this.answersService.updateAnswersForQuestion(
        questionId,
        updateQuestionDto.updateAnswers,
      );
    }

    // Return the updated question
    return dataQuestion;
  }

  async remove(questionId: string): Promise<Date> {
    const result = await this.questionRepository.delete({ id: questionId });

    // Check if a question was deleted
    if (result.affected === 0) {
      throw new NotFoundException(`Question with ID ${questionId} not found`);
    }

    return new Date(); // Return the current date as a Date object
  }
}
