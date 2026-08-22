# Changelog

All notable changes to Vulkan Typing Studio are documented here.

## [0.7.0] — 2026-08-21

### Added

- Larger Hindi-to-English hint in Keys Buster
- Equal default width for editor and keyboard
- Pointer-captured resize grips
- Five-second page scrollbar idle fade
- GitHub-ready documentation and audit suite
- Offline portable release packages (no install, no network):
  - `Vulkan-Typing-Studio-Windows-x64.zip` (modern Windows)
  - `Vulkan-Typing-Studio-Linux-x64.tar.gz` (modern Linux)
  - `Vulkan-Typing-Studio-macOS-universal.tar.gz` (macOS Apple Silicon + Intel)
  - `Vulkan-Typing-Studio-Windows7-Portable.zip` (Windows 7 legacy, separate)
- Reproducible, offline `release/build-packages.sh` (uses only zip, tar, sha256sum)
- Release-asset checksum manifest at `release/SHA256SUMS.txt`

### Changed

- Removed successful-key toast feedback
- Improved scrollbar and resize behavior

## [0.6.0] — 2026-08-21

### Added

- Automatic Keys Buster profile selection:
  - Hindi → Kruti Dev/Remington
  - English → Georgia/QWERTY
- Safe rich paste preserving bold, italic, and underline
- Dedicated resize handles

## [0.5.0] — 2026-08-21

### Added

- Image/embed paste rejection
- Non-editor selection/context-menu locking
- Caret-follow scrolling and focus restoration
- Token estimate
- Idle ribbon recovery
- Keys Buster advance-on-attempt behavior

## [0.4.0] — 2026-08-21

### Added

- Vulkan branding
- Hindi input profiles
- Caps Lock synchronization
- Session metrics dialog
- Hindi physical-key hint

## [0.3.0] — 2026-08-21

### Changed

- Rebuilt frontend around a minimal one-row ribbon
- Restored virtual keyboard and two-direction panel resizing
- Removed unrequested document action buttons

## [0.2.0] — 2026-08-21

### Added

- Standalone HTML frontend prototype

## [0.1.0] — 2026-08-21

### Added

- Initial PyQt concept and requirements exploration
