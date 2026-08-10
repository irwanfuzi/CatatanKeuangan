const CACHE_NAME = 'mykas-pwa-v3';
const ASSETS_TO_CACHE = [
  './', './index.html', './manifest.json', './logo.svg', './wallet-white.svg',
  './mykas-text-white.svg', './icon-192.png', './icon-512.png', './icon.png',
  './dashboard-redesign.js'
];

self.addEventListener('install', (event) => {
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS_TO_CACHE))
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => Promise.all(
      cacheNames.map((cache) => cache !== CACHE_NAME ? caches.delete(cache) : null)
    )).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.url.includes('script.google.com')) return;

  if (event.request.mode === 'navigate' || event.request.destination === 'document') {
    event.respondWith(
      fetch(event.request).then(async (networkResponse) => {
        const contentType = networkResponse.headers.get('content-type') || '';
        if (!contentType.includes('text/html')) return networkResponse;

        const html = await networkResponse.text();
        const injected = html.replace(
          '</body>',
          '<script src="./dashboard-redesign.js"></script></body>'
        );
        const response = new Response(injected, {
          status: networkResponse.status,
          statusText: networkResponse.statusText,
          headers: networkResponse.headers
        });

        const cache = await caches.open(CACHE_NAME);
        await cache.put(event.request, response.clone());
        return response;
      }).catch(() => caches.match(event.request))
    );
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      if (cachedResponse) return cachedResponse;
      return fetch(event.request).then((networkResponse) => {
        if (!networkResponse || networkResponse.status !== 200 || networkResponse.type !== 'basic') {
          return networkResponse;
        }
        const responseToCache = networkResponse.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, responseToCache));
        return networkResponse;
      });
    })
  );
});
