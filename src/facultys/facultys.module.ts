import { forwardRef, Module } from '@nestjs/common';
import { FacultysService } from './facultys.service';
import { FacultysController } from './facultys.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Faculty } from './entities/faculty.entity';
import { JwtKeepUpModule } from 'src/jwt/jwt.module';
import { UserModule } from 'src/user/user.module';

@Module({
  imports: [TypeOrmModule.forFeature([Faculty]), forwardRef(() => UserModule)],
  providers: [FacultysService],
  controllers: [FacultysController],
  exports: [FacultysService],
})
export class FacultysModule {}
