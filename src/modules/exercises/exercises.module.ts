import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ExercisesController } from './exercises.controller';
import { ExercisesService } from './exercises.service';
import { Exercise } from '../../entities/exercise.entity';
import { WorkoutRecord } from '../../entities/workout-record.entity';

@Module({
	imports: [TypeOrmModule.forFeature([Exercise, WorkoutRecord])],
	controllers: [ExercisesController],
	providers: [ExercisesService],
	exports: [ExercisesService],
})
export class ExercisesModule {}
