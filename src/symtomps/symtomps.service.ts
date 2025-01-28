import { Injectable } from '@nestjs/common';
import { CreateSymtompDto } from './dto/create-symtomp.dto';
import { UpdateSymtompDto } from './dto/update-symtomp.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Symtomp } from './entities/symtomp.entity';
import { Repository } from 'typeorm';

@Injectable()
export class SymtompsService {
  constructor(
    @InjectRepository(Symtomp)
    private symtompRepository: Repository<Symtomp>,
  ) {}

  async create(createSymtompDto: CreateSymtompDto): Promise<Symtomp> {
    return await this.symtompRepository.save(createSymtompDto);
  }

  async findAll(): Promise<Symtomp[]> {
    return await this.symtompRepository.find();
  }

  async findOneById(id: string): Promise<Symtomp> {
    return await this.symtompRepository.findOne({ where: { id: id } });
  }

  update(id: number, updateSymtompDto: UpdateSymtompDto) {
    return `This action updates a #${id} symtomp`;
  }

  remove(id: number) {
    return `This action removes a #${id} symtomp`;
  }
}
