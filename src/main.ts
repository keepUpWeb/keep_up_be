import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe, VersioningType } from '@nestjs/common';
import { HttpExceptionFilter } from './common/response/error.filter';
import * as cookieParser from 'cookie-parser';
import * as compression from 'compression';
import helmet from 'helmet';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors({
    origin: ['https://greatly-free-oriole.ngrok-free.app', 'https://husky-coherent-legally.ngrok-free.app','http://localhost:5500',"https://keepupadmin.vercel.app","http://localhost:32523","https://keepup-user.vercel.app"], // Specific domain (or '*' for all)
    credentials: true,
  });

  app.use(cookieParser());
  app.use(compression());
  app.use(helmet());



  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  app.useGlobalFilters(new HttpExceptionFilter());

  app.enableVersioning({
    type: VersioningType.URI, // Use /v1/ in the URI
  });

  await app.listen(3000);
}
bootstrap();
