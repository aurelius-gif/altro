# Railway Deployment Guide

The `altro` app with PTT (Push-to-Talk) is ready to deploy on Railway.

## Prerequisites

- GitHub account with the repo connected
- Railway account at https://railway.app
- Doppler account with `altro` project and `prd` config

## Quick Deploy Steps

### 1. Connect GitHub Repository
1. Go to https://railway.app
2. Create a new project or select existing
3. Click "Deploy from GitHub repo"
4. Select `aurelius-gif/altro`
5. Confirm and wait for Railway to detect the Dockerfile

### 2. Set Environment Variables in Railway
In the Railway dashboard for your service, add:

```
DOPPLER_TOKEN=<your-doppler-token>
DOPPLER_PROJECT=altro
DOPPLER_CONFIG=prd
PYTHONUNBUFFERED=1
NO_TORCH_COMPILE=1
```

**Critical:** The `DOPPLER_TOKEN` is required for the app to fetch secrets (including `HF_TOKEN`).

### 3. Configure Doppler Integration (Optional but Recommended)
Railway supports direct Doppler integration:
1. In Railway, go to **Integrations** → **Doppler**
2. Authenticate with Doppler
3. Select your `altro` project and `prd` config
4. Railway will automatically manage the `DOPPLER_TOKEN`

### 4. Deploy
Railway auto-deploys when you push to the main branch. To manually trigger:
1. Push your changes: `git push origin main`
2. Railway detects the push and automatically builds from `Dockerfile`
3. Monitor the deployment in Railway dashboard

## Architecture

- **Build:** Multi-stage Dockerfile builds the React client (`speak/client`) and Python server (`speak/moshi`)
- **Runtime:** Single container runs both:
  - Static files served from `speak/client/dist`
  - Python gRPC/WebSocket server on port 8998
- **Secrets:** Doppler CLI fetches secrets at container startup via the entrypoint script

## Accessing the App

Once deployed, Railway provides a public URL:
- **Frontend:** `https://<your-railway-domain>/` (static files + API proxy)
- **Backend:** gRPC/WebSocket endpoint at `https://<your-railway-domain>`

## Troubleshooting

### Deployment fails on `pip install`
- Ensure `speak/moshi/pyproject.toml` has all dependencies
- Check Railway logs: `Railway Dashboard → Logs`

### App crashes with "HF_TOKEN not found"
- Ensure `DOPPLER_TOKEN` is set in Railway environment
- Verify Doppler has `HF_TOKEN` in `altro/prd` config

### Port mismatch
- Railway sets the `PORT` env var automatically
- The entrypoint script reads `PORT` and uses it (defaults to 8998)

## Manual Local Build Test

```bash
# Build locally
docker build -t altro-speak .

# Run with Doppler token
docker run \
  -e DOPPLER_TOKEN=<token> \
  -e DOPPLER_PROJECT=altro \
  -e DOPPLER_CONFIG=prd \
  -p 8998:8998 \
  altro-speak
```

## Next Steps

1. **Push to GitHub:**
   ```bash
   git push origin main
   ```

2. **Create Railway Project:**
   - https://railway.app/new
   - Click "Deploy from GitHub"
   - Select the `altro` repo

3. **Add Secrets:**
   - In Railway dashboard, add `DOPPLER_TOKEN` and other env vars

4. **Monitor:**
   - Railway dashboard will show build + deployment logs
   - Check the public URL once deployment succeeds

---

**Deployed on:** May 23, 2026
**Tech Stack:** React (Vite) + Python (Moshi + PersonaPlex)
**Model:** NVIDIA PersonaPlex 7B v1
