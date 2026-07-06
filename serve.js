// Minimal static server for the Benefits Hub workbench (dev only).
// Serves this folder; "/" → index.html (which redirects to workbench.html).
import http from "node:http";
import { readFile } from "node:fs";
import { extname, join, normalize, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = dirname(fileURLToPath(import.meta.url));
const PORT = process.env.PORT || process.argv[2] || 8790;
const MIME = {
  ".html": "text/html", ".js": "text/javascript", ".css": "text/css",
  ".json": "application/json", ".pdf": "application/pdf", ".png": "image/png", ".svg": "image/svg+xml",
};

http.createServer((req, res) => {
  const url = decodeURIComponent(req.url.split("?")[0]);
  const file = normalize(join(ROOT, url === "/" ? "index.html" : url));
  if (!file.startsWith(ROOT)) { res.writeHead(403); res.end(); return; }
  readFile(file, (err, data) => {
    if (err) { res.writeHead(404); res.end("not found"); return; }
    res.writeHead(200, { "Content-Type": MIME[extname(file)] || "application/octet-stream", "Cache-Control": "no-store" });
    res.end(data);
  });
}).listen(PORT, () => console.log("workbench dev server on http://localhost:" + PORT));
