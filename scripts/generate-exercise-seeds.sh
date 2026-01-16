#!/bin/bash
# free-exercise-db 데이터를 필터링하여 여러 시드 파일 생성
# 사용 방법: bash scripts/generate-exercise-seeds.sh

echo "🚀 free-exercise-db 운동 시드 파일 생성 시작..."
echo ""

# 입력 파일 경로 (프로젝트 루트 기준)
INPUT_FILE="../free-exercise-db/dist/exercises.json"

# 입력 파일 확인
if [ ! -f "$INPUT_FILE" ]; then
    echo "❌ 입력 파일을 찾을 수 없습니다: $INPUT_FILE"
    echo ""
    echo "해결 방법:"
    echo "  1. free-exercise-db 저장소 클론:"
    echo "     git clone https://github.com/yuhonas/free-exercise-db.git ../free-exercise-db"
    echo "  2. 또는 exercises.json 직접 다운로드"
    exit 1
fi

# 출력 디렉토리 생성
OUTPUT_DIR="database/seeds"
mkdir -p "$OUTPUT_DIR"

echo "📦 기본 운동 생성 중 (빅3 + 주요 운동)..."
ts-node scripts/convert-free-exercise-db.ts \
  --input="$INPUT_FILE" \
  --category=UPPER,LOWER,FULL_BODY \
  --equipment=barbell \
  --output="$OUTPUT_DIR/basic_exercises.sql"

echo ""
echo "💪 상체 운동 생성 중..."
ts-node scripts/convert-free-exercise-db.ts \
  --input="$INPUT_FILE" \
  --category=UPPER \
  --output="$OUTPUT_DIR/upper_body_exercises.sql"

echo ""
echo "🦵 하체 운동 생성 중..."
ts-node scripts/convert-free-exercise-db.ts \
  --input="$INPUT_FILE" \
  --category=LOWER \
  --output="$OUTPUT_DIR/lower_body_exercises.sql"

echo ""
echo "🏋️ 바벨 운동 생성 중..."
ts-node scripts/convert-free-exercise-db.ts \
  --input="$INPUT_FILE" \
  --equipment=barbell \
  --output="$OUTPUT_DIR/barbell_exercises.sql"

echo ""
echo "🏋️ 덤벨 운동 생성 중..."
ts-node scripts/convert-free-exercise-db.ts \
  --input="$INPUT_FILE" \
  --equipment=dumbbell \
  --output="$OUTPUT_DIR/dumbbell_exercises.sql"

echo ""
echo "🧘 맨몸 운동 생성 중..."
ts-node scripts/convert-free-exercise-db.ts \
  --input="$INPUT_FILE" \
  --equipment=bodyweight \
  --output="$OUTPUT_DIR/bodyweight_exercises.sql"

echo ""
echo "🎯 초보자용 운동 생성 중..."
ts-node scripts/convert-free-exercise-db.ts \
  --input="$INPUT_FILE" \
  --level=beginner \
  --output="$OUTPUT_DIR/beginner_exercises.sql"

echo ""
echo "✅ 모든 운동 시드 파일 생성 완료!"
echo ""
echo "생성된 파일:"
ls -lh "$OUTPUT_DIR"/*.sql | awk '{print "  - " $9 " (" $5 ")"}'
echo ""
echo "다음 단계:"
echo "  1. 생성된 SQL 파일 확인"
echo "  2. 필요한 파일만 선택하여 데이터베이스에 삽입"
echo "  3. 예: psql -U username -d database_name -f database/seeds/basic_exercises.sql"
