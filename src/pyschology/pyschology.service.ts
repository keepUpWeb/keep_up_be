import {
  BadRequestException,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { ROLES } from 'src/roles/group/role.enum';
import { RolesService } from 'src/roles/roles.service';
import { User } from 'src/user/entities/user.entity';
import { PsikologiStatus } from 'src/pyschology/group/psikologiStatus.enum';
import { Repository } from 'typeorm';
import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';

@Injectable()
export class PyschologyService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,

    @InjectRepository(TakeKuisioner)
    private takeKuisionerRepository: Repository<TakeKuisioner>,

    @Inject(RolesService)
    private readonly rolesService: RolesService,
  ) { }

  async findPsychologyForUserRegister(): Promise<User> {
    const psychologist = await this.userRepository
      .createQueryBuilder('user')
      .leftJoin('user.psychologistClients', 'clients')
      .where('user.roleId = :roleId', { roleId: ROLES.ADMIN }) // Adjust this to your psychologist role
      .andWhere('user.psikologStatus = :status', { status: 'approved' }) // Only approved psychologists
      .groupBy('user.id') // Group by user.id
      .orderBy('COUNT(clients.id)', 'ASC') // Order by the count of clients
      .limit(1)
      .getOne();

    return psychologist;
  }

  async findAll(status?: PsikologiStatus): Promise<User[]> {
    const queryBuilder = this.userRepository
      .createQueryBuilder('user')
      .leftJoinAndSelect('user.psychologistClients', 'clients')
      .where('user.roleId = :roleId', { roleId: ROLES.ADMIN });

    // Add filter for psikologStatus if a specific status is provided
    if (status) {
      queryBuilder.andWhere('user.psikologStatus = :status', { status });
    }

    const psychologists = await queryBuilder.getMany();

    return psychologists;
  }

  async findOne(userId: string): Promise<User[]> {
    const queryBuilder = this.userRepository
      .createQueryBuilder('user')
      .leftJoinAndSelect('user.psychologistClients', 'clients')
      .where('user.roleId = :roleId', { roleId: ROLES.ADMIN })
      .andWhere('id= :userId', { userId: userId });
    const psychologists = await queryBuilder.getMany();

    return psychologists;
  }

  // Method to activate or reject a psychologist's account
  async activatePsychologist(
    userId: string,
    status: PsikologiStatus,
  ): Promise<User> {
    const role = await this.rolesService.getRoleById(ROLES.ADMIN);

    // Find the psychologist by their userId
    const psychologist = await this.userRepository.findOne({
      where: { id: userId, role: role },
    });

    if (!psychologist) {
      throw new NotFoundException(`Psychologist with id ${userId} not found`);
    }

    // Check if the status is valid (approved or rejected)
    if (
      ![PsikologiStatus.Approved, PsikologiStatus.Rejected].includes(status)
    ) {
      throw new BadRequestException('Invalid status provided');
    }

    // Update the psychologist's status
    psychologist.psikologStatus = status;

    // Save the updated psychologist entity
    await this.userRepository.save(psychologist);

    return psychologist;
  }

}
