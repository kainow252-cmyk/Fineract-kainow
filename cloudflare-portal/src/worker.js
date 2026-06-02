// ── Fineract Banking Portal — Cloudflare Worker ──────────────────────
import ANALYSIS_HTML from './analysis.html';
import GUIDE_HTML from './guide.html';
import DECISAO_HTML from './decisao.html';

const INDEX_HTML = `<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Fineract Banking Portal</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'Segoe UI', system-ui, sans-serif; background: #0D0D3B; min-height: 100vh; }
  .hero { background: linear-gradient(135deg, #1A237E 0%, #3949AB 50%, #00BCD4 100%); padding: 60px 20px; text-align: center; }
  .hero h1 { color: #fff; font-size: clamp(2rem,5vw,3.5rem); font-weight: 800; letter-spacing: -1px; }
  .hero p { color: rgba(255,255,255,0.8); font-size: 1.2rem; margin-top: 12px; }
  .badge { display: inline-block; background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.3); color: #fff; padding: 6px 16px; border-radius: 20px; font-size: 0.85rem; margin-top: 16px; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 24px; max-width: 1100px; margin: -40px auto 60px; padding: 0 20px; }
  .card { background: #fff; border-radius: 20px; overflow: hidden; box-shadow: 0 20px 60px rgba(0,0,0,0.3); transition: transform 0.3s, box-shadow 0.3s; }
  .card:hover { transform: translateY(-8px); box-shadow: 0 32px 80px rgba(0,0,0,0.4); }
  .card-header { padding: 28px; color: #fff; }
  .card-header .icon { font-size: 2.5rem; margin-bottom: 12px; }
  .card-header h2 { font-size: 1.4rem; font-weight: 700; }
  .card-header p { opacity: 0.85; font-size: 0.9rem; margin-top: 6px; }
  .card-1 .card-header { background: linear-gradient(135deg, #1A237E, #3949AB); }
  .card-2 .card-header { background: linear-gradient(135deg, #00695C, #00BCD4); }
  .card-3 .card-header { background: linear-gradient(135deg, #7C3AED, #EC4899); }
  .card-body { padding: 20px 28px 28px; }
  .tag { display: inline-block; background: #F3F4F6; color: #374151; padding: 4px 12px; border-radius: 20px; font-size: 0.78rem; font-weight: 500; margin: 3px; }
  .tag.blue { background: #EFF6FF; color: #1D4ED8; }
  .tag.green { background: #F0FDF4; color: #15803D; }
  .tag.purple { background: #FAF5FF; color: #7E22CE; }
  .btn { display: block; margin-top: 20px; padding: 14px; background: linear-gradient(135deg, #1A237E, #3949AB); color: #fff; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 0.95rem; text-align: center; transition: opacity 0.2s; }
  .btn:hover { opacity: 0.9; }
  .btn-2 { background: linear-gradient(135deg, #00695C, #00BCD4); }
  .btn-3 { background: linear-gradient(135deg, #7C3AED, #EC4899); }
  .stats { display: flex; gap: 12px; margin-top: 14px; }
  .stat { flex: 1; text-align: center; background: #F9FAFB; border-radius: 10px; padding: 10px; }
  .stat strong { display: block; font-size: 1.3rem; color: #1A237E; font-weight: 800; }
  .stat span { font-size: 0.75rem; color: #6B7280; }
  footer { text-align: center; padding: 30px 20px; color: rgba(255,255,255,0.4); font-size: 0.85rem; }
  footer a { color: rgba(255,255,255,0.6); text-decoration: none; }
</style>
</head>
<body>
<div class="hero">
  <h1>🏦 Fineract Banking Portal</h1>
  <p>Guias completos para construção de banco digital com Apache Fineract</p>
  <span class="badge">✅ Apache Fineract 22.x · Flutter 3.32 · Cloudflare Workers</span>
</div>
<div class="grid">

  <div class="card card-1">
    <div class="card-header">
      <div class="icon">🏗️</div>
      <h2>Análise de Arquitetura</h2>
      <p>Análise completa dos 32+ módulos do Fineract e matriz de reusabilidade</p>
    </div>
    <div class="card-body">
      <div>
        <span class="tag blue">Conta Digital 75%</span>
        <span class="tag blue">Wallet 70%</span>
        <span class="tag blue">Comissões 85%</span>
        <span class="tag blue">Marketplace 65%</span>
      </div>
      <div class="stats">
        <div class="stat"><strong>32+</strong><span>Módulos</span></div>
        <div class="stat"><strong>5</strong><span>Camadas</span></div>
        <div class="stat"><strong>147</strong><span>Arquivos Java</span></div>
      </div>
      <a href="/analysis" class="btn">📊 Ver Análise Completa</a>
    </div>
  </div>

  <div class="card card-2">
    <div class="card-header">
      <div class="icon">🔗</div>
      <h2>Integrações & Players</h2>
      <p>Como integrar PIX, Mercado Pago, PagBank, Stripe e outros</p>
    </div>
    <div class="card-body">
      <div>
        <span class="tag green">PIX / Open Finance</span>
        <span class="tag green">Mercado Pago</span>
        <span class="tag green">PagBank</span>
        <span class="tag green">Stripe</span>
        <span class="tag green">Celcoin BaaS</span>
      </div>
      <div class="stats">
        <div class="stat"><strong>12+</strong><span>Players</span></div>
        <div class="stat"><strong>4</strong><span>Etapas</span></div>
        <div class="stat"><strong>BaaS</strong><span>Recomendado</span></div>
      </div>
      <a href="/guide" class="btn btn-2">🔗 Ver Guia de Integrações</a>
    </div>
  </div>

  <div class="card card-3">
    <div class="card-header">
      <div class="icon">📱</div>
      <h2>App Flutter do Zero</h2>
      <p>Criar banco digital em Flutter com 8 telas conectadas ao Fineract</p>
    </div>
    <div class="card-body">
      <div>
        <span class="tag purple">Flutter 3.32</span>
        <span class="tag purple">Riverpod v3</span>
        <span class="tag purple">GoRouter</span>
        <span class="tag purple">Dio</span>
      </div>
      <div class="stats">
        <div class="stat"><strong>8</strong><span>Telas MVP</span></div>
        <div class="stat"><strong>22</strong><span>Arquivos Dart</span></div>
        <div class="stat"><strong>0</strong><span>Erros</span></div>
      </div>
      <a href="/decisao" class="btn btn-3">📱 Ver Guia Flutter</a>
    </div>
  </div>

</div>
<footer>
  <p>Fineract Banking Portal · Powered by <a href="https://cloudflare.com">Cloudflare Workers</a> · Apache Fineract Open Source</p>
</footer>
</body>
</html>`;

export default {
  async fetch(request) {
    const url = new URL(request.url);
    const path = url.pathname;

    const headers = {
      'Content-Type': 'text/html; charset=utf-8',
      'Cache-Control': 'public, max-age=3600',
      'X-Content-Type-Options': 'nosniff',
    };

    if (path === '/' || path === '/index' || path === '/index.html') {
      return new Response(INDEX_HTML, { headers });
    }
    if (path === '/analysis' || path === '/analysis.html') {
      return new Response(ANALYSIS_HTML, { headers });
    }
    if (path === '/guide' || path === '/guide.html') {
      return new Response(GUIDE_HTML, { headers });
    }
    if (path === '/decisao' || path === '/decisao.html') {
      return new Response(DECISAO_HTML, { headers });
    }

    // 404
    return new Response(`<!DOCTYPE html><html><body style="font-family:sans-serif;text-align:center;padding:60px">
      <h1>404</h1><p>Página não encontrada</p>
      <a href="/" style="color:#1A237E">← Voltar ao Portal</a>
    </body></html>`, { status: 404, headers });
  }
};
