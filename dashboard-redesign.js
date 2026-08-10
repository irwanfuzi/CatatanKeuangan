(() => {
  const style = document.createElement('style');
  style.textContent = `
    #screenDashboard{background:#f8fafc!important}
    #screenDashboard .dashboard-modern-section{border-radius:21px!important}
    #screenDashboard .modern-shadow{box-shadow:0 8px 22px -18px rgba(15,23,42,.45)!important}
    #screenDashboard .modern-title{font-size:17px!important;font-weight:800!important;letter-spacing:-.02em!important}
    #screenDashboard .modern-card{border:1px solid #f1f5f9!important;border-radius:19px!important;background:#fff!important;box-shadow:0 6px 18px -14px rgba(15,23,42,.35)!important}
    #screenDashboard .hero-modern{border-radius:25px!important;min-height:190px!important;overflow:hidden!important;position:relative!important;background:linear-gradient(135deg,#0052ff,#0a4be0 55%,#003cc4)!important;box-shadow:0 18px 38px -20px rgba(0,82,255,.7)!important}
    #screenDashboard .hero-modern:after{content:"";position:absolute;inset:0 0 0 45%;opacity:.22;background-image:radial-gradient(circle,#fff 1.5px,transparent 1.5px);background-size:16px 16px;mask-image:linear-gradient(90deg,transparent,#000 35%);-webkit-mask-image:linear-gradient(90deg,transparent,#000 35%);pointer-events:none}
    #screenDashboard .wallet-visual{width:112px;height:100px;position:relative;flex:none}
    #screenDashboard .wallet-back{position:absolute;width:82px;height:64px;left:7px;top:18px;border-radius:20px;background:linear-gradient(135deg,#6ea4ff,#1859e8);transform:rotate(-10deg);box-shadow:0 14px 20px -8px rgba(0,0,0,.4);border:1px solid rgba(255,255,255,.25)}
    #screenDashboard .wallet-front{position:absolute;width:78px;height:61px;left:2px;top:24px;border-radius:19px;background:#2164f2;transform:rotate(-10deg);box-shadow:0 10px 18px -8px rgba(0,0,0,.35);border:1px solid rgba(255,255,255,.2)}
    #screenDashboard .wallet-strap{position:absolute;width:62px;height:31px;right:0;top:43px;border-radius:16px 10px 10px 16px;background:#ffb901;transform:rotate(-2deg);box-shadow:0 8px 12px -6px rgba(0,0,0,.35);display:flex;align-items:center;padding-left:8px}
    #screenDashboard .wallet-strap:before{content:"";width:20px;height:20px;border-radius:50%;background:#fff;border:1px solid #e2e8f0;box-shadow:0 2px 4px rgba(0,0,0,.08)}
    #screenDashboard #mainFixedNavbar{height:72px!important;border-top:1px solid rgba(226,232,240,.85)!important}
    #screenDashboard #mainFixedNavbar button i{font-size:19px!important}
    #screenDashboard #mainFixedNavbar>div button{width:54px!important;height:54px!important;transform:translateY(-12px)!important;border:5px solid #f8fafc!important}
    @media(max-width:390px){#screenDashboard .wallet-visual{display:none!important}#screenDashboard .hero-modern{min-height:178px!important}#screenDashboard #txtSaldo{font-size:30px!important}}
    @media(min-width:768px){#screenDashboard{border-radius:2.5rem}}
  `;
  document.head.appendChild(style);

  function redesign() {
    const dashboard = document.getElementById('screenDashboard');
    if (!dashboard) return;

    const header = dashboard.querySelector('.sticky.top-0');
    if (header) {
      header.className = 'w-full px-5 pt-4 pb-3 flex items-center justify-between bg-white/95 dark:bg-[#0B132B]/95 backdrop-blur-xl sticky top-0 z-30 border-b border-slate-100/70 dark:border-slate-800/70';
      const logo = header.querySelector('.fa-wallet')?.parentElement;
      if (logo) logo.className = 'w-10 h-10 rounded-[13px] bg-[#0052FF] flex items-center justify-center text-white flex-shrink-0';
      const brand = header.querySelector('.font-urbanist');
      if (brand) brand.className += ' !text-[25px] !tracking-[-0.04em]';
    }

    const content = dashboard.querySelector('.flex-1.overflow-y-auto > div:last-child');
    if (content) content.className = 'w-full px-5 pt-4 pb-28 flex flex-col gap-5';

    const sections = dashboard.querySelectorAll('#screenDashboard section');
    sections.forEach(s => s.classList.add('dashboard-modern-section'));

    const hero = dashboard.querySelector('#txtSaldo')?.closest('.w-full');
    if (hero && !hero.classList.contains('hero-modern')) {
      hero.classList.add('hero-modern');
      hero.className = 'hero-modern w-full text-white relative';
      const inner = document.createElement('div');
      inner.className = 'relative z-10 min-h-[190px] p-5 sm:p-6 flex items-center justify-between gap-3';
      const left = document.createElement('div');
      left.className = 'min-w-0 flex-1 flex flex-col justify-center';
      left.innerHTML = `
        <div class="flex items-center gap-2 text-blue-100"><span class="text-[13px] font-semibold">Total Aset</span><button type="button" onclick="window.toggleSembunyikanSaldo()" class="text-blue-100/90"><i id="iconToggleSaldo" class="fa-regular fa-eye text-[14px]"></i></button></div>
        <h2 id="txtSaldo" class="text-[34px] sm:text-[38px] font-black tracking-[-0.04em] text-white my-1.5 font-urbanist leading-none truncate">Rp12.500.000</h2>
        <div class="flex items-center gap-2 mt-2"><div class="inline-flex items-center gap-1.5 px-2.5 py-1 bg-emerald-50 rounded-full text-emerald-600 text-[11px] font-extrabold"><i class="fa-solid fa-arrow-up text-[9px]"></i><span>12,5%</span></div><span class="text-[11px] text-blue-100/90 font-medium">dari bulan lalu</span></div>
        <div class="flex items-center gap-1.5 text-[10px] text-blue-100/75 font-medium mt-4"><i class="fa-regular fa-clock text-[10px]"></i><span>Diperbarui 09.30 WIB</span></div>`;
      const wallet = document.createElement('div');
      wallet.className = 'wallet-visual';
      wallet.innerHTML = '<div class="wallet-back"></div><div class="wallet-front"></div><div class="wallet-strap"></div>';
      inner.append(left, wallet);
      hero.replaceChildren(inner);
    }

    const headings = dashboard.querySelectorAll('h3');
    headings.forEach(h => { if (['Dompet Saya','Quick Action'].includes(h.textContent.trim())) h.classList.add('modern-title'); });

    dashboard.querySelectorAll('#listRiwayat, #loadingRiwayat').forEach(x => x.classList.add('modern-list'));
    const budget = [...dashboard.querySelectorAll('h3')].find(x => x.textContent.includes('Sisa Budget'))?.closest('[class*="col-span-5"]');
    if (budget) budget.classList.add('modern-card','modern-shadow');

    dashboard.querySelectorAll('[class*="col-span-7"]').forEach(x => x.classList.add('modern-card','modern-shadow'));
    dashboard.querySelectorAll('[onclick*="pilihDompetTab"]').forEach(x => x.classList.add('modern-card'));
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', redesign, {once:true});
  else redesign();
  setTimeout(redesign, 500);
})();
