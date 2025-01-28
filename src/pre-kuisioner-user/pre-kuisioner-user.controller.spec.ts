import { Test, TestingModule } from '@nestjs/testing';
import { PreKuisionerUserController } from './pre-kuisioner-user.controller';
import { PreKuisionerUserService } from './pre-kuisioner-user.service';

describe('PreKuisionerUserController', () => {
  let controller: PreKuisionerUserController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PreKuisionerUserController],
      providers: [PreKuisionerUserService],
    }).compile();

    controller = module.get<PreKuisionerUserController>(PreKuisionerUserController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
