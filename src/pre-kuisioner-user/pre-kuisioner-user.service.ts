import { Injectable, NotFoundException } from '@nestjs/common';
import { CreatePreKuisionerUserDto } from './dto/create-pre-kuisioner-user.dto';
import { UpdatePreKuisionerUserDto } from './dto/update-pre-kuisioner-user.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { PreKuisionerUser } from './entities/pre-kuisioner-user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class PreKuisionerUserService {

  constructor(
    @InjectRepository(PreKuisionerUser)
    private readonly preKuisionerUserRepository: Repository<PreKuisionerUser>
  ) { }

  create(createPreKuisionerUserDto: CreatePreKuisionerUserDto) {
    return 'This action adds a new preKuisionerUserRepository';
  }

  findAll() {
    return `This action returns all preKuisionerUserRepository`;
  }

  async findOne(id: string): Promise<PreKuisionerUser> {
    const userWithAnswers = await this.preKuisionerUserRepository.findOne({
      where: { user: { id } },
      relations: [
        'user',
        'preKuisionerUserAnswer',
        'preKuisionerUserAnswer.preKuisionerAnswer',
        'preKuisionerUserAnswer.preKuisionerAnswer.preQuestionId',
        'preKuisionerUserAnswer.preKuisionerAnswer.preQuestionId.category',
      ],
    });

    if (!userWithAnswers) {
      return null; // Handle the case where the user is not found
    }

    return userWithAnswers
  }

  async finishPreKuisioner(id: string): Promise<void> {
    const result = await this.preKuisionerUserRepository.update(id, { isFinish: true });

    if (result.affected === 0) {
      throw new NotFoundException(`PreKuisionerUser with ID ${id} not found`);
    }
  }




  update(id: number, updatePreKuisionerUserDto: UpdatePreKuisionerUserDto) {
    return `This action updates a #${id} preKuisionerUserRepository`;
  }

  remove(id: number) {
    return `This action removes a #${id} preKuisionerUserRepository`;
  }
}
