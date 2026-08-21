# Security Policy

## Current status

Vulkan V7 is a local, offline-first prototype. It has no backend, accounts, telemetry, persistent browser storage, or runtime network calls.

It has not received an independent penetration test and should not yet be used as an enterprise security boundary or hosted multi-user editor.

## Supported versions

Only the latest repository version is actively maintained.

| Version | Supported |
|---|---|
| Latest default branch | Yes |
| Older ZIP/prototype versions | No |

## Reporting a vulnerability

Please use GitHub’s private security advisory feature for the repository instead of opening a public issue.

Include:

- affected file and version/hash
- browser and operating system
- reproduction steps
- proof-of-concept payload, if safe
- expected impact
- suggested mitigation, if known

Do not include private user data.

## Security boundaries

The current application:

- processes text locally
- rejects pasted images and embedded objects
- reconstructs a narrow allowlist of rich formatting
- does not intentionally transmit or persist content

Remaining risks include:

- custom sanitizer rather than DOMPurify
- inline JavaScript and no strict CSP
- one internal `innerHTML` save/restore path
- unsupported Windows 7 browser/webview environments
- no formal supply-chain or release-signing process

See `docs/TRANSPARENCY_REPORT.md` for the complete assessment.
