import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerQuestionController } from './pre-kuisioner-question.controller';
import { PreKuisionerQuestionService } from './pre-kuisioner-question.service';

describe('PreKuisionerQuestionController', () => {
  let controller: PreKuisionerQuestionController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PreKuisionerQuestionController],
      providers: [PreKuisionerQuestionService],
    }).compile();

    controller = module.get<PreKuisionerQuestionController>(PreKuisionerQuestionController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
