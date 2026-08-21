const fs = require('fs');
const { JSDOM } = require('jsdom');
const html = fs.readFileSync(process.argv[2] || 'typing_studio_frontend.html', 'utf8');
const checks = [];
function check(name, condition) {
  checks.push({ name, pass: Boolean(condition) });
  if (!condition) throw new Error('FAIL: ' + name);
}
const commands = [];
const dom = new JSDOM(html, {
  runScripts: 'dangerously',
  pretendToBeVisual: true,
  url: 'file:///vulkan/typing_studio_frontend.html',
  beforeParse(window) {
    window.alert = () => {};
    window.HTMLElement.prototype.scrollIntoView = function () {};
    window.Range.prototype.getBoundingClientRect = function () { return { top: 0, bottom: 18, left: 0, right: 0, width: 0, height: 18 }; };
    window.HTMLDialogElement.prototype.showModal = function () { this.setAttribute('open', ''); };
    window.HTMLDialogElement.prototype.close = function () { this.removeAttribute('open'); };
    window.document.execCommand = (command) => { commands.push(command); return true; };
  }
});
const w = dom.window, d = w.document;
const wait = ms => new Promise(resolve => setTimeout(resolve, ms));
const key = (value, code) => new w.KeyboardEvent('keydown', { key: value, code, bubbles: true, cancelable: true });
function setCaretAtEnd(el) {
  el.focus();
  const range = d.createRange(); range.selectNodeContents(el); range.collapse(false);
  const selection = w.getSelection(); selection.removeAllRanges(); selection.addRange(range);
}
(async () => {
  await wait(60);
  check('Vulkan branding renders', d.querySelector('.quiet-title').textContent.includes('Vulkan'));
  check('default layout is QWERTY', d.getElementById('layout').value === 'QWERTY');
  check('default font is Kruti Dev 010', d.getElementById('font').value === 'Kruti Dev 010');
  check('virtual keyboard renders', d.querySelectorAll('#keyboard .key').length >= 45);
  check('three dialogs exist', d.querySelectorAll('dialog').length === 3);

  const editor = d.getElementById('editor');
  editor.innerHTML = '';
  setCaretAtEnd(editor);
  const richPaste = new w.Event('paste', { bubbles: true, cancelable: true });
  richPaste.clipboardData = { getData(type) {
    if (type === 'text/html') return '<p><b>Bold</b> <i>Italic</i> <u>Under</u><img src=x onerror=alert(1)><script>alert(1)</script></p>';
    if (type === 'text/plain' || type === 'Text') return 'Bold Italic Under';
    return '';
  }};
  editor.dispatchEvent(richPaste);
  check('rich paste keeps bold', Boolean(editor.querySelector('strong')));
  check('rich paste keeps italic', Boolean(editor.querySelector('em')));
  check('rich paste keeps underline', Boolean(editor.querySelector('u')));
  check('rich paste strips image', !editor.querySelector('img'));
  check('rich paste strips script', !editor.querySelector('script'));
  const beforeImageOnly = editor.textContent;
  const imagePaste = new w.Event('paste', { bubbles: true, cancelable: true });
  imagePaste.clipboardData = { getData(type) { return type === 'text/html' ? '<img src=x>' : ''; }};
  editor.dispatchEvent(imagePaste);
  check('image-only paste changes nothing', editor.textContent === beforeImageOnly);

  d.getElementById('busterToggle').click();
  d.getElementById('sourceText').value = 'test';
  d.getElementById('beginText').click();
  check('English Keys Buster selects Georgia', d.getElementById('font').value === 'Georgia');
  editor.dispatchEvent(key('t', 'KeyT'));
  check('correct English key advances', d.getElementById('progress').textContent.startsWith('1 / 4'));
  editor.dispatchEvent(key('x', 'KeyX'));
  check('wrong key also advances', d.getElementById('progress').textContent.startsWith('2 / 4'));
  check('wrong key is recorded', d.getElementById('broken').textContent.includes('x→e'));
  editor.dispatchEvent(key('Backspace', 'Backspace'));
  check('Backspace does not advance Keys Buster', d.getElementById('progress').textContent.startsWith('2 / 4'));
  editor.dispatchEvent(key('s', 'KeyS'));
  editor.dispatchEvent(key('t', 'KeyT'));
  await wait(180);
  check('Keys Buster completion opens results', d.getElementById('resultsDialog').hasAttribute('open'));
  d.getElementById('closeResults').click();

  d.getElementById('replaceText').click();
  d.getElementById('sourceText').value = 'ज';
  d.getElementById('beginText').click();
  check('Hindi Keys Buster selects Kruti Dev', d.getElementById('font').value === 'Kruti Dev 010');
  editor.dispatchEvent(key('t', 'KeyT'));
  await wait(180);
  check('Kruti Remington t maps to ज', d.getElementById('broken').textContent === 'Broken keys: none');

  const app = d.querySelector('.app');
  Object.defineProperty(app, 'clientWidth', { configurable: true, value: 1200 });
  const panel = d.getElementById('editorPanel');
  panel.getBoundingClientRect = () => ({ width: 1120, height: 350, top: 0, left: 0, right: 1120, bottom: 350 });
  const grip = d.getElementById('editorResizeGrip');
  grip.dispatchEvent(new w.MouseEvent('mousedown', { bubbles: true, cancelable: true, button: 0, clientX: 100, clientY: 100 }));
  d.dispatchEvent(new w.MouseEvent('mousemove', { bubbles: true, cancelable: true, clientX: 150, clientY: 150 }));
  d.dispatchEvent(new w.MouseEvent('mouseup', { bubbles: true, clientX: 150, clientY: 150 }));
  check('custom resize changes editor width', panel.style.width === '1170px');
  check('custom resize changes editor height', panel.style.height === '400px');

  d.getElementById('busterToggle').click();
  editor.innerHTML = 'format me'; setCaretAtEnd(editor);
  d.querySelector('[data-format="bold"]').dispatchEvent(new w.MouseEvent('mousedown', { bubbles: true, cancelable: true }));
  d.querySelector('[data-format="italic"]').dispatchEvent(new w.MouseEvent('mousedown', { bubbles: true, cancelable: true }));
  d.querySelector('[data-format="underline"]').dispatchEvent(new w.MouseEvent('mousedown', { bubbles: true, cancelable: true }));
  check('format commands are wired', ['bold','italic','underline'].every(x => commands.includes(x)));

  await wait(5100);
  check('page scrollbar enters idle state', d.documentElement.classList.contains('page-scroll-idle'));

  console.log(JSON.stringify({ passed: checks.length, failed: 0, checks }, null, 2));
  dom.window.close();
})().catch(error => {
  console.error(error.stack || error);
  console.error(JSON.stringify({ passed: checks.filter(x => x.pass).length, failed: 1, checks }, null, 2));
  dom.window.close();
  process.exit(1);
});
