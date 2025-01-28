export default () => ({
  openai: {
    apiKey: process.env.OPENAI_API_KEY, // Fetch OpenAI API key from the environment variables
    model: process.env.OPENAI_MODEL || 'gpt-3.5-turbo', // Use default model or specify via environment variables
    maxTokens: parseInt(process.env.OPENAI_MAX_TOKENS, 10) || 150, // Max tokens, with a default value
    temperature: parseFloat(process.env.OPENAI_TEMPERATURE) || 0.7, // Temperature parameter with a default value
  },
});
