# Publishing Vulkan on GitHub

## Browser upload

1. Create a new empty GitHub repository, for example `Vulkan-Typing-Studio`.
2. Do not ask GitHub to generate another README or license—the ZIP already includes both.
3. Extract `Vulkan-Typing-Studio-GitHub.zip` on your computer.
4. Open the extracted `Vulkan-Typing-Studio` folder.
5. Upload the **contents of that folder** to the repository root.
6. Commit the files.

`README.md`, `LICENSE`, `index.html`, and `.github/` should appear at the repository root.

## Command line

```bash
cd Vulkan-Typing-Studio
git init
git add .
git commit -m "Initial public release: Vulkan V7"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/Vulkan-Typing-Studio.git
git push -u origin main
```

## Enable GitHub Pages

1. Open repository **Settings**.
2. Select **Pages**.
3. Under **Build and deployment**, choose **Deploy from a branch**.
4. Select branch `main` and folder `/ (root)`.
5. Save.

GitHub Pages will use the root `index.html`.

## Recommended repository settings

- Enable Issues.
- Enable private vulnerability reporting/security advisories.
- Protect the `main` branch once collaborators join.
- Require the included CI workflow before merge.
- Add repository topics such as `typing`, `typing-test`, `hindi`, `inscript`, `krutidev`, `offline-first`, and `vanilla-javascript`.

## Before announcing a release

```bash
npm ci
npm test
python audit/static_audit.py index.html
```

Then create a GitHub Release and attach `release/Vulkan-Typing-Studio-Standalone.html` or the full repository ZIP.
