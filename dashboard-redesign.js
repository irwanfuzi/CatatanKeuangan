(() => {
  const style = document.createElement('style');
  style.textContent = `
    :root{--mk-blue:#0052FF;--mk-gold:#FFB901;--mk-navy:#1E293B;--mk-bg:#F8FAFC}
    #screenDashboard{background:var(--mk-bg)!important}
    #screenDashboard .dashboard-modern-section{border-radius:21px!important}
    #screenDashboard .modern-title{font-size:17px!important;font-weight:800!important;letter-spacing:-.025em!important;color:var(--mk-navy)!important}
    #screenDashboard .modern-card{border:1px solid #eef2f7!important;border-radius:19px!important;background:#fff!important;box-shadow:0 8px 24px -18px rgba(15,23,42,.34)!important}

    /* HERO — styling only. Existing live data remains untouched. */
    #screenDashboard .hero-modern{
      border-radius:24px!important;min-height:184px!important;overflow:hidden!important;position:relative!important;
      background:linear-gradient(135deg,#0757ff 0%,#0052ff 58%,#0645d8 100%)!important;
      box-shadow:0 18px 36px -22px rgba(0,82,255,.72)!important;
    }
    #screenDashboard .hero-modern:after{
      content:"";position:absolute;inset:0 0 0 48%;opacity:.20;pointer-events:none;
      background-image:radial-gradient(circle,rgba(255,255,255,.85) 1.4px,transparent 1.5px);
      background-size:16px 16px;mask-image:linear-gradient(90deg,transparent,#000 30%);
      -webkit-mask-image:linear-gradient(90deg,transparent,#000 30%);
    }
    #screenDashboard .hero-modern > *{position:relative;z-index:2}
    #screenDashboard .hero-wallet-art{position:absolute!important;right:18px!important;top:50%!important;transform:translateY(-50%)!important;width:112px!important;height:102px!important;z-index:3!important;pointer-events:none!important;filter:drop-shadow(0 12px 12px rgba(0,0,0,.18))}
    #screenDashboard .hero-wallet-art svg{width:100%;height:100%;display:block}
    #screenDashboard .hero-data-safe{position:relative;z-index:4;max-width:68%;}
    #screenDashboard #txtSaldo{font-size:34px!important;line-height:1.05!important;letter-spacing:-.045em!important;font-weight:900!important}
    #screenDashboard .hero-modern .text-blue-100{color:rgba(255,255,255,.88)!important}
    #screenDashboard .hero-modern .text-blue-100\/75{color:rgba(255,255,255,.72)!important}

    /* Header */
    #screenDashboard .mk-header{min-height:70px!important;padding:12px 20px 10px!important;background:rgba(255,255,255,.97)!important;border-bottom:1px solid #f1f5f9!important}
    #screenDashboard .mk-logo-mark{width:42px;height:42px;display:flex;align-items:center;justify-content:center;flex:none}
    #screenDashboard .mk-logo-mark svg{width:42px;height:42px;display:block}
    #screenDashboard .mk-brand{font-family:'Urbanist',sans-serif!important;font-size:25px!important;font-weight:900!important;letter-spacing:-.045em!important}
    #screenDashboard .mk-brand-my{color:#0052FF!important}.mk-brand-kas{color:#FFB901!important}

    /* Wallet cards */
    #screenDashboard [onclick*="pilihDompetTab"]{border-radius:18px!important;border:1px solid #f1f5f9!important;box-shadow:0 7px 18px -16px rgba(15,23,42,.35)!important;background:#fff!important}
    #screenDashboard [onclick*="pilihDompetTab"] i{font-size:18px!important}

    /* Quick actions: clean outlined fintech icon language */
    #screenDashboard .quick-action-item i,#screenDashboard .quick-action-item svg{color:#0052FF!important}
    #screenDashboard .quick-action-item{min-height:78px!important}

    /* Recent + budget remain side-by-side; improve density without changing data. */
    #screenDashboard .modern-shadow{box-shadow:0 8px 22px -18px rgba(15,23,42,.36)!important}
    #screenDashboard #listRiwayat{padding-bottom:2px!important}

    /* Integrated bottom action dock */
    #mainFixedNavbar{
      height:70px!important;bottom:0!important;background:rgba(255,255,255,.98)!important;
      border-top:1px solid rgba(226,232,240,.9)!important;box-shadow:0 -10px 28px -24px rgba(15,23,42,.45)!important;
      display:grid!important;grid-template-columns:repeat(5,minmax(0,1fr))!important;align-items:center!important;
      overflow:visible!important;padding-bottom:env(safe-area-inset-bottom)!important;
    }
    #mainFixedNavbar button{height:58px!important;width:100%!important;display:flex!important;flex-direction:column!important;align-items:center!important;justify-content:center!important;gap:3px!important;position:relative!important;background:transparent!important;border:0!important;box-shadow:none!important;transform:none!important}
    #mainFixedNavbar button i{font-size:20px!important;line-height:1!important}
    #mainFixedNavbar button span,#mainFixedNavbar button div{font-size:9px!important;font-weight:700!important}
    #mainFixedNavbar .mk-fab-dock{
      position:absolute!important;left:50%!important;top:-32px!important;transform:translateX(-50%)!important;
      width:70px!important;height:64px!important;border-radius:20px 20px 18px 18px!important;
      background:#0052FF!important;color:#fff!important;border:5px solid var(--mk-bg)!important;
      box-shadow:0 12px 24px -10px rgba(0,82,255,.72)!important;z-index:20!important;
    }
    #mainFixedNavbar .mk-fab-dock i{font-size:30px!important;color:#fff!important}
    #mainFixedNavbar .mk-fab-dock span,#mainFixedNavbar .mk-fab-dock div{display:none!important}
    #mainFixedNavbar .mk-nav-active{color:#0052FF!important}
    #mainFixedNavbar .mk-nav-muted{color:#94A3B8!important}

    @media(max-width:390px){
      #screenDashboard .hero-wallet-art{right:8px!important;width:94px!important;height:88px!important}
      #screenDashboard .hero-data-safe{max-width:72%}
      #screenDashboard #txtSaldo{font-size:30px!important}
      #screenDashboard .mk-brand{font-size:23px!important}
    }
    @media(min-width:768px){#screenDashboard{border-radius:2.5rem}}
  `;
  document.head.appendChild(style);

  const walletSvg = `
    <svg viewBox="0 0 160 130" aria-hidden="true">
      <defs>
        <linearGradient id="mkWalletBlue" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#74A7FF"/><stop offset=".45" stop-color="#2D6BFF"/><stop offset="1" stop-color="#0B49D8"/></linearGradient>
        <linearGradient id="mkWalletFace" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#2E73FF"/><stop offset="1" stop-color="#0646DB"/></linearGradient>
        <linearGradient id="mkWalletGold" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FFD34A"/><stop offset="1" stop-color="#F39A00"/></linearGradient>
      </defs>
      <g transform="translate(7 4) rotate(-7 74 60)">
        <rect x="22" y="13" width="96" height="86" rx="24" fill="url(#mkWalletBlue)" opacity=".95"/>
        <rect x="15" y="25" width="98" height="82" rx="22" fill="url(#mkWalletFace)"/>
        <path d="M37 27h66c13 0 23 10 23 23v35c0 13-10 23-23 23H37c-12 0-22-10-22-22V49c0-12 10-22 22-22Z" fill="#1D5FEF"/>
        <path d="M97 48h34c8 0 14 6 14 14v22c0 8-6 14-14 14H97c-8 0-14-6-14-14V62c0-8 6-14 14-14Z" fill="url(#mkWalletGold)"/>
        <circle cx="105" cy="73" r="10" fill="#fff" opacity=".95"/>
      </g>
    </svg>`;

  const logoSvg = `
    <svg viewBox="0 0 96 72" aria-hidden="true">
      <defs><linearGradient id="mkLogoBlue" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#246BFF"/><stop offset="1" stop-color="#0649D9"/></linearGradient><linearGradient id="mkLogoGold" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#FFD34A"/><stop offset="1" stop-color="#F39A00"/></linearGradient></defs>
      <path d="M18 10h44c8 0 14 6 14 14v32c0 8-6 14-14 14H18c-8 0-14-6-14-14V24c0-8 6-14 14-14Z" fill="url(#mkLogoBlue)"/>
      <path d="M20 20h37c9 0 17 7 17 16v18c0 7-6 13-13 13H20c-6 0-11-5-11-11V31c0-6 5-11 11-11Z" fill="#fff"/>
      <path d="M56 33h24c7 0 12 5 12 12v12c0 7-5 12-12 12H56c-7 0-12-5-12-12V45c0-7 5-12 12-12Z" fill="url(#mkLogoGold)"/>
      <circle cx="60" cy="51" r="5" fill="#fff"/>
    </svg>`;

  function getHeader(dashboard){
    return dashboard.querySelector('.sticky.top-0') || dashboard.querySelector('header');
  }

  function redesignHeader(dashboard){
    const header = getHeader(dashboard);
    if (!header) return;
    header.classList.add('mk-header');
    const icon = header.querySelector('.fa-wallet');
    if (icon) {
      const wrap = icon.parentElement;
      wrap.className = 'mk-logo-mark';
      wrap.innerHTML = logoSvg;
    }
    const brand = header.querySelector('.font-urbanist');
    if (brand) {
      brand.classList.add('mk-brand');
      const text = brand.textContent.trim();
      if (text.includes('MyKas')) brand.innerHTML = '<span class="mk-brand-my">My</span><span class="mk-brand-kas">Kas</span>';
    }
  }

  function redesignHero(dashboard){
    const saldo = dashboard.querySelector('#txtSaldo');
    if (!saldo) return;
    const hero = saldo.closest('.w-full');
    if (!hero) return;
    hero.classList.add('hero-modern');
    hero.style.position = 'relative';

    const directChildren = [...hero.children];
    directChildren.forEach(el => el.classList.add('hero-data-safe'));

    if (!hero.querySelector('.hero-wallet-art')) {
      const art = document.createElement('div');
      art.className = 'hero-wallet-art';
      art.innerHTML = walletSvg;
      hero.appendChild(art);
    }
  }

  function redesignSections(dashboard){
    dashboard.querySelectorAll('section').forEach(s => s.classList.add('dashboard-modern-section'));
    dashboard.querySelectorAll('h3').forEach(h => {
      if (['Dompet Saya','Quick Action'].includes(h.textContent.trim()) || h.textContent.trim().startsWith('Transaksi Terbaru') || h.textContent.trim().startsWith('Sisa Budget')) h.classList.add('modern-title');
    });
    dashboard.querySelectorAll('#listRiwayat,#loadingRiwayat').forEach(x => x.classList.add('modern-list'));
    dashboard.querySelectorAll('[onclick*="pilihDompetTab"]').forEach(x => x.classList.add('modern-card'));
    dashboard.querySelectorAll('[class*="col-span-7"],[class*="col-span-5"]').forEach(x => x.classList.add('modern-card','modern-shadow'));
  }

  function redesignBottomNav(){
    const nav = document.getElementById('mainFixedNavbar');
    if (!nav) return;
    const buttons = [...nav.querySelectorAll('button')];
    buttons.forEach((btn, i) => {
      btn.classList.remove('mk-nav-active','mk-nav-muted','mk-fab-dock');
      if (i === 2 || btn.querySelector('.fa-plus')) btn.classList.add('mk-fab-dock');
      else btn.classList.add(i === 0 ? 'mk-nav-active' : 'mk-nav-muted');
    });
  }

  function redesign(){
    const dashboard = document.getElementById('screenDashboard');
    if (!dashboard) return;
    redesignHeader(dashboard);
    redesignHero(dashboard);
    redesignSections(dashboard);
    redesignBottomNav();
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', redesign, {once:true});
  else redesign();
  [300,900,1800].forEach(ms => setTimeout(redesign, ms));
})();
