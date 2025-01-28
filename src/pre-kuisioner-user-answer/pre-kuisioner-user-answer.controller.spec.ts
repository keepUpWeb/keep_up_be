import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerUserAnswerController } from './pre-kuisioner-user-answer.controller';
import { PreKuisionerUserAnswerService } from './pre-kuisioner-user-answer.service';

describe('PreKuisionerUserAnswerController', () => {
  let controller: PreKuisionerUserAnswerController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PreKuisionerUserAnswerController],
      providers: [PreKuisionerUserAnswerService],
    }).compile();

    controller = module.get<PreKuisionerUserAnswerController>(PreKuisionerUserAnswerController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
