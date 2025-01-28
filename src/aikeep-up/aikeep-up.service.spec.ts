import { Test, TestingModule } from '@nestjs/testing';
import { AikeepUpService } from './aikeep-up.service';

describe('AikeepUpService', () => {
  let service: AikeepUpService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [AikeepUpService],
    }).compile();

    service = module.get<AikeepUpService>(AikeepUpService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
