# Installation & customization

[← Back to the theme](../README.md)

## Quick installation — Windows

1. Download the latest **UniverseLiquidGlass ZIP** from [Releases](https://github.com/psy-zney/UniverseLiquidGlass/releases/latest) and extract it completely.
2. **Close Zen completely**, then run `install.cmd` from the extracted folder (if Zen is still running, the installer will alert you to close it).
3. Reopen Zen with the **Dark** appearance and expanded vertical tabs.

The installer automatically scans all Zen profiles (whether a brand new installation or an existing setup with multiple profiles) and safely applies the theme across all detected profiles, creating a dedicated timestamped backup for each. To target only a specific profile, specify `-ProfilePath`:

```powershell
.\install.cmd -ProfilePath "C:\path\to\your\Zen\profile"
```

Preview the changes without writing files:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1 -ProfilePath "C:\path\to\your\Zen\profile" -WhatIf
```

### What the installer changes

- Backs up `chrome/userChrome.css`, `chrome/userContent.css`, `user.js` and the previous managed theme, if present, in `.universe-liquid-glass-backups/<timestamp>/` inside the profile.
- Copies the theme into `chrome/UniverseLiquidGlass/` and adds one import to each entry CSS file. Your existing custom CSS is preserved.
- Adds a labeled block to `user.js` enabling `toolkit.legacyUserProfileCustomizations.stylesheets`.
- Rejects a locked profile. Bookmarks, passwords, extensions and history are not modified.

Existing theme rules may override this theme. Back up your configuration and disable conflicting theme imports if the appearance differs from the demo.

### Use your current desktop wallpaper

On Windows, install with the optional wallpaper setting:

```powershell
.\install.cmd -UseDesktopWallpaper -ProfilePath "C:\path\to\your\Zen\profile"
```

For an existing installation, run this from the extracted theme folder:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/use-desktop-wallpaper.ps1 -ProfilePath "C:\path\to\your\Zen\profile"
```

This copies the current desktop image into a **local profile setting** for the browser frame and internal new-tab/blank pages. Stars and celestial events appear above the image, beneath native controls. Normal websites retain their own backgrounds, and cannot read the wallpaper variable.

The personal image is not included in this repository or downloaded from the Internet. Wallpaper changes are **not synchronized automatically**; run the command again after changing your desktop image, then restart Zen. Pass `-WallpaperPath "C:\path\to\image.jpg"` to the standalone script to select an image explicitly.

Without a personal image, the theme uses its built-in dark star field. The uninstaller also removes the local wallpaper imports and managed setting.

## Manual installation — Windows, macOS and Linux

1. Open `about:profiles` and find your profile's **Root Directory**. Close Zen.
2. Create `chrome/UniverseLiquidGlass/` inside that profile and copy both files from `theme/` into it.
3. Create or edit `chrome/userChrome.css`. Add this at the start, after `@charset` if present:

   ```css
   @import url("UniverseLiquidGlass/userChrome.css");
   ```

4. In `chrome/userContent.css`, add:

   ```css
   @import url("UniverseLiquidGlass/userContent.css");
   ```

5. In `about:config`, set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`, then restart Zen.

**Tested on Zen 1.23.2b / Windows.** Manual installation on macOS/Linux is documented but has not been tested directly. The [official Zen Mods repository is archived](https://github.com/zen-browser/theme-store), so this theme is **not yet submitted or listed**. A [review bundle and submission status](zen-store-submission.md) are available; use Releases for installation in the meantime.

## Uninstall and restore

Close Zen, then run `uninstall.cmd`, or select the profile explicitly:

```powershell
.\uninstall.cmd -ProfilePath "C:\path\to\your\Zen\profile"
```

The uninstaller removes managed imports and theme files while preserving unrelated custom CSS, edits made after installation and backups. Zen may retain the CSS-enabled preference in `prefs.js`; it no longer loads this theme once the imports are removed.

For a manual installation, remove the two imports and `chrome/UniverseLiquidGlass/`. To restore the exact previous configuration, use the backed-up files while Zen is closed.

## Vietnamese input (EVKey / UniKey)

If typing `dd` produces `dđ` or accented letters are duplicated in the address bar, try setting `browser.urlbar.autoFill` to `false` in `about:config`. This disables inline completion in the input while retaining dropdown suggestions. Reset the preference to restore inline completion.

This is a workaround for a [reported Firefox/Zen input conflict](https://bugzilla.mozilla.org/show_bug.cgi?id=1982340), separate from the CSS theme. It is optional and is not automatically applied by the theme installer. The replacement sequence was reproduced in an isolated native Zen profile; actual OS-level Telex input still needs confirmation on the affected machine.

## Customize and build

```text
theme/                   Ready-to-use CSS
src/sidebar.css          Star layers and sidebar motion
src/cosmic_events.py      Celestial objects, lighting and event schedule
src/deep_space_assets.py  Star field and SVG details
src/ui.css               Glass tabs, top bar, Library and popups
scripts/build.py         Deterministic CSS generator, Python standard library only
videos/demo/             Timeline, local demo pages, native recorder and video edit
```

```powershell
python scripts/build.py
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/test-install.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/package.ps1
```

Edit `SCHEDULE` in `src/cosmic_events.py` to change event timing, then rebuild. Adjust `.tab-background` surfaces and borders in `src/ui.css` to change glass brightness. See [video source](../videos/demo/README.md) to reproduce the recording and tracked close-ups.

## Notes

- Black-hole lensing and illumination are graphical approximations, not a complete physical simulation.
- Contrast fixes cover the tested Zen panels and native select popups. Arbitrary websites are not forced into a global color scheme.
- Compact mode keeps its native behavior; when the toolbar is hidden, events appear in the remaining exposed top edge.
- Blur and animation costs depend on your GPU. Zen updates may change the selectors used by this theme.

MIT · [psy-zney](https://github.com/psy-zney)
