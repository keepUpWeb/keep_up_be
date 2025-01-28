import { Test, TestingModule } from '@nestjs/testing';
import { SymtompsService } from './symtomps.service';

describe('SymtompsService', () => {
  let service: SymtompsService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [SymtompsService],
    }).compile();

    service = module.get<SymtompsService>(SymtompsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
