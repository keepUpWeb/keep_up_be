import {
  BadRequestException,
  ForbiddenException,
  HttpException,
  HttpStatus,
  Inject,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
  Res,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from 'src/user/entities/user.entity';
import { DataSource, Repository } from 'typeorm';
import { Auth } from './entities/auth.entity';
import { randomUUID } from 'crypto';
import { EmailService } from 'src/email/email.service';
import { UserService } from 'src/user/user.service';
import {
  comparePasswords,
  hashPassword,
} from 'src/common/function/password.function';
import { RolesService } from 'src/roles/roles.service';
import { JwtKeepUpService } from 'src/jwt/jwt.service';
import { UserId } from 'src/user/decorator/userId.decorator';
import { JwtPayloadInterfaces } from 'src/jwt/interfaces/jwtPayload.interface';
import { RegisterRequestDTO } from './dto/request/registerRequest.dto';
import { LoginRequestDTO } from './dto/request/loginRequest.dto';
import { ROLES } from 'src/roles/group/role.enum';
import { PsikologiStatus } from 'src/pyschology/group/psikologiStatus.enum';
import { ClientPsychologistService } from 'src/client_psychologist/client_psychologist.service';
import { CreateUserDto } from 'src/user/dto/create-user.dto';
import { CreatePyschologyDto } from 'src/pyschology/dto/create-pyschology.dto';
import { PreKuisionerUser } from 'src/pre-kuisioner-user/entities/pre-kuisioner-user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(Auth)
    private authRepository: Repository<Auth>,

    @Inject(EmailService)
    private emailService: EmailService,

    @Inject(UserService)
    private userService: UserService,

    @Inject(RolesService)
    private roleService: RolesService,

    @Inject(JwtKeepUpService)
    private jwtKeepUpService: JwtKeepUpService,

    @Inject(ClientPsychologistService)
    private readonly clientPsychologistService: ClientPsychologistService,

    private dataSource: DataSource,
  ) { }

  private async isEmailNotExist(email: string): Promise<boolean> {
    const existingUser = await this.userService.findByEmail(email);
    return !existingUser; // Returns true if no user found
  }

  async createAuth(): Promise<Auth> {
    const newAuth = this.authRepository.create({
      token: this.generateTokenConfirmation(), // Generate a confirmation token
    });

    // Save the new auth record to get the generated ID
    const savedAuth = await this.authRepository.save(newAuth);
    return savedAuth;
  }

  async register(registerAuthDTO: RegisterRequestDTO, origin: string): Promise<RegisterData> {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // Check if the email is already registered
      const emailNotExists = await this.isEmailNotExist(registerAuthDTO.email);
      if (!emailNotExists) {
        throw new ForbiddenException(
          'The email is already in use by another account',
        );
      }

      // Check if passwords match
      if (registerAuthDTO.password !== registerAuthDTO.retypedpassword) {
        throw new BadRequestException('Passwords do not match');
      }

      // Determine roleId based on origin
      let roleId: string;
      if (origin === 'https://keepup-user.vercel.app' || origin === 'http://localhost:32523') {
        roleId = ROLES.USER; // Role for greatly-free-oriole
      } else if (origin === 'https://keepupadmin.vercel.app') {

        roleId = ROLES.ADMIN; // Role for husky-coherent-legally
        
      }


      const role = await this.roleService.getRoleById(roleId);
      if (!role) {
        throw new BadRequestException('Invalid Role ID');
      }

      // Hash the password
      const hashedPassword = await hashPassword(registerAuthDTO.password);

      // Create a new auth record WITHIN the transaction
      const authRecord = new Auth(); // Assuming Auth is the entity for auth records
      authRecord.token = this.generateTokenConfirmation(); // Generate token logic
      await queryRunner.manager.save(Auth, authRecord); // Save it within the transaction


      const preKuisionerUser = new PreKuisionerUser();
      preKuisionerUser.isFinish = false; // Fill in any other required fields here
      await queryRunner.manager.save(PreKuisionerUser, preKuisionerUser);


      // Initialize new user
      let newUser: any;

      // Role-specific user creation logic
      if (role.id === ROLES.ADMIN) {
        newUser = new CreatePyschologyDto();
        newUser.psikologStatus = PsikologiStatus.Pending;
      } else if (role.id === ROLES.USER) {
        newUser = new CreateUserDto();
        newUser.preKuisioner = preKuisionerUser
      }

      // Common user properties
      newUser.email = registerAuthDTO.email;
      newUser.username = registerAuthDTO.username;
      newUser.password = hashedPassword;
      newUser.auth = authRecord;
      newUser.role = role;



      // Save the user using the query runner's transactional method
      const saveUser = await queryRunner.manager.save(User, newUser);

      //if the role is User Assign the user to the Psikolog that have filter by Faculty and Have Minimum Client
      if (role.id === ROLES.USER) {
        this.clientPsychologistService.createOnRegisterUser(
          saveUser,
          queryRunner,
        );
      }

      // Send the confirmation email
      await this.emailService.sendConfirmationEmail(
        registerAuthDTO.email,
        registerAuthDTO.username,
        authRecord.token,
        authRecord.id,
      );

      // Commit the transaction if everything is successful
      await queryRunner.commitTransaction();

      const payload = {
        id: newUser.id,
        user: newUser.username,
        role: newUser.role.id,
        iat: Math.floor(Date.now() / 1000),
        iss: 'ApiKeepUp',
        aud: 'KeepUp',
      };

      // Step 4: Generate access and refresh tokens
      const accessToken =
        await this.jwtKeepUpService.generateAccessToken(payload);

      const data: RegisterData = {
        access_token: accessToken,
        created_at: new Date(),
      };

      // Return success response
      return data;
    } catch (error) {
      // Roll back the transaction in case of any failure
      await queryRunner.rollbackTransaction();

      if (error instanceof HttpException) {
        throw error;
      }

      throw new InternalServerErrorException(error.message);
    } finally {
      // Release the query runner after the transaction
      await queryRunner.release();
    }
  }

  async login(loginAuthDTO: LoginRequestDTO): Promise<LoginData> {
    const user = await this.userService.findByEmail(loginAuthDTO.email);

    if (!user) {
      throw new ForbiddenException('Invalid credentials');
    }

    const isPasswordValid = await comparePasswords(
      loginAuthDTO.password,
      user.password,
    );

    if (!isPasswordValid) {
      throw new ForbiddenException('Invalid credentials');
    }

    const payload: JwtPayloadInterfaces = {
      id: user.id,
      user: user.username,
      role: user.role.id,
      iat: Math.floor(Date.now() / 1000),
      iss: 'ApiKeepUp',
      aud: 'KeepUp',
    };

    // Step 4: Generate access and refresh tokens
    const accessToken =
      await this.jwtKeepUpService.generateAccessToken(payload);

    const refreshToken =
      await this.jwtKeepUpService.generateRefreshToken(payload);

    const data: LoginData = {
      access_token: accessToken,
      refresh_token: refreshToken,
    };

    if (user.role.id == ROLES.SUPERADMIN) {

      data.isAdmin = false

    } else if (user.role.id == ROLES.ADMIN) {
      data.isAdmin = true

    }

    return data;
  }

  async resendConfirmation(@UserId() userId: string): Promise<boolean> {
    // Find the user by ID
    const dataUser = await this.userService.findById(userId);
    if (!dataUser) {
      throw new NotFoundException('User not found');
    }

    // Find the corresponding auth record
    const updateTokenAuth = await this.authRepository.findOne({
      where: { id: dataUser.auth.id },
    });

    if (!updateTokenAuth) {
      throw new NotFoundException('Auth record not found');
    }

    if (updateTokenAuth.isVerification) {
      throw new ForbiddenException('Your Account Is Verified');
    }

    // Generate a new confirmation token
    updateTokenAuth.token = this.generateTokenConfirmation();

    // Save the updated auth record with the new token
    await this.authRepository.save(updateTokenAuth);

    // Send the confirmation email
    await this.emailService.sendConfirmationEmail(
      dataUser.email,
      dataUser.username,
      updateTokenAuth.token,
      dataUser.auth.id,
    );

    return true;
  }

  async confirmEmail(authId: string, token: string): Promise<boolean> {
    try {
      // Find the auth record by authId and token
      const authRecord = await this.authRepository.findOne({
        where: { id: authId, token },
      });

      // Check if the auth record exists
      if (!authRecord) {
        throw new BadRequestException('Invalid token or authId');
      }

      // Check if the email is already confirmed
      if (authRecord.isVerification) {
        throw new BadRequestException('Email is already confirmed');
      }

      // Mark the email as confirmed
      authRecord.isVerification = true;
      authRecord.verificationAt = new Date();
      await this.authRepository.save(authRecord);

      return true; // Return true if the confirmation was successful
    } catch (error) {
      // Check if the error is an instance of HttpException (covers all known HTTP exceptions)
      if (error instanceof HttpException) {
        throw error; // Re-throw all known HTTP exceptions (Forbidden, Unauthorized, BadRequest, etc.)
      }

      throw new InternalServerErrorException(
        'An unexpected error occurred during registration. Please try again later.',
      );
    }
  }

  async refreshToken(user: any): Promise<RefreshData> {
    const payload: JwtPayloadInterfaces = {
      id: user.id,
      user: user.username,
      role: user.role,
      iat: Math.floor(Date.now() / 1000),
      iss: 'ApiKeepUp',
      aud: 'KeepUp',
    };

    // Step 4: Generate access and refresh tokens
    const accessToken =
      await this.jwtKeepUpService.generateAccessToken(payload);

    const data: RefreshData = {
      access_token: accessToken,
    };
    return data;
  }

  private generateTokenConfirmation(): string {
    return randomUUID();
  }
}
