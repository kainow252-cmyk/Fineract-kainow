// ── MeuBanco Digital + Fineract Portal — Cloudflare Worker ───────────
import APP_HTML      from './app.html';
import ANALYSIS_HTML from './analysis.html';
import GUIDE_HTML    from './guide.html';
import DECISAO_HTML  from './decisao.html';
import PRIVACY_HTML  from './privacy.html';
import TERMS_HTML    from './terms.html';

// Firebase Messaging Service Worker — servido como JS estático em /firebase-messaging-sw.js
const FCM_SW_CONTENT = `importScripts("https://www.gstatic.com/firebasejs/11.9.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/11.9.0/firebase-messaging-compat.js");
firebase.initializeApp({
  apiKey:"AIzaSyDl1sR0sgb6BH52fwQ_twgSiwbGvrJ9Ek8",
  authDomain:"kainowpay.firebaseapp.com",
  projectId:"kainowpay",
  storageBucket:"kainowpay.firebasestorage.app",
  messagingSenderId:"625304649401",
  appId:"1:625304649401:web:0fb95cc8c350a528332568",
});
const messaging = firebase.messaging();
messaging.onBackgroundMessage((payload) => {
  const title = payload.notification?.title || "KaiNowPay";
  const opts  = { body: payload.notification?.body || "", icon: "/favicon.svg", badge: "/favicon.svg", tag: payload.data?.type || "knp-push", data: payload.data || {} };
  self.registration.showNotification(title, opts);
});
self.addEventListener("notificationclick", (e) => {
  e.notification.close();
  if (e.action === "dismiss") return;
  e.waitUntil(clients.matchAll({type:"window",includeUncontrolled:true}).then(ws=>{
    for(const w of ws){ if(w.url.includes(self.location.origin)&&"focus" in w){ w.postMessage({type:"FCM_CLICK",data:e.notification.data}); return w.focus(); } }
    if(clients.openWindow) return clients.openWindow("/");
  }));
});
console.log("[KaiNowPay SW] FCM Service Worker ativo ✅");
`;

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

