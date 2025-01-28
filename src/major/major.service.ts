import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Major } from './entities/major.entity';
import { CreateMajorDTO } from './dto/create-major';
import { FacultysService } from 'src/facultys/facultys.service';

@Injectable()
export class MajorService {
    constructor(
        @InjectRepository(Major)
        private readonly majorRepository: Repository<Major>, // Injecting the Major repository

        @Inject(FacultysService)
        private readonly facultyService: FacultysService
    ) { }

    // Get all majors
    async getAllMajors(facultyId: string): Promise<Major[]> {
        return await this.majorRepository.find({ where: { faculty: { id: facultyId } } });
    }

    // Get a major by ID
    async getMajorById(id: string): Promise<Major> {
        const major = await this.majorRepository.findOne({ where: { id } });
        if (!major) {
            throw new NotFoundException(`Major with ID ${id} not found`);
        }
        return major;
    }

    // Create a new major
    async createMajor(createMajorDTO: CreateMajorDTO, facultyId: string): Promise<string> {

        const faculty = await this.facultyService.getFacultyById(facultyId)
        const createMajor = {
            name: createMajorDTO.name,
            faculty: faculty
        }

        const newMajor = this.majorRepository.create(createMajor); // Prepare entity
        await this.majorRepository.save(newMajor); // Save to the database
        return 'Major created successfully';
    }

    // Delete a major by ID
    async deleteMajor(id: string): Promise<string> {
        const major = await this.getMajorById(id); // Check if the major exists
        await this.majorRepository.remove(major); // Delete the major
        return 'Major deleted successfully';
    }
}
