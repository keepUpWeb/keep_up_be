import {
  registerDecorator,
  ValidationArguments,
  ValidatorConstraint,
  ValidatorConstraintInterface,
  ValidationOptions,
} from 'class-validator';

@ValidatorConstraint({ name: 'isNotBlank', async: false })
export class IsNotBlankConstraint implements ValidatorConstraintInterface {
  // Validate that the string is not blank (i.e., not just spaces)
  validate(value: any): boolean {
    return typeof value === 'string' && value.trim().length > 0;
  }

  // Default message if not overridden
  defaultMessage(args: ValidationArguments): string {
    return `${args.property} should not be empty or contain only spaces`;
  }
}

// Custom decorator function that accepts validation options, including a custom message
export function isNotBlank(validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      target: object.constructor,
      propertyName,
      options: validationOptions, // Pass the validation options, including the message
      constraints: [],
      validator: IsNotBlankConstraint,
    });
  };
}
