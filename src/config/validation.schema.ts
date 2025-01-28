import * as Joi from 'joi';

export const validationSchema = Joi.object({
  // Database config validation
  DATABASE_HOST: Joi.string().required(),
  DATABASE_PORT: Joi.number().required(),
  DATABASE_USER: Joi.string().required(),
  DATABASE_PASSWORD: Joi.string().required(),
  DATABASE_NAME: Joi.string().required(),

  // JWT secret validation
  JWT_ACCESS_SECRET: Joi.string().required(),
  JWT_REFRESH_SECRET: Joi.string().required(),

  // JWT expiration time validation (e.g., "1h", "7d", etc.)
  JWT_ACCESS_EXPIRED: Joi.string().required(),
  JWT_REFRESH_EXPIRED: Joi.string().required(),

  EMAIL_API_KEY: Joi.string().required(),

  BASE_URL_APP: Joi.string().required(),

  // OpenAI configuration validation
  OPENAI_API_KEY: Joi.string().required(),
  OPENAI_MODEL: Joi.string().default('gpt-3.5-turbo'), // Default to GPT-3.5-turbo if not provided
  OPENAI_MAX_TOKENS: Joi.number().default(150), // Default max tokens to 150
  OPENAI_TEMPERATURE: Joi.number().default(0.7),

  // NODE_ENV validation
  NODE_ENV: Joi.string()
    .valid('development', 'production')
    .default('development'),
});
