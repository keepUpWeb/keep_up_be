import { Injectable, NotFoundException } from '@nestjs/common';
import { CreatePreKuisionerCategoryDto } from './dto/create-pre-kuisioner-category.dto';
import { UpdatePreKuisionerCategoryDto } from './dto/update-pre-kuisioner-category.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { PreKuisionerCategory } from './entities/pre-kuisioner-category.entity';
import { Repository } from 'typeorm';

@Injectable()
export class PreKuisionerCategoryService {
  constructor(
    @InjectRepository(PreKuisionerCategory)
    private readonly preKuisionerCategoryRepository: Repository<PreKuisionerCategory>,
  ) { }

  async create(createPreKuisionerCategoryDto: CreatePreKuisionerCategoryDto): Promise<PreKuisionerCategory> {
    const newCategory = this.preKuisionerCategoryRepository.create(createPreKuisionerCategoryDto);
    return await this.preKuisionerCategoryRepository.save(newCategory);
  }

  async findAll(): Promise<PreKuisionerCategory[]> {
    return await this.preKuisionerCategoryRepository.find({ relations: ['preKuisionerQuestion'] });
  }

  async findOne(id: string): Promise<PreKuisionerCategory> {
    const category = await this.preKuisionerCategoryRepository.findOne({ where: { id: id } });
    if (!category) {
      throw new NotFoundException(`PreKuisionerCategory with ID ${id} not found`);
    }
    return category;
  }

  async update(id: string, updatePreKuisionerCategoryDto: UpdatePreKuisionerCategoryDto): Promise<PreKuisionerCategory> {
    await this.preKuisionerCategoryRepository.update(id, updatePreKuisionerCategoryDto);
    const updatedCategory = await this.preKuisionerCategoryRepository.findOne({ where: { id: id } });
    if (!updatedCategory) {
      throw new NotFoundException(`PreKuisionerCategory with ID ${id} not found`);
    }
    return updatedCategory;
  }

  async remove(id: string): Promise<void> {
    const result = await this.preKuisionerCategoryRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`PreKuisionerCategory with ID ${id} not found`);
    }
  }
}
