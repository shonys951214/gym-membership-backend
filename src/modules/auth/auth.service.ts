import {
	Injectable,
	UnauthorizedException,
	Logger,
} from "@nestjs/common";
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../../entities/user.entity';
import { Role } from '../../common/enums';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { ApiResponseHelper } from '../../common/utils/api-response';
import { ErrorCodes } from '../../common/utils/error-codes';

@Injectable()
export class AuthService {
	private readonly logger = new Logger(AuthService.name);

	constructor(
		@InjectRepository(User)
		private userRepository: Repository<User>,
		private jwtService: JwtService,
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

		if (await bcrypt.compare(password, user.password)) {
			return user;
		}

		return null;
	}

  async login(loginDto: LoginDto) {
    const user = await this.validateUser(loginDto.email, loginDto.password);

    if (!user) {
      throw new UnauthorizedException('이메일 또는 비밀번호가 올바르지 않습니다.');
    }

		return this.generateToken(user);
  }

  async register(registerDto: RegisterDto) {
    const existingUser = await this.userRepository.findOne({
      where: { email: registerDto.email },
    });

		if (existingUser) {
			this.logger.warn(
				`회원가입 실패: 이미 등록된 이메일입니다. Email: ${registerDto.email}`,
			);
			throw new UnauthorizedException("이미 등록된 이메일입니다.");
		}

    const hashedPassword = await bcrypt.hash(registerDto.password, 10);

		const user = this.userRepository.create({
			email: registerDto.email,
			password: hashedPassword,
			name: registerDto.name,
			role: registerDto.role || Role.MEMBER,
			provider: 'LOCAL', // 일반 회원가입은 LOCAL
			providerId: null,
		});

    const savedUser = await this.userRepository.save(user);

    return {
      id: savedUser.id,
      email: savedUser.email,
      name: savedUser.name,
      role: savedUser.role,
    };
  }

	async findById(id: string): Promise<User | null> {
		return this.userRepository.findOne({
			where: { id },
		});
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
	}): Promise<{ accessToken: string; user: any }> {
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
				}
			}

			// 여전히 없으면 새로 생성
			if (!user) {
				user = this.userRepository.create({
					email: socialUser.email || `${socialUser.provider}_${socialUser.providerId}@social.local`,
					password: null, // 소셜 로그인은 비밀번호 없음
					name: socialUser.name,
					provider: socialUser.provider,
					providerId: socialUser.providerId,
					role: Role.MEMBER, // 기본 역할
				});

				user = await this.userRepository.save(user);
			}
		}

		// JWT 토큰 생성
		const payload = {
			sub: user.id,
			email: user.email,
			role: user.role,
		};

		return {
			accessToken: this.jwtService.sign(payload),
			user: {
				id: user.id,
				email: user.email,
				name: user.name,
				role: user.role,
				provider: user.provider,
			},
		};
	}

	/**
	 * 토큰 생성 로직 (일반 로그인과 소셜 로그인 공통 사용)
	 */
	private generateToken(user: User): { accessToken: string; user: any } {
		const payload = {
			sub: user.id,
			email: user.email,
			role: user.role,
		};

		return {
			accessToken: this.jwtService.sign(payload),
			user: {
				id: user.id,
				email: user.email,
				name: user.name,
				role: user.role,
				provider: user.provider || 'LOCAL',
			},
		};
	}
}

