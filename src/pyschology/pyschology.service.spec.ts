import { Test, TestingModule } from '@nestjs/testing';
import { PyschologyService } from './pyschology.service';

describe('PyschologyService', () => {
  let service: PyschologyService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [PyschologyService],
    }).compile();

    service = module.get<PyschologyService>(PyschologyService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
