import { forwardRef, Global, Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { FacultysModule } from 'src/facultys/facultys.module';
import { Auth } from 'src/auth/entities/auth.entity';
import { MajorModule } from 'src/major/major.module';

@Global()
@Module({
  imports: [
    TypeOrmModule.forFeature([User, Auth]),
    forwardRef(() => FacultysModule),
    MajorModule
  ],
  controllers: [UserController],
  providers: [UserService],
  exports: [UserService],
})
export class UserModule {}
