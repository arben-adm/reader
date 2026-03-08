FROM node:18-slim

RUN apt-get update && apt-get install -y \
    chromium \
    libmagic-dev \
    build-essential \
    python3 \
    && rm -rf /var/lib/apt/lists/*

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV CHROMIUM_FLAGS="--no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu"

WORKDIR /app

COPY backend/functions/package*.json ./
RUN npm ci
COPY backend/functions .
RUN npm run build

RUN mkdir -p /app/local-storage && chmod 777 /app/local-storage

EXPOSE 3000

CMD ["node", "build/server.js"]
