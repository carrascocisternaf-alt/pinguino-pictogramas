# Pingüino Pictogramas

Indicaciones de medicamentos que se entienden sin leer. Arma la etiqueta adhesiva de 10 × 7 cm para la impresora Zebra con pictogramas de **cuándo** (momentos del día o comidas), **cuánto** (pastillas dibujadas) y **con qué cuidados**, en español o kreyòl.

Parte del Ecosistema Pingüino APS · CESFAM Limache Viejo, DESAM Limache.

## Usar

- **En línea e instalable:** la versión publicada en GitHub Pages se instala desde Edge o Chrome con el botón *Instalar aplicación*. Después funciona sin internet.
- **Desde un pendrive:** `dist/Pictogramas_pendrive.zip` (también en la web publicada). Se descomprime, doble clic en *Instalar Pictogramas* y queda el ícono en el Escritorio. No necesita internet ni administrador.
- **Sin instalar:** `dist/Pinguino_Pictogramas.html` funciona abriéndolo directamente (doble clic), también en Firefox.

## Qué hace

- Busca en el arsenal del CESFAM y rellena nombre, concentración y forma tal como vienen.
- Lee la indicación de la receta (`1 comp c/12 h por 30 días con las comidas`, `½-0-1`, `al desayuno y a la cena`…).
- Etiqueta en blanco y negro con solo los horarios que lleva el medicamento.
- Ticket de emergencia con el formato de AVIS, para cuando el sistema no permite rebajar.
- Hoja de horario para llevar, con figuras (estrella, triángulo…) que relacionan cada caja con su fila.
- Pautas guardadas y código QR opcional.

## Privacidad

No guarda datos de pacientes. Ver [PRIVACIDAD.md](PRIVACIDAD.md).

## Desarrollo

```
python build.py            # arma dist/ desde src/ + data/ + public/
python tests/privacidad.py # verifica que no haya datos de pacientes en el repositorio
python tests/smoke.py      # pruebas en navegador (requiere playwright)
```

Cada cambio en `main` se prueba y se publica solo (`.github/workflows/publicar.yml`). Si una prueba falla, no se publica.

| Carpeta | Contenido |
|---|---|
| `src/` | la herramienta (`pictogramas.html`) y el service worker |
| `data/` | catálogo: arsenal del CESFAM cruzado con las fichas del Compendio |
| `public/` | manifiesto e íconos para instalar |
| `tests/` | privacidad y pruebas en navegador |
| `instalador/` | instalador para pendrive (Windows) |

## Validación pendiente

Las frases en kreyòl deben ser revisadas por un hablante nativo o facilitador intercultural. Las correcciones se hacen en *Ajustes → Traducción al kreyòl* y se exportan.
