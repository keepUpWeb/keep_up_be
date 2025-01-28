import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerQuestionService } from './pre-kuisioner-question.service';

describe('PreKuisionerQuestionService', () => {
  let service: PreKuisionerQuestionService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PreKuisionerQuestionService],
    }).compile();

    service = module.get<PreKuisionerQuestionService>(PreKuisionerQuestionService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
