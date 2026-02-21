#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  PROPTREX — Güncelleme Scripti (Sıfır Kesinti)
#  Kullanım: bash scripts/update.sh
# ═══════════════════════════════════════════════════════════

set -e
GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'

cd "$(dirname "$0")/.."

echo -e "${CYAN}[1/3] Yeni imaj derleniyor...${NC}"
docker compose build --no-cache

echo -e "${CYAN}[2/3] Container yeniden başlatılıyor...${NC}"
docker compose up -d --force-recreate

echo -e "${CYAN}[3/3] Eski imajlar temizleniyor...${NC}"
docker image prune -f

echo -e "${GREEN}✓ PROPTREX güncellendi!${NC}"
docker compose ps
