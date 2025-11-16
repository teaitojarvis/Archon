#!/bin/bash
# ArchonFull - Chargeur de secrets via Age
# - Déchiffre /home/windsurf/IA_Config/secrets/secrets.env.age
# - Crée un .env adapté à ArchonFull (ports alignés avec Jarvis)

set -e

cd "$(dirname "$0")"

echo "[archon-full] Loading secrets from Age..."

AGE_KEY_PATH=/home/windsurf/IA_Config/secrets/.age-key.txt
AGE_SECRETS_PATH=/home/windsurf/IA_Config/secrets/secrets.env.age

if [ ! -f "$AGE_KEY_PATH" ]; then
  echo "[archon-full] Age key not found at $AGE_KEY_PATH" >&2
  exit 1
fi

if [ ! -f "$AGE_SECRETS_PATH" ]; then
  echo "[archon-full] Age secrets file not found at $AGE_SECRETS_PATH" >&2
  exit 1
fi

# On déchiffre tous les secrets connus (SUPABASE_URL, SUPABASE_SERVICE_KEY, OPENAI_API_KEY, etc.)
# Puis on filtre SUPABASE_URL pour pouvoir la surcharger proprement
age -d -i "$AGE_KEY_PATH" "$AGE_SECRETS_PATH" | grep -v '^SUPABASE_URL=' > .env.tmp

# On force les ports, l'host, SUPABASE_URL (en IPv4 explicite) et les hosts Vite autorisés pour Alignement avec Supabase local et mcp.teaito.com
cat >> .env.tmp <<'EOF'
SUPABASE_URL=http://127.0.0.1:54321
HOST=localhost
ARCHON_SERVER_PORT=8283
ARCHON_MCP_PORT=8051
ARCHON_AGENTS_PORT=8052
AGENT_WORK_ORDERS_PORT=8053
ARCHON_UI_PORT=3838
VITE_ALLOWED_HOSTS=mcp.teaito.com
EOF

mv .env.tmp .env

echo "[archon-full] .env created with decrypted secrets and Jarvis-aligned ports."
