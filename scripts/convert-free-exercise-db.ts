#!/usr/bin/env ts-node
/**
 * free-exercise-db JSON 데이터를 현재 프로젝트 exercises 테이블 구조로 변환하는 스크립트
 * 
 * 사용 방법:
 * 1. free-exercise-db 저장소 클론 또는 exercises.json 다운로드
 * 2. npm install -g ts-node typescript
 * 3. ts-node scripts/convert-free-exercise-db.ts [옵션]
 * 
 * 옵션:
 *   --input <파일>          입력 JSON 파일 경로
 *   --output <파일>         출력 SQL 파일 경로
 *   --category <카테고리>    필터: UPPER, LOWER, FULL_BODY (쉼표로 구분)
 *   --equipment <장비>      필터: barbell, dumbbell, bodyweight 등 (쉼표로 구분)
 *   --level <레벨>          필터: beginner, intermediate, expert (쉼표로 구분)
 *   --body-part <부위>      필터: 가슴, 등, 어깨, 팔, 하체 (쉼표로 구분)
 *   --include-images       이미지 URL 포함 (선택적)
 *   --min-muscles <개수>    최소 primaryMuscles 개수 (기본: 1)
 *   --help                  도움말 표시
 * 
 * 예시:
 *   # 전체 운동 변환
 *   ts-node scripts/convert-free-exercise-db.ts
 * 
 *   # 상체 운동만 변환
 *   ts-node scripts/convert-free-exercise-db.ts --category UPPER
 * 
 *   # 바벨과 덤벨 운동만 변환
 *   ts-node scripts/convert-free-exercise-db.ts --equipment barbell,dumbbell
 * 
 *   # 초보자용 상체 운동만 변환
 *   ts-node scripts/convert-free-exercise-db.ts --category UPPER --level beginner
 */

import * as fs from 'fs';
import * as path from 'path';

// free-exercise-db 데이터 타입
interface FreeExerciseDB {
	id: string;
	name: string;
	force?: string | null;
	level?: string | null;
	mechanic?: string | null;
	equipment?: string | null;
	primaryMuscles?: string[];
	secondaryMuscles?: string[];
	instructions?: string[];
	category?: string;
	images?: string[];
}

// 필터 옵션
interface FilterOptions {
	categories?: string[];
	equipment?: string[];
	levels?: string[];
	bodyParts?: string[];
	minMuscles?: number;
	includeImages?: boolean;
}

// 근육 → 부위 매핑
const muscleToBodyPart: Record<string, string> = {
	// 상체
	pectorals: '가슴',
	'upper chest': '가슴',
	'lower chest': '가슴',
	lats: '등',
	'middle back': '등',
	'lower back': '등',
	traps: '등',
	deltoids: '어깨',
	'anterior deltoids': '어깨',
	'posterior deltoids': '어깨',
	'lateral deltoids': '어깨',
	biceps: '팔',
	triceps: '팔',
	forearms: '팔',
	
	// 하체
	quadriceps: '하체',
	hamstrings: '하체',
	glutes: '하체',
	calves: '하체',
	'adductors': '하체',
	'abductors': '하체',
	
	// 기타
	abs: '복부',
	core: '복부',
	obliques: '복부',
};

// 영문명 → 한글명 매핑 (주요 운동)
const nameEnToName: Record<string, string> = {
	'Bench Press': '벤치프레스',
	'Squat': '스쿼트',
	'Deadlift': '데드리프트',
	'Overhead Press': '오버헤드 프레스',
	'Shoulder Press': '숄더 프레스',
	'Barbell Curl': '바벨 컬',
	'Dumbbell Curl': '덤벨 컬',
	'Lat Pulldown': '랫풀다운',
	'Bent Over Row': '벤트오버 로우',
	'Pull Up': '풀업',
	'Push Up': '푸시업',
	'Dip': '딥스',
	'Leg Press': '레그프레스',
	'Leg Curl': '레그 컬',
	'Leg Extension': '레그 익스텐션',
	'Calf Raise': '카프 레이즈',
	'Incline Bench Press': '인클라인 벤치프레스',
	'Decline Bench Press': '딥라인 벤치프레스',
	'Dumbbell Press': '덤벨 프레스',
	'Romanian Deadlift': '루마니안 데드리프트',
	'Sumo Deadlift': '스모 데드리프트',
	'Front Squat': '프론트 스쿼트',
	'Bulgarian Split Squat': '불가리안 스플릿 스쿼트',
	'Lunge': '런지',
	// ... 더 많은 매핑 추가 가능
};

