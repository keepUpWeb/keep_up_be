import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Auth } from './entities/auth.entity';
import { EmailModule } from 'src/email/email.module';
import { UserModule } from 'src/user/user.module';
import { RolesModule } from 'src/roles/roles.module';
import { JwtKeepUpModule } from 'src/jwt/jwt.module';
import { ClientPsychologistModule } from 'src/client_psychologist/client_psychologist.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Auth]),
    JwtKeepUpModule,
    RolesModule,
    EmailModule,
    UserModule,
    ClientPsychologistModule,
  ],
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
