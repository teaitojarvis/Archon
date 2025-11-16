#!/bin/bash
# Start ArchonFull backend with Age-encrypted secrets and uv

set -e

cd /home/windsurf/IA_Agents/ArchonFull

echo "[archon-full] Loading secrets and generating .env..."
./load-archonfull-secrets.sh

echo "[archon-full] Starting backend with uv (port ${ARCHON_SERVER_PORT:-8283})..."
cd python

# Use the local .venv created by `uv sync` and run the FastAPI server
exec uv run python -m src.server.main
