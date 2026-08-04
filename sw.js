const CACHE_NAME = 'mykas-pwa-v2'; // <--- VERSI DINAIKKAN AGAR CACHE LAMA TERHAPUS

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

// 1. EVENT INSTALLATION (Simpan aset ke cache browser/HP baru)
self.addEventListener('install', (event) => {
  self.skipWaiting(); // Paksa Service Worker baru langsung aktif tanpa menunggu tab ditutup
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[Service Worker] Caching all PWA static assets (v2)');
      return cache.addAll(ASSETS_TO_CACHE);
    })
  );
});

// 2. EVENT ACTIVATION (Bersihkan cache versi v1 lama secara permanen)
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
    }).then(() => self.clients.claim()) // Langsung ambil alih semua halaman yang sedang terbuka
  );
});

// 3. EVENT FETCH (Network-First untuk HTML & Cache-First untuk Aset Statis)
self.addEventListener('fetch', (event) => {
  // Biarkan request ke Google Apps Script (database) selalu mengambil data terbaru secara online
  if (event.request.url.includes('script.google.com')) {
    return;
  }

  // STRATEGI NETWORK-FIRST UNTUK NAVIGASI (INDEX.HTML):
  // Utamakan mengambil file terbaru dari Vercel agar layout baru selalu langsung terlihat
  if (event.request.mode === 'navigate' || event.request.destination === 'document') {
    event.respondWith(
      fetch(event.request)
        .then((networkResponse) => {
          return caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, networkResponse.clone());
            return networkResponse;
          });
        })
        .catch(() => caches.match(event.request)) // Fallback jika offline
    );
    return;
  }

  // STRATEGI CACHE-FIRST UNTUK ASET STATIS (Gambar, Logo, Icon)
  event.respondWith(
    caches.match(event.request).then((cachedResponse) => {
      if (cachedResponse) {
        return cachedResponse;
      }

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
