import { Test, TestingModule } from '@nestjs/testing';
import { ClientPsychologistService } from './client_psychologist.service';

describe('ClientPsychologistService', () => {
  let service: ClientPsychologistService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ClientPsychologistService],
    }).compile();

    service = module.get<ClientPsychologistService>(ClientPsychologistService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
