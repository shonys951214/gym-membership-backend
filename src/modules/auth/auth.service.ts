import {
	Injectable,
	Logger,
} from "@nestjs/common";
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { User } from '../../entities/user.entity';
import { Role } from '../../common/enums';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { ApiResponseHelper } from '../../common/utils/api-response';
import { ApiExceptions } from '../../common/exceptions';

@Injectable()
export class AuthService {
	private readonly logger = new Logger(AuthService.name);

	constructor(
		@InjectRepository(User)
		private userRepository: Repository<User>,
		private jwtService: JwtService,
		private configService: ConfigService,
	) {}

	async validateUser(email: string, password: string): Promise<User | null> {
		const user = await this.userRepository.findOne({
			where: { email },
		});

		// 소셜 로그인 사용자는 비밀번호가 없음
		if (!user || !user.password) {
			return null;
		}

		// provider가 KAKAO 등 소셜 로그인이면 일반 로그인 불가
		if (user.provider && user.provider !== 'LOCAL') {
			return null;
		}

		// TRAINER는 승인되지 않으면 로그인 불가
		if (user.role === Role.TRAINER && !user.isApproved) {
			this.logger.warn(
				`로그인 실패: 승인 대기 중인 TRAINER입니다. Email: ${email}`,
			);
			return null;
		}

		if (await bcrypt.compare(password, user.password)) {
			return user;
		}

		return null;
	}

	async login(loginDto: LoginDto) {
		const user = await this.validateUser(loginDto.email, loginDto.password);

		if (!user) {
			// 승인 대기 중인 TRAINER인지 확인
			const checkUser = await this.userRepository.findOne({
				where: { email: loginDto.email },
			});
			
			if (checkUser && checkUser.role === Role.TRAINER && !checkUser.isApproved) {
				throw ApiExceptions.unauthorized('TRAINER 승인이 대기 중입니다. ADMIN의 승인을 기다려주세요.');
			}
			
			throw ApiExceptions.unauthorized('이메일 또는 비밀번호가 올바르지 않습니다.');
		}

		return await this.generateToken(user);
	}

  async register(registerDto: RegisterDto) {
    const existingUser = await this.userRepository.findOne({
      where: { email: registerDto.email },
    });

		if (existingUser) {
			this.logger.warn(
				`회원가입 실패: 이미 등록된 이메일입니다. Email: ${registerDto.email}`,
			);
			throw ApiExceptions.memberAlreadyExists("이미 등록된 이메일입니다.");
		}

    const hashedPassword = await bcrypt.hash(registerDto.password, 10);
		const requestedRole = registerDto.role || Role.MEMBER;
		
		// TRAINER는 ADMIN 승인 필요 (isApproved: false)
		// MEMBER는 자동 승인 (isApproved: true)
		// ADMIN은 회원가입 불가 (test 계정만 사용)
		const isApproved = requestedRole === Role.MEMBER;

		if (requestedRole === Role.ADMIN) {
			this.logger.warn(
				`회원가입 실패: ADMIN 역할은 회원가입으로 생성할 수 없습니다. Email: ${registerDto.email}`,
			);
			throw ApiExceptions.forbidden("ADMIN 역할은 회원가입으로 생성할 수 없습니다.");
		}

		const user = this.userRepository.create({
			email: registerDto.email,
			password: hashedPassword,
			name: registerDto.name,
			role: requestedRole,
			isApproved: isApproved,
			provider: 'LOCAL', // 일반 회원가입은 LOCAL
			providerId: null,
		});

    const savedUser = await this.userRepository.save(user);

		if (requestedRole === Role.TRAINER) {
			this.logger.log(
				`TRAINER 회원가입 완료 (승인 대기): ${savedUser.email} - ADMIN 승인 필요`,
			);
		}

    return {
      id: savedUser.id,
      email: savedUser.email,
      name: savedUser.name,
      role: savedUser.role,
      isApproved: savedUser.isApproved,
      message: requestedRole === Role.TRAINER 
				? 'TRAINER 회원가입이 완료되었습니다. ADMIN의 승인을 기다려주세요.'
				: '회원가입이 완료되었습니다.',
    };
  }

	async findById(id: string): Promise<User | null> {
		return this.userRepository.findOne({
			where: { id },
		});
	}

	/**
	 * 승인 대기 중인 TRAINER 목록 조회 (ADMIN만)
	 */
	async getPendingTrainers(): Promise<User[]> {
		const pendingTrainers = await this.userRepository.find({
			where: {
				role: Role.TRAINER,
				isApproved: false,
			},
			order: {
				createdAt: 'ASC', // 가입일 순으로 정렬
			},
		});

		return pendingTrainers;
	}

	/**
	 * TRAINER 승인 (ADMIN만)
	 */
	async approveTrainer(trainerId: string, adminId: string): Promise<User> {
		const trainer = await this.userRepository.findOne({
			where: { id: trainerId },
		});

		if (!trainer) {
			throw ApiExceptions.memberNotFound('TRAINER를 찾을 수 없습니다.');
		}

		if (trainer.role !== Role.TRAINER) {
			throw ApiExceptions.forbidden('TRAINER가 아닙니다.');
		}

		if (trainer.isApproved) {
			throw ApiExceptions.validationError('이미 승인된 TRAINER입니다.');
		}

		trainer.isApproved = true;
		const approvedTrainer = await this.userRepository.save(trainer);

		this.logger.log(
			`TRAINER 승인 완료: ${approvedTrainer.email} (승인자: ${adminId})`,
		);

		return approvedTrainer;
	}

