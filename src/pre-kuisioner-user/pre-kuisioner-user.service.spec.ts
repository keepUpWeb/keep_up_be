import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerUserService } from './pre-kuisioner-user.service';

describe('PreKuisionerUserService', () => {
  let service: PreKuisionerUserService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PreKuisionerUserService],
    }).compile();

    service = module.get<PreKuisionerUserService>(PreKuisionerUserService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
