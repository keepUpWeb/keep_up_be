import { Test, TestingModule } from '@nestjs/testing';
import { SubKuisionerController } from './sub-kuisioner.controller';
import { SubKuisionerService } from './sub-kuisioner.service';

describe('SubKuisionerController', () => {
  let controller: SubKuisionerController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SubKuisionerController],
      providers: [SubKuisionerService],
    }).compile();

    controller = module.get<SubKuisionerController>(SubKuisionerController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
