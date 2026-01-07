# Smarter Playlists

This is a web app for creating complex Spotify playlists.

## Run the app locally (HTTPS)
Spotify now requires redirect URIs to use HTTPS. The steps below stand up a fully
functional local clone with secure redirect/callback URLs.

### Prerequisites
- Python **2.7** for the API (the codebase uses Python 2 syntax).
- Python **3.8+** for the HTTPS static file server.
- Redis 6+ (a Docker one-liner is shown below).
- OpenSSL (for generating a self-signed certificate).
- A Spotify Developer application with redirect URIs set to:
  - `https://localhost:8000/auth.html`
  - `https://localhost:8000/callback.html`

### 1) Generate local HTTPS certificates
```bash
./scripts/generate_dev_certs.sh
```

This writes `certs/dev.crt` and `certs/dev.key`, which are ignored by git.

### 2) Provide Spotify credentials
Copy `.env.example` to `.env` and fill in your Spotify client values:
```bash
cp .env.example .env
# edit .env to include SPOTIPY_CLIENT_ID and SPOTIPY_CLIENT_SECRET
```

### 3) Start Redis
You can use Docker to avoid installing Redis locally:
```bash
docker run --name smarterplaylists-redis -p 6379:6379 -d redis:7-alpine
```

### 4) Run the Flask API with HTTPS
Use Python 2 to launch the API. The helper script automatically loads `.env`
and points Flask at the generated certs:
```bash
(python2) cd server
./start_debug_server
```

If you prefer to run the module directly:
```bash
SSL_CERT=../certs/dev.crt SSL_KEY=../certs/dev.key \
SPOTIPY_REDIRECT_URI=https://localhost:8000/auth.html \
python2 flask_server.py --debug
```

### 5) Serve the web UI over HTTPS
Use Python 3 to serve the static site:
```bash
python3 web/dev_https_server.py --port 8000
```

Then visit `https://localhost:8000/` and log in with Spotify. Both the OAuth
redirect (`auth.html`) and playlist save callback (`callback.html`) now use
HTTPS, satisfying Spotify's updated token rules.
