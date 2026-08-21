const fs = require('fs');
const vm = require('vm');
const source = fs.readFileSync(process.argv[2] || 'app_v7.js', 'utf8');
const start = source.indexOf('var inscriptNormal=');
const end = source.indexOf('var codeButtons=', start);
if (start < 0 || end < 0) throw new Error('Mapping tables not found');
const context = {};
vm.createContext(context);
vm.runInContext(source.slice(start, end), context);
function audit(name, normal, shifted) {
  const all = [...normal.flat(), ...shifted.flat()];
  const multiCodepoint = [...new Set(all.filter(v => Array.from(v).length > 1))];
  const duplicateOutputs = Object.entries(all.reduce((m, v) => (m[v] = (m[v] || 0) + 1, m), {}))
    .filter(([, count]) => count > 1).map(([value, count]) => ({ value, count }));
  return { name, entries: all.length, unique_outputs: new Set(all).size, multi_codepoint_outputs: multiCodepoint, duplicate_outputs: duplicateOutputs };
}
const result = [
  audit('InScript', context.inscriptNormal, context.inscriptShift),
  audit('Kruti Dev / Remington emulation', context.remingtonNormal, context.remingtonShift)
];
console.log(JSON.stringify(result, null, 2));
