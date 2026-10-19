"""Arma la aplicación publicable en dist/ desde src/ + data/ + public/.

Produce:
  dist/index.html                 la herramienta (catálogo embebido, funciona en file://)
  dist/Pinguino_Pictogramas.html  copia suelta para usar sin instalar
  dist/sw.js, manifest, íconos    para que sea instalable (PWA)
Uso: python build.py
"""
import json, re, shutil, pathlib

ROOT = pathlib.Path(__file__).parent
SRC, DATA, PUB, DIST = ROOT / "src", ROOT / "data", ROOT / "public", ROOT / "dist"

html = (SRC / "pictogramas.html").read_text(encoding="utf-8")
cat = (DATA / "catalogo.json").read_text(encoding="utf-8").replace("</", "<\\/")
json.loads(cat.replace("<\\/", "</"))  # el catálogo debe ser JSON válido
version = re.search(r"var VERSION='([^']+)'", html).group(1)

out = html.replace("/*__CATALOG__*/null", cat, 1)
assert "/*__CATALOG__*/" not in out, "no se pudo insertar el catálogo"

if DIST.exists():
    shutil.rmtree(DIST)
shutil.copytree(PUB, DIST)
# en la versión publicada el ícono viene de archivos, no embebido
pub = re.sub(r'<link rel="icon" href="data:image/svg\+xml[^"]*">',
             '<link rel="icon" href="icons/favicon-32.png" sizes="32x32"><link rel="icon" href="icons/icon.svg" type="image/svg+xml">', out, count=1)
(DIST / "index.html").write_text(pub, encoding="utf-8")
(DIST / "Pinguino_Pictogramas.html").write_text(out, encoding="utf-8")
(DIST / "sw.js").write_text((SRC / "sw.js").read_text(encoding="utf-8").replace("__VERSION__", "v" + version), encoding="utf-8")
(DIST / ".nojekyll").write_text("")
# carpeta para pendrive: doble clic en "Instalar Pictogramas" (Windows, sin administrador)
PEN = DIST / "Pictogramas_pendrive"
shutil.copytree(ROOT / "instalador", PEN)
(PEN / "app" / "Pinguino_Pictogramas.html").write_text(out, encoding="utf-8")
(PEN / "VERSION.txt").write_text("Pingüino Pictogramas " + version + "\r\n", encoding="utf-8")
shutil.make_archive(str(DIST / "Pictogramas_pendrive"), "zip", DIST, "Pictogramas_pendrive")
shutil.rmtree(PEN)
print(f"Pingüino Pictogramas {version} → {DIST} (con Pictogramas_pendrive.zip)")
