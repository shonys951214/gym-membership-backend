import {
	Controller,
	Get,
	Param,
	Query,
	UseGuards,
} from '@nestjs/common';
import {
	ApiTags,
	ApiOperation,
	ApiResponse,
	ApiBearerAuth,
	ApiParam,
} from '@nestjs/swagger';
import { ExercisesService } from './exercises.service';
import { GetExercisesDto } from './dto/get-exercises.dto';
import { JwtAuthGuard } from '../../common/guards';
import { ApiResponseHelper } from '../../common/utils/api-response';

@ApiTags('exercises')
@ApiBearerAuth('JWT-auth')
@Controller('api/exercises')
@UseGuards(JwtAuthGuard)
export class ExercisesController {
	constructor(private readonly exercisesService: ExercisesService) {}

	@Get()
	@ApiOperation({
		summary: '운동 목록 조회',
		description: '필터링 및 검색을 지원하는 운동 목록을 조회합니다.',
	})
	@ApiResponse({ status: 200, description: '운동 목록 조회 성공' })
	async findAll(@Query() query: GetExercisesDto) {
		const exercises = await this.exercisesService.findAll(query);
		return ApiResponseHelper.success(
			{ exercises, total: exercises.length },
			'운동 목록 조회 성공',
		);
	}

	@Get(':id')
	@ApiOperation({
		summary: '운동 상세 조회',
		description: '특정 운동의 상세 정보를 조회합니다.',
	})
	@ApiParam({ name: 'id', description: '운동 ID (UUID)' })
	@ApiResponse({ status: 200, description: '운동 상세 조회 성공' })
	@ApiResponse({ status: 404, description: '운동을 찾을 수 없습니다' })
	async findOne(@Param('id') id: string) {
		const exercise = await this.exercisesService.findOne(id);
		return ApiResponseHelper.success(exercise, '운동 상세 조회 성공');
	}
}
