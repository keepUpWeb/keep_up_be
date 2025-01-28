import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import {
  BodyCreateSubKuisionerDto,
  CreateSubKuisionerDto,
} from './dto/create-sub-kuisioner.dto';
import { UpdateSubKuisionerDto } from './dto/update-sub-kuisioner.dto';
import { KuisionerService } from 'src/kuisioner/kuisioner.service';
import { InjectRepository } from '@nestjs/typeorm';
import { SubKuisioner } from './entities/sub-kuisioner.entity';
import { Repository } from 'typeorm';
import { SymtompsService } from 'src/symtomps/symtomps.service';

@Injectable()
export class SubKuisionerService {
  constructor(
    @Inject(KuisionerService)
    private kuisionerService: KuisionerService,

    @Inject(SymtompsService)
    private symtompService: SymtompsService,

    @InjectRepository(SubKuisioner)
    private subKuisionerRepository: Repository<SubKuisioner>,
  ) { }

  async create(
    kuisionerId: string,
    createSubKuisionerDto: BodyCreateSubKuisionerDto,
  ): Promise<SubKuisioner> {
    const kuisioner =
      await this.kuisionerService.getOneKuisionerById(kuisionerId);

    const symtomp = await this.symtompService.findOneById(
      createSubKuisionerDto.symtompId,
    );

    const data: CreateSubKuisionerDto = {
      title: createSubKuisionerDto.title,
      kuisionerId: kuisioner,
      symtompId: symtomp,
    };

    return await this.subKuisionerRepository.save(data);
  }

  async findOne(subKuisionerId: string): Promise<SubKuisioner> {
    const payload = await this.subKuisionerRepository.createQueryBuilder('subKuisioner')
      .leftJoinAndSelect('subKuisioner.symtompId', 'symtompId')
      .leftJoinAndSelect('subKuisioner.questions', 'questions')
      .leftJoinAndSelect('questions.answers', 'answers')
      .where('subKuisioner.id = :subKuisionerId', { subKuisionerId })
      .orderBy('questions.createdAt', 'DESC')  // Order the questions by createdAt
      .addOrderBy('answers.score','DESC')
      .getOne();

    if (!payload) {
      throw new NotFoundException('Sub Kuisioner Not Found');
    }

    return payload;
  }

  async update(
    subKuisionerId: string,
    updateSubKuisionerDto: UpdateSubKuisionerDto,
  ): Promise<SubKuisioner> {
    // Find the existing SubKuisioner by ID
    const subKuisioner = await this.subKuisionerRepository.findOne({
      where: { id: subKuisionerId },
      relations: ['kuisionerId', 'symtompId'],
    });

    if (!subKuisioner) {
      throw new NotFoundException(
        `SubKuisioner with ID ${subKuisionerId} not found`,
      );
    }

    // Update the fields only if they are provided
    Object.assign(subKuisioner, updateSubKuisionerDto);

    // Save the updated entity
    return await this.subKuisionerRepository.save(subKuisioner);
  }

  async remove(id: string): Promise<string> {
    const deleteResult = await this.subKuisionerRepository.delete({ id });

    // Check if the entity was found and deleted
    if (deleteResult.affected === 0) {
      throw new NotFoundException(`SubKuisioner with ID ${id} not found`);
    }

    return `SubKuisioner with ID #${id} has been removed successfully`;
  }
}
