# ===================================

# Server

# ===================================

PORT=3001
NODE_ENV=development

# ===================================

# PostgreSQL (Render - External)

# ===================================

DB_TYPE=postgres
DB_HOST=dpg-d5dm70je5dus739fa9tg-a.singapore-postgres.render.com
DB_PORT=5432
DB_NAME=gym_membership_db
DB_USERNAME=gym_membership_db_user
DB_PASSWORD=XQXbY7xwCyEObFgTEa6QNMoxz2ir8xY7

# ===================================

# TypeORM

# ===================================

DB_SYNCHRONIZE=false
DB_LOGGING=true

# ===================================

# CORS

# ===================================

FRONTEND_URL=http://localhost:3000

# ===================================

# JWT

# ===================================

JWT_SECRET=your-secret-key-change-this-in-production-minimum-32-characters

# Access Token 만료 시간 (15분)

JWT_EXPIRES_IN=15m

# Refresh Token 만료 시간 (7일)

JWT_REFRESH_EXPIRES_IN=7d

# ===================================

# 카카오 로그인

# ===================================

KAKAO_CLIENT_ID=4fdad03aee8a169f3fa75fd005a972bc
KAKAO_REDIRECT_URI=http://localhost:3001/api/auth/kakao/callback
