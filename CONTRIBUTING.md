# Contributing to Vulkan

Thank you for helping improve Vulkan Typing Studio.

## Before contributing

Please read:

- `README.md`
- `docs/TRANSPARENCY_REPORT.md`
- `SECURITY.md`

## Development setup

Requirements for the audit suite:

- Node.js 20+
- npm
- Python 3.9+

```bash
npm install
npm test
python audit/static_audit.py index.html
```

The application itself has no runtime dependencies and can be opened directly from `index.html`.

## Source synchronization

`index.html` and `release/Vulkan-Typing-Studio-Standalone.html` contain the embedded runtime script. `src/app.js` is the reviewable source copy.

If application logic changes, update all three and run:

```bash
npm run check:sync
```

## Pull-request expectations

- Keep the distraction-free visual design unless the issue specifically requests a redesign.
- Add or update tests for behavior changes.
- Do not add network calls, telemetry, cookies, or persistent storage without explicit design review.
- Do not bundle proprietary font files.
- Document changes to scoring formulas.
- Do not claim exam/certification compatibility without authoritative fixtures and validation.
- Keep English and Hindi input behavior separately testable.

## Hindi mapping contributions

Mapping changes require:

1. A cited source or authoritative keyboard chart.
2. Normal and shifted key fixtures.
3. Tests for matras, virama, reph/rakar, conjuncts, nukta, punctuation, and digits where applicable.
4. A clear distinction between Unicode input and true legacy font encoding.

## Security

Do not open public issues for undisclosed vulnerabilities. Follow `SECURITY.md`.

## License of contributions

By submitting a contribution, you agree that it is licensed under Apache-2.0, the repository’s license.
