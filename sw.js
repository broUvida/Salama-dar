// Salama Dar service worker: the app shell, map and advice work offline.
const CACHE = "salama-dar-v4";
const SHELL = ["./", "./index.html", "./config.js", "./manifest.webmanifest", "./icon.svg", "./icon-192.png", "./icon-512.png"];
self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(SHELL)).then(() => self.skipWaiting()));
});
self.addEventListener("activate", (e) => {
  e.waitUntil(caches.keys().then((ks) => Promise.all(ks.filter((k) => k !== CACHE).map((k) => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener("fetch", (e) => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  const fonts = url.host === "fonts.googleapis.com" || url.host === "fonts.gstatic.com";
  if (url.origin !== location.origin && !fonts) return; // never cache report data
  if (url.pathname.endsWith("/moderate.html")) return;
  // stale-while-revalidate
  e.respondWith(caches.open(CACHE).then(async (c) => {
    const hit = await c.match(req, {ignoreSearch: true});
    const net = fetch(req).then((res) => { if (res.ok || res.type === "opaque") c.put(req, res.clone()); return res; }).catch(() => hit);
    return hit || net;
  }));
});
