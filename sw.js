// ==========================================
// 1. SERVICE WORKER PWA (MYKAS V6)
// ==========================================
const CACHE_NAME = 'mykas-pwa-v6';
const ASSETS_TO_CACHE = [
  './', './index.html', './manifest.json', './logo.svg', './wallet-white.svg',
  './mykas-text-white.svg', './icon-192.png', './icon-512.png', './icon.png'
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
      fetch(event.request, { cache: 'no-store' }).then(async (networkResponse) => {
        const contentType = networkResponse.headers.get('content-type') || '';
        if (!contentType.includes('text/html')) return networkResponse;

        const html = await networkResponse.text();
        const response = new Response(html, {
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

// ==========================================
// 2. LOGIC JS INSIGHT KEUANGAN DINAMIS
// ==========================================

/**
 * Memperbarui tampilan Insight Keuangan sesuai statistik transaksi/budget
 * @param {number} rasioPengeluaran - Persentase vs minggu lalu (+% membengkak / -% hemat)
 * @param {number} sisaBudgetPersen - Persentase sisa budget saat ini (0-100)
 */
function updateInsightKeuangan(rasioPengeluaran = -15, sisaBudgetPersen = 47) {
  const iconInsightBox = document.getElementById('iconInsightBox');
  const iconInsight = document.getElementById('iconInsight');
  const txtPesanInsight = document.getElementById('txtPesanInsight');
  const boxStatusPerforma = document.getElementById('boxStatusPerforma');
  const txtStatusPerforma = document.getElementById('txtStatusPerforma');
  const lblInsightHeader = document.getElementById('lblInsightHeader');

  // Pastikan elemen ada di DOM sebelum mengubah
  if (!txtPesanInsight) return;

  // KONDISI A: Sisa Budget Kritis (<= 15%)
  if (sisaBudgetPersen <= 15) {
    if (lblInsightHeader) {
      lblInsightHeader.innerText = "PERINGATAN BUDGET";
      lblInsightHeader.className = "text-[10px] font-black uppercase tracking-wider text-rose-500 block";
    }
    
    if (iconInsightBox) {
      iconInsightBox.className = "w-10 h-10 rounded-2xl bg-rose-500 text-white flex items-center justify-center text-base shrink-0 shadow-md shadow-rose-500/20";
    }
    if (iconInsight) {
      iconInsight.className = "fa-solid fa-triangle-exclamation";
    }
    
    txtPesanInsight.innerHTML = `Sisa budget kamu tinggal <span class="font-black text-rose-500">${sisaBudgetPersen}%</span>. Rem pengeluaran dulu ya! ⚠️`;
    
    if (boxStatusPerforma) {
      boxStatusPerforma.className = "bg-rose-50 dark:bg-rose-950/40 p-2.5 rounded-xl border border-rose-100 dark:border-rose-900/50 flex items-center justify-between";
    }
    if (txtStatusPerforma) {
      txtStatusPerforma.innerText = "Kritis 🚨";
      txtStatusPerforma.className = "text-[10px] font-black text-rose-500";
    }
  } 
  // KONDISI B: Pengeluaran Membengkak (> 0%)
  else if (rasioPengeluaran > 0) {
    if (lblInsightHeader) {
      lblInsightHeader.innerText = "EVALUASI PENGELUARAN";
      lblInsightHeader.className = "text-[10px] font-black uppercase tracking-wider text-amber-500 block";
    }

    if (iconInsightBox) {
      iconInsightBox.className = "w-10 h-10 rounded-2xl bg-amber-500 text-amber-950 flex items-center justify-center text-base shrink-0 shadow-md shadow-amber-500/20";
    }
    if (iconInsight) {
      iconInsight.className = "fa-solid fa-arrow-trend-up";
    }
    
    txtPesanInsight.innerHTML = `Pengeluaran kamu <span class="font-black text-amber-600 dark:text-amber-400">${rasioPengeluaran}% lebih tinggi</span> dari minggu lalu.`;
    
    if (boxStatusPerforma) {
      boxStatusPerforma.className = "bg-amber-50 dark:bg-amber-950/40 p-2.5 rounded-xl border border-amber-100 dark:border-amber-900/50 flex items-center justify-between";
    }
    if (txtStatusPerforma) {
      txtStatusPerforma.innerText = "Perlu Diperhatikan ⚠️";
      txtStatusPerforma.className = "text-[10px] font-black text-amber-600 dark:text-amber-400";
    }
  } 
  // KONDISI C: Keuangan Aman & Hemat (≤ 0%)
  else {
    if (lblInsightHeader) {
      lblInsightHeader.innerText = "INSIGHT MINGGU INI";
      lblInsightHeader.className = "text-[10px] font-black uppercase tracking-wider text-[#0052FF] dark:text-blue-400 block";
    }

    if (iconInsightBox) {
      iconInsightBox.className = "w-10 h-10 rounded-2xl bg-[#0052FF] text-white flex items-center justify-center text-base shrink-0 shadow-md shadow-blue-500/20";
    }
    if (iconInsight) {
      iconInsight.className = "fa-solid fa-chart-line";
    }
    
    txtPesanInsight.innerHTML = `Pengeluaran kamu <span class="font-black text-[#0052FF] dark:text-blue-400">${Math.abs(rasioPengeluaran)}% lebih hemat</span> dibanding minggu lalu.`;
    
    if (boxStatusPerforma) {
      boxStatusPerforma.className = "bg-blue-50 dark:bg-blue-950/40 p-2.5 rounded-xl border border-blue-100 dark:border-blue-900/50 flex items-center justify-between";
    }
    if (txtStatusPerforma) {
      txtStatusPerforma.innerText = "Sangat Baik 👍";
      txtStatusPerforma.className = "text-[10px] font-black text-[#0052FF] dark:text-blue-400";
    }
  }
}
