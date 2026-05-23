#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/doppler_fetch.sh [project] [config] [output_file]
# Defaults: project=altro, config=dev, output_file=speak/.env

PROJECT=${1:-altro}
CONFIG=${2:-dev}
OUT_FILE=${3:-speak/.env}

echo "Ensuring Doppler CLI is installed..."
if ! command -v doppler >/dev/null 2>&1; then
  echo "Doppler CLI not found. Installing via official install script..."
  curl -sLf https://cli.doppler.com/install.sh | sh
else
  echo "Doppler CLI found: $(doppler --version 2>/dev/null || echo 'version unknown')"
fi

if [ -z "${DOPPLER_TOKEN:-}" ]; then
  echo "No DOPPLER_TOKEN env var detected. Ensure you're logged in with 'doppler login' or set DOPPLER_TOKEN."
fi

echo "Downloading secrets for project='$PROJECT' config='$CONFIG' -> $OUT_FILE"
mkdir -p "$(dirname "$OUT_FILE")"

# Use Doppler to download as an env file. This will fail if you are not authenticated.
doppler secrets download --project "$PROJECT" --config "$CONFIG" --format env --output "$OUT_FILE"

echo "Wrote secrets to $OUT_FILE (do NOT commit this file)."
echo "Add $OUT_FILE to .gitignore if it isn't already."
