import { Module } from '@nestjs/common';
import { PreKuisionerUserService } from './pre-kuisioner-user.service';
import { PreKuisionerUserController } from './pre-kuisioner-user.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PreKuisionerUser } from './entities/pre-kuisioner-user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([PreKuisionerUser])],
  controllers: [PreKuisionerUserController],
  providers: [PreKuisionerUserService],
  exports: [PreKuisionerUserService]
})
export class PreKuisionerUserModule { }
