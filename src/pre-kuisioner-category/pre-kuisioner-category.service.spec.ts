import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerCategoryService } from './pre-kuisioner-category.service';

describe('PreKuisionerCategoryService', () => {
  let service: PreKuisionerCategoryService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PreKuisionerCategoryService],
    }).compile();

    service = module.get<PreKuisionerCategoryService>(PreKuisionerCategoryService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
