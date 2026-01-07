import { Repository, FindOptionsWhere } from 'typeorm';
import { Logger } from '@nestjs/common';
import { ApiExceptions } from '../exceptions';

/**
 * Repository 공통 메서드 헬퍼
 */
export class RepositoryHelper {
	/**
	 * memberId로 엔티티 찾기 (없으면 에러)
	 */
	static async findOneOrFailByMemberId<T>(
		repository: Repository<T>,
		id: string,
		memberId: string,
		logger: Logger,
		entityName: string,
		where?: FindOptionsWhere<T>,
	): Promise<T> {
		const entity = await repository.findOne({
			where: {
				id,
				memberId,
				...where,
			} as FindOptionsWhere<T>,
		});

		if (!entity) {
			logger.warn(`${entityName}을 찾을 수 없습니다. ID: ${id}, MemberId: ${memberId}`);
			throw ApiExceptions.memberNotFound(`${entityName}을 찾을 수 없습니다.`);
		}

		return entity;
	}

	/**
	 * memberId로 엔티티 존재 확인
	 */
	static async ensureMemberExists<T>(
		repository: Repository<T>,
		memberId: string,
		logger: Logger,
	): Promise<void> {
		const member = await repository.findOne({
			where: { id: memberId } as unknown as FindOptionsWhere<T>,
		});

		if (!member) {
			logger.warn(`회원을 찾을 수 없습니다. MemberId: ${memberId}`);
			throw ApiExceptions.memberNotFound();
		}
	}
}

