VULKAN TYPING STUDIO — WINDOWS 7 PORTABLE PACKAGE
==================================================

HOW TO START
------------
1. Extract the entire ZIP to a normal folder.
2. Double-click "Vulkan Compatibility Check.bat" first.
3. Confirm that core browser checks pass and review installed-font results.
4. Double-click "Start.bat".

SUPPORTED WINDOWS 7 BROWSER BASELINES
-------------------------------------
Recommended: Firefox 115 ESR on Windows 7 SP1.
Alternative: Chrome 109, the final Chrome line for Windows 7.
Internet Explorer is NOT supported.

The launcher searches common 32-bit and 64-bit Firefox/Chrome installation paths. It does not install or download anything.

FONTS
-----
Font binaries are not bundled because several requested fonts have separate/proprietary licenses.

Windows 7 commonly supplies Mangal. Other fonts may require lawful installation:
- Poor Richard (UI; Georgia fallback)
- Kruti Dev 010
- Nirmala UI
- Shruti
- Chanakya
- Arial
- Georgia

If a font is unavailable, the browser uses a fallback. Run the diagnostics page after installing fonts and restart the browser.

WHAT WAS VERIFIED BEFORE PACKAGING
----------------------------------
- Standalone JavaScript syntax
- Source/standalone synchronization
- 23/23 automated DOM smoke checks
- English Keys Buster profile
- representative Kruti/Remington t -> ज mapping
- formatting command wiring
- safe rich paste behavior
- image/script paste rejection
- resize event wiring
- offline/no-network static audit
- no duplicate HTML IDs
- no npm vulnerabilities in development tests

WHAT CANNOT BE CERTIFIED HERE
-----------------------------
This package was not executed inside a real Windows 7 SP1 virtual machine in the build environment. Smoothness, exact font availability, graphics-driver behavior, and browser installation must be checked on the target PC using the included diagnostics page.

The application is intended for offline use on Windows 7. Windows 7 itself is end-of-life. Keep the machine isolated from untrusted web browsing where possible.

FILES
-----
Vulkan-Typing-Studio-Standalone.html  Main standalone application
Start.bat                            Browser-detecting launcher
Vulkan-Win7-Diagnostics.html         Offline feature/font/FPS checker
Vulkan Compatibility Check.bat       Diagnostics launcher
README.txt                           This file
LICENSE                              Apache License 2.0
THIRD-PARTY-NOTICES.txt              Font/license notice
SHA256SUMS.txt                       Integrity hashes

No installation and no administrator access are required after a compatible browser and fonts are already installed.
