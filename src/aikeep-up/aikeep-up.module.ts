import { Module } from '@nestjs/common';
import { AikeepUpService } from './aikeep-up.service';
import { ConfigModule } from '@nestjs/config';
import aiConfig from 'src/config/ai.config';
import { validationSchema } from 'src/config/validation.schema';

@Module({
  imports: [
    ConfigModule.forRoot({
      load: [aiConfig], // Load only the database config
      validationSchema, // Use the Joi schema for validation
      envFilePath: ['.env'], // Use the environment file
    }),
  ],
  providers: [AikeepUpService],
  controllers: [],
  exports:[AikeepUpService]
})
export class AikeepUpModule {}
