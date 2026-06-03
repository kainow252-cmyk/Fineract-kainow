#!/usr/bin/env python3
"""
Playwright mobile test — login + navegação entre páginas
Emula Pixel 5 (Android Chrome mobile)
"""
from playwright.sync_api import sync_playwright
import time, os

URL = "https://kainowpay.com.br"
SCREENSHOTS = "/home/user/webapp/screenshots"
os.makedirs(SCREENSHOTS, exist_ok=True)

def shot(page, name):
    path = f"{SCREENSHOTS}/{name}.png"
    page.screenshot(path=path, full_page=False)
    print(f"  📸 {name}.png")
    return path

def run():
    with sync_playwright() as p:
        # Pixel 5 viewport — emulação mobile real
        pixel5 = {
            "viewport": {"width": 393, "height": 851},
            "user_agent": "Mozilla/5.0 (Linux; Android 11; Pixel 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
            "is_mobile": True,
            "has_touch": True,
            "device_scale_factor": 2.75,
        }

        browser = p.chromium.launch(headless=True, args=["--no-sandbox"])
        ctx = browser.new_context(**pixel5)
        page = ctx.new_page()

        # Captura erros JS do console
        js_errors = []
        page.on("console", lambda m: js_errors.append(f"[{m.type}] {m.text}") if m.type == "error" else None)

        # ── 1. Abrir URL ──────────────────────────────────────────────
        print("\n[1] Abrindo https://kainowpay.com.br ...")
        page.goto(URL, wait_until="networkidle", timeout=30000)
        time.sleep(1.5)
        shot(page, "01_splash")

        # ── 2. Aguardar splash sumir (auto-dismiss 1.4s) ──────────────
        print("[2] Aguardando splash sumir ...")
        time.sleep(2)
        shot(page, "02_after_splash")

        # ── 3. Verificar login visível ────────────────────────────────
        login_visible = page.is_visible("#page-login")
        print(f"[3] #page-login visível: {login_visible}")
        shot(page, "03_login_page")

        # ── 4. Preencher credenciais ──────────────────────────────────
        print("[4] Preenchendo usuário e senha ...")
        page.fill("#inpUser", "admin")
        page.fill("#inpPass", "admin")
        shot(page, "04_credentials_filled")

        # ── 5. Clicar em Entrar ────────────────────────────────────────
        print("[5] Clicando Entrar (button.lgn-btn-primary) ...")
        # Usar JavaScript para disparar o login — mais próximo do comportamento real
        page.evaluate("doLogin()")
        time.sleep(1.5)
        shot(page, "05_after_login")

        # ── 6. Verificar estado pós-login ─────────────────────────────
        print("\n[6] Estado pós-login:")
        state = page.evaluate("""
            () => ({
                appActive:    document.getElementById('app').classList.contains('active'),
                loginActive:  document.getElementById('page-login').classList.contains('active'),
                splashDisplay: document.getElementById('splash').style.display,
                splashPointerEvents: document.getElementById('splash').style.pointerEvents,
                splashZIndex: document.getElementById('splash').style.zIndex,
                loginPointerEvents: document.getElementById('page-login').style.pointerEvents,
                loginZIndex:  document.getElementById('page-login').style.zIndex,
                loginDisplay: document.getElementById('page-login').style.display,
                // Computed styles (what browser actually uses)
                splashComputedPE: window.getComputedStyle(document.getElementById('splash')).pointerEvents,
                splashComputedDisplay: window.getComputedStyle(document.getElementById('splash')).display,
                loginComputedPE: window.getComputedStyle(document.getElementById('page-login')).pointerEvents,
                loginComputedDisplay: window.getComputedStyle(document.getElementById('page-login')).display,
            })
        """)
        for k, v in state.items():
            icon = "✅" if v not in ('', None, False, 'auto', 'all') or k in ('appActive',) else "⚠️"
            if k == 'appActive': icon = "✅" if v else "❌"
            if k == 'loginActive': icon = "✅" if not v else "❌"
            print(f"  {icon} {k}: {v!r}")

        # ── 7. Checar overlays residuais com position:fixed ───────────
        print("\n[7] Overlays position:fixed após login:")
        overlays = page.evaluate("""
            () => {
                const suspects = [];
                for(const el of document.querySelectorAll('*')){
                    const s = window.getComputedStyle(el);
                    if(s.position === 'fixed' && s.display !== 'none'){
                        const rect = el.getBoundingClientRect();
                        if(rect.width > 100 && rect.height > 100){
                            suspects.push({
                                id: el.id || el.className.substring(0,30),
                                zIndex: s.zIndex,
                                opacity: parseFloat(s.opacity).toFixed(2),
                                pointerEvents: s.pointerEvents,
                                display: s.display,
                                w: Math.round(rect.width),
                                h: Math.round(rect.height)
                            });
                        }
                    }
                }
                return suspects;
            }
        """)
        if overlays:
            for o in overlays:
                z = int(o['zIndex']) if o['zIndex'].lstrip('-').isdigit() else 0
                blocking = z > 0 and o['pointerEvents'] != 'none' and float(o['opacity']) > 0.01
                flag = "🔴 BLOCKING" if blocking else "🟡 ok"
                print(f"  {flag} #{o['id']} z:{o['zIndex']} op:{o['opacity']} pe:{o['pointerEvents']} {o['w']}x{o['h']}")
        else:
            print("  ✅ Nenhum overlay detectado!")

        # ── 8. Touch hit-test — que elemento está no centro? ─────────
        print("\n[8] Hit-test de toque (elemento no centro da tela):")
        center = page.evaluate("""
            () => {
                const el = document.elementFromPoint(196, 425);
                if(!el) return null;
                const s = window.getComputedStyle(el);
                return {
                    tag: el.tagName,
                    id: el.id,
                    class: el.className.substring(0,50),
                    zIndex: s.zIndex,
                    pointerEvents: s.pointerEvents
                };
            }
        """)
        print(f"  Elemento em (196,425): {center}")
        
        topLeft = page.evaluate("""
            () => {
                const el = document.elementFromPoint(50, 100);
                return el ? {tag:el.tagName, id:el.id, class:el.className.substring(0,40)} : null;
            }
        """)
        print(f"  Elemento em (50,100): {topLeft}")

        # ── 9. Navegar por páginas via tap na nav bar ─────────────────
        print("\n[9] Testando navegação mobile (nav bar):")
        nav_pages = [
            ("pix",           "PIX"),
            ("extrato",       "Extrato"),
            ("cartoes",       "Cartões"),
            ("investimentos", "Invest."),
            ("home",          "Início"),
        ]

        for pg_name, pg_label in nav_pages:
            print(f"\n  → Navegando: {pg_name}")
            try:
                # Checar nav item visível
                selector = f".nav-item[onclick*=\"'{pg_name}'\"]"
                el = page.locator(selector).first
                if not el.count():
                    # Tentar selector alternativo
                    selector = f"[onclick*=\"goPage('{pg_name}')\"]"
                    el = page.locator(selector).first

                el_visible = el.is_visible() if el.count() else False
                print(f"    nav-item visível: {el_visible} (selector: {selector})")

                if el_visible:
                    el.tap()
                else:
                    # Fallback: disparar via JS
                    print(f"    ⚠️ Fallback via JS: goPage('{pg_name}')")
                    page.evaluate(f"goPage('{pg_name}')")

                time.sleep(0.7)

                # Verificar qual página ficou ativa
                active_id = page.evaluate("""
                    () => {
                        const a = document.querySelector('.page.active');
                        return a ? a.id : 'none';
                    }
                """)
                ok = "✅" if pg_name in active_id else "❌"
                print(f"    {ok} página ativa: {active_id}")
                shot(page, f"09_nav_{pg_name}")

            except Exception as ex:
                print(f"    ❌ Erro: {ex}")
                shot(page, f"09_nav_{pg_name}_ERROR")

        # ── 10. Erro JS acumulados ────────────────────────────────────
        print(f"\n[10] Erros JS durante o teste: {len(js_errors)}")
        for err in js_errors[:10]:
            print(f"  ❌ {err}")

        shot(page, "99_final")
        print("\n✅ Teste concluído!")
        browser.close()

if __name__ == "__main__":
    run()
