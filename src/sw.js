/* Pingüino Pictogramas — funciona sin conexión.
   Sirve desde la caché y, si hay internet, trae la versión nueva para la próxima apertura. */
const CACHE = 'pictogramas-__VERSION__';
const FILES = ['./', './index.html', './manifest.webmanifest',
  './icons/icon-192.png', './icons/icon-512.png', './icons/maskable-192.png', './icons/maskable-512.png',
  './icons/apple-touch-icon.png', './icons/favicon-32.png', './icons/icon.svg'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES)));
});
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k))))
    .then(() => self.clients.claim()));
});
self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET' || new URL(req.url).origin !== location.origin) return;
  const isPage = req.mode === 'navigate';
  e.respondWith(caches.open(CACHE).then(async cache => {
    const cached = await cache.match(isPage ? './index.html' : req, { ignoreSearch: true });
    const fresh = fetch(req).then(res => {
      if (res && res.ok) cache.put(isPage ? './index.html' : req, res.clone());
      return res;
    }).catch(() => null);
    return cached || (await fresh) || new Response('Sin conexión', { status: 503 });
  }));
});
