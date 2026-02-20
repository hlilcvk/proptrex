# ═══════════════════════════════════════════════════════════
#  PROPTREX — Dockerfile v2.1
#  Web + PWA Mobile App
#  www.proptrex.com
# ═══════════════════════════════════════════════════════════

FROM node:20-alpine AS builder
WORKDIR /build
COPY html/ .

FROM nginx:1.27-alpine AS production

LABEL org.opencontainers.image.title="PROPTREX Platform"
LABEL org.opencontainers.image.description="Global Market Intelligence + PWA Mobile App"
LABEL org.opencontainers.image.version="2.1.0"

RUN rm -rf /usr/share/nginx/html/*

# Web pages
COPY --from=builder /build/index.html     /usr/share/nginx/html/index.html
COPY --from=builder /build/platform.html  /usr/share/nginx/html/platform.html
COPY --from=builder /build/dashboard.html /usr/share/nginx/html/dashboard.html

# PWA Mobile App
COPY --from=builder /build/app.html       /usr/share/nginx/html/app.html
COPY --from=builder /build/manifest.json  /usr/share/nginx/html/manifest.json
COPY --from=builder /build/sw.js          /usr/share/nginx/html/sw.js

COPY config/nginx.conf /etc/nginx/conf.d/default.conf

RUN adduser -S -D -H -u 1001 proptrex && \
    chown -R proptrex:0 /var/cache/nginx /var/run /var/log/nginx && \
    chmod -R g+w /var/cache/nginx /var/run /var/log/nginx

USER 1001
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

CMD ["nginx", "-g", "daemon off;"]
