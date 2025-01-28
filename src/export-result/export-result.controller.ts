import { Controller, ForbiddenException, Get, HttpException, HttpStatus, Inject, Param, ParseUUIDPipe, Res, UseGuards } from '@nestjs/common';
import { Response } from 'express';
import { ExportResultService } from './export-result.service';
import { ExportType, ReportType } from './strategy/export-strategy.interface';
import { TakeKuisionerService } from 'src/take-kuisioner/take-kuisioner.service';
import { transformPreKuisionerUserAnswerFromEntity } from 'src/common/function/helper/preKuisionerUserProses.function';
import { ReportData } from 'src/take-kuisioner/take-kuisioner.model';
import { transformPreKuisionerUserAnswer, transformUserAnswerSubKuisioner } from 'src/common/function/helper/exportProses.function';
import { IsVerificationRequired } from 'src/jwt/decorator/jwtRoute.decorator';
import { Roles } from 'src/roles/decorators/role.decorator';
import { ROLES } from 'src/roles/group/role.enum';
import { RoleId } from 'src/roles/decorators/roleId.decorator';
import { TakeKuisioner } from 'src/take-kuisioner/entities/take-kuisioner.entity';
import { UserId } from 'src/user/decorator/userId.decorator';
import { JwtAuthGuard } from 'src/jwt/guards/jwt-auth.guard';
import { RolesGuard } from 'src/roles/guards/role.guard';

