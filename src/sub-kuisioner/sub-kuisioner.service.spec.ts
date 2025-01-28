import { Test, TestingModule } from '@nestjs/testing';
import { SubKuisionerService } from './sub-kuisioner.service';

describe('SubKuisionerService', () => {
  let service: SubKuisionerService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [SubKuisionerService],
    }).compile();

    service = module.get<SubKuisionerService>(SubKuisionerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
