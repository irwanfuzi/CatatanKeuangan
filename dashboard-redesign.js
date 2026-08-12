(() => {
  'use strict';

  const BLUE = '#1769FF';
  const GOLD = '#FFB901';
  const NAVY = '#1E293B';
  const BG = '#F7F9FC';

  const css = `
  #mkRedesignRoot{font-family:'Plus Jakarta Sans',sans-serif;color:${NAVY}}
  #mkRedesignRoot *{box-sizing:border-box}
  .mk-tab-view{position:fixed;inset:0;z-index:9990;background:${BG};overflow:auto;padding:18px 16px 105px;display:none}
  .mk-tab-view.mk-active{display:block;animation:mkFade .22s ease}
  @keyframes mkFade{from{opacity:0;transform:translateY(5px)}to{opacity:1;transform:none}}
  .mk-wrap{width:100%;max-width:448px;margin:0 auto}
  .mk-top{display:flex;align-items:center;justify-content:space-between;margin:2px 0 18px}
  .mk-kicker{font-size:11px;font-weight:800;color:#94A3B8;letter-spacing:.02em;text-transform:uppercase}
  .mk-title{margin:3px 0 0;font-family:'Urbanist',sans-serif;font-size:27px;line-height:1.05;font-weight:900;letter-spacing:-.8px;color:${NAVY}}
  .mk-icon{width:40px;height:40px;border:1px solid #E8EDF4;border-radius:14px;background:#fff;display:flex;align-items:center;justify-content:center;color:${NAVY};box-shadow:0 5px 16px rgba(15,23,42,.04)}
  .mk-card{background:#fff;border:1px solid #E9EEF5;border-radius:22px;box-shadow:0 7px 22px rgba(15,23,42,.045)}
  .mk-pad{padding:16px}
  .mk-label{font-size:11px;color:#94A3B8;font-weight:700}
  .mk-value{font-family:'Urbanist',sans-serif;font-size:24px;font-weight:900;letter-spacing:-.5px;color:${NAVY}}
  .mk-row{display:flex;align-items:center;justify-content:space-between;gap:10px}
  .mk-chip{display:inline-flex;align-items:center;gap:5px;padding:6px 9px;border-radius:999px;background:#EAF2FF;color:${BLUE};font-size:10px;font-weight:800}
  .mk-chart{height:155px;position:relative;margin-top:12px;overflow:hidden;border-radius:16px;background:linear-gradient(180deg,#F5F8FF 0%,#fff 100%)}
  .mk-chart svg{width:100%;height:100%;display:block}
  .mk-stat-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px;margin-top:10px}
  .mk-stat{padding:14px;border-radius:18px;background:#fff;border:1px solid #E9EEF5}
  .mk-stat strong{display:block;margin-top:5px;font-family:'Urbanist',sans-serif;font-size:17px;font-weight:900}
  .mk-section{margin-top:18px}
  .mk-section-title{font-family:'Urbanist',sans-serif;font-size:16px;font-weight:900;margin:0 0 10px}
  .mk-bars{display:flex;align-items:flex-end;gap:9px;height:115px;padding:12px 4px 8px}
  .mk-bar-col{height:100%;flex:1;display:flex;flex-direction:column;align-items:center;justify-content:flex-end;gap:6px}
  .mk-bar{width:100%;max-width:28px;border-radius:8px 8px 4px 4px;background:#DCE8FF;min-height:8px}
  .mk-bar.active{background:${BLUE}}
  .mk-bar-col span{font-size:9px;color:#94A3B8;font-weight:700}
  .mk-list{display:flex;flex-direction:column}
  .mk-list-item{display:flex;align-items:center;gap:12px;padding:13px 0}
  .mk-list-item+.mk-list-item{border-top:1px solid #EEF2F7}
  .mk-avatar{width:40px;height:40px;border-radius:14px;display:flex;align-items:center;justify-content:center;flex:0 0 auto;font-size:16px}
  .mk-list-main{min-width:0;flex:1}.mk-list-main b{display:block;font-size:12px;font-weight:800;color:${NAVY}}.mk-list-main span{display:block;margin-top:3px;font-size:9px;color:#94A3B8;font-weight:600}
  .mk-list-amount{text-align:right;font-family:'Urbanist',sans-serif;font-size:12px;font-weight:900}.mk-minus{color:#EF4444}.mk-plus{color:#0FA968}
  .mk-wallet-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:10px}
  .mk-wallet{padding:15px;border-radius:21px;background:#fff;border:1px solid #E9EEF5;box-shadow:0 7px 20px rgba(15,23,42,.04);min-height:142px}
  .mk-wallet-icon{width:43px;height:43px;border-radius:14px;display:flex;align-items:center;justify-content:center;margin-bottom:12px}
  .mk-wallet-name{font-size:11px;font-weight:800}.mk-wallet-money{margin-top:4px;font-family:'Urbanist',sans-serif;font-size:16px;font-weight:900;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
  .mk-wallet-meta{margin-top:8px;font-size:9px;color:#94A3B8;font-weight:600}
  .mk-profile-hero{padding:20px;display:flex;align-items:center;gap:14px}
  .mk-profile-avatar{width:62px;height:62px;border-radius:21px;background:${BLUE};color:#fff;display:flex;align-items:center;justify-content:center;font-family:'Urbanist',sans-serif;font-size:24px;font-weight:900;box-shadow:0 10px 22px rgba(23,105,255,.2)}
  .mk-profile-name{font-family:'Urbanist',sans-serif;font-size:20px;font-weight:900}.mk-profile-sub{font-size:10px;color:#94A3B8;margin-top:4px;font-weight:600}
  .mk-menu{margin-top:12px;overflow:hidden}.mk-menu button{width:100%;border:0;background:#fff;padding:15px 16px;display:flex;align-items:center;gap:12px;text-align:left;color:${NAVY};font:700 11px 'Plus Jakarta Sans',sans-serif}.mk-menu button+button{border-top:1px solid #EEF2F7}.mk-menu i{width:32px;height:32px;border-radius:11px;background:#F1F5F9;color:${NAVY};display:flex;align-items:center;justify-content:center}.mk-menu .danger{color:#DC2626}.mk-menu .danger i{background:#FEF2F2;color:#DC2626}
  #mkRedesignNav{position:fixed;left:50%;bottom:0;transform:translateX(-50%);width:100%;max-width:448px;height:72px;padding:0 8px env(safe-area-inset-bottom);z-index:10000;background:rgba(255,255,255,.97);border-top:1px solid #E8EDF3;box-shadow:0 -8px 24px rgba(15,23,42,.06);backdrop-filter:blur(18px);display:grid;grid-template-columns:1fr 1fr 1.18fr 1fr 1fr}
  .mk-nav-btn{border:0;background:transparent;color:#94A3B8;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:4px;font:700 9px 'Plus Jakarta Sans',sans-serif}.mk-nav-btn i{font-size:19px}.mk-nav-btn.active{color:${BLUE}}
  .mk-nav-add{width:58px;height:50px;border:4px solid ${BG};border-radius:19px;background:${BLUE};color:#fff;display:flex;align-items:center;justify-content:center;font-size:22px;box-shadow:0 11px 24px rgba(23,105,255,.28);margin-top:-22px}
  @media(max-width:370px){.mk-tab-view{padding-left:12px;padding-right:12px}.mk-title{font-size:24px}.mk-wallet-grid{gap:7px}.mk-wallet{padding:13px}.mk-wallet-money{font-size:14px}}
  `;

  const root = document.createElement('div');
  root.id = 'mkRedesignRoot';
  root.innerHTML = `
    <style>${css}</style>
    <section id="mkAnalysis" class="mk-tab-view">
      <div class="mk-wrap">
        <div class="mk-top"><div><div class="mk-kicker">MyKas</div><h1 class="mk-title">Analisis</h1></div><div class="mk-icon"><i class="fa-solid fa-sliders"></i></div></div>
        <div class="mk-card mk-pad">
          <div class="mk-row"><div><div class="mk-label">Total pengeluaran</div><div class="mk-value">Rp 3.240.000</div></div><span class="mk-chip"><i class="fa-solid fa-arrow-trend-down"></i> 8,4%</span></div>
          <div class="mk-chart"><svg viewBox="0 0 420 155" preserveAspectRatio="none"><defs><linearGradient id="mkFill" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1769FF" stop-opacity=".18"/><stop offset="1" stop-color="#1769FF" stop-opacity="0"/></linearGradient></defs><path d="M0 123 C42 118 58 92 91 101 S145 121 175 80 S223 62 249 76 S295 95 323 49 S369 36 420 20 L420 155 L0 155 Z" fill="url(#mkFill)"/><path d="M0 123 C42 118 58 92 91 101 S145 121 175 80 S223 62 249 76 S295 95 323 49 S369 36 420 20" fill="none" stroke="#1769FF" stroke-width="4" stroke-linecap="round"/></svg></div>
        </div>
        <div class="mk-stat-grid"><div class="mk-stat"><div class="mk-label">Pemasukan</div><strong class="mk-plus">Rp 7.850.000</strong></div><div class="mk-stat"><div class="mk-label">Tabungan</div><strong>Rp 1.420.000</strong></div></div>
        <div class="mk-section"><h2 class="mk-section-title">Pengeluaran per kategori</h2><div class="mk-card mk-pad"><div class="mk-bars"><div class="mk-bar-col"><div class="mk-bar" style="height:45%"></div><span>Makan</span></div><div class="mk-bar-col"><div class="mk-bar active" style="height:82%"></div><span>Belanja</span></div><div class="mk-bar-col"><div class="mk-bar" style="height:56%"></div><span>Tagihan</span></div><div class="mk-bar-col"><div class="mk-bar" style="height:34%"></div><span>Transport</span></div><div class="mk-bar-col"><div class="mk-bar" style="height:24%"></div><span>Lainnya</span></div></div></div></div>
        <div class="mk-section"><h2 class="mk-section-title">Insight bulan ini</h2><div class="mk-card mk-pad"><div class="mk-row"><div><div class="mk-label">Pola pengeluaran</div><div style="margin-top:5px;font-size:11px;font-weight:800">Belanja jadi kategori terbesar.</div></div><div class="mk-icon" style="background:#EAF2FF;color:${BLUE};border:0"><i class="fa-solid fa-lightbulb"></i></div></div></div></div>
      </div>
    </section>
    <section id="mkWallet" class="mk-tab-view">
      <div class="mk-wrap">
        <div class="mk-top"><div><div class="mk-kicker">MyKas</div><h1 class="mk-title">Dompet</h1></div><div class="mk-icon"><i class="fa-solid fa-plus"></i></div></div>
        <div class="mk-card mk-pad"><div class="mk-label">Total saldo</div><div class="mk-value" style="font-size:30px;margin-top:4px">Rp 12.480.000</div><div style="margin-top:9px;font-size:10px;color:#64748B;font-weight:600">4 tempat penyimpanan aktif</div></div>
        <div class="mk-section"><div class="mk-row" style="margin-bottom:10px"><h2 class="mk-section-title" style="margin:0">Semua dompet</h2><span class="mk-label">4 akun</span></div><div class="mk-wallet-grid">
          <div class="mk-wallet"><div class="mk-wallet-icon" style="background:#FFF7DE;color:#E9A400"><i class="fa-solid fa-money-bill-wave"></i></div><div class="mk-wallet-name">Cash</div><div class="mk-wallet-money">Rp 1.850.000</div><div class="mk-wallet-meta">Saldo tersedia</div></div>
          <div class="mk-wallet"><div class="mk-wallet-icon" style="background:#EEF2F7;color:${NAVY}"><i class="fa-solid fa-building-columns"></i></div><div class="mk-wallet-name">Bank</div><div class="mk-wallet-money">Rp 6.430.000</div><div class="mk-wallet-meta">Saldo tersedia</div></div>
          <div class="mk-wallet"><div class="mk-wallet-icon" style="background:#EAF2FF;color:${BLUE}"><i class="fa-solid fa-wallet"></i></div><div class="mk-wallet-name">E-Wallet</div><div class="mk-wallet-money">Rp 2.200.000</div><div class="mk-wallet-meta">Saldo tersedia</div></div>
          <div class="mk-wallet"><div class="mk-wallet-icon" style="background:#F6ECFF;color:#9B3BDE"><i class="fa-solid fa-piggy-bank"></i></div><div class="mk-wallet-name">Tabungan</div><div class="mk-wallet-money">Rp 2.000.000</div><div class="mk-wallet-meta">Saldo tersedia</div></div>
        </div></div>
        <div class="mk-section"><h2 class="mk-section-title">Aktivitas terbaru</h2><div class="mk-card mk-pad"><div class="mk-list"><div class="mk-list-item"><div class="mk-avatar" style="background:#FEF2F2;color:#EF4444"><i class="fa-solid fa-arrow-up"></i></div><div class="mk-list-main"><b>Belanja bulanan</b><span>Bank • Hari ini</span></div><div class="mk-list-amount mk-minus">- Rp 450.000</div></div><div class="mk-list-item"><div class="mk-avatar" style="background:#ECFDF5;color:#0FA968"><i class="fa-solid fa-arrow-down"></i></div><div class="mk-list-main"><b>Gaji</b><span>Bank • Kemarin</span></div><div class="mk-list-amount mk-plus">+ Rp 7.500.000</div></div></div></div></div>
      </div>
    </section>
    <section id="mkProfile" class="mk-tab-view">
      <div class="mk-wrap">
        <div class="mk-top"><div><div class="mk-kicker">MyKas</div><h1 class="mk-title">Profil</h1></div><div class="mk-icon"><i class="fa-solid fa-gear"></i></div></div>
        <div class="mk-card mk-profile-hero"><div class="mk-profile-avatar">A</div><div><div class="mk-profile-name">Akun Saya</div><div class="mk-profile-sub">Kelola akun dan preferensi MyKas</div></div></div>
        <div class="mk-card mk-menu">
          <button><i class="fa-solid fa-user"></i><span>Edit profil</span><i class="fa-solid fa-chevron-right" style="margin-left:auto;background:none;color:#94A3B8;width:auto"></i></button>
          <button><i class="fa-solid fa-shield-halved"></i><span>Keamanan & biometrik</span><i class="fa-solid fa-chevron-right" style="margin-left:auto;background:none;color:#94A3B8;width:auto"></i></button>
          <button><i class="fa-solid fa-bell"></i><span>Notifikasi</span><i class="fa-solid fa-chevron-right" style="margin-left:auto;background:none;color:#94A3B8;width:auto"></i></button>
          <button><i class="fa-solid fa-palette"></i><span>Tampilan</span><i class="fa-solid fa-chevron-right" style="margin-left:auto;background:none;color:#94A3B8;width:auto"></i></button>
          <button class="danger"><i class="fa-solid fa-right-from-bracket"></i><span>Keluar</span><i class="fa-solid fa-chevron-right" style="margin-left:auto;background:none;color:#FCA5A5;width:auto"></i></button>
        </div>
        <div class="mk-section"><div class="mk-card mk-pad" style="text-align:center"><div class="mk-label">MyKas</div><div style="font-family:Urbanist;font-size:14px;font-weight:900;margin-top:3px">Own Your Money</div><div style="font-size:9px;color:#94A3B8;margin-top:4px">Versi aplikasi 1.0</div></div></div>
      </div>
    </section>
    <nav id="mkRedesignNav" aria-label="Navigasi utama">
      <button class="mk-nav-btn" data-tab="home"><i class="fa-solid fa-house"></i><span>Beranda</span></button>
      <button class="mk-nav-btn" data-tab="analysis"><i class="fa-solid fa-chart-pie"></i><span>Analisis</span></button>
      <div style="display:flex;align-items:center;justify-content:center"><button id="mkNavAdd" class="mk-nav-add" aria-label="Tambah transaksi"><i class="fa-solid fa-plus"></i></button></div>
      <button class="mk-nav-btn" data-tab="wallet"><i class="fa-solid fa-wallet"></i><span>Dompet</span></button>
      <button class="mk-nav-btn" data-tab="profile"><i class="fa-solid fa-user"></i><span>Profil</span></button>
    </nav>
  `;

  function showTab(tab) {
    document.querySelectorAll('.mk-tab-view').forEach(v => v.classList.remove('mk-active'));
    document.querySelectorAll('.mk-nav-btn').forEach(v => v.classList.remove('active'));
    if (tab === 'analysis') document.getElementById('mkAnalysis').classList.add('mk-active');
    if (tab === 'wallet') document.getElementById('mkWallet').classList.add('mk-active');
    if (tab === 'profile') document.getElementById('mkProfile').classList.add('mk-active');
    const btn = document.querySelector(`.mk-nav-btn[data-tab="${tab}"]`);
    if (btn) btn.classList.add('active');
    if (tab === 'home') {
      document.querySelectorAll('.mk-tab-view').forEach(v => v.classList.remove('mk-active'));
      const app = document.getElementById('appCanvasWrapper');
      if (app) app.style.display = '';
    } else {
      const app = document.getElementById('appCanvasWrapper');
      if (app) app.style.display = 'none';
    }
  }

  function init() {
    if (document.getElementById('mkRedesignRoot')) return;
    document.body.appendChild(root);
    document.querySelectorAll('.mk-nav-btn').forEach(btn => btn.addEventListener('click', () => showTab(btn.dataset.tab)));
    document.getElementById('mkNavAdd').addEventListener('click', () => {
      const candidates = ['#btnTambahTransaksi','#btnAddTransaction','#btnTambah','#btnTriggerTambah','[data-action="add-transaction"]'];
      const target = candidates.map(s => document.querySelector(s)).find(Boolean);
      if (target) target.click();
      else if (typeof window.openTransactionModal === 'function') window.openTransactionModal();
      else if (typeof window.tambahTransaksi === 'function') window.tambahTransaksi();
    });
    showTab('home');
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init, {once:true});
  else init();
})();
