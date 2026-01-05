# 카카오 로그인 구현 준비 가이드

## 📋 개요

카카오 로그인 기능을 추가하기 전에 필요한 대비 작업을 완료했습니다.
이 문서는 카카오 로그인 구현 시 참고할 수 있는 가이드입니다.

## ✅ 완료된 대비 작업

### 1. User 엔티티 확장
- `provider`: 로그인 제공자 (LOCAL, KAKAO 등)
- `providerId`: 소셜 로그인 제공자의 사용자 ID
- `password`: nullable로 변경 (소셜 로그인 사용자는 비밀번호 없음)

### 2. AuthService 확장
- `validateOrCreateSocialUser()`: 소셜 로그인 사용자 검증/생성
- `generateToken()`: 토큰 생성 로직 분리 (일반/소셜 로그인 공통 사용)

### 3. AuthController 확장
- `/api/auth/kakao` 엔드포인트 준비 (구현 대기 중)

### 4. 환경 변수 준비
- `KAKAO_CLIENT_ID`: 카카오 앱 REST API 키
- `KAKAO_CLIENT_SECRET`: 카카오 앱 Client Secret
- `KAKAO_REDIRECT_URI`: 카카오 로그인 리다이렉트 URI

### 5. 폴더 구조 준비
- `src/modules/auth/strategies/kakao.strategy.ts` (구현 대기 중)

## 🔧 카카오 로그인 구현 시 필요한 작업

### 1. 패키지 설치

```bash
npm install passport-kakao
npm install --save-dev @types/passport-kakao
```

### 2. 카카오 전략 구현

`src/modules/auth/strategies/kakao.strategy.ts` 파일을 생성하고 다음 내용을 구현:

```typescript
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-kakao';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class KakaoStrategy extends PassportStrategy(Strategy, 'kakao') {
  constructor(
    private configService: ConfigService,
    private authService: AuthService,
  ) {
    super({
      clientID: configService.get<string>('KAKAO_CLIENT_ID'),
      clientSecret: configService.get<string>('KAKAO_CLIENT_SECRET'),
      callbackURL: configService.get<string>('KAKAO_REDIRECT_URI'),
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any) {
    const { id, username, _json } = profile;
    
    // 카카오 사용자 정보 추출
    const kakaoUser = {
      provider: 'KAKAO',
      providerId: id.toString(),
      email: _json.kakao_account?.email,
      name: username || _json.kakao_account?.profile?.nickname,
    };

    // 사용자 검증/생성 및 토큰 반환
    return await this.authService.validateOrCreateSocialUser(kakaoUser);
  }
}
```

### 3. AuthModule에 KakaoStrategy 추가

`src/modules/auth/auth.module.ts`에 KakaoStrategy를 providers에 추가:

```typescript
providers: [AuthService, JwtStrategy, KakaoStrategy],
```

### 4. AuthController에 카카오 로그인 엔드포인트 구현

```typescript
@Get('kakao')
@Public()
@UseGuards(AuthGuard('kakao'))
async kakaoLogin() {
  // Passport가 자동으로 처리
}

@Get('kakao/callback')
@Public()
@UseGuards(AuthGuard('kakao'))
async kakaoCallback(@Request() req) {
  // req.user에 validate 메서드에서 반환한 값이 들어있음
  return ApiResponseHelper.success(req.user, '카카오 로그인 성공');
}
```

### 5. 데이터베이스 마이그레이션

User 테이블에 새로운 필드가 추가되었으므로 마이그레이션을 실행:

```bash
npm run migration:generate -- -n AddSocialLoginFields
npm run migration:run
```

또는 `synchronize: true`로 설정된 경우 자동으로 반영됩니다.

## 🔐 보안 고려사항

1. **환경 변수 보안**: `.env` 파일은 절대 커밋하지 않기
2. **토큰 검증**: 카카오에서 받은 accessToken을 서버에서 검증
3. **이메일 중복 처리**: 같은 이메일로 일반 로그인과 카카오 로그인을 할 수 있도록 처리
4. **계정 연결**: 기존 계정과 카카오 계정 연결 기능 고려

## 📝 API 엔드포인트

### 카카오 로그인 시작
```
GET /api/auth/kakao
```
- 카카오 로그인 페이지로 리다이렉트

### 카카오 로그인 콜백
```
GET /api/auth/kakao/callback
```
- 카카오 인증 후 콜백 처리
- JWT 토큰 반환

### 응답 형식
```json
{
  "success": true,
  "message": "카카오 로그인 성공",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "홍길동",
      "role": "MEMBER",
      "provider": "KAKAO"
    }
  }
}
```

## 🚀 테스트 방법

1. 카카오 개발자 콘솔에서 앱 등록 및 리다이렉트 URI 설정
2. 환경 변수 설정 (`.env` 파일)
3. 서버 실행
4. 프론트엔드에서 `/api/auth/kakao`로 리다이렉트
5. 카카오 로그인 후 콜백 처리 확인

## 📚 참고 자료

- [카카오 로그인 REST API](https://developers.kakao.com/docs/latest/ko/kakaologin/rest-api)
- [Passport Kakao Strategy](https://github.com/cfsghost/passport-kakao)

