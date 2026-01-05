// TypeORM 모델 생성 스크립트 (Node.js 버전)
// 사용법: node scripts/generate-entities.js

const { execSync } = require('child_process');
const path = require('path');

// 환경 변수에서 데이터베이스 정보 가져오기
require('dotenv').config();

let user, password, host, port, database;

// DATABASE_URL 우선 사용, 없으면 개별 설정 사용
if (process.env.DATABASE_URL) {
  const dbUrl = process.env.DATABASE_URL;
  const urlMatch = dbUrl.match(/postgresql:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/);
  
  if (!urlMatch) {
    console.error('DATABASE_URL 형식이 올바르지 않습니다.');
    console.error('형식: postgresql://user:password@host:port/database');
    process.exit(1);
  }
  
  [, user, password, host, port, database] = urlMatch;
} else {
  // 개별 설정 사용
  user = process.env.DB_USERNAME;
  password = process.env.DB_PASSWORD;
  host = process.env.DB_HOST;
  port = process.env.DB_PORT || '5432';
  database = process.env.DB_NAME;
  
  if (!user || !password || !host || !database) {
    console.error('데이터베이스 설정이 완료되지 않았습니다.');
    console.error('DATABASE_URL 또는 DB_USERNAME, DB_PASSWORD, DB_HOST, DB_NAME을 설정해주세요.');
    process.exit(1);
  }
}

console.log('데이터베이스에서 엔티티 생성 중...');
console.log(`Host: ${host}`);
console.log(`Port: ${port}`);
console.log(`Database: ${database}`);
console.log(`User: ${user}`);

try {
  // Windows 환경을 고려하여 npx 사용
  // SSL이 필요한 경우 --ssl 옵션 추가
  const needsSsl = host.includes('render.com') || host.includes('amazonaws.com');
  const sslOption = needsSsl ? '--ssl' : '';
  const command = `npx typeorm-model-generator -h ${host} -d ${database} -u ${user} -x ${password} -p ${port} -e postgres -o ./src/entities-generated --noConfig true --cf camel --ce pascal --cp camel ${sslOption}`.trim();
  console.log('실행 명령어:', command.replace(password, '***'));
  execSync(command, { stdio: 'inherit' });
  console.log('\n✅ 엔티티 생성이 완료되었습니다!');
  console.log('생성된 파일 위치: ./src/entities-generated');
} catch (error) {
  console.error('\n❌ 엔티티 생성 중 오류가 발생했습니다.');
  console.error(error.message);
  process.exit(1);
}

