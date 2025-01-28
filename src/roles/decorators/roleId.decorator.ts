import { createParamDecorator, ExecutionContext, BadRequestException } from '@nestjs/common';
import { IsUUID } from 'class-validator';

export const RoleId = createParamDecorator(
    (data: unknown, ctx: ExecutionContext): string => {
        const request = ctx.switchToHttp().getRequest();
        const roleId = request.user?.role;

        // Validate if the userId is a valid UUID
        if (!roleId || !IsUUID(roleId)) {
            throw new BadRequestException('Invalid role ID format');
        }

        return roleId;
    },
);
