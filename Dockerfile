FROM n8nio/n8n:latest

USER root

# Install dependencies for Puppeteer + Chromium
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libgtk-3-0 \
    libxshmfence1 \
    xdg-utils \
    libxss1 \
    libxtst6 \
    fonts-noto-color-emoji \
    chromium \
    && apt-get clean

# Puppeteer settings
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Install puppeteer custom node
COPY . /opt/n8n-custom-nodes/node_modules/n8n-nodes-puppeteer
RUN cd /opt/n8n-custom-nodes/node_modules/n8n-nodes-puppeteer && \
    npm install && \
    npm run build && \
    chown -R node:node /opt/n8n-custom-nodes

# Custom entrypoint
COPY docker/docker-custom-entrypoint.sh /docker-custom-entrypoint.sh
RUN chmod +x /docker-custom-entrypoint.sh && \
    chown node:node /docker-custom-entrypoint.sh

USER node

ENTRYPOINT ["/docker-custom-entrypoint.sh"]