/**
 * primaryMuscles 기반으로 카테고리 판단
 */
function mapCategory(primaryMuscles?: string[]): 'UPPER' | 'LOWER' | 'FULL_BODY' {
	if (!primaryMuscles || primaryMuscles.length === 0) {
		return 'FULL_BODY';
	}
	
	const upperBodyMuscles = [
		'pectorals', 'lats', 'middle back', 'lower back', 'traps',
		'deltoids', 'anterior deltoids', 'posterior deltoids', 'lateral deltoids',
		'biceps', 'triceps', 'forearms', 'upper chest', 'lower chest'
	];
	
	const lowerBodyMuscles = [
		'quadriceps', 'hamstrings', 'glutes', 'calves',
		'adductors', 'abductors'
	];
	
	const hasUpper = primaryMuscles.some(m => upperBodyMuscles.includes(m.toLowerCase()));
	const hasLower = primaryMuscles.some(m => lowerBodyMuscles.includes(m.toLowerCase()));
	
	if (hasUpper && hasLower) return 'FULL_BODY';
	if (hasUpper) return 'UPPER';
	if (hasLower) return 'LOWER';
	
	return 'FULL_BODY'; // 기본값
}

/**
 * primaryMuscles 기반으로 부위 판단
 */
function mapBodyPart(primaryMuscles?: string[]): string | null {
	if (!primaryMuscles || primaryMuscles.length === 0) {
		return null;
	}
	
	// 첫 번째 primaryMuscle을 기준으로 부위 결정
	const firstMuscle = primaryMuscles[0].toLowerCase();
	
	// 정확한 매칭
	if (muscleToBodyPart[firstMuscle]) {
		return muscleToBodyPart[firstMuscle];
	}
	
	// 부분 매칭
	for (const [muscle, bodyPart] of Object.entries(muscleToBodyPart)) {
		if (firstMuscle.includes(muscle) || muscle.includes(firstMuscle)) {
			return bodyPart;
		}
	}
	
	return null;
}

/**
 * 영문명을 한글명으로 변환 (없으면 null 반환)
 */
function mapName(nameEn: string): string | null {
	return nameEnToName[nameEn] || null;
}

/**
 * SQL 문자열 이스케이프
 */
