import { Test, TestingModule } from '@nestjs/testing';
import { KuisionerService } from './kuisioner.service';

describe('KuisionerService', () => {
  let service: KuisionerService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [KuisionerService],
    }).compile();

    service = module.get<KuisionerService>(KuisionerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
