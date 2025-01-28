import {
  Controller,
  Get,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  HttpStatus,
  ParseUUIDPipe,
  InternalServerErrorException,
} from '@nestjs/common';
import { UserService } from './user.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { UserId } from './decorator/userId.decorator';
import { UserProfileDto } from './dto/user-profile.dto';

@Controller({ path: 'user', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class UserController {
  constructor(private readonly userService: UserService) {}

  // @Get()
  // findAll() {
  //   return this.userService.findAll();
  // }

  @Get()
  @IsVerificationRequired(true)
  @Roles(ROLES.USER, ROLES.ADMIN, ROLES.SUPERADMIN)
  async profile(
    @UserId() userId: string,
  ): Promise<ResponseApi<any>> {
    const userData = await this.userService.findOne(userId);

    // Map the User entity to UserProfileDto to exclude unwanted fields
    // const userProfile: UserProfileDto = {
    //   id: userData.id,
    //   email: userData.email,
    //   username: userData.username,
    //   nim: userData.nim,
    //   yearEntry: userData.yearEntry,
    //   gender: userData.gender,
    //   birthDate: userData.birthDate, // Optional
    // };

    return new ResponseApi(HttpStatus.OK, 'Get User Successfully', userData);
  }

  @Get(':id')
  @IsVerificationRequired(true)
  @Roles(ROLES.ADMIN, ROLES.SUPERADMIN)
  async findOne(
    @Param('id', new ParseUUIDPipe()) userId: string,
  ): Promise<ResponseApi<UserProfileDto>> {
    const userData = await this.userService.findOne(userId);

    const userProfile: UserProfileDto = {
      id: userData.id,
      email: userData.email,
      username: userData.username,
      nim: userData.nim,
      yearEntry: userData.yearEntry,
      gender: userData.gender,
      birthDate: userData.birthDate, // Optional
    };

    return new ResponseApi(HttpStatus.OK, 'Get User Successfully', userProfile);
  }

  @Patch()
  @IsVerificationRequired(true)
  @Roles(ROLES.USER, ROLES.ADMIN, ROLES.SUPERADMIN)
  async update(
    @UserId() id: string,
    @Body() updateUserDto: UpdateUserDto,
  ): Promise<ResponseApi<Date>> {
    const data = await this.userService.update(id, updateUserDto);

    return new ResponseApi(
      HttpStatus.OK,
      'Update User Successfully',
      data.updatedAt,
    );
  }

  @Delete()
  @IsVerificationRequired(true)
  @Roles(ROLES.USER, ROLES.ADMIN, ROLES.SUPERADMIN)
  async remove(@UserId() userId: string): Promise<ResponseApi<string>> {
    const data = await this.userService.remove(userId);

    if (!data) {
      throw new InternalServerErrorException('Gagagl');
    }

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Delete User',
      'success',
    );
  }
}
