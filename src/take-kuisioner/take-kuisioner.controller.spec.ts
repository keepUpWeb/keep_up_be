import { Test, TestingModule } from '@nestjs/testing';
import { TakeKuisionerController } from './take-kuisioner.controller';
import { TakeKuisionerService } from './take-kuisioner.service';

describe('TakeKuisionerController', () => {
  let controller: TakeKuisionerController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TakeKuisionerController],
      providers: [TakeKuisionerService],
    }).compile();

    controller = module.get<TakeKuisionerController>(TakeKuisionerController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
