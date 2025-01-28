import { Test, TestingModule } from '@nestjs/testing';
import { StatistikSuperadminController } from './statistik-superadmin.controller';

describe('StatistikSuperadminController', () => {
  let controller: StatistikSuperadminController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [StatistikSuperadminController],
    }).compile();

    controller = module.get<StatistikSuperadminController>(
      StatistikSuperadminController,
    );
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
