# Changelog

## 1.1.10 — 2026-10-27

- Fix Compact Mode auto-hide: suppress sidebar background, starfield, pseudo-elements, border and shadow when retracted.
- Fix collapsed navbar borders, shadows, and button opacity in Compact Mode.
- Add smooth opacity transitions when sidebar auto-hides and reveals on hover.

## 1.1.9 — 2026-10-24

- Fix native webpage select labels that were forced white by the generic dark-menu rule.
- Make labels inherit the option row foreground for normal, active and grouped entries.
- Give disabled options a readable muted foreground on the light popup.
- Verified against native select popups in Zen 1.23.4b on Windows.

## 1.1.8 — 2026-10-19

- Align the search input and results without overlap or drawing beyond the rounded frame.
- Fit exactly five standard result rows using consistent row heights and gaps.
- Snap scrolling to rows so the list does not stop on a cut-off suggestion.
- Preserve glass styling, keyboard navigation and native text editing.
- Document an optional inline-autofill workaround for duplicated Vietnamese text with EVKey/UniKey.

## 1.1.7 — 2026-10-19

- Restore an opaque starfield sidebar, independent of the frame/new-tab wallpaper.
- Remove the sidebar black-hole visitor while keeping the other eight visitors and star twinkle.
- Keep Library navigation free of page wallpaper in expanded and compact states.
- Include the compact 640px search palette and dark browser frame with subtle page edges.

## 1.1.6 — 2026-10-19

- Reduce the open search surface tint to 22% opacity and soften the full-palette blur.
- Match result cards to tab glass: reflective gradients, brighter borders and inset highlights.
- Add text shadows and brighter URLs, plus an opaque reduced-transparency fallback.
- Preserve the centered layout, five-row limit and keyboard scrolling.

## 1.1.5 — 2026-10-19

- Hide Zen's extra decorative compact-sidebar background so its acrylic layer cannot cover the theme wallpaper.
- Keep the toolbox wallpaper, glass controls, star animations and five-row search layout.

## 1.1.4 — 2026-10-19

- Keep the floating search palette compact with five visible standard rows.
- Preserve centered glass styling and scrolling for remaining suggestions.

## 1.1.3 — 2026-10-19

- Center the complete floating search palette as suggestions grow or shrink.
- More transparent dark glass, brighter edge reflections and clearer URL text.
- Replace nested result height limits with one scrollable list that fits the window.
- Compact suggestion rows; all returned results remain accessible by scrolling.

## 1.1.2 — 2026-10-19

- Sidebar wallpaper now crops to the sidebar instead of the full viewport, keeping its focal subject visible.
- Lighter overlays behind glass controls and a matching wallpaper on the Library icon rail.
- Configurable sidebar focal position through `--cosmos-sidebar-wallpaper-position` (default: `56% center`).
- Verified in native Zen 1.23.3b on Windows.

## 1.1.1 — 2026-10-18

- Floating liquid glass search palette with translucent results and reflective borders.
- Updated selectors for Zen's current native search container and background.
- Readable result titles, muted URLs, clear keyboard selection and scrollable suggestions.
- Transparent input surface, reduced-transparency fallback and reduced-motion support.

## 1.1.0 — 2026-10-18

- Wide cosmic backgrounds on internal new-tab, home, blank and private pages.
- Optional Windows desktop wallpaper copied into a private local profile setting.
- Glass browser frame, sidebar surfaces, address bar and native new-tab controls.
- Stars and celestial events behind page content; ordinary websites keep their backgrounds.
- Desktop-image settings are scoped to browser chrome and internal pages.

## 1.0.0 — 2026-10-17

- Deep black star field with irregular white pinpoints and staggered twinkle.
- Nine celestial events with local illumination and simulated gravitational lensing.
- Liquid glass tabs, selected-tab motion and an active-page loading indicator.
- Cosmic top bar and compact-mode frame events behind browser controls.
- Readable Library Downloads, Spaces, History and native select popups.
- Windows installer, backups, uninstaller, source generator and native Zen demo video.
