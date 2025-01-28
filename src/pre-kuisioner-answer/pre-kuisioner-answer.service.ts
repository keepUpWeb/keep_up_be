import { Injectable } from '@nestjs/common';
import { CreatePreKuisionerAnswerDto } from './dto/create-pre-kuisioner-answer.dto';
import { UpdatePreKuisionerAnswerDto } from './dto/update-pre-kuisioner-answer.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { PreKuisionerAnswer } from './entities/pre-kuisioner-answer.entity';
import { In, Repository } from 'typeorm';
import { PreKuisionerQuestion } from 'src/pre-kuisioner-question/entities/pre-kuisioner-question.entity';
import { BodyCreatePreKuisionerUserAnswerDto, CreatePreKuisionerUserAnswerDto } from 'src/pre-kuisioner-user-answer/dto/create-pre-kuisioner-user-answer.dto';

@Injectable()
export class PreKuisionerAnswerService {

  constructor(
    @InjectRepository(PreKuisionerAnswer)
    private readonly preKuisionerAnswerRepository: Repository<PreKuisionerAnswer>
  ) { }
  async create(
    preKuisionerQuestion: PreKuisionerQuestion,
    createAnswerDto: CreatePreKuisionerAnswerDto[],
  ): Promise<PreKuisionerAnswer[]> {

    // Create and save answers
    const answers = createAnswerDto.map((dto: CreatePreKuisionerAnswerDto) => {
      return this.preKuisionerAnswerRepository.create({
        answer: dto.answer, // Assuming answerText is the field in CreateAnswerDto
        preQuestionId: preKuisionerQuestion,
      });
    });

    // Save all answers in one go
    return this.preKuisionerAnswerRepository.save(answers);
  }

  findAll() {
    return `This action returns all preKuisionerAnswer`;
  }

  findOne(id: number) {
    return `This action returns a #${id} preKuisionerAnswer`;
  }

  update(id: number, updatePreKuisionerAnswerDto: UpdatePreKuisionerAnswerDto) {
    return `This action updates a #${id} preKuisionerAnswer`;
  }

  remove(id: number) {
    return `This action removes a #${id} preKuisionerAnswer`;
  }

  async findAllUserAnswer(data: BodyCreatePreKuisionerUserAnswerDto): Promise<{ answers: PreKuisionerAnswer[], count: number }> {
    // Extract the UUIDs from the DTO
    const answerIds = data.preKuisionerAnswers.map(
      (answer: CreatePreKuisionerUserAnswerDto) => answer.id_answer
    );

    // Use findAndCount with the In operator
    const [answers, count] = await this.preKuisionerAnswerRepository.findAndCount({
      where: { id: In(answerIds) }, // Adjust 'id' to match your entity's field name
    });

    // Return both the found answers and the count
    return { answers, count };
  }


}
