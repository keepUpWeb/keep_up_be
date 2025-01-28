import { Test, TestingModule } from '@nestjs/testing';
import { SymtompsController } from './symtomps.controller';
import { SymtompsService } from './symtomps.service';

describe('SymtompsController', () => {
  let controller: SymtompsController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SymtompsController],
      providers: [SymtompsService],
    }).compile();

    controller = module.get<SymtompsController>(SymtompsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
