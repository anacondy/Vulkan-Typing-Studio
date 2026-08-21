const fs = require('fs');
const [htmlPath, jsPath, releasePath] = process.argv.slice(2);
if (!htmlPath || !jsPath || !releasePath) {
  console.error('Usage: node audit/sync_check.js <index.html> <src/app.js> <standalone.html>');
  process.exit(2);
}
function embedded(path) {
  const text = fs.readFileSync(path, 'utf8');
  const match = text.match(/<script>\s*([\s\S]*?)\s*<\/script>/);
  if (!match) throw new Error('No embedded script in ' + path);
  return match[1].trim().replace(/\r\n/g, '\n');
}
const source = fs.readFileSync(jsPath, 'utf8').trim().replace(/\r\n/g, '\n');
const indexScript = embedded(htmlPath);
const releaseScript = embedded(releasePath);
const failures = [];
if (source !== indexScript) failures.push('src/app.js differs from index.html embedded script');
if (source !== releaseScript) failures.push('src/app.js differs from standalone release embedded script');
if (fs.readFileSync(htmlPath, 'utf8') !== fs.readFileSync(releasePath, 'utf8')) failures.push('index.html differs from standalone release HTML');
if (failures.length) {
  failures.forEach(x => console.error('FAIL:', x));
  process.exit(1);
}
console.log('Source synchronization: PASS');
