import { Module } from '@nestjs/common';
import { JwtModule, JwtModuleOptions } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { JwtStrategy } from './strategies/jwt.strategy';
import { KakaoStrategy } from './strategies/kakao.strategy';
import { User } from '../../entities/user.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([User]),
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService): JwtModuleOptions => {
        // accessToken 만료 시간: 15분 (기본값)
        // 실제 토큰 생성 시에는 AuthService에서 개별적으로 설정
        const expiresIn = configService.get<string>('JWT_EXPIRES_IN') || '15m';
        return {
          secret: configService.get<string>('JWT_SECRET') || 'default-secret',
          signOptions: {
            // @ts-ignore - JWT expiresIn accepts string values like '15m'
            expiresIn: expiresIn,
          },
        };
      },
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy, KakaoStrategy],
  exports: [AuthService],
})
export class AuthModule {}

