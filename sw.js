const CACHE_NAME = 'mykas-v2'; // Ubah angka versi (v3, v4, dst) jika ada update besar
const ASSETS = [
  './',
  './index.html',
  './manifest.json'
];

// 1. INSTALL: Menyimpan file ke cache saat pertama kali diakses
self.addEventListener('install', (e) => {
  e.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(ASSETS);
    })
  );
  self.skipWaiting(); // Memaksa SW untuk segera aktif
});

// 2. ACTIVATE: Membersihkan cache lama yang tidak terpakai
self.addEventListener('activate', (e) => {
  e.waitUntil(
    caches.keys().then((keyList) => {
      return Promise.all(keyList.map((key) => {
        if (key !== CACHE_NAME) {
          console.log('[SW] Menghapus cache lama:', key);
          return caches.delete(key);
        }
      }));
    })
  );
  self.clients.claim(); // Mengambil kendali atas semua tab
});

// 3. FETCH: Strategi Network-First untuk Data, Cache-First untuk Aset
self.addEventListener('fetch', (e) => {
  // Selalu ambil data terbaru dari Google Sheets (Bypass cache)
  if (e.request.url.includes('script.google.com')) {
    e.respondWith(fetch(e.request));
    return;
  }

  // Untuk file lainnya: Cek cache dulu, kalau tidak ada baru ambil dari network
  e.respondWith(
    caches.match(e.request).then((res) => {
      return res || fetch(e.request);
    })
  );
});
