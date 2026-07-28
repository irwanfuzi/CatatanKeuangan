const CACHE_NAME = 'mykas-pwa-v1';

// Daftar semua aset penting yang wajib di-cache
const ASSETS_TO_CACHE = [
  './',
  './index.html',
  './manifest.json',
  './logo.svg',
  './wallet-white.svg',
  './mykas-text-white.svg',
  './icon-192.png',
  './icon-512.png',
  './icon.png'
];

// 1. EVENT INSTALLATION (Simpan aset ke cache browser/HP)
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[Service Worker] Caching all PWA static assets');
      return cache.addAll(ASSETS_TO_CACHE);
    }).then(() => self.skipWaiting())
  );
});

// 2. EVENT ACTIVATION (Bersihkan cache versi lama jika ada update)
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME) {
            console.log('[Service Worker] Deleting old cache version:', cache);
            return caches.delete(cache);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// 3. EVENT FETCH (Cache First Strategy dengan Network Fallback)
self.addEventListener('fetch', (event) => {
  // Biarkan request ke Google Apps Script (database) selalu mengambil data terbaru secara online
  if (event.request.url.includes('script.google.com')) {
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      // Jika file ada di cache, gunakan file dari cache
      if (cachedResponse) {
        return cachedResponse;
      }

      // Jika tidak ada di cache, ambil dari jaringan lalu simpan otomatis
      return fetch(event.request).then((networkResponse) => {
        if (!networkResponse || networkResponse.status !== 200 || networkResponse.type !== 'basic') {
          return networkResponse;
        }

        const responseToCache = networkResponse.clone();
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(event.request, responseToCache);
        });

        return networkResponse;
      });
    })
  );
});
