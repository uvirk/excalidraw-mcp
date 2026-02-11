# Build stage
FROM node:22-slim AS build
WORKDIR /app

# Install bun
RUN npm install -g bun

# Install dependencies
COPY package.json package-lock.json ./
RUN npm ci --include=optional

# Copy source and build
COPY . .
RUN npm run build

# Production stage
FROM node:22-slim
WORKDIR /app

COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./

ENV NODE_ENV=production
ENV PORT=8080

EXPOSE 8080

CMD ["node", "dist/index.js"]
