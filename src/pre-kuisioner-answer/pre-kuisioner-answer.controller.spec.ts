import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerAnswerController } from './pre-kuisioner-answer.controller';
import { PreKuisionerAnswerService } from './pre-kuisioner-answer.service';

describe('PreKuisionerAnswerController', () => {
  let controller: PreKuisionerAnswerController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PreKuisionerAnswerController],
      providers: [PreKuisionerAnswerService],
    }).compile();

    controller = module.get<PreKuisionerAnswerController>(PreKuisionerAnswerController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
