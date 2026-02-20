# ⚡ PROPTREX — Global Market Intelligence

**www.proptrex.com** | Kripto · Forex · Hisse · BYF · Tahvil  
4 AI Agent · Gerçek Zamanlı Tarama · Claude AI Analizi

---

## 📁 Klasör Yapısı

```
proptrex/
├── html/
│   ├── index.html       ← Landing page (ana sayfa)
│   ├── platform.html    ← Trading dashboard (ana platform)
│   └── dashboard.html   ← Market overview (ek panel)
├── config/
│   └── nginx.conf       ← Nginx production konfigürasyonu
├── scripts/
│   ├── deploy.sh        ← Otomatik VPS kurulumu
│   └── update.sh        ← Sıfır kesintili güncelleme
├── Dockerfile           ← Multi-stage Docker build
├── docker-compose.yml   ← Servis konfigürasyonu
├── .dockerignore
├── .gitignore
└── README.md
```

---

## 🚀 Kurulum Yöntemleri

### Yöntem 1 — Otomatik (Önerilen)

```bash
# VPS'e SSH ile bağlan
ssh root@VPS_IP

# Dosyaları yükle
git clone https://github.com/SENIN_REPO/proptrex.git
# veya scp ile kopyala:
# scp -r proptrex/ root@VPS_IP:/opt/

cd proptrex

# Tek komutla kur
bash scripts/deploy.sh
```

### Yöntem 2 — Manuel Docker

```bash
cd proptrex

# Build
docker compose build

# Başlat
docker compose up -d

# Durum kontrol
docker compose ps
docker compose logs -f
```

### Yöntem 3 — Coolify (GUI ile)

1. Coolify dashboard → **New Resource** → **Docker Compose**
2. GitHub/GitLab reponuzu bağlayın
3. **Domains** sekmesi → `proptrex.com` ve `www.proptrex.com` ekleyin
4. SSL: **Let's Encrypt** seçin (otomatik)
5. **Deploy** tıklayın ✅

---

## 🌐 URL Yapısı

| URL | Sayfa |
|-----|-------|
| `proptrex.com/` | Landing page (ana sayfa) |
| `proptrex.com/platform` | Trading platform (asıl panel) |
| `proptrex.com/exchange` | Exchange Hub — 19 CEX, Spot/Futures, Filtreler |
| `proptrex.com/dashboard` | Market dashboard |
| `proptrex.com/health` | Health check endpoint |

---

## ⚙️ Ortam Değişkenleri

| Değişken | Varsayılan | Açıklama |
|----------|-----------|---------|
| `PORT` | `8080` | Container portu |
| `TZ` | `Europe/Istanbul` | Saat dilimi |
| `NODE_ENV` | `production` | Ortam modu |

### Özel port:
```bash
PORT=3000 docker compose up -d
```

---

## 🔒 DNS & SSL Kurulumu

### DNS (Domain Sağlayıcıda)
```
A    @              → VPS_IP
A    www            → VPS_IP
```

### SSL — Certbot (Manuel)
```bash
apt install certbot python3-certbot-nginx -y
certbot --nginx -d proptrex.com -d www.proptrex.com
```

### SSL — Coolify
Otomatik Let's Encrypt sertifikası alır. Ekstra ayar gerekmez.

---

## 🔧 Yaygın Komutlar

```bash
# Container durumu
docker compose ps

# Logları izle
docker compose logs -f proptrex-web

# Yeniden başlat
docker compose restart

# Güncelle (sıfır kesinti)
bash scripts/update.sh

# Durdur
docker compose down

# Tamamen sil (verilerle birlikte)
docker compose down -v --rmi all
```

---

## 📊 Platform Özellikleri

### Gerçek Zamanlı Veri Kaynakları
- **TradingView Scanner API** — 300+ kripto çifti, 10sn yenileme
- **DexScreener API** — DEX token tarama, rug risk analizi
- **Claude Sonnet 4.6 AI** — Token başına detaylı analiz

### Desteklenen Piyasalar
| Piyasa | Veri Kaynağı | Yenileme |
|--------|-------------|---------|
| Kripto (CEX) | TradingView Scanner | 10 saniye |
| Kripto (DEX) | DexScreener API | 10 saniye |
| Balina Takibi | Simülasyon + Platform Linkleri | Anlık |
| Forex | Simülasyon (2sn) | 2 saniye |
| Hisse / ETF | Statik (API entegrasyonu yakında) | — |
| Tahvil | Statik | — |

### AI Agent Sistemi
- **DipHunter Agent** — DIP SCORE™ (0-100 puanlama)
- **ForexSentinel Agent** — Seans bazlı forex sinyal
- **WhaleScout Agent** — Balina cüzdan takibi
- **NewsReactor Agent** — Haber sentiment analizi

---

## 🔗 Balina Takip Linkleri (Platform İçinde)

| Platform | URL |
|----------|-----|
| Nansen.ai | https://nansen.ai |
| Arkham Intelligence | https://platform.arkhamintelligence.com |
| GMGN.ai | https://gmgn.ai |
| Bubblemaps | https://app.bubblemaps.io |
| Lookonchain | https://lookonchain.com |
| Whale Alert | https://whale-alert.io |
| DeBank | https://debank.com |
| Kryll X-Ray | https://app.kryll.io/x-ray |

---

## ✅ Production Checklist

- [ ] DNS A kaydı → VPS IP
- [ ] SSL sertifikası aktif
- [ ] `proptrex.com` ve `www.proptrex.com` çalışıyor
- [ ] `/health` endpoint yanıt veriyor
- [ ] `docker compose ps` — tüm servisler `healthy`
- [ ] Uptime monitörü kuruldu (UptimeRobot önerilen)
- [ ] Nginx.conf'ta `server_name proptrex.com www.proptrex.com;` güncellendi
- [ ] Google Analytics / Plausible eklendi (isteğe bağlı)

---

## ⚠️ Yasal Uyarı

PROPTREX yatırım tavsiyesi vermez. Tüm sinyaller bilgilendirme amaçlıdır.  
**DYOR — Do Your Own Research.** Kripto ve finansal piyasalar yüksek risk içerir.

---

**© 2025 PROPTREX · proptrex.com**
