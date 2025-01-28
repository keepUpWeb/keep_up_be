import {
  forwardRef,
  HttpException,
  HttpStatus,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateAnswerDto } from './dto/create-answer.dto';
import { UpdateAnswerDto } from './dto/update-answer.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Answer } from './entities/answer.entity';
import { Repository } from 'typeorm';
import { Question } from 'src/questions/entities/question.entity';
import { QuestionsService } from 'src/questions/questions.service';

@Injectable()
export class AnswersService {
  constructor(
    @InjectRepository(Answer)
    private readonly answerRepository: Repository<Answer>,

    @Inject(forwardRef(() => QuestionsService))
    private questionsService: QuestionsService, // Inject the QuestionsService
  ) { }

  async create(
    questionId: string,
    createAnswerDto: CreateAnswerDto[],
  ): Promise<Answer[]> {
    const dataQuestion = await this.questionsService.findOne(questionId);

    // Create and save answers
    const answers = createAnswerDto.map((dto: CreateAnswerDto) => {
      return this.answerRepository.create({
        answer: dto.answer, // Assuming answerText is the field in CreateAnswerDto
        score: dto.score, // Set the related question
        questionId: dataQuestion,
      });
    });

    // Save all answers in one go
    return this.answerRepository.save(answers);
  }

  findAll() {
    return `This action returns all answers`;
  }

  async findOne(id: string): Promise<Answer> {
    const data = await this.answerRepository.findOne({ where: { id: id } });

    if (!data) {
      throw new NotFoundException('Answer Not Found');
    }

    return data;
  }

  async updateAnswersForQuestion(
    questionId: string,
    updateAnswerDtos: UpdateAnswerDto[],
  ): Promise<Answer[]> {
    // Find the existing question (to ensure the question exists)
    const dataQuestion = await this.questionsService.findOne(questionId);


    if (!dataQuestion) {
      throw new NotFoundException('Question Not Found');
    }

    // Find all existing answers for this question
    const existingAnswers = dataQuestion.answers;

    // Map over the DTOs and update each corresponding answer
    const updatedAnswers: Answer[] = [];

    for (const dto of updateAnswerDtos) {
      // Find the specific answer to update
      const answer = existingAnswers.find((a) => a.id === dto.id);

      if (!answer) {
        throw new NotFoundException(`Answer with ID ${dto.id} not found`);
      }

      // Update the answer properties
      answer.answer = dto.answer;
      answer.score = dto.score;

      // Save the updated answer
      updatedAnswers.push(await this.answerRepository.save(answer));
    }

    return updatedAnswers;
  }

  async add(id_question: string, data: CreateAnswerDto) {
    try {
      // Fetch the related question
      const questionData = await this.questionsService.findOne(id_question);

      // If no question found, throw a 404 error
      if (!questionData) {
        throw new HttpException('Question not found', HttpStatus.NOT_FOUND);
      }

      // Create the answer entity
      const newAnswer = this.answerRepository.create({
        answer: data.answer,
        score: data.score,
        questionId: questionData, // Assuming this is a relation mapping
      });

      // Save the new answer to the repository
      const savedAnswer = await this.answerRepository.save(newAnswer);

      return savedAnswer; // Return the saved entity for further use or response
    } catch (error) {
      // Handle database or other errors gracefully
      throw new HttpException(
        error.message || 'An error occurred while adding the answer',
        error.status || HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
  
  async update(id_answer: string, data: UpdateAnswerDto) {
    try {
      // Find the existing answer by ID
      const existingAnswer = await this.answerRepository.findOne({ where: { id: id_answer } });

      // If the answer doesn't exist, throw a 404 error
      if (!existingAnswer) {
        throw new HttpException('Answer not found', HttpStatus.NOT_FOUND);
      }

      // Update the fields of the existing answer
      existingAnswer.answer = data.answer;
      existingAnswer.score = data.score;

      // Save the updated answer
      const updatedAnswer = await this.answerRepository.save(existingAnswer);

      return updatedAnswer; // Return the updated entity for further use or response
    } catch (error) {
      // Handle database or other errors gracefully
      throw new HttpException(
        error.message || 'An error occurred while updating the answer',
        error.status || HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }


  async remove(id: string) {
    try {
      return await this.answerRepository.delete({ id });
    } catch (error) {
      throw new HttpException('An error occurred while deleting the answer', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }

}
