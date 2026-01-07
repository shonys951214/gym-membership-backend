import { PTUsage } from '../../entities/pt-usage.entity';
import { Repository } from 'typeorm';
import { Logger } from '@nestjs/common';
import { ApiExceptions } from '../exceptions';

/**
 * PT 횟수 관리 헬퍼 유틸리티
 */
export class PTUsageHelper {
	/**
	 * PTUsage 조회 (최신 것)
	 */
	static async getLatestPTUsage(
		repository: Repository<PTUsage>,
		memberId: string,
	): Promise<PTUsage | null> {
		return repository.findOne({
			where: { memberId },
			order: { createdAt: 'DESC' },
		});
	}

	/**
	 * PT 횟수 검증 (없거나 부족하면 에러)
	 */
	static validatePTUsage(
		ptUsage: PTUsage | null,
		memberId: string,
		logger: Logger,
	): void {
		if (!ptUsage) {
			logger.warn(
				`PT 횟수 정보가 없습니다. PT 운동 기록을 생성할 수 없습니다. (MemberId: ${memberId})`,
			);
			throw ApiExceptions.badRequest(
				'PT 횟수 정보가 없습니다. PT 세션 및 횟수 관리에서 먼저 PT 횟수를 추가해주세요.',
			);
		}

		if (ptUsage.remainingCount <= 0) {
			logger.warn(
				`PT 횟수가 부족합니다. 남은 횟수: ${ptUsage.remainingCount} (MemberId: ${memberId})`,
			);
			throw ApiExceptions.badRequest(
				`PT 횟수가 부족합니다. 남은 횟수: ${ptUsage.remainingCount}회. PT 세션 및 횟수 관리에서 횟수를 추가해주세요.`,
			);
		}
	}

	/**
	 * PT 횟수 차감
	 */
	static async deductPTUsage(
		repository: Repository<PTUsage>,
		ptUsage: PTUsage,
		usedDate: Date,
		logger: Logger,
		memberId: string,
	): Promise<void> {
		ptUsage.remainingCount -= 1;
		ptUsage.usedCount += 1;
		ptUsage.lastUsedDate = usedDate;
		await repository.save(ptUsage);
		logger.log(
			`PT 횟수 자동 차감: 남은 횟수 ${ptUsage.remainingCount} (MemberId: ${memberId})`,
		);
	}

	/**
	 * PT 횟수 복구
	 */
	static async restorePTUsage(
		repository: Repository<PTUsage>,
		ptUsage: PTUsage | null,
		logger: Logger,
		memberId: string,
	): Promise<void> {
		if (ptUsage) {
			ptUsage.remainingCount += 1;
			ptUsage.usedCount = Math.max(0, ptUsage.usedCount - 1);
			await repository.save(ptUsage);
			logger.log(
				`PT 횟수 복구: 남은 횟수 ${ptUsage.remainingCount} (MemberId: ${memberId})`,
			);
		}
	}
}

