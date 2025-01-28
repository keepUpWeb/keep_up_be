import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerCategoryController } from './pre-kuisioner-category.controller';
import { PreKuisionerCategoryService } from './pre-kuisioner-category.service';

describe('PreKuisionerCategoryController', () => {
  let controller: PreKuisionerCategoryController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PreKuisionerCategoryController],
      providers: [PreKuisionerCategoryService],
    }).compile();

    controller = module.get<PreKuisionerCategoryController>(PreKuisionerCategoryController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
