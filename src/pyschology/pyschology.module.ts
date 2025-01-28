import { Module } from '@nestjs/common';
import { PyschologyService } from './pyschology.service';
import { PyschologyController } from './psychology.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from 'src/user/entities/user.entity';
import { RolesModule } from 'src/roles/roles.module';
import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, TakeKuisioner]), RolesModule],
  controllers: [PyschologyController],
  providers: [PyschologyService],
  exports: [PyschologyService],
})
export class PyschologyModule { }
