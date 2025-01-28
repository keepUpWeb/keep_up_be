/* eslint-disable prettier/prettier */
import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { LoggingMiddleware } from './common/middleware/loggingRoute.middleware';
import { DatabaseModule } from './database/database.module';
import { UserModule } from './user/user.module';
import { RolesModule } from './roles/roles.module';
import { FacultysModule } from './facultys/facultys.module';
import { EmailModule } from './email/email.module';
import { KuisionerModule } from './kuisioner/kuisioner.module';
import { SubKuisionerModule } from './sub-kuisioner/sub-kuisioner.module';
import { SymtompsModule } from './symtomps/symtomps.module';
import { QuestionsModule } from './questions/questions.module';
import { AnswersModule } from './answers/answers.module';
import { TakeKuisionerModule } from './take-kuisioner/take-kuisioner.module';
import { UserAnswerKuisionerModule } from './user-answer-kuisioner/user-answer-kuisioner.module';
import { UserAnswerSubKuisionerModule } from './user-answer-sub-kuisioner/user-answer-sub-kuisioner.module';
import { ClientPsychologistModule } from './client_psychologist/client_psychologist.module';
import { PyschologyModule } from './pyschology/pyschology.module';
import { AikeepUpModule } from './aikeep-up/aikeep-up.module';
import { StatistikSuperadminModule } from './statistik-superadmin/statistik-superadmin.module';
import { ExportResultModule } from './export-result/export-result.module';
import { PreKuisionerCategoryModule } from './pre-kuisioner-category/pre-kuisioner-category.module';
import { PreKuisionerQuestionModule } from './pre-kuisioner-question/pre-kuisioner-question.module';
import { PreKuisionerAnswerModule } from './pre-kuisioner-answer/pre-kuisioner-answer.module';
import { PreKuisionerUserModule } from './pre-kuisioner-user/pre-kuisioner-user.module';
import { PreKuisionerUserAnswerModule } from './pre-kuisioner-user-answer/pre-kuisioner-user-answer.module';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { CacheModule } from '@nestjs/cache-manager';
import { StatistikPsychologyModule } from './statistik-psychology/statistik-psychology.module';
import { SumaryKuisionerModule } from './sumary_kuisioner/sumary_kuisioner.module';
import { MajorModule } from './major/major.module';

@Module({
  imports: [
    AuthModule,
    DatabaseModule,
    UserModule,
    RolesModule,
    FacultysModule,
    EmailModule,
    KuisionerModule,
    SubKuisionerModule,
    SymtompsModule,
    QuestionsModule,
    AnswersModule,
    TakeKuisionerModule,
    UserAnswerKuisionerModule,
    UserAnswerSubKuisionerModule,
    ClientPsychologistModule,
    PyschologyModule,
    AikeepUpModule,
    ExportResultModule,
    StatistikSuperadminModule,
    PreKuisionerCategoryModule,
    PreKuisionerQuestionModule,
    PreKuisionerAnswerModule,
    PreKuisionerUserModule,
    PreKuisionerUserAnswerModule,

    ThrottlerModule.forRoot([{
      ttl: 60000,  // 1 minute (60000ms)
      limit: 50,   // Allow up to 10 requests within 1 minute
    }]),

    CacheModule.register({
      isGlobal:true,
      ttl: 300000, // time to live in seconds
      max: 10, // maximum number of items in cache
    }),

    StatistikPsychologyModule,


    SumaryKuisionerModule,


    MajorModule,

  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard
    }
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(LoggingMiddleware).forRoutes('*');
  }
}
