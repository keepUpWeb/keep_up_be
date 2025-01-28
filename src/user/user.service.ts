import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { UpdateUserDto } from './dto/update-user.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { FacultysService } from 'src/facultys/facultys.service';
import { ROLES } from 'src/roles/group/role.enum';
import { PsikologiStatus } from '../pyschology/group/psikologiStatus.enum';
import { Auth } from 'src/auth/entities/auth.entity';
import { Major } from 'src/major/entities/major.entity';
import { MajorService } from 'src/major/major.service';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,

    @InjectRepository(Auth)
    private authRepository: Repository<Auth>,

    @Inject(FacultysService)
    private readonly facultyService: FacultysService,


    @Inject(MajorService)
    private readonly majorService: MajorService
  ) { }

  async create(createUserDto: CreateUserDto): Promise<User> {
    const newUser = this.userRepository.create(createUserDto);
    const savedUser = await this.userRepository.save(newUser);
    return savedUser;
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { email },
      select: ['password', 'id', 'role', 'username', 'email'],
      relations: ['userPsycholog', 'userPsycholog.psychologist', 'psychologistClients', 'faculty', 'role', 'auth', 'preKuisioner','major'], // Include role and auth relations
    });
  }
  async findById(id: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { id },
      relations: ['userPsycholog', 'userPsycholog.psychologist', 'psychologistClients', 'faculty', 'role', 'auth', 'preKuisioner','major'], // Include role and auth relations
    });
  }

  findAll() {
    return `This action returns all user`;
  }

  async findOne(id: string): Promise<User> {
    const dataArrayUser = await this.userRepository.findOne({
      where: { id: id },
      relations: ['userPsycholog', 'userPsycholog.psychologist', 'psychologistClients', 'faculty', 'role', 'auth', 'preKuisioner','major']
    });

    if (!dataArrayUser) {
      throw new NotFoundException('User That u Searching Not Found');
    }

    return dataArrayUser;
  }

  async update(id: string, updateUserDto: UpdateUserDto) {
    const user = await this.userRepository.findOne({ where: { id: id } });
    if (!user) {
      throw new NotFoundException(`User with id ${id} not found`);
    }

    if (updateUserDto.facultyId) {
      const faculty = await this.facultyService.getFacultyById(
        updateUserDto.facultyId,
      );

      updateUserDto.faculty = faculty;
    }

    if (updateUserDto.majorId) {
      const major = await this.majorService.getMajorById(updateUserDto.majorId)

      updateUserDto.major = major
    }

    Object.assign(user, updateUserDto); // Apply the updates
    return await this.userRepository.save(user); // Save the updated user
  }

  async remove(userId: string): Promise<boolean> {
    const user = await this.userRepository.findOne({
      where: { id: userId },
      relations: ['auth'],
    });

    if (user) {
      // First, delete the related Auth entity
      if (user.auth) {
        await this.authRepository.delete({ id: user.auth.id });
      }
      // Then, remove the User
      await this.userRepository.remove(user); // You can keep this to remove the user
      return true;
    }

    return false;
  }
}