	/**
	 * TRAINER 거부 (ADMIN만) - 계정 삭제
	 */
	async rejectTrainer(trainerId: string, adminId: string): Promise<void> {
		const trainer = await this.userRepository.findOne({
			where: { id: trainerId },
		});

		if (!trainer) {
			throw ApiExceptions.memberNotFound('TRAINER를 찾을 수 없습니다.');
		}

		if (trainer.role !== Role.TRAINER) {
			throw ApiExceptions.forbidden('TRAINER가 아닙니다.');
		}

		if (trainer.isApproved) {
			throw ApiExceptions.validationError('이미 승인된 TRAINER는 거부할 수 없습니다.');
		}

		await this.userRepository.remove(trainer);

		this.logger.log(
			`TRAINER 거부 완료: ${trainer.email} (거부자: ${adminId})`,
		);
	}

	/**
	 * 사용자 정보 수정
	 */
	async updateUser(
		userId: string,
		updateUserDto: {
			name?: string;
			email?: string;
			password?: string;
			role?: Role;
		},
		currentUser: { id: string; role: Role },
	): Promise<User> {
		const user = await this.userRepository.findOne({
			where: { id: userId },
		});

		if (!user) {
			throw ApiExceptions.memberNotFound('사용자를 찾을 수 없습니다.');
		}

		// 이메일 변경 시 중복 체크
		if (updateUserDto.email && updateUserDto.email !== user.email) {
			const existingUser = await this.userRepository.findOne({
				where: { email: updateUserDto.email },
			});

			if (existingUser) {
				this.logger.warn(
					`사용자 수정 실패: 이미 등록된 이메일입니다. Email: ${updateUserDto.email}`,
				);
				throw ApiExceptions.memberAlreadyExists('이미 등록된 이메일입니다.');
			}
		}

		// 역할 변경은 ADMIN만 가능
		if (updateUserDto.role && updateUserDto.role !== user.role) {
			if (currentUser.role !== Role.ADMIN) {
				this.logger.warn(
					`사용자 수정 실패: 역할 변경은 ADMIN만 가능합니다. User: ${currentUser.id}`,
				);
				throw ApiExceptions.forbidden('역할 변경은 ADMIN만 가능합니다.');
			}
		}

		// 비밀번호 변경 시 해싱
		if (updateUserDto.password) {
			updateUserDto.password = await bcrypt.hash(updateUserDto.password, 10);
		}

		// 소셜 로그인 사용자는 비밀번호 변경 불가
		if (updateUserDto.password && user.provider && user.provider !== 'LOCAL') {
			this.logger.warn(
				`사용자 수정 실패: 소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다. User: ${userId}`,
			);
			throw ApiExceptions.forbidden('소셜 로그인 사용자는 비밀번호를 변경할 수 없습니다.');
		}

		// 정보 업데이트
		Object.assign(user, {
			...(updateUserDto.name && { name: updateUserDto.name }),
			...(updateUserDto.email && { email: updateUserDto.email }),
			...(updateUserDto.password && { password: updateUserDto.password }),
			...(updateUserDto.role && currentUser.role === Role.ADMIN && { role: updateUserDto.role }),
		});

		const updatedUser = await this.userRepository.save(user);
		this.logger.log(`사용자 정보 수정 완료: ${userId}`);

		return updatedUser;
	}

	/**
	 * refreshToken으로 accessToken 갱신
	 */
	async refreshToken(refreshToken: string): Promise<{ accessToken: string; refreshToken: string; user: any }> {
		try {
			// refreshToken 검증
			const payload = this.jwtService.verify(refreshToken);

			// DB에서 사용자와 refreshToken 확인
			const user = await this.userRepository.findOne({
				where: { id: payload.sub },
			});

			if (!user || !user.refreshToken || user.refreshToken !== refreshToken) {
				this.logger.warn(`토큰 갱신 실패: 유효하지 않은 refreshToken`);
				throw ApiExceptions.unauthorized('유효하지 않은 refreshToken입니다.');
			}

			// 새로운 토큰 생성
			return await this.generateToken(user);
		} catch (error) {
			this.logger.error(`토큰 갱신 실패: ${error.message}`);
			throw ApiExceptions.unauthorized('유효하지 않은 refreshToken입니다.');
		}
	}

	/**
	 * 로그아웃 시 refreshToken 삭제
	 */
	async logout(userId: string): Promise<void> {
		const user = await this.userRepository.findOne({
			where: { id: userId },
		});

		if (user) {
			user.refreshToken = null;
			await this.userRepository.save(user);
			this.logger.log(`로그아웃: 사용자(${userId})의 refreshToken 삭제됨`);
		}
	}

