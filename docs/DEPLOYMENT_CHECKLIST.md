# 배포 전 최종 체크리스트

## 📋 배포 전 확인사항

### 1. 코드 상태 확인

- [x] 모든 코드 빌드 성공
- [x] TypeScript 오류 없음
- [x] CORS 설정 완료 (프론트엔드 주소 포함)
- [x] 환경 변수 설정 확인

### 2. 데이터베이스 마이그레이션

#### 실행 순서

1. **기존 테이블 확인**
   ```sql
   SELECT table_name 
   FROM information_schema.tables 
   WHERE table_schema = 'public' 
   ORDER BY table_name;
   ```

2. **새 필드 추가 (기존 테이블이 있는 경우)**
   ```sql
   -- 운동 기록 테이블 필드 추가
   \i database/add_workout_records_fields.sql
   
   -- 운동 루틴 테이블 필드 추가
   \i database/add_workout_routines_fields.sql
   ```

3. **새 테이블 생성 (테이블이 없는 경우)**
   ```sql
   -- 운동 기록 테이블
   \i database/create_workout_records_table.sql
   
   -- PT 세션 테이블
   \i database/create_pt_sessions_table.sql
   
   -- 운동 루틴 테이블
   \i database/create_workout_routines_table.sql
   ```

4. **테이블 생성 확인**
   ```sql
   -- 모든 테이블 확인
   SELECT table_name 
   FROM information_schema.tables 
   WHERE table_schema = 'public' 
   ORDER BY table_name;
   
   -- workout_records 테이블 구조 확인
   \d workout_records
   
   -- pt_sessions 테이블 구조 확인
   \d pt_sessions
   
   -- workout_routines 테이블 구조 확인
   \d workout_routines
   ```

### 3. Render 환경 변수 설정

#### 필수 환경 변수

```env
NODE_ENV=production
DATABASE_URL=postgresql://...
JWT_SECRET=your-secret-key
JWT_REFRESH_SECRET=your-refresh-secret-key
```

#### 선택적 환경 변수

```env
# 프론트엔드 URL (이미 기본값에 포함됨)
FRONTEND_URL=https://gym-admin-mu.vercel.app

# TypeORM 설정
DB_SYNCHRONIZE=false
DB_LOGGING=false

# 기타
REQUEST_TIMEOUT=30000
```

### 4. 배포 후 테스트

#### API 엔드포인트 테스트

1. **헬스 체크**
   ```bash
   curl https://your-backend.onrender.com/
   ```

2. **로그인 테스트**
   ```bash
   curl -X POST https://your-backend.onrender.com/api/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email":"test","password":"test"}'
   ```

3. **Swagger 확인**
   ```
   https://your-backend.onrender.com/api
   ```

#### 프론트엔드 연결 테스트

1. 프론트엔드에서 로그인 시도
2. CORS 오류 확인
3. API 응답 확인

---

## 🚀 배포 단계

### Step 1: 코드 푸시

```bash
git add .
git commit -m "feat: 프론트엔드 요청사항 반영 및 CORS 설정"
git push origin main
```

### Step 2: Render 배포 확인

1. Render 대시보드에서 배포 상태 확인
2. 빌드 로그 확인
3. 실행 로그 확인

### Step 3: 데이터베이스 마이그레이션

Render Shell에서 실행:

```bash
# Render 대시보드 → Shell 탭
psql $DATABASE_URL -f database/add_workout_records_fields.sql
psql $DATABASE_URL -f database/add_workout_routines_fields.sql
```

또는 로컬에서 실행:

```bash
psql $DATABASE_URL -f database/add_workout_records_fields.sql
psql $DATABASE_URL -f database/add_workout_routines_fields.sql
```

### Step 4: API 테스트

Swagger UI에서 테스트:
- 목표 관리 API
- 운동 기록 API
- PT 세션 API
- 추천 운동 루틴 API
- 대시보드 API

---

## ✅ 완료 체크리스트

### 기능 구현

- [x] 목표 관리 API (GET, POST, PUT, DELETE)
- [x] 운동 기록 API (CRUD + 볼륨 분석 + 캘린더)
- [x] PT 세션 API (CRUD + 세션 번호 자동 계산)
- [x] 추천 운동 루틴 API (공통 + 회원별)
- [x] 대시보드 통합 API

### 데이터베이스

- [ ] SQL 마이그레이션 실행 완료
- [ ] 테이블 생성 확인
- [ ] 필드 추가 확인

### 배포

- [ ] Render 환경 변수 설정
- [ ] 코드 푸시 완료
- [ ] 배포 성공 확인
- [ ] API 테스트 완료
- [ ] 프론트엔드 연결 확인

---

## 🐛 문제 해결

### SQL 마이그레이션 오류

**문제**: 제약조건 중복 오류
**해결**: `database/create_workout_records_table.sql` 파일이 이미 수정됨 (DO 블록 사용)

### CORS 오류

**문제**: 프론트엔드에서 CORS 오류 발생
**해결**: `src/config/cors.config.ts`에 프론트엔드 주소 자동 포함됨

### 빌드 실패

**문제**: TypeScript 컴파일 오류
**해결**: 로컬에서 `npm run build` 실행하여 확인

---

**작성일**: 2026-01-07

