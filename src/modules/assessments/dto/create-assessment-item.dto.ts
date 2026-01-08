import { IsEnum, IsString, IsNumber, MaxLength, IsOptional, IsObject } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Category } from '../../../common/enums';

export class CreateAssessmentItemDto {
	@ApiProperty({
		description: '평가 카테고리',
		enum: Category,
		example: Category.STRENGTH,
	})
	@IsEnum(Category, { message: '올바른 카테고리가 아닙니다.' })
	category: Category;

	@ApiProperty({
		description: '평가 항목 이름',
		example: '체중 스쿼트',
		maxLength: 255,
	})
	@IsString({ message: '이름은 문자열이어야 합니다.' })
	@MaxLength(255, { message: '이름은 255자 이하여야 합니다.' })
	name: string;

	@ApiPropertyOptional({
		description: '측정값 (등급 기반 평가의 경우 null 가능)',
		example: 80,
	})
	@IsOptional()
	@IsNumber({}, { message: '값은 숫자여야 합니다.' })
	value?: number;

	@ApiPropertyOptional({
		description: '단위 (value가 null이면 unit도 null)',
		example: 'kg',
		maxLength: 50,
	})
	@IsOptional()
	@IsString({ message: '단위는 문자열이어야 합니다.' })
	@MaxLength(50, { message: '단위는 50자 이하여야 합니다.' })
	unit?: string;

	@ApiPropertyOptional({
		description: '평가 항목 상세 정보 (등급, 관찰 포인트, 대체 항목 정보 등)',
		example: {
			grade: 'A',
			internalScore: 80,
			recoverySpeed: ['fast'],
			flexibilityItems: {
				sitAndReach: 'A',
				shoulder: 'B',
				hip: 'C',
			},
			ohsa: 'A',
			pain: 'none',
			muscleMass: 45.2,
			fatMass: 15.8,
			bodyFatPercentage: 22.4,
		},
	})
	@IsOptional()
	@IsObject({ message: '상세 정보는 객체여야 합니다.' })
	details?: {
		// 등급 정보
		grade?: string; // 'A', 'B', 'C', 'D', 'D-1', 'D-2' 등
		internalScore?: number; // 내부 점수 (0-100, UI 비노출)
		
		// 대체 항목 정보
		isReplacement?: boolean;
		isImpossible?: boolean;
		weight?: number; // 항목별 비중
		
		// 심폐 지구력 회복 속도
		recoverySpeed?: string[]; // ['fast', 'slow']
		
		// 유연성 항목별 평가
		flexibilityItems?: {
			sitAndReach?: 'A' | 'B' | 'C';
			shoulder?: 'A' | 'B' | 'C';
			hip?: 'A' | 'B' | 'C';
			hamstring?: 'A' | 'B' | 'C';
		};
		
		// 안정성 평가
		ohsa?: 'A' | 'B' | 'C';
		pain?: 'none' | 'present';
		
		// 체성분 데이터
		muscleMass?: number;
		fatMass?: number;
		bodyFatPercentage?: number;
		
		// 관찰 포인트
		observations?: {
			[key: string]: any;
		};
		
		// 좌우 차이
		leftRightDifference?: {
			left?: number;
			right?: number;
		};
		
		// 기타 상세 정보
		[key: string]: any;
	};
}

