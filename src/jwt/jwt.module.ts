// src/jwt/jwt.module.ts
import { Global, Module } from '@nestjs/common';
import { JwtModule as NestJwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';
import jwtConfig from 'src/config/jwt.config'; // Adjust import path as necessary
import { validationSchema } from 'src/config/validation.schema'; // Adjust import path as necessary
import { JwtKeepUpService } from './jwt.service';
import { PassportModule } from '@nestjs/passport';
import { UserModule } from 'src/user/user.module';

@Global()
@Module({
  imports: [
    UserModule,
    ConfigModule.forRoot({
      load: [jwtConfig], // Load the JWT config
      validationSchema, // Use the Joi schema for validation
      envFilePath: ['.env'], // Load environment variables from .env
    }),
    NestJwtModule.registerAsync({
      imports: [ConfigModule], // Import ConfigModule
      useFactory: (configService: ConfigService) => ({
        secret: configService.get<string>('jwt.access_secret'), // Use ConfigService for the JWT secret
        signOptions: {
          expiresIn: configService.get<string>('jwt.access_expired'),
        }, // Set default expiration for access tokens
      }),
      inject: [ConfigService], // Inject ConfigService
    }),
  ],
  providers: [JwtKeepUpService],
  exports: [JwtKeepUpService],
})
export class JwtKeepUpModule {}
