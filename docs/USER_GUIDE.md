# Vulkan Typing Studio

Vulkan is a minimalist, offline-first typing workspace for English and Hindi practice. It combines a distraction-reduced editor, an animated virtual keyboard, timed sessions, rich-text emphasis, multiple keyboard layouts, and a character-by-character **Keys Buster** exercise mode.

> **Current status:** functional browser prototype, version V7. It is not yet a signed native desktop installer or a certified typing-exam engine.

## Quick start

### Any current desktop browser

Open:

```text
typing_studio_frontend.html
```

No server, account, internet connection, or installation is required.

### Linux

```bash
chmod +x start_linux.sh
./start_linux.sh
```

### Windows

Double-click:

```text
start_windows7.bat
```

The launcher opens the local HTML file in the default browser.

## Default configuration

- Product name: **Vulkan typing studio**
- Physical layout: **QWERTY**
- Typing profile: **Kruti Dev 010**
- Timer: **No timer**
- Editor and virtual keyboard: equal default width
- Interface font: **Poor Richard**, with Georgia fallback

## Main features

### Focused editor

- Autofocus on launch
- Smooth focus mode while typing
- Ribbon returns when hovered, when `Esc` is pressed, or after three seconds of inactivity
- Caret-follow scrolling keeps the current typing position visible
- Vertical editor scrolling without an unnecessary horizontal editor scrollbar
- Page and panel scrollbar thumbs fade while idle/typing and return near the scrolling area
- Typing panel, virtual keyboard, and Keys Buster panel have independent lower-right resize grips

### Formatting and paste handling

- Bold
- Italic
- Underline
- Safe rich-text paste preserves only:
  - text
  - paragraphs and line breaks
  - bold
  - italic
  - underline
- Images, scripts, styles, iframes, embedded objects, video, audio, SVG, canvas, tables, links, colors, and pasted font-family declarations are discarded
- The font selected in Vulkan remains authoritative

### Fonts and input profiles

Typing-area choices:

- Kruti Dev 010
- Mangal
- Nirmala UI
- Shruti
- Chanakya
- Arial
- Georgia

The interface font is separate from the typing-area font.

Important distinction:

- **Mangal and Nirmala UI** are Unicode Devanagari fonts normally paired with an input method such as InScript.
- **Kruti Dev 010** is a legacy, non-Unicode font associated with Remington-style key mappings.
- **Chanakya** is also a legacy font/encoding family.
- **Shruti is a Gujarati Unicode font**, not a Hindi Devanagari font. Hindi glyphs therefore use a fallback when Shruti does not contain them.

Vulkan currently stores Hindi as Unicode. Its Kruti Dev and Chanakya modes emulate physical key mappings; they do not produce a certified legacy-encoded Kruti Dev/Chanakya document.

References:

