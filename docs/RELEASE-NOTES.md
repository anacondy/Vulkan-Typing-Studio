# Vulkan Typing Studio — Release Notes (draft)

**Version:** 0.7.0 (V7)
**Status:** DRAFT — not yet published. These notes and the four assets below are
intended to be attached to a GitHub Release **after** the packaging PR is reviewed
and merged. Do not publish the release yourself.

All assets are fully offline, zero-dependency, and make **no** network requests.
Each archive bundles the standalone `Vulkan-Typing-Studio-Standalone.html`, a
one-click launcher, a `README.txt`, and the Apache-2.0 `LICENSE`. No installers,
accounts, telemetry, or external resources are involved.

## Assets

| Asset | Platform | Classification | How to run |
|-------|----------|----------------|------------|
| `Vulkan-Typing-Studio-Windows-x64.zip` | Windows 8.1 / 10 / 11 | **Modern** | Extract, double-click `Start.bat` |
| `Vulkan-Typing-Studio-Linux-x64.tar.gz` | Linux (x86-64) | **Modern** | Extract, `./start.sh` (first time: `chmod +x start.sh`) |
| `Vulkan-Typing-Studio-macOS-universal.tar.gz` | macOS 11+ (Apple Silicon **and** Intel) | **Modern** | Extract, double-click `start.command` (first time: right-click → Open) |
| `Vulkan-Typing-Studio-Windows7-Portable.zip` | Windows 7 SP1 | **Windows 7 only (legacy)** | Extract, run `Vulkan Compatibility Check.bat`, then `Start.bat` |

> The three modern packages are **not** for Windows 7. Windows 7 requires the
> separate `Vulkan-Typing-Studio-Windows7-Portable.zip` asset, which bundles an
> offline compatibility/diagnostics check. The Windows 7 package is built from
> distinct sources (`release/win7/`) and does **not** affect or downgrade the
> modern packages.

Integrity hashes for all four assets are in [`release/SHA256SUMS.txt`](release/SHA256SUMS.txt).
Each archive also contains its own internal `SHA256SUMS.txt`.

## What is inside each package

### Modern packages (Windows / Linux / macOS)

```text
Vulkan-Typing-Studio/
├── Vulkan-Typing-Studio-Standalone.html   # the entire app (one file)
├── Start.bat          (Windows)           # one-click launcher
├── start.sh           (Linux)
├── start.command      (macOS)
├── README.txt                             # quick start
└── LICENSE                                # Apache-2.0
```

### Windows 7 legacy package

```text
Vulkan-Typing-Studio-Windows7/
├── Vulkan-Typing-Studio-Standalone.html   # same app build
├── Start.bat                             # launches Firefox 115 ESR or Chrome 109
├── Vulkan Compatibility Check.bat        # opens the diagnostics page
├── Vulkan-Win7-Diagnostics.html          # offline feature/font/FPS checker
├── README.txt
├── THIRD-PARTY-NOTICES.txt
└── LICENSE
```

## Known limitations

**Modern packages**
- Require a current, up-to-date browser (Edge, Chrome, Firefox, Safari, or Brave).
- On macOS, the first launch may require right-click → Open (Gatekeeper).
- No fonts are bundled (licensing). Install properly licensed copies of the
  requested fonts (Kruti Dev 010, Mangal, Nirmala UI, Shruti, Chanakya, Poor
  Richard, Arial, Georgia) for full Hindi/Latin coverage; the app falls back to
  available system fonts otherwise.

**Windows 7 package (legacy — use OFFLINE only)**
- Windows 7 is end-of-life. Use only on an isolated machine, not for general
  web browsing.
- Requires **Firefox 115 ESR** or **Chrome 109** (the final Chrome line for
  Windows 7). **Internet Explorer is NOT supported.**
- There is no modern WebView2 on Windows 7; the package launches the system
  browser directly.
- Smoothness, exact font availability, and graphics-driver behavior must be
  verified on the target PC using the included diagnostics page. This package
  was not executed inside a real Windows 7 SP1 virtual machine in the packaging
  environment.

## Reproducing the assets

From a checkout of the packaging branch:

```bash
bash release/build-packages.sh
```

This regenerates all four archives (plus `release/SHA256SUMS.txt`) using only
`zip`, `tar`, and `sha256sum`. No network access is required.

## Publish steps (after the PR is reviewed/merged)

1. Merge this PR (or cut the release from the branch as-is).
2. Draft a new GitHub Release (suggested tag: `v0.7.0`).
3. Attach the four assets:
   - `Vulkan-Typing-Studio-Windows-x64.zip`
   - `Vulkan-Typing-Studio-Linux-x64.tar.gz`
   - `Vulkan-Typing-Studio-macOS-universal.tar.gz`
   - `Vulkan-Typing-Studio-Windows7-Portable.zip`
4. Also attach `release/SHA256SUMS.txt` so users can verify downloads
   (`sha256sum -c SHA256SUMS.txt`).
5. Copy the **Assets**, **Known limitations**, and **Windows 7** notes above into
   the release description.
6. Publish. Do **not** mark as "Latest" until you have confirmed the uploaded
   assets extract and launch correctly.
