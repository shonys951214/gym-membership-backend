import { Repository, FindOptionsWhere, FindOneOptions } from 'typeorm';
import { Logger } from '@nestjs/common';
import { ApiExceptions } from '../exceptions';

/**
 * Repository 공통 메서드 헬퍼
 * 에러 처리 및 로깅 패턴 통일
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
	 * memberId로 엔티티 존재 확인 (간단한 체크용)
	 * @param repository Repository 인스턴스
	 * @param memberId 회원 ID
	 * @param logger Logger 인스턴스
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

	/**
	 * findOneOrFail 래퍼 (간단한 체크용)
	 * @param repository Repository 인스턴스
	 * @param where 조건
	 * @param logger Logger 인스턴스
	 * @param entityName 엔티티 이름 (에러 메시지용)
	 * @returns 찾은 엔티티
	 */
	static async findOneOrFailSimple<T>(
		repository: Repository<T>,
		where: FindOptionsWhere<T>,
		logger: Logger,
		entityName: string = '엔티티',
	): Promise<T> {
		try {
			return await repository.findOneOrFail({ where });
		} catch (error) {
			logger.warn(`${entityName}을 찾을 수 없습니다.`);
			throw ApiExceptions.memberNotFound(`${entityName}을 찾을 수 없습니다.`);
		}
	}

	/**
	 * 엔티티 찾기 (없으면 에러) - 범용 메서드
	 * @param repository Repository 인스턴스
	 * @param options FindOneOptions
	 * @param logger Logger 인스턴스
	 * @param entityName 엔티티 이름 (에러 메시지용)
	 * @param errorMessage 커스텀 에러 메시지 (선택)
	 * @returns 찾은 엔티티
	 */
	static async findOneOrFail<T>(
		repository: Repository<T>,
		options: FindOneOptions<T>,
		logger: Logger,
		entityName: string,
		errorMessage?: string,
	): Promise<T> {
		const entity = await repository.findOne(options);

		if (!entity) {
			const message = errorMessage || `${entityName}을 찾을 수 없습니다.`;
			logger.warn(message);
			throw ApiExceptions.memberNotFound(message);
		}

		return entity;
	}

	/**
	 * 엔티티 찾기 (없으면 null 반환) - 안전한 조회
	 * @param repository Repository 인스턴스
	 * @param options FindOneOptions
	 * @returns 찾은 엔티티 또는 null
	 */
	static async findOneSafe<T>(
		repository: Repository<T>,
		options: FindOneOptions<T>,
	): Promise<T | null> {
		return repository.findOne(options);
	}
}

