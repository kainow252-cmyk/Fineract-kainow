// ── MeuBanco Digital + Fineract Portal — Cloudflare Worker ───────────
import APP_HTML    from './app.html';
import ANALYSIS_HTML from './analysis.html';
import GUIDE_HTML  from './guide.html';
import DECISAO_HTML from './decisao.html';

const INDEX_HTML = `<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>MeuBanco — Portal</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Segoe UI',system-ui,sans-serif;background:#0D0D3B;min-height:100vh}
.hero{background:linear-gradient(135deg,#1A237E 0%,#3949AB 55%,#00BCD4 100%);padding:60px 20px 80px;text-align:center}
.hero h1{color:#fff;font-size:clamp(2rem,5vw,3.2rem);font-weight:900;letter-spacing:-1px}
.hero p{color:rgba(255,255,255,.8);font-size:1.1rem;margin-top:10px}
.badge{display:inline-block;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.3);color:#fff;padding:6px 16px;border-radius:20px;font-size:.85rem;margin-top:14px}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:24px;max-width:1100px;margin:-44px auto 60px;padding:0 20px}
.card{background:#fff;border-radius:20px;overflow:hidden;box-shadow:0 20px 60px rgba(0,0,0,.3);transition:transform .3s,box-shadow .3s}
.card:hover{transform:translateY(-6px);box-shadow:0 28px 70px rgba(0,0,0,.4)}
.card-h{padding:26px;color:#fff}
.card-h .ico{font-size:2.4rem;margin-bottom:10px}
.card-h h2{font-size:1.35rem;font-weight:800}
.card-h p{opacity:.82;font-size:.88rem;margin-top:5px}
.h1{background:linear-gradient(135deg,#1A237E,#3949AB)}
.h2{background:linear-gradient(135deg,#059669,#00BCD4)}
.h3{background:linear-gradient(135deg,#00695C,#10B981)}
.h4{background:linear-gradient(135deg,#7C3AED,#EC4899)}
.card-b{padding:18px 22px 22px}
.tag{display:inline-block;padding:4px 11px;border-radius:20px;font-size:.75rem;font-weight:600;margin:2px;background:#F3F4F6;color:#374151}
.tag.b{background:#EFF6FF;color:#1D4ED8}.tag.g{background:#F0FDF4;color:#15803D}.tag.p{background:#FAF5FF;color:#7E22CE}.tag.r{background:#FFF7ED;color:#B45309}
.stats{display:flex;gap:10px;margin-top:12px}
.stat{flex:1;text-align:center;background:#F9FAFB;border-radius:10px;padding:10px}
.stat strong{display:block;font-size:1.2rem;color:#1A237E;font-weight:800}
.stat span{font-size:.72rem;color:#6B7280}
.btn{display:block;margin-top:16px;padding:14px;border-radius:12px;font-weight:700;font-size:.92rem;text-align:center;text-decoration:none;transition:opacity .2s;color:#fff}
.btn:hover{opacity:.9}
.b1{background:linear-gradient(135deg,#1A237E,#3949AB)}
.b2{background:linear-gradient(135deg,#059669,#00BCD4)}
.b3{background:linear-gradient(135deg,#00695C,#10B981)}
.b4{background:linear-gradient(135deg,#7C3AED,#EC4899)}
.featured{grid-column:1/-1;display:grid;grid-template-columns:1fr 1fr;gap:20px;align-items:center;padding:28px;border-radius:20px;background:#fff;box-shadow:0 20px 60px rgba(0,0,0,.3)}
@media(max-width:600px){.featured{grid-template-columns:1fr}}
.featured-text h2{font-size:1.6rem;font-weight:900;color:#1A237E}
.featured-text p{color:#6B7280;margin:10px 0 16px;font-size:.95rem;line-height:1.6}
.phone-preview{background:linear-gradient(135deg,#1A237E,#3949AB,#7C3AED);border-radius:20px;padding:20px;text-align:center;font-size:3rem}
footer{text-align:center;padding:30px;color:rgba(255,255,255,.4);font-size:.83rem}
footer a{color:rgba(255,255,255,.6)}
</style>
</head>
<body>
<div class="hero">
  <h1>🏦 MeuBanco Digital</h1>
  <p>Plataforma bancária completa • Apache Fineract + Flutter</p>
  <span class="badge">✅ Conta Digital · PIX · Cartão · Crédito · Open Finance</span>
</div>
<div class="grid">

  <!-- FEATURED: App -->
  <div class="featured">
    <div class="featured-text">
      <h2>📱 App Bancário Completo</h2>
      <p>Plataforma web interativa com todas as telas do banco digital. Login, saldo, PIX, QR Code, cartão virtual, crédito e muito mais — tudo funcionando!</p>
      <div>
        <span class="tag b">Login seguro</span>
        <span class="tag g">PIX + QR Code</span>
        <span class="tag p">Cartão virtual</span>
        <span class="tag r">Crédito</span>
        <span class="tag b">Extrato</span>
        <span class="tag g">Biometria</span>
      </div>
      <a href="/app" class="btn b1" style="margin-top:18px;width:fit-content;padding:14px 32px">🚀 Abrir o Aplicativo</a>
    </div>
    <div class="phone-preview">
      📱<br>
      <div style="font-size:.85rem;color:rgba(255,255,255,.7);margin-top:8px;line-height:1.6">
        Simulação completa<br>do app bancário
      </div>
    </div>
  </div>

  <div class="card">
    <div class="card-h h1"><div class="ico">🏗️</div><h2>Análise de Arquitetura</h2><p>32+ módulos do Fineract e matriz de reusabilidade</p></div>
    <div class="card-b">
      <span class="tag b">Conta Digital 75%</span><span class="tag b">Wallet 70%</span><span class="tag b">Comissões 85%</span>
      <div class="stats">
        <div class="stat"><strong>32+</strong><span>Módulos</span></div>
        <div class="stat"><strong>5</strong><span>Camadas</span></div>
        <div class="stat"><strong>147</strong><span>Java</span></div>
      </div>
      <a href="/analysis" class="btn b1">📊 Ver Análise</a>
    </div>
  </div>

  <div class="card">
    <div class="card-h h3"><div class="ico">🔗</div><h2>Integrações & Players</h2><p>PIX, Mercado Pago, PagBank, Stripe, BaaS</p></div>
    <div class="card-b">
      <span class="tag g">PIX / Open Finance</span><span class="tag g">Mercado Pago</span><span class="tag g">Stripe</span><span class="tag g">Celcoin</span>
      <div class="stats">
        <div class="stat"><strong>12+</strong><span>Players</span></div>
        <div class="stat"><strong>4</strong><span>Etapas</span></div>
        <div class="stat"><strong>BaaS</strong><span>Recomendado</span></div>
      </div>
      <a href="/guide" class="btn b3">🔗 Ver Integrações</a>
    </div>
  </div>

  <div class="card">
    <div class="card-h h4"><div class="ico">💻</div><h2>App Flutter do Zero</h2><p>22 arquivos Dart, 8 telas, 0 erros de compilação</p></div>
    <div class="card-b">
      <span class="tag p">Flutter 3.32</span><span class="tag p">Riverpod v3</span><span class="tag p">GoRouter</span><span class="tag p">Dio</span>
      <div class="stats">
        <div class="stat"><strong>8</strong><span>Telas</span></div>
        <div class="stat"><strong>22</strong><span>Arquivos</span></div>
        <div class="stat"><strong>0</strong><span>Erros</span></div>
      </div>
      <a href="/decisao" class="btn b4">📱 Ver Código Flutter</a>
    </div>
  </div>

</div>
<footer>MeuBanco Digital · Apache Fineract Open Source · <a href="https://cloudflare.com">Cloudflare Workers</a></footer>
</body>
</html>`;

export default {
  async fetch(request) {
    const url  = new URL(request.url);
    const path = url.pathname.replace(/\/$/, '') || '/';

    const html = { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'public, max-age=3600' };

    if (path === '/' || path === '/app') return new Response(APP_HTML, { headers: html });
    if (path === '/analysis')  return new Response(ANALYSIS_HTML, { headers: html });
    if (path === '/guide')     return new Response(GUIDE_HTML,    { headers: html });
    if (path === '/decisao')   return new Response(DECISAO_HTML,  { headers: html });

    return new Response(`<!DOCTYPE html><html><body style="font-family:sans-serif;text-align:center;padding:60px;background:#0D0D3B;color:#fff">
      <h1 style="font-size:4rem">404</h1>
      <p style="color:rgba(255,255,255,.6);margin:12px 0 24px">Página não encontrada</p>
      <a href="/" style="background:#3949AB;color:#fff;padding:12px 28px;border-radius:12px;text-decoration:none;font-weight:600">← Voltar ao Portal</a>
    </body></html>`, { status: 404, headers: html });
  }
};
