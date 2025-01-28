import { createParamDecorator, ExecutionContext, BadRequestException } from '@nestjs/common';
import { IsUUID } from 'class-validator';

export const UserId = createParamDecorator(
  (data: unknown, ctx: ExecutionContext): string => {
    const request = ctx.switchToHttp().getRequest();
    const userId = request.user?.id;


    // Validate if the userId is a valid UUID
    if (!userId || !IsUUID(userId)) {
      throw new BadRequestException('Invalid user ID format');
    }

    return userId;
  },
);
