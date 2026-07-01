#!/usr/bin/env bash
set -euo pipefail

HOST="127.0.0.1"
PORT="3306"
USER="root"
PASSWORD=""

usage() {
  echo "Uso: $0 [-h host] [-P port] [-u user] [-p password]"
}

while getopts ":h:P:u:p:" opt; do
  case "$opt" in
    h) HOST="$OPTARG" ;;
    P) PORT="$OPTARG" ;;
    u) USER="$OPTARG" ;;
    p) PASSWORD="$OPTARG" ;;
    *) usage; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mysql_args=(
  -h "$HOST"
  -P "$PORT"
  -u "$USER"
  --default-character-set=utf8mb4
)

if [[ -n "$PASSWORD" ]]; then
  mysql_args+=(-p"$PASSWORD")
fi

if ! command -v mysql >/dev/null 2>&1; then
  echo "mysql no está instalado. Usa Docker: docker compose up -d" >&2
  exit 1
fi

echo "Aplicando schema.sql..."
mysql "${mysql_args[@]}" < "$SCRIPT_DIR/schema.sql"

echo "Aplicando seed.sql..."
mysql "${mysql_args[@]}" < "$SCRIPT_DIR/seed.sql"

echo "Aplicando seed-demo.sql..."
mysql "${mysql_args[@]}" < "$SCRIPT_DIR/seed-demo.sql"

echo "Base de datos uidepet_huellitas lista."
