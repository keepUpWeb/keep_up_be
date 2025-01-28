import { Test, TestingModule } from '@nestjs/testing';
import { StatistikSuperadminService } from './statistik-superadmin.service';

describe('StatistikSuperadminService', () => {
  let service: StatistikSuperadminService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [StatistikSuperadminService],
    }).compile();

    service = module.get<StatistikSuperadminService>(
      StatistikSuperadminService,
    );
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
