import { Test, TestingModule } from '@nestjs/testing';
import { KuisionerController } from './kuisioner.controller';

describe('KuisionerController', () => {
  let controller: KuisionerController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [KuisionerController],
    }).compile();

    controller = module.get<KuisionerController>(KuisionerController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
