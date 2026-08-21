# Vulkan V7 Transparency, Security, Performance, and Market Report

**Audit date:** 21 August 2026  
**Audited artifact:** `typing_studio_frontend.html`  
**SHA-256:** `858a09c7f8826114978d99b43eac6f982cf1eb316f0e9cc133489b8f9fcd841b`  
**Status:** functional prototype; not independently certified

---

## 1. Executive assessment

Vulkan V7 is a highly compact, offline browser prototype with a polished minimal interface and an unusual focus on English plus Hindi/legacy-layout practice. Its strongest current qualities are:

- extremely small source/runtime payload
- zero runtime dependencies
- no network activity or telemetry
- responsive physical/virtual keyboard feedback
- focused editor experience
- safe-format paste policy
- Unicode Hindi plus InScript/Remington-oriented input profiles
- an original Keys Buster exercise mode

Its most important weaknesses are:

- it is not yet a native desktop application
- Hindi legacy-layout scoring is not exhaustive or certified
- multi-code-point Devanagari sequences can be scored incorrectly
- free-typing accuracy is only a correction-based estimate
- token count is approximate
- consistency is an experimental implementation
- formatting uses deprecated `document.execCommand`
- there is no persistent history, adaptive curriculum, accessibility certification, or cross-OS browser matrix
- Windows 7 execution depends on end-of-life browser/webview technology

### Bottom-line answer

**Is it lightweight?** Yes, exceptionally lightweight as a frontend artifact.

**Is it fast?** Architecturally likely fast for ordinary passages, but real-browser FPS, memory, and long-passage performance have not yet been benchmarked. Keys Buster currently rebuilds the entire passage DOM after every key and will not scale as well as an incremental renderer.

**Is it secure?** Relatively low-risk for local offline use because there is no network, backend, storage, or external dependency. It is not yet hardened enough to call production-secure for hostile web hosting or enterprise deployment.

**Is it cross-platform?** The HTML file is portable across browsers, but native packaging and a real Windows/Linux test matrix do not yet exist. Windows 7 compatibility is possible only through legacy browsers/webviews whose security support has ended.

**Can its scores be trusted?** English Keys Buster results for ordinary text are reasonably interpretable. Free-typing accuracy, token estimates, consistency, and complex Hindi/Kruti scoring should not yet be used for certification, exams, recruitment, or legal claims.

---

## 2. What was tested

### 2.1 Static artifact audit

Captured in `audit/static_audit_results.json`:

| Measurement | V7 result |
|---|---:|
| Standalone HTML size | 42,291 bytes |
| Gzip-compressed size | 12,549 bytes |
| HTML lines | 140 |
| HTML elements | 116 |
| IDs | 40 |
| Duplicate IDs | 0 |
| Script blocks | 1 opening / 1 closing |
| External HTTP references | 0 |
| `eval()` calls | 0 |
| `new Function()` calls | 0 |
| `document.write()` calls | 0 |
| Network API mentions | 0 |
| Persistent-storage API mentions | 0 |
| `innerHTML` assignments | 1 |

JavaScript syntax was checked with:

```bash
node --check app_v7.js
```

Result: passed.

### 2.2 Automated DOM smoke suite

The jsdom suite in `audit/functional_smoke.js` passed **23/23 checks**:

- product branding initializes
- QWERTY is the default layout
- Kruti Dev 010 is the default font/profile
- virtual keyboard renders
- dialogs initialize
- bold paste survives sanitization
- italic paste survives sanitization
- underline paste survives sanitization
- images are removed
- scripts are removed
- image-only paste changes nothing
- English Keys Buster selects Georgia
- a correct English key advances
- an incorrect key also advances
- an incorrect key is recorded
- Backspace cannot advance Keys Buster
- completion opens results
- Hindi Keys Buster selects Kruti Dev
- tested Remington `t → ज` mapping succeeds
- custom resize changes width
- custom resize changes height
- formatting commands are connected
- page scrollbar reaches idle state

Captured output: `audit/functional_smoke_results.json`.

### 2.3 Keyboard-table structural audit

Captured in `audit/mapping_audit_results.json`:

