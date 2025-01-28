// refresh-token.guard.ts
import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
  Logger,
} from '@nestjs/common';
import { Request } from 'express';
import { JwtKeepUpService } from '../jwt.service';
import { JsonWebTokenError, TokenExpiredError } from '@nestjs/jwt';
import { UserService } from 'src/user/user.service';
import { JwtPayloadInterfaces } from '../interfaces/jwtPayload.interface';

@Injectable()
export class RefreshTokenGuard implements CanActivate {
  private readonly logger = new Logger(RefreshTokenGuard.name);

  constructor(
    private userService: UserService,
    private jwtService: JwtKeepUpService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context
      .switchToHttp()
      .getRequest<Request & { user?: JwtPayloadInterfaces }>();
    const token = this.extractTokenFromCookies(request); // Use cookies instead of header

    if (!token) {
      this.logger.warn('Refresh token not found in cookies');
      throw new UnauthorizedException('Refresh Token Not Found');
    }

    try {
      // Verify the refresh token
      const payload = await this.jwtService.verifyRefreshToken(token);
      request.user = payload; // Attach the payload to the request
      this.logger.log('Refresh token validated successfully for user ID');
    } catch (error) {
      // Handle token errors specifically
      if (error instanceof TokenExpiredError) {
        this.logger.warn('Refresh token has expired');
        throw new UnauthorizedException('Refresh Token Expired');
      } else if (error instanceof JsonWebTokenError) {
        this.logger.error('Invalid refresh token detected');
        throw new ForbiddenException('Invalid Refresh Token');
      } else {
        this.logger.error(
          'Unexpected error during refresh token validation',
          error.message,
        );
        throw new UnauthorizedException('Access Denied');
      }
    }

    return true;
  }

  // Extracts the refresh token from cookies
  private extractTokenFromCookies(request: Request): string | undefined {
    const token = request.cookies['refreshToken']; // Assuming refresh token is stored in 'refreshToken' cookie
    if (token) {
      this.logger.debug('Extracted refresh token from cookies');
      return token;
    } else {
      this.logger.warn('Refresh token not found in cookies');
      return undefined;
    }
  }
}
