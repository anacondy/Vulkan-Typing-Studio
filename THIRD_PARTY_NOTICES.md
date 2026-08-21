# Third-Party and Font Notices

Vulkan Typing Studio source code is licensed under Apache-2.0.

No third-party font binaries are included in this repository.

The interface and typing controls may request fonts by locally installed family name, including:

- Poor Richard
- Kruti Dev 010
- Mangal
- Nirmala UI
- Shruti
- Chanakya
- Arial
- Georgia

Those names and font files remain subject to their respective owners’ licenses. Users and distributors are responsible for obtaining fonts lawfully. Vulkan falls back to available system fonts when a requested font is unavailable.

The repository also uses standard web platform APIs and contains no third-party runtime JavaScript packages. `jsdom` is an optional development-only dependency used by the smoke test and is governed by its own license as recorded by npm.
