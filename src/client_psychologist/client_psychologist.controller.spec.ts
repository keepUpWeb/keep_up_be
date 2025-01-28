import { Test, TestingModule } from '@nestjs/testing';
import { ClientPsychologistController } from './client_psychologist.controller';
import { ClientPsychologistService } from './client_psychologist.service';

describe('ClientPsychologistController', () => {
  let controller: ClientPsychologistController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ClientPsychologistController],
      providers: [ClientPsychologistService],
    }).compile();

    controller = module.get<ClientPsychologistController>(
      ClientPsychologistController,
    );
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
