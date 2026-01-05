import { IsString, IsDateString, IsEnum, IsOptional, MaxLength } from 'class-validator';
import { Severity, RecoveryStatus } from '../../../common/enums';

export class CreateInjuryDto {
  @IsString({ message: '부상 타입은 문자열이어야 합니다.' })
  @MaxLength(255, { message: '부상 타입은 255자 이하여야 합니다.' })
  injuryType: string;

  @IsString({ message: '부위는 문자열이어야 합니다.' })
  @MaxLength(255, { message: '부위는 255자 이하여야 합니다.' })
  bodyPart: string;

  @IsDateString({}, { message: '올바른 날짜 형식이 아닙니다. (YYYY-MM-DD)' })
  date: string;

  @IsEnum(Severity, { message: '올바른 심각도가 아닙니다.' })
  severity: Severity;

  @IsOptional()
  @IsString({ message: '설명은 문자열이어야 합니다.' })
  description?: string;

  @IsEnum(RecoveryStatus, { message: '올바른 회복 상태가 아닙니다.' })
  recoveryStatus: RecoveryStatus;
}

