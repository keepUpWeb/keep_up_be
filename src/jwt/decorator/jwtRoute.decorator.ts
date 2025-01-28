// is-verification-required.decorator.ts
import { SetMetadata } from '@nestjs/common';

// Define a constant key for the metadata
export const IS_VERIFICATION_REQUIRED_KEY = 'isVerificationRequired';

// Create a decorator that sets the verification requirement on the route
export const IsVerificationRequired = (required: boolean = true) =>
  SetMetadata(IS_VERIFICATION_REQUIRED_KEY, required);
