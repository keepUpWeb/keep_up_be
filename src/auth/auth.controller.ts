import {
  Controller,
  Get,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  Query,
  Res,
  UseGuards,
  Req,
  ParseUUIDPipe,
  Headers,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { Response } from 'express';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { UserId } from 'src/user/decorator/userId.decorator';
import { RefreshTokenGuard } from 'src/jwt/guards/jwt-refresh.guard';
import { RegisterResponseDTO } from './dto/response/registerResponse.dto';
import { LoginResponseDTO } from './dto/response/loginResponse.dto';
import { RefreshResponseDTO } from './dto/response/refreshResponse.dto';
import { RegisterRequestDTO } from './dto/request/registerRequest.dto';
import { LoginRequestDTO } from './dto/request/loginRequest.dto';

@Controller({ path: 'auth', version: '1' })
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post('register')
  async register(
    @Headers('origin') origin: string,
    @Body() registerAuthDTO: RegisterRequestDTO,
  ): Promise<ResponseApi<RegisterResponseDTO>> {
    const registerUser = await this.authService.register(registerAuthDTO,origin);

    const payload = new RegisterResponseDTO();

    payload.access_token = registerUser.access_token;
    payload.created_at = registerUser.created_at;

    return new ResponseApi(
      HttpStatus.CREATED,
      'Register Successfully',
      payload,
    );
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(
    @Body() loginAuthDTO: LoginRequestDTO,
    @Res({ passthrough: true }) res: Response,
  ): Promise<ResponseApi<LoginResponseDTO>> {
    const loginUser = await this.authService.login(loginAuthDTO);

    const payload = new LoginResponseDTO();
    payload.access_token = loginUser.access_token;

    // console.log(loginUser)

    // Check if `isAdmin` exists on `loginUser` and add it to `payload` without relying on truthiness
    if (loginUser.hasOwnProperty('isAdmin')) {
      payload.isAdmin = loginUser.isAdmin;
    }

    // Set the refresh token in HttpOnly cookie
    res.cookie('refreshToken', loginUser.refresh_token, {
      httpOnly: true,
      secure: true, // Ensures secure cookie in production
      sameSite: 'none',
      path: '/v1/auth/refresh', // Restrict where the refresh token can be used
      maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
    });

    return new ResponseApi(HttpStatus.OK, 'Login Successfully', payload);
  }

  @Post('resendConfirmation')
  @UseGuards(JwtAuthGuard)
  @IsVerificationRequired(false)
  async resendConfirmation(
    @UserId() userId: string,
  ): Promise<ResponseApi<string>> {
    const resendEmailConfirmation =
      await this.authService.resendConfirmation(userId);
    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Resend Confirmation Email',
    );
  }

  @Get('confirm')
  async confirmationEmail(
    @Res() response: Response,
    @Query('idAuth', new ParseUUIDPipe()) authId: string,
    @Query('token', new ParseUUIDPipe()) token: string,
  ) {
    // Call the service to confirm the email
    const result = await this.authService.confirmEmail(authId, token);

    // If confirmation is successful, respond with success message
    return response.redirect('https://keepup-iota.vercel.app/User/login');
  }

  @Post('refresh')
  @UseGuards(RefreshTokenGuard) // Protect route with RefreshTokenGuard
  async refresh(
    @Req() req: Request & { user?: any },
    @Res({ passthrough: true }) res: Response,
  ): Promise<ResponseApi<RefreshResponseDTO>> {
    const user = req.user;

    const payload = await this.authService.refreshToken(user);

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Create New Access Token',
      payload,
    );
  }
}
