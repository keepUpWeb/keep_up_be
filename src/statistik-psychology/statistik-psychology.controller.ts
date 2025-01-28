import { Controller, Get, UseGuards, HttpStatus } from '@nestjs/common';
import { StatistikPsychologyService } from './statistik-psychology.service';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { UserId } from 'src/user/decorator/userId.decorator';
import { SummaryKuisionerService } from 'src/sumary_kuisioner/summary-kuisioner.service';

@Controller({ path: "statistik/psychology", version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class StatistikPsychologyController {
  constructor(private readonly statistikPsychologyService: StatistikPsychologyService,private readonly summaryKuisionerService: SummaryKuisionerService) { }

  @Get('user')
  @IsVerificationRequired(true)
  @Roles(ROLES.ADMIN)
  async findStatistikUser(@UserId('id') id: string) {
    const responsePayload = await this.statistikPsychologyService.findClientsUserStatistikForPsychologist(id);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Statistik All Client',
      responsePayload

    )
  }

  @Get()
  @IsVerificationRequired(true)
  @Roles(ROLES.ADMIN)
  async findStatistik(@UserId('id') id: string) {
    const responsePayload = await this.statistikPsychologyService.getAllTakeKuisionerStatistikPsychology(id);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Statistik All Client',
      responsePayload

    )
  }
  @Get('gender')
  @IsVerificationRequired(true)
  @Roles(ROLES.ADMIN)
  async findStatistikGender(@UserId('id') id: string) {
    const responsePayload = await this.statistikPsychologyService.getAllUserGenderStatistikPsychology(id);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Statistik All Client',
      responsePayload

    )
  }

  @Get('symtomp')
  @IsVerificationRequired(true)
  @Roles(ROLES.ADMIN)
  async findStatistikSymtomp(@UserId('id') id: string) {
    const responsePayload = await this.statistikPsychologyService.findClientsSymtopmStatistikForPsychologist(id);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Statistik All Client',
      responsePayload

    )
  }
  @Get('count')
  @IsVerificationRequired(true)
  @Roles(ROLES.ADMIN)
  async findStatistikUserCount(@UserId('id') id: string) {
    const responsePayload = await this.statistikPsychologyService.countAllUserKuisionerStatistikPsychology(id);

    return new ResponseApi(
      HttpStatus.OK,
      'Successfully Get Statistik All Client',
      responsePayload

    )
  }

  @Get('sumarize')
  @IsVerificationRequired(true)
  @Roles(ROLES.ADMIN)
  async getSumarizeOfKuisioner(@UserId() userId:string){

    const summary = await this.summaryKuisionerService.getOrUpdateSummaryForUser(userId);

    // Return the summary
    return new ResponseApi (
      HttpStatus.OK,
      'Successfully Get Statistik Gender User',
      summary,
    );
  }

}