function escapeSql(str: string): string {
	return str.replace(/'/g, "''");
}

/**
 * 필터링 함수
 */
function shouldInclude(exercise: FreeExerciseDB, filters: FilterOptions): boolean {
	// 카테고리 필터
	if (filters.categories && filters.categories.length > 0) {
		const category = mapCategory(exercise.primaryMuscles);
		if (!filters.categories.includes(category)) {
			return false;
		}
	}
	
	// 장비 필터
	if (filters.equipment && filters.equipment.length > 0) {
		if (!exercise.equipment || !filters.equipment.includes(exercise.equipment.toLowerCase())) {
			return false;
		}
	}
	
	// 레벨 필터
	if (filters.levels && filters.levels.length > 0) {
		if (!exercise.level || !filters.levels.includes(exercise.level.toLowerCase())) {
			return false;
		}
	}
	
	// 부위 필터
	if (filters.bodyParts && filters.bodyParts.length > 0) {
		const bodyPart = mapBodyPart(exercise.primaryMuscles);
		if (!bodyPart || !filters.bodyParts.includes(bodyPart)) {
			return false;
		}
	}
	
	// 최소 근육 개수 필터
	if (filters.minMuscles !== undefined) {
		const muscleCount = exercise.primaryMuscles?.length || 0;
		if (muscleCount < filters.minMuscles) {
			return false;
		}
	}
	
	return true;
}

/**
 * 메인 변환 함수
 */
function convertExercises(
	inputFile: string,
	outputFile: string,
	filters: FilterOptions = {}
) {
	console.log('📖 free-exercise-db 데이터 변환 시작...\n');
	
	// JSON 파일 읽기
	const jsonData = fs.readFileSync(inputFile, 'utf-8');
	const exercises: FreeExerciseDB[] = JSON.parse(jsonData);
	
	console.log(`✅ ${exercises.length}개 운동 데이터 로드 완료\n`);
	
	// 필터링
	const filteredExercises = exercises.filter(ex => shouldInclude(ex, filters));
	
	console.log(`🔍 필터 적용 후: ${filteredExercises.length}개 운동\n`);
	
	if (filters.categories) {
		console.log(`   카테고리: ${filters.categories.join(', ')}`);
	}
	if (filters.equipment) {
		console.log(`   장비: ${filters.equipment.join(', ')}`);
	}
	if (filters.levels) {
		console.log(`   레벨: ${filters.levels.join(', ')}`);
	}
	if (filters.bodyParts) {
		console.log(`   부위: ${filters.bodyParts.join(', ')}`);
	}
	if (filters.minMuscles) {
		console.log(`   최소 근육 개수: ${filters.minMuscles}`);
	}
	console.log('');
	
	// SQL 생성
	const sqlLines: string[] = [
		'-- ============================================',
		'-- free-exercise-db 데이터 변환 스크립트',
		'-- 자동 생성됨',
		`-- 생성일: ${new Date().toISOString()}`,
		'-- ============================================\n',
	];
	
	// 필터 정보 추가
	if (Object.keys(filters).length > 0) {
		sqlLines.push('-- 적용된 필터:');
		if (filters.categories) {
			sqlLines.push(`--   카테고리: ${filters.categories.join(', ')}`);
		}
		if (filters.equipment) {
			sqlLines.push(`--   장비: ${filters.equipment.join(', ')}`);
		}
		if (filters.levels) {
			sqlLines.push(`--   레벨: ${filters.levels.join(', ')}`);
		}
		if (filters.bodyParts) {
			sqlLines.push(`--   부위: ${filters.bodyParts.join(', ')}`);
		}
		if (filters.minMuscles) {
			sqlLines.push(`--   최소 근육 개수: ${filters.minMuscles}`);
		}
		sqlLines.push('');
	}
	
	sqlLines.push('-- 주의: 한글명이 없는 경우 NULL로 저장됩니다.');
	sqlLines.push('-- 필요시 수동으로 한글명을 추가하세요.');
	sqlLines.push('-- 한글명이 NULL인 운동 찾기: SELECT * FROM exercises WHERE name IS NULL;\n');
	sqlLines.push('-- ============================================');
	sqlLines.push('-- EXERCISES 테이블 데이터 삽입');
	sqlLines.push('-- ============================================\n');
	
	let successCount = 0;
	let skipCount = 0;
	
	for (const exercise of filteredExercises) {
		try {
			// 필수 필드 확인
			if (!exercise.name || !exercise.id) {
				console.warn(`⚠️  필수 필드 누락: ${exercise.id || 'unknown'}`);
				skipCount++;
				continue;
			}
			
			// 데이터 변환
			const nameEn = exercise.name;
			const name = mapName(nameEn);
			const category = mapCategory(exercise.primaryMuscles);
			const bodyPart = mapBodyPart(exercise.primaryMuscles);
			
			// SQL 생성 (한글명이 없으면 NULL)
			const nameValue = name ? `'${escapeSql(name)}'` : 'NULL';
			const sql = `INSERT INTO exercises (id, name, name_en, category, body_part, unit, is_active, created_at, updated_at)
VALUES 
    (gen_random_uuid(), ${nameValue}, '${escapeSql(nameEn)}', '${category}', ${bodyPart ? `'${escapeSql(bodyPart)}'` : 'NULL'}, 'kg', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (name_en) DO NOTHING;`;
			
			sqlLines.push(sql);
			sqlLines.push('');
			successCount++;
			
		} catch (error) {
			console.error(`❌ 변환 실패: ${exercise.id} - ${error}`);
			skipCount++;
		}
	}
	
	// 통계 추가
	sqlLines.push('-- ============================================');
	sqlLines.push('-- 완료 메시지');
	sqlLines.push('-- ============================================');
	sqlLines.push('SELECT \'free-exercise-db 데이터 삽입 완료!\' AS message;');
	sqlLines.push(`SELECT COUNT(*) as total_exercises FROM exercises;`);
	
	// 파일 저장
	fs.writeFileSync(outputFile, sqlLines.join('\n'), 'utf-8');
	
	console.log('\n✅ 변환 완료!');
	console.log(`   - 성공: ${successCount}개`);
	console.log(`   - 건너뜀: ${skipCount}개`);
	console.log(`   - 출력 파일: ${outputFile}\n`);
}

/**
 * 명령줄 인자 파싱
 */
function parseArgs(): { input: string; output: string; filters: FilterOptions } {
	const args = process.argv.slice(2);
	
	const input = args.find(arg => arg.startsWith('--input'))?.split('=')[1] ||
		path.join(__dirname, '../free-exercise-db/dist/exercises.json');
	
	const output = args.find(arg => arg.startsWith('--output'))?.split('=')[1] ||
		path.join(__dirname, '../database/seeds/free_exercise_db_seed.sql');
	
	const filters: FilterOptions = {};
	
	// 카테고리 필터
	const categoryArg = args.find(arg => arg.startsWith('--category'))?.split('=')[1];
	if (categoryArg) {
		filters.categories = categoryArg.split(',').map(c => c.trim().toUpperCase());
	}
	
	// 장비 필터
	const equipmentArg = args.find(arg => arg.startsWith('--equipment'))?.split('=')[1];
	if (equipmentArg) {
		filters.equipment = equipmentArg.split(',').map(e => e.trim().toLowerCase());
	}
	
	// 레벨 필터
	const levelArg = args.find(arg => arg.startsWith('--level'))?.split('=')[1];
	if (levelArg) {
		filters.levels = levelArg.split(',').map(l => l.trim().toLowerCase());
	}
	
	// 부위 필터
	const bodyPartArg = args.find(arg => arg.startsWith('--body-part'))?.split('=')[1];
	if (bodyPartArg) {
		filters.bodyParts = bodyPartArg.split(',').map(b => b.trim());
	}
	
	// 최소 근육 개수
	const minMusclesArg = args.find(arg => arg.startsWith('--min-muscles'))?.split('=')[1];
	if (minMusclesArg) {
		filters.minMuscles = parseInt(minMusclesArg, 10);
	}
	
	// 이미지 포함
	filters.includeImages = args.includes('--include-images');
	
	// 도움말
	if (args.includes('--help') || args.includes('-h')) {
		console.log(`
사용 방법:
  ts-node scripts/convert-free-exercise-db.ts [옵션]

옵션:
  --input <파일>          입력 JSON 파일 경로
  --output <파일>         출력 SQL 파일 경로
  --category <카테고리>    필터: UPPER, LOWER, FULL_BODY (쉼표로 구분)
  --equipment <장비>      필터: barbell, dumbbell, bodyweight 등 (쉼표로 구분)
  --level <레벨>          필터: beginner, intermediate, expert (쉼표로 구분)
  --body-part <부위>      필터: 가슴, 등, 어깨, 팔, 하체 (쉼표로 구분)
  --min-muscles <개수>    최소 primaryMuscles 개수 (기본: 1)
  --include-images       이미지 URL 포함 (선택적)
  --help                 도움말 표시

예시:
  # 전체 운동 변환
  ts-node scripts/convert-free-exercise-db.ts

  # 상체 운동만 변환
  ts-node scripts/convert-free-exercise-db.ts --category=UPPER

  # 바벨과 덤벨 운동만 변환
  ts-node scripts/convert-free-exercise-db.ts --equipment=barbell,dumbbell

  # 초보자용 상체 운동만 변환
  ts-node scripts/convert-free-exercise-db.ts --category=UPPER --level=beginner

  # 가슴 운동만 변환
  ts-node scripts/convert-free-exercise-db.ts --body-part=가슴
`);
		process.exit(0);
	}
	
	return { input, output, filters };
}

// 실행
const { input, output, filters } = parseArgs();

if (!fs.existsSync(input)) {
	console.error(`❌ 입력 파일을 찾을 수 없습니다: ${input}`);
	console.error('\n사용 방법:');
	console.error('  1. free-exercise-db 저장소 클론:');
	console.error('     git clone https://github.com/yuhonas/free-exercise-db.git');
	console.error('  2. 또는 exercises.json 직접 다운로드');
	console.error('  3. 스크립트 실행:');
	console.error('     ts-node scripts/convert-free-exercise-db.ts --input=<파일> [옵션]');
	process.exit(1);
}

convertExercises(input, output, filters);
