import { Test, TestingModule } from '@nestjs/testing';
import { StatistikPsychologyService } from './statistik-psychology.service';

describe('StatistikPsychologyService', () => {
  let service: StatistikPsychologyService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [StatistikPsychologyService],
    }).compile();

    service = module.get<StatistikPsychologyService>(StatistikPsychologyService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
