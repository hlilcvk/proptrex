// PROPTREX Service Worker v2.0
const CACHE = 'proptrex-v2';
const ASSETS = ['/app', '/app.html', '/manifest.json'];

// Install — cache shell
self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(CACHE).then(c => c.addAll(ASSETS)).then(() => self.skipWaiting())
  );
});

// Activate — clean old caches
self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

// Fetch — network first, cache fallback
self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);

  // Always network for API calls
  if (url.hostname.includes('tradingview') ||
      url.hostname.includes('dexscreener') ||
      url.hostname.includes('anthropic') ||
      url.hostname.includes('fonts.googleapis')) {
    return; // bypass SW
  }

  e.respondWith(
    fetch(e.request)
      .then(res => {
        // Cache successful GET responses
        if (e.request.method === 'GET' && res.status === 200) {
          const clone = res.clone();
          caches.open(CACHE).then(c => c.put(e.request, clone));
        }
        return res;
      })
      .catch(() => caches.match(e.request).then(r => r || caches.match('/app')))
  );
});

// Push notifications
self.addEventListener('push', e => {
  const data = e.data?.json() || {};
  const options = {
    body: data.body || 'Yeni sinyal tespit edildi',
    icon: '/manifest.json',
    badge: '/manifest.json',
    vibrate: [200, 100, 200],
    tag: data.tag || 'proptrex-signal',
    data: { url: data.url || '/app' },
    actions: [
      { action: 'open', title: '📊 Görüntüle' },
      { action: 'dismiss', title: 'Kapat' }
    ]
  };
  e.waitUntil(
    self.registration.showNotification(
      data.title || '⚡ PROPTREX — ' + (data.level || 'Sinyal'),
      options
    )
  );
});

self.addEventListener('notificationclick', e => {
  e.notification.close();
  if (e.action !== 'dismiss') {
    e.waitUntil(clients.openWindow(e.notification.data?.url || '/app'));
  }
});
