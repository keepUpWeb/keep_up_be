import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerAnswerService } from './pre-kuisioner-answer.service';

describe('PreKuisionerAnswerService', () => {
  let service: PreKuisionerAnswerService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PreKuisionerAnswerService],
    }).compile();

    service = module.get<PreKuisionerAnswerService>(PreKuisionerAnswerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
