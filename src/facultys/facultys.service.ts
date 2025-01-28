import { HttpStatus, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Faculty } from './entities/faculty.entity';
import { CreateFacultyDTO } from './dto/request/createFaculty.dto';

@Injectable()
export class FacultysService {
  constructor(
    @InjectRepository(Faculty)
    private readonly facultyRepository: Repository<Faculty>, // Injecting the Faculty repository
  ) {}

  async getAllFaculties(): Promise<Faculty[]> {
    return await this.facultyRepository.find();
  }

  async getFacultyById(id: string): Promise<Faculty> {
    const faculty = await this.facultyRepository.findOne({ where: { id } });
    if (!faculty) {
      throw new NotFoundException(`Faculty with ID ${id} not found`);
    }
    return faculty;
  }

  async createFaculty(createFacultyDTO: CreateFacultyDTO): Promise<string> {
    const newFaculty = this.facultyRepository.create(createFacultyDTO); // Prepare entity
    await this.facultyRepository.save(newFaculty); // Save to the database
    return 'Faculty created successfully';
  }
}
