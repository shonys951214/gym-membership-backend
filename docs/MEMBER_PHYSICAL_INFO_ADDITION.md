# 회원 신체 정보 필드 추가

## 개요

회원 등록 시 키, 몸무게, 성별을 입력받을 수 있도록 DB 스키마와 API를 확장했습니다.

## 추가된 필드

### 1. 키 (height)

- **타입**: `REAL` (float)
- **단위**: cm
- **제약조건**: nullable, 50cm ~ 250cm
- **컬럼명**: `height`

### 2. 몸무게 (weight)

- **타입**: `REAL` (float)
- **단위**: kg
- **제약조건**: nullable, 20kg ~ 300kg
- **컬럼명**: `weight`

### 3. 성별 (gender)

- **타입**: `ENUM` (gender_enum)
- **값**: `MALE`, `FEMALE`
- **제약조건**: nullable
- **컬럼명**: `gender`

## 변경 사항

### 백엔드

#### 1. Enum 추가

**파일**: `src/common/enums/gender.enum.ts`

```typescript
export enum Gender {
	MALE = "MALE",
	FEMALE = "FEMALE",
}
```

#### 2. Member 엔티티 수정

**파일**: `src/entities/member.entity.ts`

```typescript
// 신체 정보
@Column({ type: 'float', name: 'height', nullable: true, comment: '키 (cm)' })
height?: number;

@Column({ type: 'float', name: 'weight', nullable: true, comment: '몸무게 (kg)' })
weight?: number;

@Column({
  type: 'enum',
  enum: Gender,
  name: 'gender',
  nullable: true,
  comment: '성별',
})
gender?: Gender;
```

#### 3. CreateMemberDto 수정

**파일**: `src/modules/members/dto/create-member.dto.ts`

- `height` 필드 추가 (optional, 50-250 범위 검증)
- `weight` 필드 추가 (optional, 20-300 범위 검증)
- `gender` 필드 추가 (optional, Gender enum 검증)

#### 4. UpdateMemberDto 수정

**파일**: `src/modules/members/dto/update-member.dto.ts`

- `height`, `weight`, `gender` 필드 추가 (모두 optional)

## 데이터베이스 마이그레이션

**파일**: `database/migrations/add_member_physical_info.sql`

마이그레이션 실행 방법:

```sql
-- PostgreSQL에서 실행
\i database/migrations/add_member_physical_info.sql
```

또는 psql에서:

```bash
psql -U your_username -d your_database -f database/migrations/add_member_physical_info.sql
```

## API 변경 사항

### POST /api/members (회원 등록)

**요청 예시**:

```json
{
	"name": "홍길동",
	"phone": "010-1234-5678",
	"email": "hong@example.com",
	"joinDate": "2024-01-01",
	"height": 175.5,
	"weight": 70.5,
	"gender": "MALE"
}
```

**응답 예시**:

```json
{
  "id": "uuid",
  "name": "홍길동",
  "phone": "010-1234-5678",
  "email": "hong@example.com",
  "joinDate": "2024-01-01",
  "height": 175.5,
  "weight": 70.5,
  "gender": "MALE",
  "status": "ACTIVE",
  ...
}
```

### PUT /api/members/:id (회원 정보 수정)

**요청 예시**:

```json
{
	"height": 176.0,
	"weight": 72.0,
	"gender": "MALE"
}
```

## 유효성 검증

### 키 (height)

- **타입**: 숫자
- **범위**: 50cm ~ 250cm
- **에러 메시지**: "키는 50cm 이상이어야 합니다." / "키는 250cm 이하여야 합니다."

### 몸무게 (weight)

- **타입**: 숫자
- **범위**: 20kg ~ 300kg
- **에러 메시지**: "몸무게는 20kg 이상이어야 합니다." / "몸무게는 300kg 이하여야 합니다."

### 성별 (gender)

- **타입**: Enum
- **값**: `MALE` 또는 `FEMALE`
- **에러 메시지**: "올바른 성별이 아닙니다. (MALE 또는 FEMALE)"

## 프론트엔드 수정 필요 사항

### 1. 회원 등록 폼 수정

다음 필드 추가:

- 키 입력 필드 (cm 단위)
- 몸무게 입력 필드 (kg 단위)
- 성별 선택 필드 (MALE/FEMALE 라디오 버튼 또는 드롭다운)

### 2. 타입 정의 수정

```typescript
export interface CreateMemberRequest {
	// ... 기존 필드
	height?: number; // 키 (cm)
	weight?: number; // 몸무게 (kg)
	gender?: "MALE" | "FEMALE"; // 성별
}
```

### 3. 회원 상세 페이지 수정

회원 프로필에 키, 몸무게, 성별 정보 표시 추가

## 주의사항

1. **기존 데이터 호환성**: 모든 필드가 `nullable`이므로 기존 회원 데이터에 영향을 주지 않습니다.
2. **선택적 필드**: 모든 필드가 optional이므로 회원 등록 시 입력하지 않아도 됩니다.
3. **데이터베이스 마이그레이션**: 프로덕션 환경에 배포하기 전에 마이그레이션을 실행해야 합니다.

## 테스트 방법

1. **회원 등록 테스트**:
    - 키, 몸무게, 성별을 포함하여 회원 등록
    - 필드 없이 회원 등록 (기존 동작 확인)

2. **유효성 검증 테스트**:
    - 키: 50cm 미만, 250cm 초과 값 입력 시 에러 확인
    - 몸무게: 20kg 미만, 300kg 초과 값 입력 시 에러 확인
    - 성별: 잘못된 값 입력 시 에러 확인

3. **회원 정보 수정 테스트**:
    - 키, 몸무게, 성별 수정 가능 여부 확인
