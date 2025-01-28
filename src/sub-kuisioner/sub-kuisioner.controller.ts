import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  HttpStatus,
  UseGuards,
  ParseUUIDPipe,
  Inject,
} from '@nestjs/common';
import { SubKuisionerService } from './sub-kuisioner.service';
import {
  BodyCreateSubKuisionerDto,
  CreateSubKuisionerDto,
} from './dto/create-sub-kuisioner.dto';
import { UpdateSubKuisionerDto } from './dto/update-sub-kuisioner.dto';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { SubKuisioner } from './entities/sub-kuisioner.entity';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Cache } from 'cache-manager';

@Controller({ path: 'subkuisioner', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class SubKuisionerController {
  constructor(
    private readonly subKuisionerService: SubKuisionerService,
    @Inject(CACHE_MANAGER) private cacheManager: Cache // Inject cache manager
  ) { }

  @Post(':kuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  async create(
    @Param('kuisionerId', new ParseUUIDPipe()) kuisionerId: string,
    @Body() createSubKuisionerDto: BodyCreateSubKuisionerDto,
  ): Promise<ResponseApi<SubKuisioner>> {
    const payload = await this.subKuisionerService.create(
      kuisionerId,
      createSubKuisionerDto,
    );

    return new ResponseApi(
      HttpStatus.CREATED,
      'Successfully Add New SubKuisioner',
      payload,
    );
  }

  @Get(':subKuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.USER, ROLES.ADMIN, ROLES.SUPERADMIN)
  async findOne(
    @Param('subKuisionerId', new ParseUUIDPipe()) subKuisionerId: string,
  ): Promise<ResponseApi<SubKuisioner>> {
    const cacheKey = `subKuisioner_${subKuisionerId}`;

    // Check if data is cached
    const cachedData = await this.cacheManager.get<SubKuisioner>(cacheKey)
    if (cachedData) {
      return new ResponseApi(
        HttpStatus.OK,
        'Successfully Get Sub Kuisioner (from cache)',
        cachedData,
      );
    }

    // Fetch data from service if not cached
    const payload = await this.subKuisionerService.findOne(subKuisionerId);

    // Cache the data with a custom TTL
    await this.cacheManager.set(cacheKey, payload);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Sub Kuisioner',
      payload,
    );
  }

  @Patch(':subKuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  update(
    @Param('subKuisionerId', new ParseUUIDPipe()) subKuisionerId: string,
    @Body() updateSubKuisionerDto: UpdateSubKuisionerDto,
  ) {
    return this.subKuisionerService.update(
      subKuisionerId,
      updateSubKuisionerDto,
    );
  }

  @Delete(':subKuisionerId')
  @IsVerificationRequired(true)
  @Roles(ROLES.SUPERADMIN)
  remove(@Param('subKuisionerId', new ParseUUIDPipe()) subKuisionerId: string) {
    return this.subKuisionerService.remove(subKuisionerId);
  }
}
