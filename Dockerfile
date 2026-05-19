# Build the speak client UI
FROM node:20-bullseye AS client-build
WORKDIR /build
COPY speak/client/package*.json speak/client/
COPY speak/client/tsconfig.json speak/client/
COPY speak/client/vite.config.ts speak/client/
COPY speak/client/src speak/client/src
COPY speak/client/public speak/client/public
RUN cd speak/client && npm ci --no-audit --no-fund && npm run build

# Runtime image
FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends \
    libopus-dev \
    portaudio19-dev \
    build-essential \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=client-build /build/speak /app/speak
ENV PYTHONUNBUFFERED=1
RUN cd /app/speak/moshi && pip install --no-cache-dir -e .
EXPOSE 8998
CMD ["python", "-m", "moshi.server", "--host", "0.0.0.0", "--port", "8998", "--static", "speak/client/dist"]