| Profile | Table entries | Unique outputs | Multi-code-point outputs |
|---|---:|---:|---:|
| InScript | 94 | 94 | 6 |
| Kruti Dev / Remington emulation | 94 | 91 | 20 |

The audit identified repeated Remington outputs for `ल`, `घ`, and `झ`. Repeated outputs are not automatically wrong because multiple physical combinations can produce related glyphs, but inverse key hints become ambiguous.

The audit also identifies a deeper issue: Vulkan’s target is split with `Array.from`, while some mapped outputs contain multiple Unicode code points, such as `क्ष`, `श्र`, `ज्ञ`, `र्`, or half-letter combinations. A multi-code-point mapped output cannot reliably equal one current code-point target. This is a known correctness limitation.

### 2.4 What was not tested

The following were **not** completed in this audit environment:

- real Chromium rendering benchmark
- real Firefox rendering benchmark
- Windows 7 hardware/VM test
- Windows 10 or 11 installer test
- Arch Linux X11 test
- Arch Linux Wayland test
- screen-reader audit
- keyboard-only accessibility audit
- high-contrast mode
- 125%/150%/200% DPI matrix
- IME composition events
- mobile soft keyboard
- clipboard behavior across Word, LibreOffice, Google Docs, and legacy DTP programs
- long-duration soak test
- memory profiling
- formal penetration test
- exhaustive Hindi mapping comparison against certified typing-exam software

Therefore, this report does not claim complete cross-platform or production validation.

---

## 3. Current technology stack

### Runtime

- semantic HTML
- embedded CSS
- vanilla JavaScript
- browser DOM APIs
- Selection and Range APIs
- Clipboard events
- Pointer events with mouse/touch fallback
- native `<dialog>` elements
- local timer APIs

### Explicitly absent

- framework runtime
- server
- database
- authentication
- analytics
- cookies
- network requests
- external font downloads
- CDN dependencies
- package-manager dependencies at runtime
- Electron or bundled Chromium
- Tauri/Rust shell
- native Qt shell

### Architecture

The runtime is a single HTML file. State is held in JavaScript variables for:

- active keyboard profile
- Shift/Caps state
- editor selection
- timer state
- session measurements
- Keys Buster target and index
- errors
- resize state
- scrollbar and focus-idle timers

The separate `app_v7.js` is a reviewable copy of the JavaScript embedded in the HTML. It is not loaded as a second runtime resource.

### Maintainability assessment

The no-build structure is easy to distribute but increasingly difficult to maintain:

- JavaScript is concentrated in one closure
- CSS and application markup are concentrated in one HTML file
- state is not modularized
- there are no TypeScript types
- there is no formal unit-test runner configuration
- mapping data, rendering, metrics, input handling, and security policy are mixed together

For continued development, the code should be split into modules while retaining a generated single-file release artifact.

---

## 4. Feature inventory

### Editor and UI

- Poor Richard interface styling with Georgia fallback
- separate typing-area font
- autofocus
- focus blur
- hover, `Esc`, and three-second idle ribbon restoration
- automatic caret-follow scrolling
- non-editor text selection disabled
- non-editor context menus disabled
- independent editor/keyboard/Buster resize grips
- idle scrollbar fading
- responsive layout rules

### Text input

- English input
- Unicode Hindi input
- QWERTY, AZERTY, QWERTZ, and Dvorak display/input profiles
- InScript mapping
- Kruti Dev / Remington emulation
- Chanakya selection
- physical-key animation
- clickable virtual keyboard
- Shift and Caps behavior

### Text handling

- bold
- italic
- underline
- safe-format rich paste
- image/embed rejection
- live words, characters, and estimated tokens

### Practice and measurement

- timer presets
- custom timer up to three hours
- timer begins on first attempt
- Keys Buster custom text
- script-based English/Hindi profile choice
- moving key lane
- English hint under Hindi current key
- broken-key list
- disabled Backspace in Keys Buster
- completion dialog
- words, WPM, accuracy, and consistency

### Privacy

- no account
- no telemetry
- no network
- no persistence

---

## 5. How measurement currently works

### 5.1 Session start

