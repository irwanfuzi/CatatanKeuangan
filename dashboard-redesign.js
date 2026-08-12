/* MyKas — premium fintech sizing + navigation polish
 * Non-destructive: injects only responsive visual sizing rules.
 * Existing application logic and dashboard markup remain untouched.
 */
(() => {
  const STYLE_ID = 'mykas-premium-sizing-v2';
  if (document.getElementById(STYLE_ID)) return;

  const css = `
    :root {
      --mk-spacing-page: 16px;
      --mk-radius-card: 20px;
      --mk-radius-hero: 24px;
      --mk-title: 17px;
      --mk-body: 12px;
      --mk-caption: 10px;
      --mk-blue: #1769FF;
      --mk-blue-soft: #EAF2FF;
      --mk-gold: #FFB901;
      --mk-navy: #1E293B;
      --mk-muted: #94A3B8;
    }

    body { font-family: 'Plus Jakarta Sans', sans-serif !important; }

    /* Header — compact premium fintech proportions */
    .dashboard-header {
      min-height: 68px !important;
      height: 68px !important;
      padding: 0 16px !important;
    }
    .dashboard-logo-mark { width: 44px !important; height: 38px !important; }
    .dashboard-brand-text { font-size: 25px !important; letter-spacing: -1px !important; }
    .header-icon-btn { width: 40px !important; height: 40px !important; font-size: 18px !important; }
    .header-profile-btn {
      width: 40px !important;
      height: 40px !important;
      font-size: 15px !important;
      box-shadow: none !important;
    }

    /* Main content rhythm */
    .dashboard-content {
      padding: 14px 16px 96px !important;
      gap: 16px !important;
    }

    /* Hero */
    .hero-assets-card {
      min-height: 184px !important;
      padding: 20px 18px !important;
      border-radius: var(--mk-radius-hero) !important;
    }
    .hero-copy { width: 63% !important; }
    .hero-label-row { font-size: 12px !important; }
    .hero-balance {
      margin: 10px 0 11px !important;
      font-size: 32px !important;
      letter-spacing: -1.25px !important;
    }
    .hero-growth-row { font-size: 11px !important; }
    .hero-growth { padding: 5px 9px !important; }
    .hero-updated { margin-top: 13px !important; font-size: 9px !important; }
    .hero-wallet { width: 37% !important; max-width: 156px !important; }

    /* Section hierarchy */
    .dashboard-section { gap: 9px !important; }
    .section-heading h2,
    .section-title-only {
      font-size: var(--mk-title) !important;
      letter-spacing: -.25px !important;
    }
    .section-heading button,
    .panel-heading button { font-size: 10px !important; }

    /* Wallets — flatter, calmer and easier to scan */
    .wallet-grid { gap: 8px !important; }
    .wallet-card {
      min-height: 142px !important;
      padding: 12px 7px 10px !important;
      border-radius: 18px !important;
      box-shadow: none !important;
    }
    .wallet-icon {
      width: 44px !important;
      height: 44px !important;
      border-radius: 14px !important;
      font-size: 18px !important;
    }
    .wallet-name { margin-top: 9px !important; font-size: 10px !important; }
    .wallet-card strong { margin-top: 5px !important; font-size: 11px !important; }
    .wallet-card small { margin-top: 4px !important; font-size: 9px !important; }
    .wallet-progress { height: 4px !important; width: 82% !important; }

    /* Quick actions — flat Material 3 treatment */
    .quick-action-card {
      min-height: 92px !important;
      border-radius: 18px !important;
      box-shadow: none !important;
    }
    .quick-action-item { gap: 6px !important; }
    .quick-action-item span {
      width: 32px !important;
      height: 32px !important;
      font-size: 20px !important;
    }
    .quick-action-item b { font-size: 9px !important; }

    /* Transaction + budget panels */
    .dashboard-module-grid { gap: 9px !important; }
    .dashboard-panel {
      padding: 13px 11px !important;
      border-radius: 20px !important;
      box-shadow: none !important;
    }
    .panel-heading { margin-bottom: 9px !important; }
    .panel-heading h2 { font-size: 12px !important; }
    .budget-icon { width: 38px !important; height: 38px !important; border-radius: 13px !important; }
    .budget-value { font-size: 19px !important; }

    /* Transaction readability: make actual transaction copy noticeably larger */
    .dashboard-module-grid > .dashboard-panel:first-child span,
    .dashboard-module-grid > .dashboard-panel:first-child small {
      font-size: 11px !important;
    }
    .dashboard-module-grid > .dashboard-panel:first-child strong,
    .dashboard-module-grid > .dashboard-panel:first-child b {
      font-size: 12px !important;
    }
    .dashboard-module-grid > .dashboard-panel:first-child .text-xs { font-size: 10px !important; }

    /* Insight */
    .insight-card {
      min-height: 84px !important;
      border-radius: 20px !important;
      padding: 12px !important;
      box-shadow: none !important;
    }
    .insight-icon {
      width: 44px !important;
      height: 44px !important;
      border-radius: 14px !important;
      box-shadow: none !important;
    }
    .insight-copy b { font-size: 12px !important; }
    .insight-copy p { font-size: 10px !important; line-height: 1.45 !important; }

    /* Flat Material 3 bottom navigation */
    .integrated-bottom-dock,
    #mainFixedNavbar {
      height: 70px !important;
      box-shadow: none !important;
      backdrop-filter: none !important;
      -webkit-backdrop-filter: none !important;
      background: #fff !important;
    }
    .dock-nav-item {
      height: 60px !important;
      gap: 4px !important;
      color: #94A3B8 !important;
      transition: color .18s ease, background-color .18s ease, transform .18s ease !important;
    }
    .dock-nav-item i { font-size: 19px !important; }
    .dock-nav-item span { font-size: 9px !important; font-weight: 700 !important; }

    /* Modern Material 3 active state for Analisis, Dompet and Profil too */
    .dock-nav-item.active,
    .dock-nav-item.is-active,
    .dock-nav-item[aria-current="page"] {
      color: var(--mk-blue) !important;
      background: var(--mk-blue-soft) !important;
      border-radius: 16px !important;
    }
    .dock-nav-item.active i,
    .dock-nav-item.is-active i,
    .dock-nav-item[aria-current="page"] i { color: var(--mk-blue) !important; }

    /* Primary action — closer to navbar, no floating shadow */
    .dock-add-btn {
      width: 64px !important;
      height: 54px !important;
      top: -18px !important;
      border-radius: 18px !important;
      box-shadow: none !important;
      border: 2px solid #fff !important;
      background: var(--mk-blue) !important;
      color: #fff !important;
    }
    .dock-add-btn::after {
      content: '';
      position: absolute;
      width: 7px;
      height: 7px;
      right: 8px;
      top: 7px;
      border-radius: 50%;
      background: var(--mk-gold);
    }
    .dock-add-btn i { font-size: 24px !important; }
    .dock-add-btn span { font-size: 9px !important; font-weight: 800 !important; }

    /* Prevent primary action from feeling detached from the bar */
    .integrated-bottom-dock,
    #mainFixedNavbar { padding-top: 2px !important; }

    /* Dark mode */
    body.dark .integrated-bottom-dock,
    body.dark #mainFixedNavbar { background: #131C35 !important; }
    body.dark .dock-nav-item.active,
    body.dark .dock-nav-item.is-active,
    body.dark .dock-nav-item[aria-current="page"] { background: rgba(23,105,255,.16) !important; }

    @media (max-width: 370px) {
      .dashboard-content { padding-left: 12px !important; padding-right: 12px !important; }
      .hero-assets-card { min-height: 176px !important; padding: 18px 15px !important; }
      .hero-balance { font-size: 29px !important; }
      .hero-copy { width: 68% !important; }
      .hero-wallet { width: 34% !important; }
      .wallet-card { min-height: 136px !important; }
      .wallet-icon { width: 42px !important; height: 42px !important; }
      .quick-action-card { min-height: 88px !important; }
      .dock-add-btn { width: 60px !important; height: 52px !important; top: -16px !important; }
    }
  `;

  const style = document.createElement('style');
  style.id = STYLE_ID;
  style.textContent = css;
  document.head.appendChild(style);
})();

/* MyKas polish integration: dashboard sizing/navigation refinement committed 2026-08-12. */
