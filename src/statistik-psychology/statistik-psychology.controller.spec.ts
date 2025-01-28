import { Test, TestingModule } from '@nestjs/testing';
import { StatistikPsychologyController } from './statistik-psychology.controller';
import { StatistikPsychologyService } from './statistik-psychology.service';

describe('StatistikPsychologyController', () => {
  let controller: StatistikPsychologyController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [StatistikPsychologyController],
      providers: [StatistikPsychologyService],
    }).compile();

    controller = module.get<StatistikPsychologyController>(StatistikPsychologyController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