A session timestamp is created by the first recorded typing attempt. Editor focus by itself does not start the timer.

This matches the requested behavior.

### 5.2 Words

Displayed editor words are calculated by trimming text and splitting on Unicode whitespace.

The result dialog’s “words typed” is a natural word count, not the standardized five-character WPM unit.

In Keys Buster, the displayed result is based on the portion of the target that has been advanced through. Because incorrect attempts also advance, it can count target words that were not typed correctly. The separate accuracy value partially explains this, but the label “words typed” is potentially misleading.

### 5.3 Characters

The free editor uses JavaScript `text.length`, which counts UTF-16 code units.

For ordinary English and Devanagari BMP characters this is usually intuitive. Emoji and some supplementary Unicode symbols may count as two. Combining marks are counted separately. A future version should offer code-point or grapheme-cluster counts.

### 5.4 Net WPM

Current formula:

```text
net WPM = (usable characters / 5) / elapsed minutes
```

- Keys Buster usable characters = correct attempted keys
- Free typing usable characters = final editor text length

The five-character convention is standard across typing products, but products differ in error penalties and treatment of corrected mistakes. References:

- [Typing speed and accuracy glossary](https://alllangtype.com/typing-speed-accuracy/)
- [Monkeytype metric documentation](https://dev.monkeytype.com/)

#### Trust limitation

Free typing permits pasting. Pasted content changes final editor length but does not represent physical keystrokes. If a timed session has started, pasting can inflate free-typing WPM. Vulkan therefore has no cheat-resistant or exam-safe free-typing score yet.

### 5.5 Accuracy

#### Keys Buster

```text
accuracy = correct attempts / all attempts × 100
```

This is straightforward when each target unit corresponds to one key output.

#### Free typing

No source passage exists, so correctness cannot be known. Vulkan treats Backspace corrections as errors:

```text
accuracy estimate = (attempts - recorded errors) / attempts × 100
```

This does not detect spelling mistakes, wrong words left uncorrected, selection replacement, mouse edits, or paste. It must be described as a correction-based estimate, not true accuracy.

### 5.6 Consistency

Vulkan places correct attempts into one-second buckets and converts each bucket to a per-second WPM rate. It then computes:

```text
100 - coefficient of variation × 100
```

The result is clamped from zero to 100.

This approach is directionally consistent with tools that use WPM variance. Monkeytype also documents a coefficient-of-variation-based consistency score. However:

- bucket size affects the result
- a partial last second is treated like a full sample
- pauses produce zero-speed samples
- very short tests are unstable
- different products map variance differently

The value is useful for internal comparison but not directly interchangeable with every competitor.

### 5.7 Token estimate

Current token estimation:

- Latin alphanumeric runs: about one token per four characters
- Devanagari runs: about one token per two code points
- punctuation/symbols: approximately one each
- whitespace: not independently counted

This is a heuristic, not BPE tokenization. Exact token count depends on a specific model and encoding. OpenAI explicitly notes that language and model affect tokenization: [What are tokens and how to count them?](https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them).

The `~` prefix is mandatory and honest. Do not use this number for API billing, context-limit enforcement, or provider comparison.

---

## 6. Hindi and legacy-font accuracy

### What Vulkan does correctly

- distinguishes input mapping from visual font selection
- stores Hindi as Unicode rather than unreadable legacy ASCII
- includes researched InScript and Remington-oriented tables
- automatically chooses a Hindi profile for Devanagari Keys Buster exercises
- changes the English physical-key hint according to the active profile
- handles tested simple mappings such as Remington `t → ज`

### What it does not yet do

- certified Kruti Dev 010 byte-for-byte legacy encoding
- complete Chanakya conversion
- contextual reordering for every pre-base matra
- grapheme-cluster segmentation
- full conjunct sequence matching
- normalization beyond initial NFC target normalization
- dead-key or Alt-code coverage
- exhaustive shifted/AltGr validation
- official exam-profile validation

Kruti Dev is non-Unicode while Mangal/Nirmala are Unicode. Accurate interchange requires conversion logic, not merely a CSS font change. Sources:

- [Mangal vs. Kruti Dev](https://typingexam.in/blog/how-to-enable-hindi-mangal-inscript-keyboard-on-windows/)
- [Kruti Dev ↔ Unicode distinction](https://nationaltypinghub.in/kruti-to-unicode.html)

### Current trust rating by text type

| Scenario | Confidence |
|---|---|
| English ASCII Keys Buster | Moderate to high for prototype use |
| English punctuation/layout variants | Moderate; needs broader layout tests |
| Simple one-code-point Hindi mappings | Moderate |
| Hindi matras and conjuncts | Low to moderate |
| Certified Kruti Dev exam equivalence | Not established |
| True legacy Kruti/Chanakya document output | Not implemented |

---

## 7. Security assessment

### 7.1 Positive security properties

- no network calls
- no external scripts or styles
- no third-party runtime dependencies
- no user account or credentials
- no database
- no persistent storage
- no telemetry
- no `eval`
- no `new Function`
- no `document.write`
- clipboard images and embedded objects are rejected
- pasted rich text is reconstructed into new safe elements
- event attributes, URLs, arbitrary CSS, pasted fonts, and original DOM nodes are not copied
- the only allowed rich formatting is strong/emphasis/underline plus line structure

The absence of network and persistence substantially reduces the impact of many web threats.

### 7.2 Paste sanitizer design

Vulkan parses clipboard HTML in an inert document, traverses it, and creates new nodes in the live document. It does not append the untrusted original nodes. Allowed output is intentionally narrow.

This is safer than assigning clipboard HTML directly to `innerHTML`.

### 7.3 Remaining risks

#### Manual sanitizer

The sanitizer is custom code, not a battle-tested library. Industry guidance generally recommends a maintained sanitizer such as DOMPurify for hostile HTML. DOMParser alone is not a sanitizer, although Vulkan adds an allowlist reconstruction stage. See:

- [DOMParser is not automatically XSS-safe](https://stackoverflow.com/questions/64772302/is-parsing-html-with-domparser-safe-from-xss)
- [MDN warning on HTML injection sinks](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML)
- [DOMPurify as the common browser-side sanitizer](https://www.pkgpulse.com/guides/sanitize-html-vs-dompurify-vs-xss-xss-prevention-2026)

#### One `innerHTML` restoration

Vulkan saves and restores the editor’s own generated `innerHTML` when entering/leaving Keys Buster. It is not populated directly from raw clipboard HTML, but reducing this trust boundary or sanitizing on restore would be safer.

#### No Content Security Policy

The application has inline CSS and JavaScript and no CSP. That is convenient for a single offline file but not ideal for hosted production. A packaged/hosted version should separate scripts/styles and use a strict CSP.

#### End-of-life Windows 7 browser

Firefox 115 ESR was the final Firefox line for Windows 7 and security updates ended in February 2026. Continuing to use an obsolete browser online is a material security risk: [Windows 7 Firefox support ending](https://www.neowin.net/news/mozilla-is-ending-firefox-support-on-windows-7/).

An offline local file has less exposure, but the operating system and browser remain unsupported.

### 7.4 Security conclusion

| Deployment | Assessment |
|---|---|
| Local offline personal practice | Reasonably low attack exposure; still a prototype |
| Local shared/lab machine | Needs kiosk controls, signed package, and policy testing |
| Public website | Needs DOMPurify, CSP, dependency policy, and penetration testing |
| Enterprise or exam deployment | Not ready |
| Handling confidential text | No transmission occurs, but no formal security certification exists |

---

## 8. Performance and footprint

### 8.1 What is demonstrably lightweight

- 42.3 KB standalone HTML
- 12.5 KB gzip
- 26.5 KB extracted JavaScript source
- zero runtime packages
- zero network round trips
- no framework hydration
- no image, font, or media assets
- one browser document

By frontend payload standards, this is exceptionally small.

### 8.2 Runtime efficiency strengths

- keyboard contains only roughly fifty interactive keys
- layout changes rebuild a small DOM
- counters are simple linear scans
- no background network polling
- one active timer interval during a timed session
- rendering is local

### 8.3 Performance risks

#### Full Keys Buster rerender

`renderTarget()` reconstructs a span for every target code point after every attempt. Complexity is approximately O(n) per key, producing O(n²) total work across a complete passage.

For a few hundred characters this is normally acceptable. For very long passages, it can cause excess DOM allocation and garbage collection.

Recommended fix: render once and update only previous/current/next spans, or virtualize the visible passage.

#### Character/token rescans

Word, character, and token estimates rescan the entire editor content on each input. This is acceptable for normal document sizes but should be debounced or incrementally maintained for very large text.

#### Caret measurement

Caret visibility schedules a geometry check after input. This is appropriate for UX but can cause layout reads. It should be profiled in real Chromium/Firefox.

### 8.4 What cannot currently be claimed

There is no evidence yet for:

- exact startup milliseconds
- idle RAM
- active RAM
- sustained FPS
- CPU use
- battery use
- ten-thousand-character latency
- performance on low-end Windows 7 hardware

The app is small by construction, but “fast” needs real-browser measurement before it becomes a benchmarked claim.

---

## 9. Cross-platform and packaging assessment

### Current reality

Vulkan V7 is cross-platform **as an HTML document**, not as a native installed application.

It can run wherever a sufficiently capable browser supports the APIs used. The current launchers simply open the file.

### Windows 7

Technical execution is possible with legacy browsers/webviews, but mainstream browser security support has ended. This conflicts with the goal of a secure modern product.

### Modern Windows and Linux

Current Chromium and Firefox should support the required APIs, but no real test matrix has yet been run. Arch Linux also requires testing under both X11 and Wayland, multiple desktop scaling levels, and common font packages.

### Packaging options

| Stack | Advantages | Costs/risks | Fit for Vulkan |
|---|---|---|---|
| Current standalone HTML | Tiny, zero install, easiest distribution | Browser dependency, not native, weak update story | Excellent prototype |
| Electron | Consistent bundled Chromium, mature ecosystem | Commonly very large and memory-heavy | Poor match for lightweight goal |
| Tauri 2 | Small package, system webview, Rust security boundary | Webview differences; Windows 7 setup/toolchain complexity | Strong modern-OS candidate |
| Qt 5.15 | Windows 7 target support, native control, mature desktop framework | Older branch/lifecycle, larger engineering effort | Strong legacy-build candidate |
| Qt 6 | Modern Qt | No Windows 7 support | Modern-only option |

Modern comparisons generally place Electron installers around tens to hundreds of megabytes and Tauri in the low-megabyte range because Tauri uses the system webview. These figures vary by application and must not be treated as Vulkan measurements: [2026 desktop-stack comparison](https://www.digitalapplied.com/blog/desktop-apps-web-stack-tauri-electron-deno-wails-2026).

Tauri documents special Windows 7 WebView2 installer requirements, including embedded/offline options: [Tauri Windows installer](https://v2.tauri.app/distribute/windows-installer/). Qt documents Windows 7 as a Qt 5.15 target, while Qt 6 dropped it: [Qt 5.15 platforms](https://doc.qt.io/qt-5.15/supported-platforms.html).

### Recommended release strategy

1. Keep the standalone HTML as the portable preview/reference implementation.
2. Build a Tauri package for supported modern Windows and Linux.
3. Treat Windows 7 as a separately built and tested legacy edition.
4. Consider Qt 5.15 for the legacy edition if Tauri/WebView2 reliability is insufficient.
5. Never market Windows 7 as secure for general online use.

---

## 10. Market comparison, August 2026

Modern typing products generally fall into four categories:

1. **Customizable speed testing** — Monkeytype
2. **Adaptive weak-key practice** — keybr
3. **Structured education/classroom** — TypingClub and Typing.com
4. **Offline desktop tutoring** — RapidTyping, Klavaro, TIPP10, TypingMaster-style products

A current market overview describes Monkeytype as strong in custom/timed tests and detailed statistics, keybr as adaptive weak-key practice, TypingClub/Typing.com as curricula, and RapidTyping as an offline Windows option: [2026 typing software comparison](https://www.itechguides.com/10-free-typing-software-for-windows-pc-apps-and-online-tools/).

Monkeytype’s own site lists time/word/quote/Zen/custom modes, WPM, raw WPM, accuracy, consistency, history, themes, sound, smooth caret, and multiple languages: [Monkeytype](https://dev.monkeytype.com/).

TypingClub provides structured lessons, progress, scoreboards, attempt history, reports, teacher controls, and per-character/finger analysis: [TypingClub handbook](https://s.typingclub.com/m/corp2/other/typingclub-admin-handbook.pdf).

### Feature comparison

| Capability | Vulkan V7 | Market leaders |
|---|---|---|
| Minimal distraction-free UI | Strong | Common in speed-test products |
| Timed tests | Yes | Standard |
| Custom passage | Yes via Keys Buster | Standard in Monkeytype-like tools |
| Virtual keyboard | Strong and animated | Common in tutors, absent/minimal in some speed tools |
| Multiple Latin layouts | Yes | Common |
| Hindi InScript | Prototype support | Available in specialized Indian typing tools |
| Kruti Dev/Remington orientation | Distinctive prototype feature | Common in Indian exam-specific tools, uncommon globally |
| Keys Buster dial | Distinctive | Not a common mainstream pattern |
| WPM/accuracy/consistency | Yes, with caveats | Standard and generally more mature |
| Rich-text editor | Yes | Unusual for typing tests |
| Offline/no account | Strong privacy advantage | Available in desktop/open-source tools |
| Saved history | No | Common |
| Personal bests/charts | No | Common |
| Adaptive weak-key training | No | Keybr strength |
| Structured lessons | No | TypingClub/Typing.com strength |
| Per-key/finger analytics | Only recent broken-key display | Mature tools provide detailed analysis |
| Themes/sound | No | Common in customizable tools |
| Leaderboards/social racing | No | Common in competitive tools |
| Exam profiles/certification | No | Available in specialized products |
| Accessibility evidence | No | Expected for mature educational software |
| Native installer | No | Desktop products provide one |
| Cloud/classroom administration | No | TypingClub strength |

### Market position

Vulkan is not yet a direct Monkeytype, keybr, or TypingClub replacement. Its strongest potential niche is:

> A private, offline, lightweight English/Hindi typing studio focused on visual keyboard feedback, legacy Hindi muscle memory, and distraction-free custom-text practice.

That niche is credible, but correctness in Hindi sequence handling is the gatekeeper.

---

## 11. Trust matrix

| Claim or subsystem | Current trust level | Reason |
|---|---|---|
| No network transmission | High | Static scan found no network APIs or external resources |
| No persistence/telemetry | High | No storage APIs, accounts, or analytics |
| Small file footprint | High | Direct byte and gzip measurement |
| UI initialization | Moderate-high | Automated DOM smoke coverage |
| Rich-paste image/script rejection | Moderate-high | Allowlist design plus automated tests |
| Resizer event wiring | Moderate | Automated DOM event test; no real-browser drag matrix |
| English Keys Buster basic scoring | Moderate-high | Covered by smoke tests; more punctuation/layout tests needed |
| Hindi simple Remington mapping | Moderate | One representative mapping tested; table researched but not certified |
| Hindi conjunct/matra scoring | Low-moderate | Known multi-code-point mismatch |
| Free-typing WPM | Moderate for ordinary manual typing | Paste and editing can distort score |
| Free-typing accuracy | Low | No reference passage; Backspace proxy only |
| Keys Buster accuracy | Moderate | Sound for one-output/one-target units; sequence issue remains |
| Consistency | Experimental | Reasonable formula, no market calibration |
| Token count | Approximation only | No real model tokenizer |
| Security for offline personal use | Moderate | Small attack surface; custom sanitizer |
| Security for public/enterprise deployment | Low until hardened | No CSP, DOMPurify, pen test, or signed shell |
| Windows 7 secure compatibility | Low | Browser/OS ecosystem is end-of-life |
| Arch/Linux compatibility | Plausible, unverified | Browser architecture is portable; no real matrix yet |

---

## 12. Priority roadmap before production

### P0 — correctness and safety

1. Replace code-point stepping with grapheme/input-sequence stepping.
2. Build authoritative InScript, Remington, Kruti Dev, and Chanakya mapping fixtures.
3. Add thousands of mapping tests, including matras, virama, reph, conjuncts, punctuation, Shift, Caps, and AltGr.
4. Separate “Unicode Remington input” from “true Kruti Dev legacy encoding.”
5. Prevent or disqualify paste during scored timed sessions.
6. Clarify “words advanced” versus “words correctly typed.”
7. Replace custom rich sanitization with DOMPurify for hosted builds.
8. Add a strict CSP in packaged/hosted builds.

### P1 — measurement quality

1. Define published scoring profiles:
   - practice
   - strict test
   - exam-compatible profile
2. Add raw WPM, net WPM, correct/incorrect/extra/missed counts.
3. Use high-resolution monotonic timing (`performance.now`).
4. Define correction policy explicitly.
5. Calibrate consistency against reference implementations.
6. Bundle a named tokenizer such as `o200k_base`, or remove token count from scored UI.
7. Add anti-cheat event accounting for scored sessions.

### P1 — engineering

1. Split source into modules:
   - mappings
   - editor
   - keyboard
   - Keys Buster
   - metrics
   - sanitizer
   - UI state
2. Move to TypeScript.
3. Generate the standalone HTML as a build artifact.
4. Replace deprecated `execCommand` formatting with Selection/Range commands or a minimal maintained editor engine.
5. Incrementally update Keys Buster DOM instead of rebuilding the full passage.
6. Add versioned schemas for results and settings.

### P2 — market readiness

1. Local history and personal bests
2. Per-key error analytics
3. Adaptive weak-key drills
4. Import/export of exercises and results
5. Themes and accessibility settings
6. Screen-reader and WCAG audit
7. Signed installers and update strategy
8. Crash/error reporting that is opt-in and privacy-preserving
9. Offline help and keyboard charts
10. Exam-specific profiles only after formal validation

---

## 13. Required real-world test plan

### Operating systems

- Windows 7 SP1 x86
- Windows 7 SP1 x64
- Windows 10 x64
- Windows 11 x64
- Arch Linux X11
- Arch Linux Wayland
- at least one Ubuntu LTS baseline

### Browsers/webviews

- Chromium 109 legacy Windows 7 baseline
- Firefox 115 ESR legacy baseline
- current Chromium
- current Firefox
- WebView2 packaged runtime
- WebKitGTK if Tauri/Linux is used

### Hardware

- 2-core / 4 GB legacy laptop
- common office laptop
- high-DPI display
- Indian English keyboard
- multiple physical layouts where available

### Functional corpus

- English alphabet, punctuation, symbols, numbers
- AZERTY/QWERTZ/Dvorak physical tests
- Hindi simple vowels/consonants
- all matras
- halant sequences
- conjuncts
- reph/rakar
- nukta characters
- Hindi punctuation and digits
- mixed Hindi/English text
- long passages
- Word/LibreOffice/browser clipboard sources

### Security corpus

- images and data URLs
- SVG event payloads
- malformed HTML
- nested formatting
- event attributes
- script/style/object/embed/iframe
- DOM-clobbering payloads
- huge paste payloads
- bidirectional-control characters

### Measurement validation

For fixed event logs, independently calculate:

- gross WPM
- net WPM
- accuracy
- consistency
- word count
- character count
- grapheme count
- token count for a named tokenizer

Results should be deterministic and compared with at least two mature products under identical passage and duration settings.

---

## 14. Final conclusion

Vulkan V7 is already impressive as a design prototype and unusually efficient as a portable frontend. It has a coherent visual identity, a small private runtime, useful English/Hindi concepts, and working end-to-end interactions.

However, polished UI should not be confused with production maturity. The product is currently best described as:

> **A lightweight, privacy-friendly, functional typing-studio prototype with promising Hindi specialization, but not yet a certified or fully validated typing engine.**

The next technical milestone should not be more visual features. It should be a correctness phase focused on Hindi sequence modeling, measurement fixtures, real-browser automation, and packaging tests. Completing that phase would materially increase how much users can trust Vulkan’s scores and cross-platform claims.
