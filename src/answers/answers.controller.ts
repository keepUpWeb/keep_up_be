import { Controller, Delete, HttpException, HttpStatus, Param, UseGuards, ParseUUIDPipe, Body, Post, Inject, Patch } from '@nestjs/common';
import { AnswersService } from './answers.service';
import { ResponseApi } from 'src/common/response/responseApi.format';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { CreateAnswerDto } from './dto/create-answer.dto';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Cache } from 'cache-manager';
import { UpdateAnswerDto } from './dto/update-answer.dto';

@Controller({ path: 'answers', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class AnswersController {
    constructor(private readonly answerService: AnswersService, @Inject(CACHE_MANAGER) private cacheManager: Cache) { }




    @Post(':id_question')
    @IsVerificationRequired(true)
    @Roles(ROLES.SUPERADMIN)
    async addAnswer(
        @Param('id_question', new ParseUUIDPipe()) idQuestion: string,
        @Body() data: CreateAnswerDto,
    ) {
        // Call the service to add the answer
        const addResult = await this.answerService.add(idQuestion, data);

        // Optionally clear the cache after the update (if the updated data affects the cache)
        await this.cacheManager.reset();

        // Return a structured API response
        return new ResponseApi(
            HttpStatus.CREATED,
            'Successfully added the answer',
            addResult,
        );
    }

    @Patch(':id_answers')
    @IsVerificationRequired(true)
    @Roles(ROLES.SUPERADMIN)
    async editAnswers(
        @Param('id_answers', new ParseUUIDPipe()) idAnswers: string,
        @Body() data: UpdateAnswerDto
    ) {
        // Attempt update
        const updateResult = await this.answerService.update(idAnswers, data);

        // If no rows were affected (i.e., the answer wasn't found or updated), throw an error
        if (!updateResult) {
            throw new HttpException('Answer not found or could not be updated', HttpStatus.NOT_FOUND);
        }

        // Optionally clear the cache after the update (if the updated data affects the cache)
        await this.cacheManager.reset();

        return new ResponseApi(
            HttpStatus.OK,
            'Successfully updated the answer',
            updateResult,
        );
    }

    @Delete(':id_answers')
    @IsVerificationRequired(true)
    @Roles(ROLES.SUPERADMIN)
    async deleteAnswers(@Param('id_answers', new ParseUUIDPipe()) idAnswers: string) {
        // Attempt deletion
        const deleteResult = await this.answerService.remove(idAnswers);
        if (!deleteResult.affected) {
            throw new HttpException('Answer not found or already deleted', HttpStatus.NOT_FOUND);
        }

        await this.cacheManager.reset()

        return new ResponseApi(
            HttpStatus.OK,
            'Successfully deleted the answer',
            deleteResult,
        );
    }
}
