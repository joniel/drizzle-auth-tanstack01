# 1단계: 의존성 설치 및 빌드
FROM node:20-alpine AS builder
# pnpm 설치 추가
RUN npm install -g pnpm

WORKDIR /app
COPY package*.json ./
RUN pnpm install
COPY . .
RUN pnpm run build

# 2단계: 실행 환경
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
# COPY --from=builder /app/.next ./.next
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/package.json ./package.json
# COPY --from=builder /app/public ./public

# standalone 폴더만 복사
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

EXPOSE 3000
# CMD ["pnpm", "start"]
# npm start 대신 next start를 직접 호출하는 것이 더 안정적입니다.
# CMD ["node_modules/.bin/next", "start"]

# 이제 node로 직접 실행합니다.
CMD ["node", "server.js"]