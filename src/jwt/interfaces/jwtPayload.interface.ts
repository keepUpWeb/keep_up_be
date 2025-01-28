// src/jwt/interfaces/jwt-payload.interface.ts
export interface JwtPayloadInterfaces {
  id: string; // User ID
  user: string; // Username
  role: string; // Role ID
  iat: number; // Issued At timestamp
  iss: string; // Issuer
  aud: string; // Audience
}