- [Microsoft Devanagari InScript layout](https://learn.microsoft.com/en-us/globalization/keyboards/kbdindev.html)
- [Mangal Unicode vs. Kruti Dev legacy encoding](https://typingexam.in/blog/how-to-enable-hindi-mangal-inscript-keyboard-on-windows/)
- [Kruti Dev and Unicode conversion distinction](https://nationaltypinghub.in/kruti-to-unicode.html)

### Keyboard layouts

- QWERTY
- AZERTY
- QWERTZ
- Dvorak
- Hindi InScript
- Kruti Dev / Remington
- Chanakya

Physical and virtual key activity use shared mapping tables. Virtual Shift and Caps Lock are interactive, and physical Caps Lock updates the virtual keyboard.

### Timers

Available presets:

- 30 seconds
- 60 seconds
- 1 minute
- 3 minutes
- 5 minutes
- 7 minutes
- 8 minutes
- 10 minutes
- 15 minutes
- Custom duration up to 3 hours

Selecting a duration only arms the timer. It starts on the first typing attempt, not when the editor merely receives focus.

### Keys Buster

1. Select **Keys Buster**.
2. Paste an English or Hindi passage.
3. Type the character shown in the large center card.
4. Every attempt advances the dial.
5. Incorrect attempts are collected under **Broken keys**.
6. Backspace is disabled in this mode.
7. Completion opens the result dialog.

Automatic profile selection:

- Devanagari passage → Kruti Dev 010 / Remington emulation
- Non-Devanagari passage → Georgia / QWERTY behavior

For a Hindi current card, Vulkan shows a smaller English physical-key hint underneath. The hint depends on the active input profile.

## Session results

The result dialog reports:

- Words typed
- Net WPM
- Consistency
- Accuracy

### WPM

Vulkan uses the common five-character convention:

```text
Net WPM = (usable characters / 5) / elapsed minutes
```

The five-character convention is widely used by typing tests, though products differ in how they penalize errors. See [Typing speed and accuracy glossary](https://alllangtype.com/typing-speed-accuracy/).

### Accuracy

- Keys Buster: correct attempts divided by all attempts
- Free typing: correction-based estimate; Backspace is treated as an error because there is no reference passage

### Consistency

Vulkan samples correct-character speed per second and calculates an inverted coefficient of variation:

```text
Consistency = clamp(100 - (standard deviation / mean × 100), 0, 100)
```

This is directionally similar to modern typing tools, but consistency is not governed by one universal industry formula. Monkeytype, for example, describes its score as coefficient-of-variation based but applies its own mapping. See [Monkeytype’s feature and metric description](https://dev.monkeytype.com/).

### Tokens

The status line displays `~tokens`, explicitly marking the value as an estimate. Exact token counts require a named model tokenizer. OpenAI notes that tokenization varies by language, model, and encoding; roughly four English characters per token is only a rule of thumb. See [OpenAI: What are tokens?](https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them).

## Privacy

The current build:

- makes no network requests
- has no analytics or telemetry
- has no account system
- stores no browser history or results
- uses no cookies
- uses no localStorage, sessionStorage, or IndexedDB
- processes text locally in the page

Closing the page discards the session.

## Technology stack

Runtime stack:

- HTML5
- CSS3
- Vanilla JavaScript
- Browser DOM, Selection, Range, Clipboard, Pointer, and Dialog APIs

Not used:

- React, Vue, Angular, or Svelte
- Node.js at runtime
- Electron
- Tauri
- backend server
- database
- CDN
- external fonts or scripts

The shipped standalone frontend is **42,291 bytes uncompressed** and **12,549 bytes gzip-compressed**. It contains no external HTTP resources.

## Project files

```text
typing_studio_frontend.html   Standalone runnable frontend
app_v7.js                     Extracted JavaScript source for review
start_windows7.bat            Windows browser launcher
start_linux.sh                Linux browser launcher
FIXES_V7.md                   Latest focused change summary
audit/static_audit.py         Reproducible static audit
audit/mapping_audit.js        Keyboard mapping structure audit
audit/functional_smoke.js     jsdom functional smoke suite
audit/*_results.json          Captured V7 audit results
TRANSPARENCY_REPORT.md         Detailed limitations and trust report
```

The HTML embeds its runtime JavaScript so that it remains a single portable file. `app_v7.js` is retained separately for review and testing.

## Running the audit

### Static audit

```bash
python audit/static_audit.py typing_studio_frontend.html
node --check app_v7.js
node audit/mapping_audit.js app_v7.js
```

### Functional smoke test

Install jsdom in a temporary development environment:

```bash
npm install jsdom@24
node audit/functional_smoke.js typing_studio_frontend.html
```

The captured V7 run passed **23 of 23 smoke checks**. This is a DOM-level automated test, not a replacement for real-browser and real-operating-system testing.

## Current limitations

- Not yet packaged as a native `.exe`, AppImage, Flatpak, or Arch package
- No saved history, profiles, cloud sync, accounts, or leaderboards
- No adaptive weak-key lesson engine
- No formal accessibility audit
- No IME/composition-event test matrix
- No certified government-exam scoring profile
- No exact AI tokenizer
- No exhaustive Kruti Dev/Chanakya legacy conversion engine
- Hindi conjuncts and multi-code-point key outputs need a grapheme/input-sequence engine before scoring can be considered authoritative
- Formatting currently depends on deprecated browser `execCommand` behavior
- Windows 7 can open the frontend in a legacy browser, but mainstream browser security updates for Windows 7 ended in 2026

See `TRANSPARENCY_REPORT.md` before using Vulkan for exams, hiring, certification, or security-sensitive deployment.

## Recommended packaging direction

For current Windows and Linux systems, a Tauri package is attractive because it uses the system webview and usually produces much smaller bundles than Electron. Tauri’s installer documentation includes special Windows 7/WebView2 requirements, so Windows 7 must be treated as a separate tested target rather than assumed compatible: [Tauri Windows installer documentation](https://v2.tauri.app/distribute/windows-installer/).

For a long-lived Windows 7 build, Qt 5.15 historically supports Windows 7, whereas Qt 6 does not. That route also requires careful lifecycle and security planning: [Qt 5.15 supported platforms](https://doc.qt.io/qt-5.15/supported-platforms.html).

## License and fonts

No license has yet been declared for the Vulkan source itself.

Poor Richard, Kruti Dev, Chanakya, Mangal, Nirmala UI, Shruti, Arial, and Georgia font files are **not bundled**. Rendering depends on fonts installed on the user’s operating system and their respective licenses.
