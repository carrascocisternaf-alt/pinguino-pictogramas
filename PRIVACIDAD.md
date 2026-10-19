# Privacidad

**Pingüino Pictogramas no guarda datos de pacientes.** Ni en el navegador, ni en el repositorio, ni en ningún servidor.

## En el navegador

| Se guarda (localStorage) | Qué contiene |
|---|---|
| `pict_cfg_v1` | preferencias: idioma, impresora, papel, opciones de QR, nombre y dirección del establecimiento |
| `pict_textos_v1` | frases en kreyòl corregidas por el equipo |
| `pict_pautas_v1` | pautas guardadas: medicamento + dosis + cuidados, sin paciente |

No se guarda: nombre, RUT, prescriptor ni ningún dato del ticket de emergencia, la lista de medicamentos de una entrega ni el nombre escrito en la hoja. Todo eso vive solo en la pestaña abierta y se borra al cerrarla o con *Nuevo paciente*. La prueba automática `tests/smoke.py` falla si aparece cualquier otra clave.

## Código QR

El QR contiene solo la pauta (medicamento, dosis, horarios, cuidados). Nunca el nombre del paciente. En modo enlace la pauta va después del `#` de la dirección, por lo que no se envía al servidor al abrirla.

## En el repositorio

- `.gitignore` bloquea planillas, PDF y documentos (`xlsx`, `csv`, `pdf`, `docx`…).
- `tests/privacidad.py` se ejecuta en cada cambio y lo rechaza si encuentra algo que parezca un RUT o un exporte con datos de pacientes.
- El catálogo (`data/catalogo.json`) contiene solo el arsenal farmacológico y fichas de medicamentos, sin información de personas.