@Controller({ path: 'export', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
export class ExportResultController {
    constructor(
        private readonly exportResultService: ExportResultService,
        @Inject(TakeKuisionerService)
        private readonly takeKuisionerService: TakeKuisionerService
    ) { }

    @Get('generate/pdf/personal/:id_user')
    @IsVerificationRequired(true)
    @Roles(ROLES.ADMIN, ROLES.SUPERADMIN, ROLES.USER)
    async generatePdfResultTestPersonal(
        @Res() res: Response,
        @RoleId() roleId: string,
        @UserId() requestUserId: string,
        @Param('id_user', new ParseUUIDPipe()) userId: string
    ): Promise<void> {
        const findLatestKuisionerUser = await this.takeKuisionerService.findLatest(userId)

        if (roleId == ROLES.ADMIN) {
            // data = await this.takeKuisionerService.findAll()

            console.log(findLatestKuisionerUser.user.userPsycholog)

            if (findLatestKuisionerUser.user.userPsycholog[0].psychologist.id != requestUserId) {

                throw new ForbiddenException("You are not authorize to export this")

            }
        } else if (roleId == ROLES.USER) {

            if (findLatestKuisionerUser.user.id != requestUserId) {

                throw new ForbiddenException("You are not authorize to export this")

            }

        }

        const preKuisionerData = transformPreKuisionerUserAnswerFromEntity(findLatestKuisionerUser.user.preKuisioner)

        const preKuisionerDataFinal = transformPreKuisionerUserAnswer(preKuisionerData.preKuisionerUserAnswer)

        const subKuisionerFinalData = transformUserAnswerSubKuisioner(findLatestKuisionerUser.userAnswerSubKuisioner)

        const dataGenerateAIReport: ReportData = { background: preKuisionerDataFinal, result: subKuisionerFinalData, user: findLatestKuisionerUser.user, report: findLatestKuisionerUser.report }


        try {
            // Generate the PDF buffer using the service with enum-based parameters
            const pdfBuffer = await this.exportResultService.exportResult(
                ExportType.PDF, // Specify PDF export
                dataGenerateAIReport,
                ReportType.PERSONAL_PDF// Specify the type of report
            );

            // Set response headers for the PDF
            res.setHeader('Content-Type', 'application/pdf');
            res.setHeader(
                'Content-Disposition',
                `attachment; filename=personal_report_${findLatestKuisionerUser.user.username}.pdf`
            );
            res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition');

            // Send the PDF buffer in the response
            res.end(pdfBuffer);
        } catch (error) {
            console.error('Error generating PDF:', error);
            // Handle any errors that occurred during PDF generation
            throw new HttpException('Error generating Excel', HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Get('generate/excel')
    @Roles(ROLES.ADMIN, ROLES.SUPERADMIN)
    async generateExcelResultKuisionerForGeneral(@Res() res: Response, @RoleId() roleId: string, @UserId() userId: string) {

        let data: TakeKuisioner[]
        if (roleId == ROLES.SUPERADMIN) {
            data = await this.takeKuisionerService.findAll()
        } else {
            data = await this.takeKuisionerService.findAllForPsychologist(userId)
        }

        // console.log(data)
        try {
            // Generate the Excel buffer using the service with enum-based parameters
            const excelBuffer = await this.exportResultService.exportResult(
                ExportType.EXCEL, // Specify Excel export
                data, // Example parameter
                ReportType.SUPERADMIN_EXCEL
            );


            const datenow = new Date().toISOString().split('T')[0];


            // Set response headers for the Excel file
            res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            res.setHeader(
                'Content-Disposition',
                `attachment; filename=report_all_kuisioner_${datenow}.xlsx`
            );
            res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition');
            
            

            // Send the Excel buffer in the response
            res.end(excelBuffer);
        } catch (error) {
            console.error('Error generating Excel:', error);
            // Handle any errors that occurred during Excel generation
            throw new HttpException('Error generating Excel', HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Get('generate/excel/:id_user')
    @Roles(ROLES.ADMIN, ROLES.USER, ROLES.SUPERADMIN)
    async generateExcelResultKuisionerForPersonal(
        @Res() res: Response,
        @RoleId() roleId: string,
        @UserId() psychologistId: string,
        @Param('id_user', new ParseUUIDPipe()) userId: string
    ) {

        const data: TakeKuisioner = await this.takeKuisionerService.findLatest(userId)
        if (roleId == ROLES.ADMIN) {
            if (data.user.userPsycholog[0].psychologist.id != psychologistId) {
                throw new ForbiddenException("You are not authorize to export this")
            }
        }

        // console.log(data)
        try {
            // Generate the Excel buffer using the service with enum-based parameters
            const excelBuffer = await this.exportResultService.exportResult(
                ExportType.EXCEL, // Specify Excel export
                data, // Example parameter
                ReportType.PERSONAL_EXCEL
            );

            // Set response headers for the Excel file
            res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            res.setHeader(
                'Content-Disposition',
                `attachment; filename=report_${data.user.username}_kuisioner.xlsx`,
            );
            res.setHeader('Access-Control-Expose-Headers', 'Content-Disposition');

            // Send the Excel buffer in the response
            res.end(excelBuffer);
        } catch (error) {
            console.error('Error generating Excel:', error);
            // Handle any errors that occurred during Excel generation
            throw new HttpException('Error generating Excel', HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}


// const data = {
//     "id": "2530cd77-e805-4689-9099-b605cb73249p",
//     "isFinish": true,
//     "report": null,
//     "createdAt": "2024-11-01T13:09:53.148Z",
//     "user": {
//         "id": "da50cf79-ee3b-4651-8dfe-45e9034057cd",
//         "email": "kedathons@gmail.com",
//         "username": "Sekar A",
//         "nim": "22523184",
//         "birthDate": "2004-04-20",
//         "yearEntry": 2022,
//         "createdAt": "2024-11-10T14:15:39.047Z",
//         "updatedAt": "2024-11-17T13:49:37.901Z",
//         "gender": "Laki-Laki",
//         "psikologStatus": null,
//         "faculty":{
//             "name":"Faculty Technology Industri"
//         }
//     },
//     "userAnswerSubKuisioner": [
//         {
//             "id": "d0976528-cb10-4fe9-874e-837482d34a27",
//             "level": "normal",
//             "score": 7,
//             "subKuisioner": {
//                 "id": "cd191bdd-8fea-4d6a-81b5-380de93cad59",
//                 "title": "SubKuisioner Stress",
//                 "createdAt": "2024-10-04T12:12:53.351Z",
//                 "updatedAt": "2024-10-04T12:12:53.351Z",
//                 "symtompId": {
//                     "id": "d1401692-5909-41fb-9c4c-b5d2a601c292",
//                     "name": "Stress"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "8aed6282-c500-4a4d-a50d-b805dc447a47",
//                     "answer": {
//                         "id": "33c555fb-64bd-440d-9362-d420ce224c1a",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "673570f0-32cb-4002-b50b-496ca18e4047",
//                             "question": "Setuju sih",
//                             "createdAt": "2024-10-16T11:16:10.292Z",
//                             "updatedAt": "2024-11-20T13:49:10.075Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "bee9bf85-a619-467a-9a09-62ad5dceaf1e",
//                     "answer": {
//                         "id": "26982feb-eba9-4b04-89ea-98535fa61c3d",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "b536f518-186f-494c-82b9-b7ec4686e714",
//                             "question": "Saya sulit untuk bersabar dalam menghadapi gangguan yang terjadi ketika sedang melakukan sesuatu.",
//                             "createdAt": "2024-10-16T11:16:00.293Z",
//                             "updatedAt": "2024-10-16T11:16:00.293Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "ab9b6e85-ec41-4679-b9d4-7e46397338c6",
//                     "answer": {
//                         "id": "ff0653fc-e130-4ea9-b889-96f4bea63b62",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "7667e7db-1f79-48c9-a176-bbe9d773781e",
//                             "question": "Saya merasa sulit untuk merasa tenang.",
//                             "createdAt": "2024-10-16T11:15:43.889Z",
//                             "updatedAt": "2024-10-16T11:15:43.889Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "4f6a19da-85d2-49db-8a70-a55bbdde40ae",
//                     "answer": {
//                         "id": "1e361eae-eb51-4d32-ab0c-cd453bdd2734",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "30924def-0dd1-4a4a-b603-5f8eebcceb70",
//                             "question": "Saya merasa gelisah.",
//                             "createdAt": "2024-10-16T11:15:33.392Z",
//                             "updatedAt": "2024-10-16T11:15:33.392Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "5f8bdbba-25e4-4b96-a234-34d2533f9dc4",
//                     "answer": {
//                         "id": "4e947c6f-446e-4e8e-8cf8-083538146cfe",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "aba6462a-d11b-496f-a930-7dea1d288429",
//                             "question": "Saya merasa energi saya terkuras karena terlalu cemas.",
//                             "createdAt": "2024-10-16T11:15:25.105Z",
//                             "updatedAt": "2024-10-16T11:15:25.105Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "6468bde8-54bc-410f-b9f6-53f00db1de5c",
//                     "answer": {
//                         "id": "1c8d1edf-ae25-4d10-8b63-3b60fbb9e411",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "f30be436-3c81-4ed3-9f40-79a608304a5f",
//                             "question": "Saya cenderung menunjukkan reaksi berlebihan terhadap suatu situasi.",
//                             "createdAt": "2024-10-16T11:15:13.301Z",
//                             "updatedAt": "2024-10-16T11:15:13.301Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "8cf17b89-c59d-4358-bcca-ae8860a1122b",
//                     "answer": {
//                         "id": "11063ddf-508e-4281-8dc5-ac4bd1563d0c",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "e25698f9-143a-422a-9732-95f545082e6d",
//                             "question": "Saya merasa sulit untuk beristirahat.",
//                             "createdAt": "2024-10-16T11:14:51.333Z",
//                             "updatedAt": "2024-10-16T11:14:51.333Z"
//                         }
//                     }
//                 }
//             ]
//         },
//         {
//             "id": "9c796649-76ac-4991-9791-ce310cb528f9",
//             "level": "low",
//             "score": 8,
//             "subKuisioner": {
//                 "id": "47a65933-fe35-41e9-9610-c55805c92b93",
//                 "title": "SubKuisioner Kecemasan",
//                 "createdAt": "2024-10-04T13:07:06.846Z",
//                 "updatedAt": "2024-10-04T13:07:06.846Z",
//                 "symtompId": {
//                     "id": "b549f59f-5f6c-4854-ae82-cef186c15b4f",
//                     "name": "Kecemasan"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "61c3adb7-1f5d-4301-93b5-a8603eea59f6",
//                     "answer": {
//                         "id": "2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "650707f9-f62f-452d-bfff-2abbd6337bb0",
//                             "question": "Saya merasa ketakutan tanpa alasan yang jelas.",
//                             "createdAt": "2024-10-16T11:20:00.017Z",
//                             "updatedAt": "2024-10-16T11:20:00.017Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "4a4047fe-dfb8-41db-ad18-6b900bc7de6a",
//                     "answer": {
//                         "id": "40c13606-829a-4d32-9a2f-634465feb1b3",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "8b56b1da-d0e0-4aba-b04f-d37855c01594",
//                             "question": "Saya menyadari kondisi jantung saya (seperti meningkatnya atau melemahnya detak jantung) meskipun sedang tidak melakukan aktivitas fisik.",
//                             "createdAt": "2024-10-16T11:19:42.243Z",
//                             "updatedAt": "2024-10-16T11:19:42.243Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "5f7a1056-3f27-488e-b9e2-f24134a1a746",
//                     "answer": {
//                         "id": "c965fa2d-0ebd-440c-86ce-bab64e06553a",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "970d537c-edd4-4cb9-815a-170694527754",
//                             "question": "Saya merasa hampir panik.",
//                             "createdAt": "2024-10-16T11:19:25.953Z",
//                             "updatedAt": "2024-10-16T11:19:25.953Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "fd52dd10-33a2-42f0-afc2-39ceaa37feb8",
//                     "answer": {
//                         "id": "868435dd-ab2f-48d0-8fc8-97b29a652c0c",
//                         "answer": "Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu",
//                         "score": 2,
//                         "questionId": {
//                             "id": "9580539a-9643-4ee5-8008-c2caf10fd661",
//                             "question": "Saya merasa khawatir dengan situasi dimana saya mungkin menjadi panik dan mempermalukan diri sendiri.",
//                             "createdAt": "2024-10-16T11:19:16.552Z",
//                             "updatedAt": "2024-10-16T11:19:16.552Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "5a443787-45b5-4881-ac3b-64d76051a9c5",
//                     "answer": {
//                         "id": "ca965a27-d390-453b-a3cc-69e4ccc791e3",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "8726beeb-9cd2-4e5e-acaa-6a1c8e0b3edb",
//                             "question": "Saya merasa gemetar (misalnya pada tangan).",
//                             "createdAt": "2024-10-16T11:19:03.101Z",
//                             "updatedAt": "2024-10-16T11:19:03.101Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "8509a13e-92b2-4f11-9d69-7f12440e0738",
//                     "answer": {
//                         "id": "e39910ae-2305-4c95-b7cf-a12676e2c464",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "ed9ed04d-aae5-45f1-88ca-a716fec1454e",
//                             "question": "Saya merasa kesulitan bernafas (misalnya seringkali terengah-engah atau tidak dapat bernapas padahal tidak melakukan aktivitas fisik sebelumnya).",
//                             "createdAt": "2024-10-16T11:18:50.841Z",
//                             "updatedAt": "2024-10-16T11:18:50.841Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "a33d1494-59bb-4fe7-b382-c6ea6161c564",
//                     "answer": {
//                         "id": "24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "9f997851-c784-4fea-8928-cf13baf669e4",
//                             "question": "Saya merasa rongga mulut saya kering.",
//                             "createdAt": "2024-10-16T11:18:28.150Z",
//                             "updatedAt": "2024-10-16T11:18:28.150Z"
//                         }
//                     }
//                 }
//             ]
//         },
//         {
//             "id": "87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4",
//             "level": "normal",
//             "score": 9,
//             "subKuisioner": {
//                 "id": "22fb61dd-f54d-4bec-bb98-26d90f94d16b",
//                 "title": "SubKuisioner Depresi",
//                 "createdAt": "2024-10-16T11:09:08.223Z",
//                 "updatedAt": "2024-10-16T11:09:08.223Z",
//                 "symtompId": {
//                     "id": "52801a1d-32e6-49d8-bed4-162374630e46",
//                     "name": "Depresi"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "c6cd4e6a-8589-4f38-846c-714841d7bafa",
//                     "answer": {
//                         "id": "b52ffb50-0d1e-4da5-8bf8-2ce37912d821",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "310a3ea6-2196-4e58-8f1c-5016d750d663",
//                             "question": "Saya merasa hidup ini tidak berarti.",
//                             "createdAt": "2024-10-16T11:26:37.972Z",
//                             "updatedAt": "2024-10-16T11:26:37.972Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "d4239e0c-91c5-47f2-8379-c444eb83585a",
//                     "answer": {
//                         "id": "3635d565-2a74-447e-829b-b7e334ef194e",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "aae60c45-876c-4634-98db-421b06751ac9",
//                             "question": "Saya merasa diri saya tidak berharga.",
//                             "createdAt": "2024-10-16T11:26:30.100Z",
//                             "updatedAt": "2024-10-16T11:26:30.100Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "bbf80283-e940-406f-8db4-65f279d7b301",
//                     "answer": {
//                         "id": "c7603d88-fad0-487b-9eb7-c3c31a5ca59d",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "04e07acf-f306-4ec5-8548-dff939fbba6e",
//                             "question": "Saya tidak bisa merasa antusias terhadap hal apapun.",
//                             "createdAt": "2024-10-16T11:26:21.887Z",
//                             "updatedAt": "2024-10-16T11:26:21.887Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "ba1aa45c-32b8-4841-921a-8125937870c1",
//                     "answer": {
//                         "id": "cdce8b68-4fc8-4d39-b39c-3485307475cb",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "e573d43b-6495-4b1e-9f94-7a9d062b481a",
//                             "question": "Saya merasa sedih dan tertekan.",
//                             "createdAt": "2024-10-16T11:26:01.864Z",
//                             "updatedAt": "2024-10-16T11:26:01.864Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "3dc2c348-03af-406e-a41d-7fd5261abb91",
//                     "answer": {
//                         "id": "6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a",
//                         "answer": "Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu",
//                         "score": 2,
//                         "questionId": {
//                             "id": "93d681f6-75a7-413b-9005-b1249d27210a",
//                             "question": "Saya merasa tidak ada lagi yang bisa saya harapkan.",
//                             "createdAt": "2024-10-16T11:25:53.086Z",
//                             "updatedAt": "2024-10-16T11:25:53.086Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "a1d661f8-f7ec-4888-9b97-9f77bfcbd424",
//                     "answer": {
//                         "id": "71d05faf-8913-4073-a401-7ee58d09559c",
//                         "answer": "Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu",
//                         "score": 2,
//                         "questionId": {
//                             "id": "3b89d150-a078-486a-a107-e1843db6db6e",
//                             "question": "Saya merasa sulit berinisiatif melakukan sesuatu.",
//                             "createdAt": "2024-10-16T11:25:43.546Z",
//                             "updatedAt": "2024-10-16T11:25:43.546Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "c52a0753-d0f4-4c4f-b6a2-155ee10ea87c",
//                     "answer": {
//                         "id": "6e8aa530-4d74-4e8c-babd-274b66ba6b69",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "51ee586e-6333-4d9d-a961-071a9ac4e1f7",
//                             "question": "Saya sama sekali tidak dapat merasakan perasaan positif (contoh: merasa gembira, bangga, dsb).",
//                             "createdAt": "2024-10-16T11:25:34.554Z",
//                             "updatedAt": "2024-10-16T11:25:34.554Z"
//                         }
//                     }
//                 }
//             ]
//         },
//         {
//             "id": "4542865a-e066-4fd2-a431-08a58b6cdda0",
//             "level": "very low",
//             "score": 6,
//             "subKuisioner": {
//                 "id": "744f79d7-2692-422c-9d63-b24cec2f8d6b",
//                 "title": "SubKuisioner Prokrastinasi",
//                 "createdAt": "2024-10-16T11:09:51.779Z",
//                 "updatedAt": "2024-10-16T11:09:51.779Z",
//                 "symtompId": {
//                     "id": "ff065e0a-eddf-4416-b82a-f4666b2e0a1c",
//                     "name": "Prokrastinasi"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "1249ad91-afaa-4c8e-8b05-ca5545de0a9c",
//                     "answer": {
//                         "id": "ced2e89a-0e7a-4427-8c85-b0d557baac68",
//                         "answer": "Kurang Setuju",
//                         "score": 2,
//                         "questionId": {
//                             "id": "dd485669-4209-44f8-b21b-85751223d073",
//                             "question": "Saya sering menunda deadline pengerjaan tugas yang penting ",
//                             "createdAt": "2024-11-01T12:46:04.849Z",
//                             "updatedAt": "2024-11-01T12:46:04.849Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "de86dbd8-2450-4d89-aa50-771f8945e153",
//                     "answer": {
//                         "id": "decba44a-23dc-4d6b-b754-4799e45488d6",
//                         "answer": "Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "b58a1c58-369f-4c0c-9201-3a5921171675",
//                             "question": "Ketika diberi tugas, saya biasanya membiarkan dan tidak mengerjakannya hingga mendekati waktu pengumpulan tugas",
//                             "createdAt": "2024-11-01T12:45:50.825Z",
//                             "updatedAt": "2024-11-01T12:45:50.825Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "1506ffe1-f43c-4b8f-9c76-4398c31118c9",
//                     "answer": {
//                         "id": "e9be5267-6bc7-4816-92b9-0823824a3f91",
//                         "answer": "Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "8ba5fcf1-e420-4147-8398-3f18c57b4f1d",
//                             "question": "Saya tergoda untuk melakukan kegiatan lain yang lebih menyenangkan ketika seharusnya mengerjakan tugas kuliah ",
//                             "createdAt": "2024-11-01T12:45:35.560Z",
//                             "updatedAt": "2024-11-01T12:45:35.560Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "60a6f7fa-ea52-44d9-a8ef-114eccb77449",
//                     "answer": {
//                         "id": "8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9",
//                         "answer": "Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "26bfbde5-b833-4264-aa9e-63e8a077dfd5",
//                             "question": "Saya tahu bahwa saya harus mengerjakan tugas kuliah, namun saya tidak melakukannya  ",
//                             "createdAt": "2024-11-01T12:45:19.009Z",
//                             "updatedAt": "2024-11-01T12:45:19.009Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "a791338e-c0ad-408c-bb02-c596c392897d",
//                     "answer": {
//                         "id": "64c02f11-0204-4a11-be07-68ef5b0f36f1",
//                         "answer": "Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "6509cd4d-bf62-4f16-a4a3-dd4216bd2cd5",
//                             "question": "Saya menunda tugas hingga detik-detik terakhir ",
//                             "createdAt": "2024-11-01T12:45:06.860Z",
//                             "updatedAt": "2024-11-01T12:45:06.860Z"
//                         }
//                     }
//                 }
//             ]
//         },
//         {
//             "id": "c3b8e252-de8a-4ab2-9bbd-25a78e454d51",
//             "level": "very low",
//             "score": 7,
//             "subKuisioner": {
//                 "id": "4964861f-962a-416f-b2a0-6a0c93adea91",
//                 "title": "SubKuisioner Kecanduan Ponsel",
//                 "createdAt": "2024-10-16T11:10:18.529Z",
//                 "updatedAt": "2024-10-16T11:10:18.529Z",
//                 "symtompId": {
//                     "id": "c4deb597-856f-4a9d-b23d-3d88658341d1",
//                     "name": "Kecanduan Ponsel"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "0aecc89f-e5f8-4161-9d62-d6e09afb9b1f",
//                     "answer": {
//                         "id": "ce0753c0-bd38-45f1-969f-1d8d3e035a69",
//                         "answer": "Tidak Setuju",
//                         "score": 2,
//                         "questionId": {
//                             "id": "de7716e9-894a-443c-9f7c-830ab7e0acdf",
//                             "question": "Jika saya mencoba mengurangi waktu menggunakan smartphone, saya semakin menggunakannya lebih lama atau lebih sering dari sebelumnya",
//                             "createdAt": "2024-11-01T12:49:01.581Z",
//                             "updatedAt": "2024-11-01T12:49:01.581Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "9ed9f651-7ad5-4ee8-8f83-f2c5ab3d5f1d",
//                     "answer": {
//                         "id": "e34c8419-09e5-4302-a5b4-60b8830419f2",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "36d7938a-7c2e-48e2-a99d-608259dc3475",
//                             "question": "Ketika saya tidak dapat menggunakan smartphone saat ingin, saya merasa sedih",
//                             "createdAt": "2024-11-01T12:48:51.827Z",
//                             "updatedAt": "2024-11-01T12:48:51.827Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "3843e2bc-141c-40f2-8e60-33130814343b",
//                     "answer": {
//                         "id": "5cada605-9735-4e39-9f67-e3915eb9ecfb",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "b10bf59e-921c-4e5d-bdfa-0aeed50e2072",
//                             "question": "Saya menghabiskan waktu terus-menerus hanya untuk bermain smartphone ",
//                             "createdAt": "2024-11-01T12:48:34.999Z",
//                             "updatedAt": "2024-11-01T12:48:34.999Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "ea449ebe-89e4-4b33-8d59-74e22af7855c",
//                     "answer": {
//                         "id": "3dfad056-e365-45cd-8c74-59b49985eca2",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "5fd5ab32-a4d5-435a-9507-e4789c359436",
//                             "question": "Menyibukkan diri dengan smartphone adalah cara untuk mengubah suasana hati saya ",
//                             "createdAt": "2024-11-01T12:48:25.366Z",
//                             "updatedAt": "2024-11-01T12:48:25.366Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "16cac24e-86d7-465c-969b-a15557444837",
//                     "answer": {
//                         "id": "ea88794b-f71a-44aa-8fa5-6bc9556a2afa",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "d3308666-6dee-4ff5-893f-af9e72504f9f",
//                             "question": "Aktivitas saya menggunakan smartphone menyebabkan konflik adalah hal terpenting dalam hidup saya ",
//                             "createdAt": "2024-11-01T12:48:11.126Z",
//                             "updatedAt": "2024-11-01T12:48:11.126Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "8a7109dc-bfa2-4a44-a299-a31087349a90",
//                     "answer": {
//                         "id": "966a3bcc-d18c-484e-b60e-37cdd682cb84",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "687d550f-7c64-439c-b88f-598d55f29f06",
//                             "question": "Smartphone adalah hal terpenting dalam hidup saya ",
//                             "createdAt": "2024-11-01T12:47:57.865Z",
//                             "updatedAt": "2024-11-01T12:47:57.865Z"
//                         }
//                     }
//                 }
//             ]
//         }
//     ]
// }
// const data2 = {
//     "id": "2530cd77-e805-4689-9099-b605cb73249d",
//     "isFinish": true,
//     "report": null,
//     "createdAt": "2024-11-01T13:09:53.148Z",
//     "user": {
//         "id": "da50cf79-ee3b-4651-8dfe-45e9034057cd",
//         "email": "kedathons@gmail.com",
//         "username": "Sekar Aroem Kedathon",
//         "nim": "22523184",
//         "birthDate": "2004-04-20",
//         "yearEntry": 2022,
//         "createdAt": "2024-11-10T14:15:39.047Z",
//         "updatedAt": "2024-11-17T13:49:37.901Z",
//         "gender": "Laki-Laki",
//         "psikologStatus": null,
//         "faculty":{
//             "name":"Faculty Technology Industri"
//         }
//     },
//     "userAnswerSubKuisioner": [
//         {
//             "id": "d0976528-cb10-4fe9-874e-837482d34a27",
//             "level": "normal",
//             "score": 7,
//             "subKuisioner": {
//                 "id": "cd191bdd-8fea-4d6a-81b5-380de93cad59",
//                 "title": "SubKuisioner Stress",
//                 "createdAt": "2024-10-04T12:12:53.351Z",
//                 "updatedAt": "2024-10-04T12:12:53.351Z",
//                 "symtompId": {
//                     "id": "d1401692-5909-41fb-9c4c-b5d2a601c292",
//                     "name": "Stress"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "8aed6282-c500-4a4d-a50d-b805dc447a47",
//                     "answer": {
//                         "id": "33c555fb-64bd-440d-9362-d420ce224c1a",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "673570f0-32cb-4002-b50b-496ca18e4047",
//                             "question": "Setuju sih",
//                             "createdAt": "2024-10-16T11:16:10.292Z",
//                             "updatedAt": "2024-11-20T13:49:10.075Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "bee9bf85-a619-467a-9a09-62ad5dceaf1e",
//                     "answer": {
//                         "id": "26982feb-eba9-4b04-89ea-98535fa61c3d",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "b536f518-186f-494c-82b9-b7ec4686e714",
//                             "question": "Saya sulit untuk bersabar dalam menghadapi gangguan yang terjadi ketika sedang melakukan sesuatu.",
//                             "createdAt": "2024-10-16T11:16:00.293Z",
//                             "updatedAt": "2024-10-16T11:16:00.293Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "ab9b6e85-ec41-4679-b9d4-7e46397338c6",
//                     "answer": {
//                         "id": "ff0653fc-e130-4ea9-b889-96f4bea63b62",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "7667e7db-1f79-48c9-a176-bbe9d773781e",
//                             "question": "Saya merasa sulit untuk merasa tenang.",
//                             "createdAt": "2024-10-16T11:15:43.889Z",
//                             "updatedAt": "2024-10-16T11:15:43.889Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "4f6a19da-85d2-49db-8a70-a55bbdde40ae",
//                     "answer": {
//                         "id": "1e361eae-eb51-4d32-ab0c-cd453bdd2734",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "30924def-0dd1-4a4a-b603-5f8eebcceb70",
//                             "question": "Saya merasa gelisah.",
//                             "createdAt": "2024-10-16T11:15:33.392Z",
//                             "updatedAt": "2024-10-16T11:15:33.392Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "5f8bdbba-25e4-4b96-a234-34d2533f9dc4",
//                     "answer": {
//                         "id": "4e947c6f-446e-4e8e-8cf8-083538146cfe",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "aba6462a-d11b-496f-a930-7dea1d288429",
//                             "question": "Saya merasa energi saya terkuras karena terlalu cemas.",
//                             "createdAt": "2024-10-16T11:15:25.105Z",
//                             "updatedAt": "2024-10-16T11:15:25.105Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "6468bde8-54bc-410f-b9f6-53f00db1de5c",
//                     "answer": {
//                         "id": "1c8d1edf-ae25-4d10-8b63-3b60fbb9e411",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "f30be436-3c81-4ed3-9f40-79a608304a5f",
//                             "question": "Saya cenderung menunjukkan reaksi berlebihan terhadap suatu situasi.",
//                             "createdAt": "2024-10-16T11:15:13.301Z",
//                             "updatedAt": "2024-10-16T11:15:13.301Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "8cf17b89-c59d-4358-bcca-ae8860a1122b",
//                     "answer": {
//                         "id": "11063ddf-508e-4281-8dc5-ac4bd1563d0c",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "e25698f9-143a-422a-9732-95f545082e6d",
//                             "question": "Saya merasa sulit untuk beristirahat.",
//                             "createdAt": "2024-10-16T11:14:51.333Z",
//                             "updatedAt": "2024-10-16T11:14:51.333Z"
//                         }
//                     }
//                 }
//             ]
//         },
//         {
//             "id": "9c796649-76ac-4991-9791-ce310cb528f9",
//             "level": "low",
//             "score": 8,
//             "subKuisioner": {
//                 "id": "47a65933-fe35-41e9-9610-c55805c92b93",
//                 "title": "SubKuisioner Kecemasan",
//                 "createdAt": "2024-10-04T13:07:06.846Z",
//                 "updatedAt": "2024-10-04T13:07:06.846Z",
//                 "symtompId": {
//                     "id": "b549f59f-5f6c-4854-ae82-cef186c15b4f",
//                     "name": "Kecemasan"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "61c3adb7-1f5d-4301-93b5-a8603eea59f6",
//                     "answer": {
//                         "id": "2bd82cb3-8ff5-46a7-a955-c4ca1d38ca1c",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "650707f9-f62f-452d-bfff-2abbd6337bb0",
//                             "question": "Saya merasa ketakutan tanpa alasan yang jelas.",
//                             "createdAt": "2024-10-16T11:20:00.017Z",
//                             "updatedAt": "2024-10-16T11:20:00.017Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "4a4047fe-dfb8-41db-ad18-6b900bc7de6a",
//                     "answer": {
//                         "id": "40c13606-829a-4d32-9a2f-634465feb1b3",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "8b56b1da-d0e0-4aba-b04f-d37855c01594",
//                             "question": "Saya menyadari kondisi jantung saya (seperti meningkatnya atau melemahnya detak jantung) meskipun sedang tidak melakukan aktivitas fisik.",
//                             "createdAt": "2024-10-16T11:19:42.243Z",
//                             "updatedAt": "2024-10-16T11:19:42.243Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "5f7a1056-3f27-488e-b9e2-f24134a1a746",
//                     "answer": {
//                         "id": "c965fa2d-0ebd-440c-86ce-bab64e06553a",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "970d537c-edd4-4cb9-815a-170694527754",
//                             "question": "Saya merasa hampir panik.",
//                             "createdAt": "2024-10-16T11:19:25.953Z",
//                             "updatedAt": "2024-10-16T11:19:25.953Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "fd52dd10-33a2-42f0-afc2-39ceaa37feb8",
//                     "answer": {
//                         "id": "868435dd-ab2f-48d0-8fc8-97b29a652c0c",
//                         "answer": "Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu",
//                         "score": 2,
//                         "questionId": {
//                             "id": "9580539a-9643-4ee5-8008-c2caf10fd661",
//                             "question": "Saya merasa khawatir dengan situasi dimana saya mungkin menjadi panik dan mempermalukan diri sendiri.",
//                             "createdAt": "2024-10-16T11:19:16.552Z",
//                             "updatedAt": "2024-10-16T11:19:16.552Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "5a443787-45b5-4881-ac3b-64d76051a9c5",
//                     "answer": {
//                         "id": "ca965a27-d390-453b-a3cc-69e4ccc791e3",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "8726beeb-9cd2-4e5e-acaa-6a1c8e0b3edb",
//                             "question": "Saya merasa gemetar (misalnya pada tangan).",
//                             "createdAt": "2024-10-16T11:19:03.101Z",
//                             "updatedAt": "2024-10-16T11:19:03.101Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "8509a13e-92b2-4f11-9d69-7f12440e0738",
//                     "answer": {
//                         "id": "e39910ae-2305-4c95-b7cf-a12676e2c464",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "ed9ed04d-aae5-45f1-88ca-a716fec1454e",
//                             "question": "Saya merasa kesulitan bernafas (misalnya seringkali terengah-engah atau tidak dapat bernapas padahal tidak melakukan aktivitas fisik sebelumnya).",
//                             "createdAt": "2024-10-16T11:18:50.841Z",
//                             "updatedAt": "2024-10-16T11:18:50.841Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "a33d1494-59bb-4fe7-b382-c6ea6161c564",
//                     "answer": {
//                         "id": "24885b7b-5bb4-43dc-bf61-7e4a5e32b0cc",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "9f997851-c784-4fea-8928-cf13baf669e4",
//                             "question": "Saya merasa rongga mulut saya kering.",
//                             "createdAt": "2024-10-16T11:18:28.150Z",
//                             "updatedAt": "2024-10-16T11:18:28.150Z"
//                         }
//                     }
//                 }
//             ]
//         },
//         {
//             "id": "87c8d50e-ad2b-46ca-aeab-17dcee9a2aa4",
//             "level": "normal",
//             "score": 9,
//             "subKuisioner": {
//                 "id": "22fb61dd-f54d-4bec-bb98-26d90f94d16b",
//                 "title": "SubKuisioner Depresi",
//                 "createdAt": "2024-10-16T11:09:08.223Z",
//                 "updatedAt": "2024-10-16T11:09:08.223Z",
//                 "symtompId": {
//                     "id": "52801a1d-32e6-49d8-bed4-162374630e46",
//                     "name": "Depresi"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "c6cd4e6a-8589-4f38-846c-714841d7bafa",
//                     "answer": {
//                         "id": "b52ffb50-0d1e-4da5-8bf8-2ce37912d821",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "310a3ea6-2196-4e58-8f1c-5016d750d663",
//                             "question": "Saya merasa hidup ini tidak berarti.",
//                             "createdAt": "2024-10-16T11:26:37.972Z",
//                             "updatedAt": "2024-10-16T11:26:37.972Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "d4239e0c-91c5-47f2-8379-c444eb83585a",
//                     "answer": {
//                         "id": "3635d565-2a74-447e-829b-b7e334ef194e",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "aae60c45-876c-4634-98db-421b06751ac9",
//                             "question": "Saya merasa diri saya tidak berharga.",
//                             "createdAt": "2024-10-16T11:26:30.100Z",
//                             "updatedAt": "2024-10-16T11:26:30.100Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "bbf80283-e940-406f-8db4-65f279d7b301",
//                     "answer": {
//                         "id": "c7603d88-fad0-487b-9eb7-c3c31a5ca59d",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "04e07acf-f306-4ec5-8548-dff939fbba6e",
//                             "question": "Saya tidak bisa merasa antusias terhadap hal apapun.",
//                             "createdAt": "2024-10-16T11:26:21.887Z",
//                             "updatedAt": "2024-10-16T11:26:21.887Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "ba1aa45c-32b8-4841-921a-8125937870c1",
//                     "answer": {
//                         "id": "cdce8b68-4fc8-4d39-b39c-3485307475cb",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "e573d43b-6495-4b1e-9f94-7a9d062b481a",
//                             "question": "Saya merasa sedih dan tertekan.",
//                             "createdAt": "2024-10-16T11:26:01.864Z",
//                             "updatedAt": "2024-10-16T11:26:01.864Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "3dc2c348-03af-406e-a41d-7fd5261abb91",
//                     "answer": {
//                         "id": "6f5e8d37-82ca-4ed0-b9a2-ccdd3b8a542a",
//                         "answer": "Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu",
//                         "score": 2,
//                         "questionId": {
//                             "id": "93d681f6-75a7-413b-9005-b1249d27210a",
//                             "question": "Saya merasa tidak ada lagi yang bisa saya harapkan.",
//                             "createdAt": "2024-10-16T11:25:53.086Z",
//                             "updatedAt": "2024-10-16T11:25:53.086Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "a1d661f8-f7ec-4888-9b97-9f77bfcbd424",
//                     "answer": {
//                         "id": "71d05faf-8913-4073-a401-7ee58d09559c",
//                         "answer": "Terjadi pada saya dalam tingkatan yang cukup sering atau sebagian besar waktu",
//                         "score": 2,
//                         "questionId": {
//                             "id": "3b89d150-a078-486a-a107-e1843db6db6e",
//                             "question": "Saya merasa sulit berinisiatif melakukan sesuatu.",
//                             "createdAt": "2024-10-16T11:25:43.546Z",
//                             "updatedAt": "2024-10-16T11:25:43.546Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "c52a0753-d0f4-4c4f-b6a2-155ee10ea87c",
//                     "answer": {
//                         "id": "6e8aa530-4d74-4e8c-babd-274b66ba6b69",
//                         "answer": "Terjadi pada saya dalam beberapa hal, atau pada beberapa waktu",
//                         "score": 1,
//                         "questionId": {
//                             "id": "51ee586e-6333-4d9d-a961-071a9ac4e1f7",
//                             "question": "Saya sama sekali tidak dapat merasakan perasaan positif (contoh: merasa gembira, bangga, dsb).",
//                             "createdAt": "2024-10-16T11:25:34.554Z",
//                             "updatedAt": "2024-10-16T11:25:34.554Z"
//                         }
//                     }
//                 }
//             ]
//         },
//         {
//             "id": "4542865a-e066-4fd2-a431-08a58b6cdda0",
//             "level": "very low",
//             "score": 6,
//             "subKuisioner": {
//                 "id": "744f79d7-2692-422c-9d63-b24cec2f8d6b",
//                 "title": "SubKuisioner Prokrastinasi",
//                 "createdAt": "2024-10-16T11:09:51.779Z",
//                 "updatedAt": "2024-10-16T11:09:51.779Z",
//                 "symtompId": {
//                     "id": "ff065e0a-eddf-4416-b82a-f4666b2e0a1c",
//                     "name": "Prokrastinasi"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "1249ad91-afaa-4c8e-8b05-ca5545de0a9c",
//                     "answer": {
//                         "id": "ced2e89a-0e7a-4427-8c85-b0d557baac68",
//                         "answer": "Kurang Setuju",
//                         "score": 2,
//                         "questionId": {
//                             "id": "dd485669-4209-44f8-b21b-85751223d073",
//                             "question": "Saya sering menunda deadline pengerjaan tugas yang penting ",
//                             "createdAt": "2024-11-01T12:46:04.849Z",
//                             "updatedAt": "2024-11-01T12:46:04.849Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "de86dbd8-2450-4d89-aa50-771f8945e153",
//                     "answer": {
//                         "id": "decba44a-23dc-4d6b-b754-4799e45488d6",
//                         "answer": "Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "b58a1c58-369f-4c0c-9201-3a5921171675",
//                             "question": "Ketika diberi tugas, saya biasanya membiarkan dan tidak mengerjakannya hingga mendekati waktu pengumpulan tugas",
//                             "createdAt": "2024-11-01T12:45:50.825Z",
//                             "updatedAt": "2024-11-01T12:45:50.825Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "1506ffe1-f43c-4b8f-9c76-4398c31118c9",
//                     "answer": {
//                         "id": "e9be5267-6bc7-4816-92b9-0823824a3f91",
//                         "answer": "Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "8ba5fcf1-e420-4147-8398-3f18c57b4f1d",
//                             "question": "Saya tergoda untuk melakukan kegiatan lain yang lebih menyenangkan ketika seharusnya mengerjakan tugas kuliah ",
//                             "createdAt": "2024-11-01T12:45:35.560Z",
//                             "updatedAt": "2024-11-01T12:45:35.560Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "60a6f7fa-ea52-44d9-a8ef-114eccb77449",
//                     "answer": {
//                         "id": "8d82319a-99cf-4a6c-8cd3-b3dba7b00ac9",
//                         "answer": "Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "26bfbde5-b833-4264-aa9e-63e8a077dfd5",
//                             "question": "Saya tahu bahwa saya harus mengerjakan tugas kuliah, namun saya tidak melakukannya  ",
//                             "createdAt": "2024-11-01T12:45:19.009Z",
//                             "updatedAt": "2024-11-01T12:45:19.009Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "a791338e-c0ad-408c-bb02-c596c392897d",
//                     "answer": {
//                         "id": "64c02f11-0204-4a11-be07-68ef5b0f36f1",
//                         "answer": "Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "6509cd4d-bf62-4f16-a4a3-dd4216bd2cd5",
//                             "question": "Saya menunda tugas hingga detik-detik terakhir ",
//                             "createdAt": "2024-11-01T12:45:06.860Z",
//                             "updatedAt": "2024-11-01T12:45:06.860Z"
//                         }
//                     }
//                 }
//             ]
//         },
//         {
//             "id": "c3b8e252-de8a-4ab2-9bbd-25a78e454d51",
//             "level": "very low",
//             "score": 7,
//             "subKuisioner": {
//                 "id": "4964861f-962a-416f-b2a0-6a0c93adea91",
//                 "title": "SubKuisioner Kecanduan Ponsel",
//                 "createdAt": "2024-10-16T11:10:18.529Z",
//                 "updatedAt": "2024-10-16T11:10:18.529Z",
//                 "symtompId": {
//                     "id": "c4deb597-856f-4a9d-b23d-3d88658341d1",
//                     "name": "Kecanduan Ponsel"
//                 }
//             },
//             "userAnswerKuisioners": [
//                 {
//                     "id": "0aecc89f-e5f8-4161-9d62-d6e09afb9b1f",
//                     "answer": {
//                         "id": "ce0753c0-bd38-45f1-969f-1d8d3e035a69",
//                         "answer": "Tidak Setuju",
//                         "score": 2,
//                         "questionId": {
//                             "id": "de7716e9-894a-443c-9f7c-830ab7e0acdf",
//                             "question": "Jika saya mencoba mengurangi waktu menggunakan smartphone, saya semakin menggunakannya lebih lama atau lebih sering dari sebelumnya",
//                             "createdAt": "2024-11-01T12:49:01.581Z",
//                             "updatedAt": "2024-11-01T12:49:01.581Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "9ed9f651-7ad5-4ee8-8f83-f2c5ab3d5f1d",
//                     "answer": {
//                         "id": "e34c8419-09e5-4302-a5b4-60b8830419f2",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "36d7938a-7c2e-48e2-a99d-608259dc3475",
//                             "question": "Ketika saya tidak dapat menggunakan smartphone saat ingin, saya merasa sedih",
//                             "createdAt": "2024-11-01T12:48:51.827Z",
//                             "updatedAt": "2024-11-01T12:48:51.827Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "3843e2bc-141c-40f2-8e60-33130814343b",
//                     "answer": {
//                         "id": "5cada605-9735-4e39-9f67-e3915eb9ecfb",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "b10bf59e-921c-4e5d-bdfa-0aeed50e2072",
//                             "question": "Saya menghabiskan waktu terus-menerus hanya untuk bermain smartphone ",
//                             "createdAt": "2024-11-01T12:48:34.999Z",
//                             "updatedAt": "2024-11-01T12:48:34.999Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "ea449ebe-89e4-4b33-8d59-74e22af7855c",
//                     "answer": {
//                         "id": "3dfad056-e365-45cd-8c74-59b49985eca2",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "5fd5ab32-a4d5-435a-9507-e4789c359436",
//                             "question": "Menyibukkan diri dengan smartphone adalah cara untuk mengubah suasana hati saya ",
//                             "createdAt": "2024-11-01T12:48:25.366Z",
//                             "updatedAt": "2024-11-01T12:48:25.366Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "16cac24e-86d7-465c-969b-a15557444837",
//                     "answer": {
//                         "id": "ea88794b-f71a-44aa-8fa5-6bc9556a2afa",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "d3308666-6dee-4ff5-893f-af9e72504f9f",
//                             "question": "Aktivitas saya menggunakan smartphone menyebabkan konflik adalah hal terpenting dalam hidup saya ",
//                             "createdAt": "2024-11-01T12:48:11.126Z",
//                             "updatedAt": "2024-11-01T12:48:11.126Z"
//                         }
//                     }
//                 },
//                 {
//                     "id": "8a7109dc-bfa2-4a44-a299-a31087349a90",
//                     "answer": {
//                         "id": "966a3bcc-d18c-484e-b60e-37cdd682cb84",
//                         "answer": "Sangat Tidak Setuju",
//                         "score": 1,
//                         "questionId": {
//                             "id": "687d550f-7c64-439c-b88f-598d55f29f06",
//                             "question": "Smartphone adalah hal terpenting dalam hidup saya ",
//                             "createdAt": "2024-11-01T12:47:57.865Z",
//                             "updatedAt": "2024-11-01T12:47:57.865Z"
//                         }
//                     }
//                 }
//             ]
//         }
//     ]
// }

// const realDataBanyak = [data,data2]

// const data = await this.takeKuisionerService.findLatest(idUser)
