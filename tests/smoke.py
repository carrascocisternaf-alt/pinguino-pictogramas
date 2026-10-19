"""Pruebas de humo en un navegador real (Playwright + Chromium).

Sirve dist/ en localhost y comprueba: carga sin errores, catálogo del arsenal,
lector de receta, etiqueta sin desbordes, instalable (manifiesto + service worker)
y funcionamiento sin conexión. Uso: python build.py && python tests/smoke.py
"""
import asyncio, http.server, socketserver, threading, functools, pathlib, sys
from playwright.async_api import async_playwright

DIST = pathlib.Path(__file__).resolve().parent.parent / "dist"
PORT = 0  # se elige uno libre al iniciar

def servir():
    class Silencioso(http.server.SimpleHTTPRequestHandler):
        def log_message(self, *a): pass
    h = functools.partial(Silencioso, directory=str(DIST))
    global PORT
    srv = socketserver.TCPServer(("127.0.0.1", 0), h)
    PORT = srv.server_address[1]
    threading.Thread(target=srv.serve_forever, daemon=True).start()
    return srv

RECETAS = {
    "1 comp c/12 hrs por 30 días con las comidas": ("dia", {"m": "1", "n": "1"}),
    "1 comp al desayuno y a la cena": ("comidas", {"b": "1", "c": "1"}),
    "1 cap en ayunas por 30 dias": ("comidas", {"a": "1"}),
    "½-0-1": ("dia", {"m": "½", "n": "1"}),
}

async def main():
    fallas = []
    srv = servir()
    async with async_playwright() as p:
        b = await p.chromium.launch()
        ctx = await b.new_context(viewport={"width": 1280, "height": 1000})
        pg = await ctx.new_page()
        errs = []
        pg.on("pageerror", lambda e: errs.append(str(e)))
        await pg.goto(f"http://127.0.0.1:{PORT}/")
        n = await pg.evaluate("()=>__PICT.ARS.length")
        if n < 200: fallas.append(f"catálogo con {n} presentaciones")
        for txt, (esq, dose) in RECETAS.items():
            r = await pg.evaluate("t=>{const r=__PICT.parseRx(t);return [r.esquema||'dia',r.dose]}", txt)
            if r[0] != esq or r[1] != dose: fallas.append(f"receta «{txt}» → {r}")
        # etiquetas de todo el arsenal sin desbordes (español y kreyòl+español)
        bad = await pg.evaluate("""()=>{const P=__PICT,S=P.S,bad=[];
          [['es',false],['ht',true]].forEach(([l,d])=>{S.pl=l;S.dual=d;S.lang=l==='es'?'es':'bi';
            const h=document.createElement('div');document.body.appendChild(h);
            P.ARS.forEach(a=>{const it=P.newItem();Object.assign(it,{nombre:a.n,conc:a.d,ff:a.ff,forma:P.mapForm(a.ff+' '+a.n),food:'comida',dur:'perm'});
              it.dose.m='1';it.dose.d='½';it.dose.t='1';it.dose.n='2';it.warns=['alcohol','frio','sos'];
              h.innerHTML=P.labelHTML(it,S.lang);P.fitBoxes(h);
              h.querySelectorAll('.lp-top,.lp-txt,.lp-col,.lp-w').forEach(e=>{if(e.scrollHeight>e.clientHeight+1||e.scrollWidth>e.clientWidth+1)bad.push(a.n+' '+l);});});
            h.remove();});return bad.length;}""")
        if bad: fallas.append(f"{bad} etiquetas con texto desbordado")
        # instalable
        await pg.evaluate("()=>navigator.serviceWorker.ready.then(()=>1)")
        cdp = await ctx.new_cdp_session(pg)
        ie = (await cdp.send("Page.getInstallabilityErrors"))["installabilityErrors"]
        if ie: fallas.append(f"no instalable: {ie}")
        # sin conexión
        await pg.wait_for_timeout(500)
        await ctx.set_offline(True)
        await pg.reload()
        if await pg.evaluate("()=>__PICT.ARS.length") != n: fallas.append("no abre sin conexión")
        # no guarda la lista de pacientes en el navegador
        claves = await pg.evaluate("()=>Object.keys(localStorage)")
        raras = [k for k in claves if k not in ("pict_cfg_v1", "pict_textos_v1", "pict_pautas_v1")]
        if raras: fallas.append(f"claves inesperadas en el navegador: {raras}")
        if errs: fallas.append(f"errores de JavaScript: {errs}")
        await b.close()
    srv.shutdown(); srv.server_close()
    if fallas:
        print("FALLAS:\n" + "\n".join("  - " + f for f in fallas)); sys.exit(1)
    print(f"OK: {n} presentaciones, recetas, etiquetas, instalable y sin conexión.")

asyncio.run(main())
