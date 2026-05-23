# Build the speak client UI
FROM node:20-bullseye AS client-build
WORKDIR /build
COPY speak/client/package*.json speak/client/
COPY speak/client/tsconfig.json speak/client/
COPY speak/client/vite.config.ts speak/client/
COPY speak/client/index.html speak/client/
COPY speak/client/postcss.config.js speak/client/
COPY speak/client/tailwind.config.js speak/client/
COPY speak/client/src speak/client/src
COPY speak/client/public speak/client/public
RUN cd speak/client && npm ci --no-audit --no-fund && npm run build

# Runtime image
FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    libopus-dev \
    portaudio19-dev \
    build-essential \
    curl \
    gnupg \
    gpgv \
  && rm -rf /var/lib/apt/lists/*

# Install Doppler CLI
RUN curl -sLf https://cli.doppler.com/install.sh | sh

WORKDIR /app
COPY speak /app/speak
COPY --from=client-build /build/speak/client/dist /app/speak/client/dist
COPY speak/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENV PYTHONUNBUFFERED=1
RUN cd /app/speak/moshi && pip install --no-cache-dir -e .
EXPOSE 8998

ENTRYPOINT ["/app/entrypoint.sh"]
CMD []