	/**
	 * 소셜 로그인 사용자 검증 및 생성
	 * 카카오 로그인 등에서 사용
	 */
	async validateOrCreateSocialUser(socialUser: {
		provider: string;
		providerId: string;
		email?: string;
		name: string;
	}): Promise<{ accessToken: string; refreshToken: string; user: any }> {
		// 기존 소셜 로그인 사용자 찾기
		let user = await this.userRepository.findOne({
			where: {
				provider: socialUser.provider,
				providerId: socialUser.providerId,
			},
		});

		// 없으면 새로 생성
		if (!user) {
			// 이메일이 있고, 같은 이메일의 일반 계정이 있는지 확인
			if (socialUser.email) {
				const existingUser = await this.userRepository.findOne({
					where: { email: socialUser.email },
				});

				if (existingUser) {
					// 기존 계정에 소셜 로그인 정보 연결
					existingUser.provider = socialUser.provider;
					existingUser.providerId = socialUser.providerId;
					user = await this.userRepository.save(existingUser);
					this.logger.log(
						`소셜 로그인 계정 연결: ${socialUser.provider} 계정이 기존 이메일(${socialUser.email})과 연결됨`,
					);
				}
			}

			// 여전히 없으면 새로 생성
			if (!user) {
				// 이메일이 없으면 자동 생성
				const generatedEmail = socialUser.email || `${socialUser.provider}_${socialUser.providerId}@social.local`;
				
				if (!socialUser.email) {
					this.logger.warn(
						`소셜 로그인 이메일 없음: ${socialUser.provider} 사용자(${socialUser.providerId})의 이메일 정보가 없어 자동 생성: ${generatedEmail}`,
					);
				}

				user = this.userRepository.create({
					email: generatedEmail,
					password: null, // 소셜 로그인은 비밀번호 없음
					name: socialUser.name,
					provider: socialUser.provider,
					providerId: socialUser.providerId,
					role: Role.MEMBER, // 기본 역할
				});

				user = await this.userRepository.save(user);
				this.logger.log(
					`소셜 로그인 사용자 생성: ${socialUser.provider} 사용자 생성 완료 (Email: ${generatedEmail}, Name: ${socialUser.name})`,
				);
			}
		}

		// 토큰 생성 (accessToken + refreshToken)
		return await this.generateToken(user);
	}

	/**
	 * 토큰 생성 로직 (일반 로그인과 소셜 로그인 공통 사용)
	 * accessToken: 15분, refreshToken: 7일
	 */
	private async generateToken(user: User): Promise<{ accessToken: string; refreshToken: string; user: any }> {
		const payload = {
			sub: user.id,
			email: user.email,
			role: user.role,
		};

		// accessToken 생성 (15분)
		const accessTokenExpiresIn = this.configService.get<string>('JWT_EXPIRES_IN') || '15m';
		// @ts-ignore - JWT expiresIn accepts string values like '15m'
		const accessToken = this.jwtService.sign(payload, {
			expiresIn: accessTokenExpiresIn,
		});

		// refreshToken 생성 (7일)
		const refreshTokenExpiresIn = this.configService.get<string>('JWT_REFRESH_EXPIRES_IN') || '7d';
		// @ts-ignore - JWT expiresIn accepts string values like '7d'
		const refreshToken = this.jwtService.sign(payload, {
			expiresIn: refreshTokenExpiresIn,
		});

		// refreshToken을 DB에 저장 (기존 refreshToken이 있으면 무효화됨)
		if (user.refreshToken) {
			this.logger.log(
				`기존 refreshToken 무효화: 사용자(${user.id})의 이전 세션이 종료됨 (새 로그인 또는 토큰 갱신)`,
			);
		}
		user.refreshToken = refreshToken;
		await this.userRepository.save(user);

		return {
			accessToken,
			refreshToken,
			user: {
				id: user.id,
				email: user.email,
				name: user.name,
				role: user.role,
				provider: user.provider || 'LOCAL',
			},
		};
	}

	/**
	 * 테스트 계정 생성 (개발 환경 전용)
	 * email: test, password: test, 권한: ADMIN (모든 권한)
	 */
	async createTestAccount(): Promise<{ accessToken: string; refreshToken: string; user: any }> {
		const testEmail = 'test';
		const testPassword = 'test';

		// 기존 계정 확인
		const existingUser = await this.userRepository.findOne({
			where: { email: testEmail },
		});

		if (existingUser) {
			// 이미 존재하면 로그인 처리
			this.logger.warn(`테스트 계정이 이미 존재합니다. 로그인 처리: ${testEmail}`);
			return await this.generateToken(existingUser);
		}

		// 새 테스트 계정 생성
		const hashedPassword = await bcrypt.hash(testPassword, 10);

		const user = this.userRepository.create({
			email: testEmail,
			password: hashedPassword,
			name: '테스트 사용자 (ADMIN)',
			role: Role.ADMIN, // 모든 권한 부여
			provider: 'LOCAL',
			providerId: null,
		});

		const savedUser = await this.userRepository.save(user);
		this.logger.log(`테스트 계정 생성 완료: ${testEmail} (권한: ADMIN)`);

		return await this.generateToken(savedUser);
	}
}

