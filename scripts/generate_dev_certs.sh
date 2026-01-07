#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CERT_DIR="${ROOT_DIR}/certs"
CERT_PATH="${CERT_DIR}/dev.crt"
KEY_PATH="${CERT_DIR}/dev.key"

mkdir -p "${CERT_DIR}"

if [[ -f "${CERT_PATH}" && -f "${KEY_PATH}" ]]; then
  echo "Development certificates already exist in ${CERT_DIR}"
  exit 0
fi

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "${KEY_PATH}" \
  -out "${CERT_PATH}" \
  -subj "/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"

echo "Wrote ${CERT_PATH} and ${KEY_PATH}"
