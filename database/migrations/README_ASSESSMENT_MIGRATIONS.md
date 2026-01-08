# 평가 시스템 DB 마이그레이션 가이드

## 📋 개요

이 디렉토리에는 `ASSESSMENT_DB_AND_PLAN.md` 문서를 기반으로 한 평가 시스템 DB 마이그레이션 파일들이 포함되어 있습니다.

## 📁 파일 목록

### 1. `add_assessment_items_details.sql`

- **목적**: `assessment_items` 테이블에 `details` JSONB 필드 추가
- **변경 사항**:
    - `details` JSONB 필드 추가 (nullable)
    - GIN 인덱스 추가 (JSONB 검색 최적화)
- **영향**: 기존 데이터와 호환 (기본값 NULL)

### 2. `make_assessment_items_fields_nullable.sql`

- **목적**: `assessment_items` 테이블의 `value`, `unit`, `score` 필드를 nullable로 변경
- **변경 사항**:
    - `value` 필드 nullable
    - `unit` 필드 nullable
    - `score` 필드 nullable
- **영향**: 등급 기반 평가의 경우 수치값이 없을 수 있으므로 nullable 처리

### 3. `create_body_composition_standards.sql`

- **목적**: 체성분 평가 기준표 테이블 생성
- **생성 테이블**:
    - `body_composition_standards`: 연령대별, 성별별 체성분 평가 기준
- **초기 데이터**: 남성/여성 각 4개 연령대 기준 삽입

### 4. `create_assessment_grade_constants.sql`

- **목적**: 평가 등급 상수 테이블 생성
- **생성 테이블**:
    - `assessment_grade_constants`: 등급 체계 정의 (안정적, 무난함, 제한 있음, 준비 필요)
- **초기 데이터**: 4개 등급 삽입

### 5. `create_assessment_category_scores.sql`

- **목적**: 카테고리별 등급-점수 매핑 테이블 생성
- **생성 테이블**:
    - `assessment_category_scores`: 각 카테고리별 입력 등급에 대한 내부 점수 정의
- **초기 데이터**: 하체 근력, 심폐 지구력, 근지구력, 안정성 등급-점수 매핑 삽입

### 6. `create_flexibility_weights.sql`

- **목적**: 유연성 항목별 가중치 테이블 생성
- **생성 테이블**:
    - `flexibility_item_weights`: 유연성 항목별 가중치
    - `flexibility_grade_thresholds`: 유연성 등급 판정 기준
- **초기 데이터**: 어깨(1.3), 고관절(1.2), 좌전굴(1.0), 햄스트링(0.8) 가중치 및 등급 판정 기준 삽입

### 7. `run_all_assessment_migrations.sql`

- **목적**: 모든 마이그레이션을 순서대로 실행하는 통합 스크립트 (psql 전용)
- **사용법**: psql에서 `\i` 명령어로 실행

### 8. `run_all_assessment_migrations_dbeaver.sql` ⭐

- **목적**: DBeaver에서 바로 실행 가능한 통합 스크립트
- **사용법**: DBeaver에서 파일 열고 전체 실행 (Ctrl+Alt+X 또는 F5)
- **특징**:
    - 모든 SQL이 하나의 파일에 포함됨
    - `ON CONFLICT DO NOTHING`으로 중복 실행 방지
    - DBeaver에서 바로 실행 가능

## 🚀 실행 방법

### 방법 1: DBeaver에서 통합 스크립트 실행 (권장) ⭐

1. DBeaver에서 데이터베이스 연결
2. `database/migrations/run_all_assessment_migrations_dbeaver.sql` 파일 열기
3. 전체 선택 (Ctrl+A) 후 실행 (Ctrl+Alt+X 또는 F5)
4. 모든 마이그레이션이 순서대로 실행됩니다

**장점**:

- DBeaver에서 바로 실행 가능
- 오류 발생 시 해당 부분만 확인 가능
- 재실행 시 `ON CONFLICT DO NOTHING`으로 중복 방지

### 방법 2: 개별 실행

```bash
# PostgreSQL에 연결
psql -U your_username -d your_database

# 각 마이그레이션 파일을 순서대로 실행
\i database/migrations/add_assessment_items_details.sql
\i database/migrations/make_assessment_items_fields_nullable.sql
\i database/migrations/create_body_composition_standards.sql
\i database/migrations/create_assessment_grade_constants.sql
\i database/migrations/create_assessment_category_scores.sql
\i database/migrations/create_flexibility_weights.sql
```

### 방법 3: psql에서 통합 스크립트 실행

```bash
# PostgreSQL에 연결
psql -U your_username -d your_database

# 통합 스크립트 실행 (psql 전용)
\i database/migrations/run_all_assessment_migrations.sql
```

## ⚠️ 주의사항

1. **실행 순서**: 마이그레이션은 반드시 순서대로 실행해야 합니다.
2. **백업**: 마이그레이션 실행 전 데이터베이스 백업을 권장합니다.
3. **테스트 환경**: 먼저 테스트 환경에서 실행하여 검증하세요.
4. **롤백**: 각 마이그레이션 파일에는 롤백 스크립트가 포함되어 있지 않으므로, 필요시 수동으로 롤백해야 합니다.

## 📊 생성된 테이블 구조

### `body_composition_standards`

- 연령대별, 성별별 체지방률 적정 범위 및 골격근량 최소 기준

### `assessment_grade_constants`

- 평가 등급 체계 정의 (안정적, 무난함, 제한 있음, 준비 필요)

### `assessment_category_scores`

- 카테고리별 입력 등급에 대한 내부 점수 매핑

### `flexibility_item_weights`

- 유연성 항목별 가중치

### `flexibility_grade_thresholds`

- 유연성 등급 판정 기준 (가중치 합 범위)

## 🔗 관련 문서

- [ASSESSMENT_DB_AND_PLAN.md](../../docs/ASSESSMENT_DB_AND_PLAN.md) - 평가 시스템 상세 계획
- [2차개발방향.md](../../docs/2차개발방향.md) - 개발 방향

## 📝 변경 이력

- 2024-01-XX: 초기 마이그레이션 파일 생성
