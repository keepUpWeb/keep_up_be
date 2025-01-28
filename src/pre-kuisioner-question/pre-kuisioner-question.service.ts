import { BadRequestException, Inject, Injectable, NotFoundException } from '@nestjs/common';
import { CreatePreKuisionerQuestionDto } from './dto/create-pre-kuisioner-question.dto';
import { InjectDataSource, InjectRepository } from '@nestjs/typeorm';
import { PreKuisionerQuestion } from './entities/pre-kuisioner-question.entity';
import { DataSource, Repository } from 'typeorm';
import { PreKuisionerCategoryService } from 'src/pre-kuisioner-category/pre-kuisioner-category.service';
import { PreKuisionerAnswerService } from 'src/pre-kuisioner-answer/pre-kuisioner-answer.service';

@Injectable()
export class PreKuisionerQuestionService {

  constructor(
    @InjectRepository(PreKuisionerQuestion)
    private readonly preKuisionerQuestionRepository: Repository<PreKuisionerQuestion>,

    @Inject(PreKuisionerCategoryService)
    private readonly preKuisionerCategoryService: PreKuisionerCategoryService,


    @Inject(PreKuisionerAnswerService)
    private readonly preKuisionerAnswerService: PreKuisionerAnswerService,

    @InjectDataSource()
    private readonly dataSource: DataSource
  ) { }

  async create(createPreKuisionerQuestionDto: CreatePreKuisionerQuestionDto) {

    const getCategory = await this.preKuisionerCategoryService.findOne(createPreKuisionerQuestionDto.preKuisionerCategoryId);
    if (!getCategory) {
      throw new BadRequestException('Invalid category for pre-kuisioner');
    }

    // 2. Create and save the question
    const newQuestion = this.preKuisionerQuestionRepository.create({
      question: createPreKuisionerQuestionDto.question,
      category: getCategory,
    });
    const savedQuestion = await this.preKuisionerQuestionRepository.save(newQuestion);

    console.log(savedQuestion)

    // 3. Create and save the answers using the PreKuisionerAnswerService
    const savedAnswers = await this.preKuisionerAnswerService.create(savedQuestion, createPreKuisionerQuestionDto.answers);

    // 4. Return the saved data
    return { question: savedQuestion, answers: savedAnswers };

  }

  async findAll() {
    // Fetch questions along with their related answers and categories
    const getAllQuestions = await this.preKuisionerQuestionRepository.find({
      relations: ["preKuisionerAnswer", "category"]
    });

    if (!getAllQuestions || getAllQuestions.length === 0) {
      throw new BadRequestException("You are in the wrong category pre-kuisioner");
    }

    // Group questions by category
    const groupedByCategory = getAllQuestions.reduce((result, question) => {
      // Get the category name or identifier for grouping
      const category = question.category.name || 'Uncategorized'; // Adjust as needed (e.g., using `id`)

      // Initialize an array if this category hasn't been added to the result object
      if (!result[category]) {
        result[category] = [];
      }

      // Add the question to the corresponding category group
      result[category].push({
        id: question.id,
        question: question.question,
        createdAt: question.createdAt,
        updateAt: question.updateAt,
        preKuisionerAnswer: question.preKuisionerAnswer
      });

      return result;
    }, {});

    // Convert the grouped data into an array format
    const groupedDataArray = Object.keys(groupedByCategory).map(category => ({
      category,
      questions: groupedByCategory[category]
    }));

    return groupedDataArray
  }

  findOne(id_category: string) {

    const getAllQuestion = this.preKuisionerQuestionRepository.find({
      where: { category: { id: id_category } }
    })

    if (!getAllQuestion) {
      throw new BadRequestException("You on wrong category pre-kuisioner")
    }

    return getAllQuestion
  }

  async countQuestion(){
    return await this.preKuisionerQuestionRepository.count()
  }

  // update(id: number, updatePreKuisionerQuestionDto: UpdatePreKuisionerQuestionDto) {
  //   return `This action updates a #${id} preKuisionerQuestion`;
  // }

  // remove(id: number) {
  //   return `This action removes a #${id} preKuisionerQuestion`;
  // }
}
