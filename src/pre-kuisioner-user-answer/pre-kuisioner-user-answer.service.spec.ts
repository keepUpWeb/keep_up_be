import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerUserAnswerService } from './pre-kuisioner-user-answer.service';

describe('PreKuisionerUserAnswerService', () => {
  let service: PreKuisionerUserAnswerService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PreKuisionerUserAnswerService],
    }).compile();

    service = module.get<PreKuisionerUserAnswerService>(PreKuisionerUserAnswerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
