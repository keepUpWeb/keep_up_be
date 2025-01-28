import { Test, TestingModule } from '@nestjs/testing';
import { PyschologyController } from './psychology.controller';
import { PyschologyService } from './pyschology.service';

describe('PyschologyController', () => {
  let controller: PyschologyController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [PyschologyController],
      providers: [PyschologyService],
    }).compile();

    controller = module.get<PyschologyController>(PyschologyController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
