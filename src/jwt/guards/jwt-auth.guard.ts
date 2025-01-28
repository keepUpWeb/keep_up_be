// jwt-auth.guard.ts
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
import { IS_VERIFICATION_REQUIRED_KEY } from '../decorator/jwtRoute.decorator';
import { UserService } from 'src/user/user.service';
import { Reflector } from '@nestjs/core';
import { JwtPayloadInterfaces } from '../interfaces/jwtPayload.interface';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  private readonly logger = new Logger(JwtAuthGuard.name);

  constructor(
    private userService: UserService,
    private jwtService: JwtKeepUpService,
    private reflector: Reflector, // Use reflector to access route metadata
  ) { }

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context
      .switchToHttp()
      .getRequest<Request & { user?: JwtPayloadInterfaces }>(); // Extend Request type to include user
    const token = this.extractTokenFromHeader(request);

    if (!token) {
      this.logger.warn('Token not found in request headers');
      throw new UnauthorizedException('Token Not Found');
    }

    try {
      // Verify the access token and ensure it's a valid JwtPayload
      const payload = await this.jwtService.verifyAccessToken(token);
      request.user = payload;
      this.logger.log(`Token validated successfully for user ID`);

      // Read the verification requirement from route metadata
      const requiresVerification = this.reflector.get<boolean>(
        IS_VERIFICATION_REQUIRED_KEY,
        context.getHandler(),
      );

      // If verification is required and the user is not verified, throw an exception
      if (requiresVerification) {
        const user = await this.userService.findById(request.user.id);

        if (!user || !user.auth.isVerification) {
          // Assuming `isVerified` is a property on your user model
          this.logger.warn('User is not verified');
          throw new ForbiddenException(
            'User must be verified to access this route',
          );
        }
      }
    } catch (error) {
      // Handle specific token errors
      if (error instanceof TokenExpiredError) {
        this.logger.warn('Token has expired');
        throw new UnauthorizedException('Token Expired');
      } else if (error instanceof JsonWebTokenError) {
        this.logger.error('Invalid token detected');
        throw new ForbiddenException('Invalid token');
      } else {
        // Handle unexpected errors
        this.logger.error(
          'Unexpected error during token validation',
          error.message,
        );
        throw new UnauthorizedException('Access Denied');
      }
    }

    return true;
  }

  // Extracts the Bearer token from the Authorization header
  private extractTokenFromHeader(request: Request): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    if (type === 'Bearer') {
      this.logger.debug('Extracted Bearer token from header');
      return token;
    } else {
      this.logger.warn('Authorization header format is incorrect');
      return undefined;
    }
  }
}
