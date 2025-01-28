import {
  Inject,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { CreateClientPsychologistDto } from './dto/create-client_psychologist.dto';
import { UpdateClientPsychologistDto } from './dto/update-client_psychologist.dto';
import { QueryRunner, Repository } from 'typeorm';
import { ROLES } from 'src/roles/group/role.enum';
import { User } from 'src/user/entities/user.entity';
import { ClientPsychologist } from './entities/client_psychologist.entity';
import { UserService } from 'src/user/user.service';
import { InjectRepository } from '@nestjs/typeorm';
import { PyschologyService } from 'src/pyschology/pyschology.service';

@Injectable()
export class ClientPsychologistService {
  constructor(
    @InjectRepository(ClientPsychologist)
    private readonly clientPsycholgistRepository: Repository<ClientPsychologist>,

    @Inject(PyschologyService)
    private readonly pyschologyService: PyschologyService,
  ) { }

  async createOnRegisterUser(
    user: User,
    queryRunner: QueryRunner,
  ): Promise<void> {
    try {
      // Find psychologists with the minimum number of clients (filtered by faculty, if needed)
      const psychologist =
        await this.pyschologyService.findPsychologyForUserRegister();

      if (!psychologist) {
        throw new InternalServerErrorException(
          'No available psychologists found',
        );
      }

      // Create the client-psychologist relationship
      const clientPsychologist = new ClientPsychologist();
      clientPsychologist.client = user; // Assuming clientId is in your ClientPsychologist entity
      clientPsychologist.psychologist = psychologist;

      // Save this relationship within the transaction
      await queryRunner.manager.save(ClientPsychologist, clientPsychologist);
    } catch (error) {
      throw new InternalServerErrorException(error.message);
    }
  }

  async findAll() {

    const data = await this.clientPsycholgistRepository.find({
      relations: ['client'],
    });

    if (!data || data.length === 0) {
      throw new NotFoundException('You do not have any clients as a psychologist');
    }

    // Adding the contact URL with dynamic subject inside the client object
    const dataFinalClientPsikolog = data.map((item) => ({
      ...item,
      client: {
        ...item.client,
        contact: `https://mail.google.com/mail/u/3/?fs=1&to=${item.client.email}&tf=cm`,
      },
    }));

    return dataFinalClientPsikolog;
  }

  async findOne(userId: string): Promise<ClientPsychologist> {
    const data = await this.clientPsycholgistRepository.findOne({
      where: { client: { id: userId } },
      relations: ['psychologist'],
    });

    if (!data) {
      throw new NotFoundException('You are not have psyhcolog');
    }
    return data;
  }

  async findOneAsPsychology(userId: string): Promise<ClientPsychologist[]> {
    const data = await this.clientPsycholgistRepository.find({
      where: { psychologist: { id: userId } },
      relations: ['client'],
    });

    if (!data || data.length === 0) {
      throw new NotFoundException('You do not have any clients as a psychologist');
    }

    // Adding the contact URL with dynamic subject inside the client object
    const dataFinalClientPsikolog = data.map((item) => ({
      ...item,
      client: {
        ...item.client,
        contact: `https://mail.google.com/mail/u/3/?fs=1&to=${item.client.email}&tf=cm`,
      },
    }));

    return dataFinalClientPsikolog;
  }

}
