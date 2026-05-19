# altro

This repository now contains a wired `speak` submodule and a mobile-first hold-to-talk UI for PersonaPlex.

## What is included

- `speak/` submodule pointing at `https://github.com/aurelius-gif/speak.git`
- Modified client UI to support a minimal phone-friendly hold-to-talk interface
- `Dockerfile` to build the speak client and run the PersonaPlex server with static UI
- `docker-compose.yaml` for local development
- `speak.ai` placeholder config for future PTT integration

## Local setup

1. Initialize the submodule:

   ```bash
   git submodule update --init --recursive
   ```

2. Build and run locally with Docker:

   ```bash
   docker build -t altro-speak .
   docker run --rm -p 8998:8998 -e HF_TOKEN="$HF_TOKEN" -e DEVICE=cpu altro-speak
   ```

3. Open your phone browser to `http://<host-ip>:8998`

## Docker Compose

Set your `HF_TOKEN` in an environment file or export it, then:

```bash
export HF_TOKEN="<your_hf_token>"
export DEVICE=cpu
docker compose up --build
```

## Railway deployment

Railway can deploy this repository using the provided `Dockerfile`.

- Create a Railway project
- Connect this repository
- Set environment variable `HF_TOKEN`
- Optionally set `DEVICE=cuda` if your Railway environment has GPU support; otherwise keep `DEVICE=cpu`
- Railway will build the `Dockerfile` and expose the app on port `8998`

### GitHub Actions deploy

This repo includes a GitHub Actions workflow at `.github/workflows/deploy-railway.yml`.

Set the following repository secrets before pushing:

- `RAILWAY_TOKEN`
- `RAILWAY_PROJECT_ID`

### Submodule note

Because `speak` is a git submodule, make sure the `aurelius-gif/speak` repository receives the internal UI commit before relying on the `altro` deployment.

## Notes

- The UI is served directly by the PersonaPlex server from the built `speak/client/dist` directory.
- If you want secure access, you can layer in Supabase auth later; the current setup is intentionally minimal so phone PTT works quickly.
