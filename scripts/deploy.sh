#!/bin/bash
# ═══════════════════════════════════════════════════════════
#  PROPTREX — Otomatik VPS Kurulum Scripti
#  Kullanım: bash scripts/deploy.sh
#  Ubuntu 22.04 / Debian 12 için test edildi
# ═══════════════════════════════════════════════════════════

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  ██████╗ ██████╗  ██████╗ ██████╗ ████████╗██████╗ ███████╗██╗  ██╗"
echo "  ██╔══██╗██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝╚██╗██╔╝"
echo "  ██████╔╝██████╔╝██║   ██║██████╔╝   ██║   ██████╔╝█████╗   ╚███╔╝ "
echo "  ██╔═══╝ ██╔══██╗██║   ██║██╔═══╝    ██║   ██╔══██╗██╔══╝   ██╔██╗ "
echo "  ██║     ██║  ██║╚██████╔╝██║        ██║   ██║  ██║███████╗██╔╝ ██╗"
echo "  ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝        ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝"
echo -e "${NC}"
echo -e "${YELLOW}  Global Market Intelligence Platform — www.proptrex.com${NC}"
echo ""

# ── 1. DOCKER KURULUMU ──────────────────────────────────────
echo -e "${CYAN}[1/5] Docker kontrol ediliyor...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker bulunamadı. Kuruluyor...${NC}"
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
    echo -e "${GREEN}✓ Docker kuruldu${NC}"
else
    echo -e "${GREEN}✓ Docker zaten kurulu: $(docker --version)${NC}"
fi

# ── 2. DOCKER COMPOSE ───────────────────────────────────────
echo -e "${CYAN}[2/5] Docker Compose kontrol ediliyor...${NC}"
if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
    echo -e "${YELLOW}Docker Compose plugin kuruluyor...${NC}"
    apt-get update -qq && apt-get install -y docker-compose-plugin
fi
echo -e "${GREEN}✓ Docker Compose: $(docker compose version --short)${NC}"

# ── 3. BUILD ────────────────────────────────────────────────
echo -e "${CYAN}[3/5] PROPTREX imajı derleniyor...${NC}"
cd "$(dirname "$0")/.."
docker compose build --no-cache
echo -e "${GREEN}✓ Build tamamlandı${NC}"

# ── 4. DEPLOY ───────────────────────────────────────────────
echo -e "${CYAN}[4/5] Container başlatılıyor...${NC}"
docker compose down 2>/dev/null || true
docker compose up -d
echo -e "${GREEN}✓ Container çalışıyor${NC}"

# ── 5. HEALTH CHECK ─────────────────────────────────────────
echo -e "${CYAN}[5/5] Sağlık kontrolü yapılıyor...${NC}"
sleep 5
PORT=${PORT:-8080}
if curl -sf "http://localhost:${PORT}/health" > /dev/null; then
    echo -e "${GREEN}✓ Sağlık kontrolü başarılı — http://localhost:${PORT}${NC}"
else
    echo -e "${RED}✗ Sağlık kontrolü başarısız — loglar:${NC}"
    docker compose logs proptrex-web
    exit 1
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ PROPTREX başarıyla deploy edildi!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "  🌐 Landing Page :  ${CYAN}http://localhost:${PORT}/${NC}"
echo -e "  ⚡ Platform      :  ${CYAN}http://localhost:${PORT}/platform${NC}"
echo -e "  📊 Dashboard     :  ${CYAN}http://localhost:${PORT}/dashboard${NC}"
echo -e "  ❤  Health        :  ${CYAN}http://localhost:${PORT}/health${NC}"
echo ""
echo -e "  Loglar için: ${YELLOW}docker compose logs -f${NC}"
echo -e "  Durdur:      ${YELLOW}docker compose down${NC}"
echo ""
