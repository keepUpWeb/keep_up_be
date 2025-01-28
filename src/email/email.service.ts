import {
  Injectable,
  InternalServerErrorException,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import * as brevo from '@getbrevo/brevo';
import { ConfigService } from '@nestjs/config';
import { TransactionalEmailsApi } from '@getbrevo/brevo';
import { generateConfirmationEmailContent } from 'src/common/function/generatorEmail.function';

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private apiInstance: any;

  constructor(private readonly configService: ConfigService) {
    // Initialize the Brevo API instance
    this.apiInstance = new TransactionalEmailsApi();

    // Set API key from environment variables
    const apiKey = (this.apiInstance.authentications['apiKey'].apiKey =
      this.configService.get<string>('email.apiKey'));
  }

  async sendConfirmationEmail(
    email: string,
    username: string,
    token: string,
    authId: string,
  ): Promise<void> {
    const confirmationLink = `${this.configService.get<string>('url.name')}/v1/auth/confirm?token=${token}&&idAuth=${authId}`;

    const emailContent = generateConfirmationEmailContent(
      username,
      confirmationLink,
    );

    await this.sendEmail(email, 'Confirm Your Email - Emind', emailContent);
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    try {
      const sendSmtpEmail = new brevo.SendSmtpEmail();

      sendSmtpEmail.subject = subject;
      sendSmtpEmail.htmlContent = htmlContent;
      sendSmtpEmail.sender = {
        name: 'KeepUp',
        email: 'd.raihan2004@gmail.com',
      }; // Customize sender
      sendSmtpEmail.to = [{ email: to, name: to.split('@')[0] }];
      sendSmtpEmail.replyTo = {
        email: 'd.raihan2004@gmail.com',
        name: 'KeepUp',
      };

      const response = await this.apiInstance.sendTransacEmail(sendSmtpEmail);
      // Use NestJS Logger for success logging
      this.logger.log(`Email sent successfully to ${to}`);
      return response;
    } catch (error) {
      this.logger.error(`Failed to send email to ${to}`, error.stack);
      throw new InternalServerErrorException('Email sending failed');
    }
  }
}
