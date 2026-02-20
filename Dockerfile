# ═══════════════════════════════════════════════════════════
#  PROPTREX — Dockerfile v3.0.1
#  Non-root nginx fix + Exchange Hub
#  www.proptrex.com
# ═══════════════════════════════════════════════════════════

FROM node:20-alpine AS builder
WORKDIR /build
COPY html/ .

FROM nginx:1.27-alpine AS production

LABEL org.opencontainers.image.title="PROPTREX Platform"
LABEL org.opencontainers.image.description="Global Market Intelligence + Exchange Hub + PWA"
LABEL org.opencontainers.image.version="3.0.1"

RUN rm -rf /usr/share/nginx/html/*

# Web pages
COPY --from=builder /build/index.html         /usr/share/nginx/html/index.html
COPY --from=builder /build/platform.html      /usr/share/nginx/html/platform.html
COPY --from=builder /build/dashboard.html     /usr/share/nginx/html/dashboard.html
COPY --from=builder /build/exchange-hub.html  /usr/share/nginx/html/exchange-hub.html

# PWA Mobile App
COPY --from=builder /build/app.html           /usr/share/nginx/html/app.html
COPY --from=builder /build/manifest.json      /usr/share/nginx/html/manifest.json
COPY --from=builder /build/sw.js              /usr/share/nginx/html/sw.js

# Nginx config
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# ═══ Non-root nginx düzeltmesi ═══
# pid dosyasını /tmp'ye yönlendir (ana nginx.conf'ta)
RUN sed -i 's|pid\s*/run/nginx.pid;|pid /tmp/nginx.pid;|g' /etc/nginx/nginx.conf && \
    # client_body ve proxy temp dizinlerini /tmp altına al
    sed -i 's|/var/cache/nginx/client_temp|/tmp/client_temp|g' /etc/nginx/nginx.conf 2>/dev/null || true && \
    # Tüm gerekli yazılabilir dizinleri oluştur
    mkdir -p /tmp/client_temp /tmp/proxy_temp /tmp/fastcgi_temp /tmp/uwsgi_temp /tmp/scgi_temp && \
    # user 1001 için izinler
    adduser -S -D -H -u 1001 proptrex && \
    chown -R proptrex:0 /var/cache/nginx /var/run /var/log/nginx /tmp/client_temp /tmp/proxy_temp /tmp/fastcgi_temp /tmp/uwsgi_temp /tmp/scgi_temp && \
    chmod -R g+w /var/cache/nginx /var/run /var/log/nginx /tmp/client_temp /tmp/proxy_temp /tmp/fastcgi_temp /tmp/uwsgi_temp /tmp/scgi_temp

USER 1001
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

CMD ["nginx", "-g", "daemon off;"]
