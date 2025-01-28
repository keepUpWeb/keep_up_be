import { Test, TestingModule } from '@nestjs/testing';
import { TakeKuisionerService } from './take-kuisioner.service';

describe('TakeKuisionerService', () => {
  let service: TakeKuisionerService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [TakeKuisionerService],
    }).compile();

    service = module.get<TakeKuisionerService>(TakeKuisionerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
