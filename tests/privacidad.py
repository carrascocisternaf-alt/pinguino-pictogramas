"""Falla si el repositorio contiene algo que parezca dato de paciente.

Revisa todos los archivos versionados: RUT chilenos, archivos de datos exportados
(xlsx, csv, pdf, docx) y palabras típicas de exportes de AVIS/RAYEN.
"""
import re, subprocess, sys, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
files = subprocess.run(["git", "ls-files"], cwd=ROOT, capture_output=True, text=True).stdout.split()
if not files:  # fuera de git: revisa todo
    files = [str(p.relative_to(ROOT)) for p in ROOT.rglob("*") if p.is_file() and ".git" not in p.parts and "dist" not in p.parts]

RUT = re.compile(r"\b\d{1,2}\.\d{3}\.\d{3}-[\dkK]\b|\b\d{7,8}-[\dkK]\b")
PROHIBIDOS = {".xlsx", ".xls", ".csv", ".pdf", ".docx", ".doc", ".ods"}
PALABRAS = re.compile(r"\b(rut[ _]paciente|fecha[ _](de[ _])?nacimiento)\b", re.I)

errores = []
for f in files:
    p = ROOT / f
    if p.suffix.lower() in PROHIBIDOS:
        errores.append(f"{f}: archivo de datos no permitido en el repositorio")
        continue
    if p.suffix.lower() in {".png", ".ico", ".zip"}:
        continue
    try:
        txt = p.read_text(encoding="utf-8")
    except Exception:
        continue
    if f.startswith("tests/privacidad.py"):
        continue
    for m in RUT.finditer(txt):
        errores.append(f"{f}: posible RUT «{m.group(0)}»")
    for m in PALABRAS.finditer(txt):
        errores.append(f"{f}: texto típico de exporte con pacientes «{m.group(0)}»")

if errores:
    print("PRIVACIDAD: se encontró algo que no debe estar en el repositorio:")
    print("\n".join("  - " + e for e in errores))
    sys.exit(1)
print(f"Privacidad OK ({len(files)} archivos revisados, sin datos de pacientes).")
