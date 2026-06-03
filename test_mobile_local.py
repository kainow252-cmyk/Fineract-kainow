#!/usr/bin/env python3
"""
Playwright mobile test — LOCAL file (sem deploy)
"""
from playwright.sync_api import sync_playwright
import time, os

HTML_PATH = "file:///home/user/webapp/banco-digital/app.html"
SCREENSHOTS = "/home/user/webapp/screenshots"
os.makedirs(SCREENSHOTS, exist_ok=True)

def shot(page, name):
    path = f"{SCREENSHOTS}/local_{name}.png"
    page.screenshot(path=path, full_page=False)
    print(f"  📸 local_{name}.png")
    return path

def run():
    with sync_playwright() as p:
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

        print(f"\n[1] Abrindo arquivo local ...")
        page.goto(HTML_PATH, wait_until="networkidle", timeout=15000)
        time.sleep(2)
        shot(page, "01_splash")

        print("[2] Aguardando splash ...")
        time.sleep(2)
        shot(page, "02_after_splash")

        print("[3] Login ...")
        page.evaluate("document.getElementById('inpUser').value='admin'")
        page.evaluate("document.getElementById('inpPass').value='admin'")
        page.evaluate("doLogin()")
        time.sleep(1.5)
        shot(page, "03_after_login")

        print("\n[4] Estado pós-login:")
        state = page.evaluate("""
            () => ({
                appActive: document.getElementById('app').classList.contains('active'),
                loginActive: document.getElementById('page-login').classList.contains('active'),
                splashDisplay: window.getComputedStyle(document.getElementById('splash')).display,
                splashPE: window.getComputedStyle(document.getElementById('splash')).pointerEvents,
                loginComputedDisplay: window.getComputedStyle(document.getElementById('page-login')).display,
                loginComputedPE: window.getComputedStyle(document.getElementById('page-login')).pointerEvents,
                mobDrawerDisplay: window.getComputedStyle(document.getElementById('mob-drawer')).display,
                mobDrawerPE: window.getComputedStyle(document.getElementById('mob-drawer')).pointerEvents,
                mobDrawerZIndex: window.getComputedStyle(document.getElementById('mob-drawer')).zIndex,
                mobDrawerHasOpen: document.getElementById('mob-drawer').classList.contains('open'),
            })
        """)
        for k, v in state.items():
            print(f"  {k}: {v!r}")

        print("\n[5] Hit-test centro da tela:")
        center = page.evaluate("""
            () => {
                const el = document.elementFromPoint(196, 425);
                if(!el) return null;
                const s = window.getComputedStyle(el);
                return {tag:el.tagName, id:el.id, class:el.className.substring(0,50), z:s.zIndex, pe:s.pointerEvents};
            }
        """)
        print(f"  Elemento em centro: {center}")

        mob_drawer_blocking = page.evaluate("""
            () => {
                const d = document.getElementById('mob-drawer');
                const s = window.getComputedStyle(d);
                return {
                    display: s.display,
                    pointerEvents: s.pointerEvents,
                    zIndex: s.zIndex,
                    opacity: s.opacity,
                    inlineDisplay: d.style.display,
                    hasOpen: d.classList.contains('open')
                }
            }
        """)
        blocking = mob_drawer_blocking['display'] != 'none' and mob_drawer_blocking['pointerEvents'] != 'none'
        icon = "🔴 AINDA BLOQUEANDO" if blocking else "✅ OK - não bloqueia"
        print(f"\n[6] mob-drawer: {icon}")
        print(f"  {mob_drawer_blocking}")

        print("\n[7] Navegação:")
        for pg in ['pix', 'extrato', 'cartoes', 'home']:
            page.evaluate(f"goPage('{pg}')")
            time.sleep(0.5)
            active = page.evaluate("document.querySelector('.page.active')?.id || 'none'")
            shot(page, f"nav_{pg}")
            print(f"  goPage('{pg}') → ativa: {active}")

        shot(page, "99_final")
        print("\n✅ Teste local concluído!")
        browser.close()

if __name__ == "__main__":
    run()
