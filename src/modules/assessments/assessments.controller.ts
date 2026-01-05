import {
  Controller,
  Get,
  Post,
  Put,
  Param,
  Body,
  UseGuards,
  Query,
} from '@nestjs/common';
import { AssessmentsService } from './assessments.service';
import { CreateAssessmentDto } from './dto/create-assessment.dto';
import { UpdateAssessmentDto } from './dto/update-assessment.dto';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Role } from '../../common/enums';
import { ApiResponseHelper } from '../../common/utils/api-response';

@Controller('api/members/:memberId/assessments')
@UseGuards(JwtAuthGuard)
export class AssessmentsController {
  constructor(private readonly assessmentsService: AssessmentsService) {}

  @Get()
  async findAll(@Param('memberId') memberId: string) {
    const assessments = await this.assessmentsService.findAll(memberId);
    return ApiResponseHelper.success({
      assessments,
      total: assessments.length,
    });
  }

  @Get(':id')
  async findOne(
    @Param('memberId') memberId: string,
    @Param('id') id: string,
  ) {
    const assessment = await this.assessmentsService.findOne(id, memberId);
    return ApiResponseHelper.success(assessment, '평가 조회 성공');
  }

  @Post()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.TRAINER)
  async create(
    @Param('memberId') memberId: string,
    @Body() createAssessmentDto: CreateAssessmentDto,
  ) {
    const assessment = await this.assessmentsService.create(
      memberId,
      createAssessmentDto,
    );
    return ApiResponseHelper.success(assessment, '평가 생성 성공');
  }

  @Put(':id')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN, Role.TRAINER)
  async update(
    @Param('memberId') memberId: string,
    @Param('id') id: string,
    @Body() updateAssessmentDto: UpdateAssessmentDto,
  ) {
    const assessment = await this.assessmentsService.update(
      id,
      memberId,
      updateAssessmentDto,
    );
    return ApiResponseHelper.success(assessment, '평가 수정 성공');
  }

}

