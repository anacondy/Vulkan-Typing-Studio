# Vulkan Roadmap

## P0 — correctness

- Grapheme-cluster and input-sequence engine
- Authoritative InScript, Remington, Kruti Dev, and Chanakya fixtures
- Matra, virama, reph/rakar, conjunct, nukta, Shift, and AltGr tests
- Separate Unicode Remington input from true legacy encoding/export
- Strict scored-session paste policy
- Correct-vs-advanced word labels

## P0 — security

- DOMPurify for hosted/package builds
- Strict Content Security Policy
- Release checksums and signed artifacts
- Malformed-HTML and DOM-clobbering corpus

## P1 — measurement

- Published practice/strict/exam scoring profiles
- Raw WPM and detailed character counts
- Monotonic timing with `performance.now()`
- Calibrated consistency
- Exact named AI tokenizer or removal of token metric
- Deterministic scoring fixtures

## P1 — architecture

- TypeScript modules
- Generated single-file release
- Incremental Keys Buster renderer
- Replace deprecated `execCommand`
- Browser automation with Playwright

## P2 — product

- Local result history and personal bests
- Per-key and per-finger analytics
- Adaptive weak-key exercises
- Exercise/result import and export
- Themes and accessibility controls
- Signed Tauri packages for supported Windows/Linux
- Separately validated Windows 7 legacy build

See `docs/TRANSPARENCY_REPORT.md` for rationale and trust limitations.