/* ══════════════════════════════════════════════════════════════════
   FIREBASE SERVICE ACCOUNT — JWT helper
   Gera um OAuth2 Bearer token a partir da chave privada RSA
   (necessário para Firebase Admin HTTP v1 API sem Node.js SDK)
══════════════════════════════════════════════════════════════════ */
async function getFirebaseAccessToken(clientEmail, privateKeyPem) {
  // Remove cabeçalhos PEM e decodifica base64
  const pemBody = privateKeyPem
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\s+/g, '');

  const keyData = Uint8Array.from(atob(pemBody), c => c.charCodeAt(0));

  // Importa a chave RSA-256 para WebCrypto
  const cryptoKey = await crypto.subtle.importKey(
    'pkcs8', keyData.buffer,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false, ['sign']
  );

  // Cria o JWT header + claims
  const now = Math.floor(Date.now() / 1000);
  const header  = { alg: 'RS256', typ: 'JWT' };
  const payload = {
    iss: clientEmail,
    sub: clientEmail,
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
  };

  const b64url = (obj) => btoa(JSON.stringify(obj))
    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '');

  const signingInput = `${b64url(header)}.${b64url(payload)}`;
  const sigBytes = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    cryptoKey,
    new TextEncoder().encode(signingInput)
  );
  const sig = btoa(String.fromCharCode(...new Uint8Array(sigBytes)))
    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '');

  const jwt = `${signingInput}.${sig}`;

  // Troca o JWT por um access_token OAuth2
  const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=${jwt}`,
  });

  if (!tokenRes.ok) {
    const err = await tokenRes.text();
    throw new Error(`Firebase OAuth2 error: ${err}`);
  }

  const tokenData = await tokenRes.json();
  return tokenData.access_token;
}

export default {
  async fetch(request, env) {
    const url  = new URL(request.url);
    const path = url.pathname.replace(/\/$/, '') || '/';

    // Force HTTPS redirect
    if (url.protocol === 'http:') {
      const httpsUrl = 'https://' + url.host + url.pathname + url.search;
      return Response.redirect(httpsUrl, 301);
    }

    const html = { 
      'Content-Type': 'text/html; charset=utf-8', 
      'Cache-Control': 'public, max-age=3600',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains; preload',
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'SAMEORIGIN',
      'Referrer-Policy': 'strict-origin-when-cross-origin'
    };

    if (path === '/' || path === '/app') return new Response(APP_HTML, { headers: html });
    if (path === '/analysis')  return new Response(ANALYSIS_HTML, { headers: html });
    if (path === '/guide')     return new Response(GUIDE_HTML,    { headers: html });
    if (path === '/decisao')    return new Response(DECISAO_HTML,  { headers: html });
    if (path === '/privacidade') return new Response(PRIVACY_HTML,  { headers: html });
    if (path === '/termos')      return new Response(TERMS_HTML,    { headers: html });

    // ── Firebase Messaging Service Worker ────────────────────────────
    // DEVE estar na raiz (/) para ter escopo completo do domínio
    if (path === '/firebase-messaging-sw.js') {
      return new Response(FCM_SW_CONTENT, {
        headers: {
          'Content-Type': 'application/javascript; charset=utf-8',
          'Service-Worker-Allowed': '/',
          'Cache-Control': 'no-cache, no-store, must-revalidate',
        }
      });
    }

    // Favicon — SVG verde inline
    if (path === '/favicon.ico' || path === '/favicon.svg') {
      const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32"><rect width="32" height="32" rx="8" fill="#1a4731"/><text x="16" y="22" text-anchor="middle" font-size="18" font-family="sans-serif">🏦</text></svg>`;
      return new Response(svg, { headers: { 'Content-Type': 'image/svg+xml', 'Cache-Control': 'public, max-age=86400' } });
    }

    // Web App Manifest
    if (path === '/manifest.json') {
      const manifest = JSON.stringify({
        name: 'KaiNowPay',
        short_name: 'KaiNowPay',
        description: 'Plataforma Financeira Completa',
        start_url: '/',
        display: 'standalone',
        background_color: '#f0fdf4',
        theme_color: '#1a4731',
        icons: [{ src: '/favicon.svg', sizes: 'any', type: 'image/svg+xml' }]
      });
      return new Response(manifest, { headers: { 'Content-Type': 'application/manifest+json', 'Cache-Control': 'public, max-age=86400' } });
    }

    // robots.txt
    if (path === '/robots.txt') {
      return new Response('User-agent: *\nAllow: /\n', { headers: { 'Content-Type': 'text/plain', 'Cache-Control': 'public, max-age=86400' } });
    }

    /* ══════════════════════════════════════════════════════════════════
       WOOVI PIX API — Rotas de Backend
       AppID guardado como secret: WOOVI_APP_ID
       Base URL prod : https://api.woovi.com/api/v1
       Base URL sandbox: https://api.woovi-sandbox.com/api/v1
    ══════════════════════════════════════════════════════════════════ */

    // Helpers CORS para chamadas do frontend
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: corsHeaders });
    }

    // ── POST /api/pix/charge ─────────────────────────────────────────
    // Body esperado: { value: number (centavos), comment: string, correlationID?: string }
    // Retorna: { correlationID, brCode, qrCodeImage, paymentLinkUrl, expiresIn }
    if (path === '/api/pix/charge' && request.method === 'POST') {
      try {
        const appID = (env && env.WOOVI_APP_ID)
          || (typeof WOOVI_APP_ID !== 'undefined' && WOOVI_APP_ID)
          || request.headers.get('X-Woovi-AppID') || '';
        if (!appID) {
          return new Response(JSON.stringify({ error: 'WOOVI_APP_ID não configurado. Adicione o secret no Cloudflare Dashboard.' }), {
            status: 500, headers: { 'Content-Type': 'application/json', ...corsHeaders }
          });
        }

        const body = await request.json();
        const value       = Math.round(Number(body.value) || 100);   // centavos, mínimo R$1
        const comment     = String(body.comment || 'Cobrança KaiNowPay').slice(0, 140);
        const correlationID = body.correlationID || crypto.randomUUID();
        const customerName  = String(body.customerName || 'Cliente');
        const customerEmail = body.customerEmail || undefined;
        const customerPhone = body.customerPhone || undefined;
        const customerTaxID = body.customerTaxID  || undefined;

        // Woovi exige customer com ao menos email, phone ou taxID.
        // Se nenhum identificador for fornecido, omite o objeto customer
        // (cobrança anônima — aceita normalmente pela API).
        const hasIdentifier = !!(customerEmail || customerPhone || customerTaxID);
        const customer = (customerName && hasIdentifier) ? {
          name: customerName,
          ...(customerEmail && { email: customerEmail }),
          ...(customerPhone && { phone: customerPhone }),
          ...(customerTaxID  && { taxID: customerTaxID  }),
          correlationID: correlationID + '-customer',
        } : undefined;

        // Detecta sandbox: env var WOOVI_SANDBOX=true ou AppID contém sandbox/test
        const isSandbox = (env && env.WOOVI_SANDBOX === 'true')
          || (typeof WOOVI_SANDBOX !== 'undefined' && WOOVI_SANDBOX === 'true')
          || appID.toLowerCase().includes('test') || appID.toLowerCase().includes('sandbox');
        const baseURL = isSandbox
          ? 'https://api.woovi-sandbox.com/api/v1'
          : 'https://api.woovi.com/api/v1';

        const payload = { correlationID, value, comment, ...(customer && { customer }) };

        const wooviRes = await fetch(`${baseURL}/charge`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', 'Authorization': appID },
          body: JSON.stringify(payload),
        });

        const wooviData = await wooviRes.json();

        if (!wooviRes.ok) {
          return new Response(JSON.stringify({ error: 'Woovi API error', details: wooviData }), {
            status: wooviRes.status, headers: { 'Content-Type': 'application/json', ...corsHeaders }
          });
        }

        const charge = wooviData.charge || wooviData;
        return new Response(JSON.stringify({
          correlationID:   charge.correlationID,
          identifier:      charge.identifier || charge.transactionID,
          brCode:          charge.brCode || charge.paymentMethods?.pix?.brCode,
          qrCodeImage:     charge.qrCodeImage || charge.paymentMethods?.pix?.qrCodeImage,
          paymentLinkUrl:  charge.paymentLinkUrl,
          expiresIn:       charge.expiresIn,
          value,
          status:          charge.status || 'ACTIVE',
        }), { status: 200, headers: { 'Content-Type': 'application/json', ...corsHeaders } });

      } catch (err) {
        return new Response(JSON.stringify({ error: 'Erro interno', message: err.message }), {
          status: 500, headers: { 'Content-Type': 'application/json', ...corsHeaders }
        });
      }
    }

    // ── GET /api/pix/charge/:correlationID ──────────────────────────
    // Consulta status de uma cobrança
    if (path.startsWith('/api/pix/charge/') && request.method === 'GET') {
      try {
        const appID = (env && env.WOOVI_APP_ID)
          || (typeof WOOVI_APP_ID !== 'undefined' && WOOVI_APP_ID)
          || request.headers.get('X-Woovi-AppID') || '';
        if (!appID) {
          return new Response(JSON.stringify({ error: 'WOOVI_APP_ID não configurado.' }), {
            status: 500, headers: { 'Content-Type': 'application/json', ...corsHeaders }
          });
        }
        const correlationID = path.split('/api/pix/charge/')[1];
        const isSandbox = (env && env.WOOVI_SANDBOX === 'true')
          || (typeof WOOVI_SANDBOX !== 'undefined' && WOOVI_SANDBOX === 'true')
          || appID.toLowerCase().includes('test') || appID.toLowerCase().includes('sandbox');
        const baseURL = isSandbox
          ? 'https://api.woovi-sandbox.com/api/v1'
          : 'https://api.woovi.com/api/v1';

        const wooviRes = await fetch(`${baseURL}/charge/${correlationID}`, {
          headers: { 'Authorization': appID }
        });
        const wooviData = await wooviRes.json();
        const charge = wooviData.charge || wooviData;
        return new Response(JSON.stringify({
          correlationID: charge.correlationID,
          status:        charge.status,
          value:         charge.value,
          paidAt:        charge.paidAt || null,
          payer:         charge.payer || null,
        }), { status: 200, headers: { 'Content-Type': 'application/json', ...corsHeaders } });
      } catch (err) {
        return new Response(JSON.stringify({ error: err.message }), {
          status: 500, headers: { 'Content-Type': 'application/json', ...corsHeaders }
        });
      }
    }

    // ── POST /api/woovi/webhook ──────────────────────────────────────
    // Recebe notificações da Woovi (OPENPIX:CHARGE_COMPLETED, etc.)
    // Na plataforma Woovi, configure o webhook URL como:
    //   https://kainowpay.com.br/api/woovi/webhook
    // Com o campo "authorization" preenchido com um secret seu (WOOVI_WEBHOOK_SECRET)
    if (path === '/api/woovi/webhook' && request.method === 'POST') {
      try {
        // Verifica token de autorização (opcional mas recomendado)
        const webhookSecret = (env && env.WOOVI_WEBHOOK_SECRET) || (typeof WOOVI_WEBHOOK_SECRET !== 'undefined' ? WOOVI_WEBHOOK_SECRET : '');
        if (webhookSecret) {
          const authHeader = request.headers.get('Authorization') || '';
          if (authHeader !== webhookSecret) {
            return new Response('Unauthorized', { status: 401 });
          }
        }

        const event = await request.json();
        const eventType = event.event || '';

        // Log do evento (em produção, salvar no D1 ou KV)
        console.log('[Woovi Webhook]', eventType, event.charge?.correlationID || '');

        // Aqui você pode:
        // 1. Salvar no Cloudflare D1: await env.DB.prepare('INSERT INTO pix_events...').run()
        // 2. Salvar no KV: await env.KV.put('pix_'+correlationID, JSON.stringify(event))
        // 3. Notificar via WebSocket ou Server-Sent Events

        // Por ora retornamos 200 para confirmar recebimento
        return new Response(JSON.stringify({ ok: true, event: eventType }), {
          status: 200, headers: { 'Content-Type': 'application/json' }
        });
      } catch (err) {
        return new Response(JSON.stringify({ error: err.message }), { status: 500 });
      }
    }

    /* ══════════════════════════════════════════════════════════════════
       FIREBASE FCM — Push Notifications (HTTP v1 API)
       Admin SDK: chaves em env.FIREBASE_PROJECT_ID / FIREBASE_CLIENT_EMAIL / FIREBASE_PRIVATE_KEY
    ══════════════════════════════════════════════════════════════════ */

    // ── POST /api/fcm/register — salva token FCM do dispositivo ──────
    if (path === '/api/fcm/register' && request.method === 'POST') {
      try {
        const body = await request.json();
        const { token, userId = 'anonymous', userAgent = '' } = body;
        if (!token) {
          return new Response(JSON.stringify({ error: 'token obrigatório' }), {
            status: 400, headers: { 'Content-Type': 'application/json', ...corsHeaders }
          });
        }
        // Por ora loga e retorna ok (em produção: salvar no D1/KV)
        console.log(`[FCM] Token registrado — userId:${userId} token:${token.substring(0,20)}...`);
        return new Response(JSON.stringify({ ok: true, message: 'Token FCM registrado' }), {
          status: 200, headers: { 'Content-Type': 'application/json', ...corsHeaders }
        });
      } catch(err) {
        return new Response(JSON.stringify({ error: err.message }), {
          status: 500, headers: { 'Content-Type': 'application/json', ...corsHeaders }
        });
      }
    }

    // ── POST /api/fcm/send — envia push via Firebase HTTP v1 API ─────
    // Body: { token: string, title: string, body: string, data?: object }
    // Usa JWT gerado com a Service Account key para autenticar
    if (path === '/api/fcm/send' && request.method === 'POST') {
      try {
        const projectId   = (env && env.FIREBASE_PROJECT_ID)   || 'kainowpay';
        const clientEmail = (env && env.FIREBASE_CLIENT_EMAIL) || '';
        const privateKey  = (env && env.FIREBASE_PRIVATE_KEY)  || '';

        if (!clientEmail || !privateKey) {
          return new Response(JSON.stringify({ error: 'FIREBASE_CLIENT_EMAIL / FIREBASE_PRIVATE_KEY não configurados' }), {
            status: 500, headers: { 'Content-Type': 'application/json', ...corsHeaders }
          });
        }

        const body = await request.json();
        const { token, title = 'KaiNowPay', body: msgBody = '', data = {}, topic } = body;

        if (!token && !topic) {
          return new Response(JSON.stringify({ error: 'token ou topic obrigatório' }), {
            status: 400, headers: { 'Content-Type': 'application/json', ...corsHeaders }
          });
        }

        // Gera OAuth2 access token via JWT (Service Account → Google OAuth2)
        const accessToken = await getFirebaseAccessToken(clientEmail, privateKey);

        // Monta payload FCM HTTP v1
        const fcmPayload = {
          message: {
            ...(token ? { token } : { topic }),
            notification: { title, body: msgBody },
            webpush: {
              notification: {
                title, body: msgBody,
                icon: 'https://kainowpay.com.br/favicon.svg',
                badge: 'https://kainowpay.com.br/favicon.svg',
                requireInteraction: false,
              },
              fcm_options: { link: 'https://kainowpay.com.br/' },
            },
            data: Object.fromEntries(Object.entries(data).map(([k,v])=>[k, String(v)])),
          }
        };

        const fcmRes = await fetch(
          `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
          {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${accessToken}`,
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(fcmPayload),
          }
        );

        const fcmData = await fcmRes.json();
        if (!fcmRes.ok) {
          console.error('[FCM send error]', fcmData);
          return new Response(JSON.stringify({ error: 'FCM API error', details: fcmData }), {
            status: fcmRes.status, headers: { 'Content-Type': 'application/json', ...corsHeaders }
          });
        }

        return new Response(JSON.stringify({ ok: true, messageId: fcmData.name }), {
          status: 200, headers: { 'Content-Type': 'application/json', ...corsHeaders }
        });

      } catch(err) {
        console.error('[FCM send]', err);
        return new Response(JSON.stringify({ error: err.message }), {
          status: 500, headers: { 'Content-Type': 'application/json', ...corsHeaders }
        });
      }
    }

    return new Response(`<!DOCTYPE html><html><body style="font-family:sans-serif;text-align:center;padding:60px;background:#0D0D3B;color:#fff">
      <h1 style="font-size:4rem">404</h1>
      <p style="color:rgba(255,255,255,.6);margin:12px 0 24px">Página não encontrada</p>
      <a href="/" style="background:#3949AB;color:#fff;padding:12px 28px;border-radius:12px;text-decoration:none;font-weight:600">← Voltar ao Portal</a>
    </body></html>`, { status: 404, headers: html });
  }
};
