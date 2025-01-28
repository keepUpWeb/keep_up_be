import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Request, Response } from 'express';
import { ResponseApi } from './responseApi.format';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const status = exception.getStatus();
    const exceptionResponse: any = exception.getResponse();

    const errorResponse = new ResponseApi<any>(
      status,
      exceptionResponse.message || 'Internal server error',
      null,
    );

    response.status(status).json({
      statusCode: errorResponse.statusCode,
      message: errorResponse.message,
      data: errorResponse.data,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
