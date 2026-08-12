const CACHE_NAME = 'mykas-pwa-v5';
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

  // Always prefer the network for the app shell so a deployed UI cannot
  // remain stuck on an older dashboard inside an installed PWA.
  if (event.request.mode === 'navigate' || event.request.destination === 'document') {
    event.respondWith(
      fetch(event.request, { cache: 'no-store' }).then(async (networkResponse) => {
        const contentType = networkResponse.headers.get('content-type') || '';
        if (!contentType.includes('text/html')) return networkResponse;

        const html = await networkResponse.text();
        const injected = html.includes('dashboard-redesign.js')
          ? html
          : html.replace('</body>', '<script src="./dashboard-redesign.js?v=5"></script></body>');
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

  // Versioned dashboard JS must also bypass an old cached copy.
  if (new URL(event.request.url).pathname.endsWith('/dashboard-redesign.js')) {
    event.respondWith(
      fetch(event.request, { cache: 'no-store' }).then((networkResponse) => {
        if (networkResponse.ok) {
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, networkResponse.clone()));
        }
        return networkResponse;
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
