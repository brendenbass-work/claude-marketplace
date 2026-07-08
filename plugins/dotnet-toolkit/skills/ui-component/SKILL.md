---
name: ui-component
description: This skill should be used when creating or editing UI in our ASP.NET Core MVC apps — Razor views, forms, tables, cards, modals, buttons, or any front-end markup — so new pages match the Approval Process visual design language (clean corporate-blue SaaS, soft-rounded, tinted-accent, light theme).
allowed-tools: "Read, Grep, Glob, Edit, Write, Bash(dotnet build:*)"
---
# UI conventions — match the Approval Process look & feel

Our apps share one visual language: **clean corporate-blue SaaS, airy, soft-rounded, card-based, light theme, with a tinted-accent system.** New UI must look native to it. Prefer the project's existing CSS variables (`--ap-*`, `--text-*`, `--radius-*`) over hardcoding; the values below are the source of truth when a variable isn't available.

## Design tokens

Colors:
- Primary/brand `#0d6efd` (hover `#0b5ed7`) — buttons, links, active nav, focus rings
- Page background `#f5f6f8`; cards/containers `#ffffff`; borders `rgba(0,0,0,.06)`
- Text: primary/headings `#1a1a2e`; body `#212529`; secondary `#64748b`; muted `#6c757d`
- State (stock Bootstrap 5): success `#198754`, danger `#dc3545`, warning `#ffc107` (use `#b58100`/`#D9A600` when warning text needs contrast)
- Accents (use sparingly, for their specific meaning): orange `#ff8c00` ("replace" actions), purple `#6f42c1` (require-all pills)
- Focus ring: `#258cfb` border + `3px rgba(13,110,253,.12)` glow

Shape & depth:
- Radii: sm 10px · md 14px · lg 18px · xl 20px · pill 999px. **Cards use 18px; pills/search/badges/nav-links use 999px.**
- Shadows are soft and low-opacity: cards `0 10px 24px rgba(0,0,0,.05)`. Never harsh/dark shadows.
- The signature move: apply accents as **low-opacity rgba tints** (`.08–.12` background + matching border + solid colored text), not solid fills. Match this for any new tinted element.

Typography:
- No web font — use the inherited system stack (Bootstrap default). Do not add Google Fonts.
- Base 14px (16px ≥768px), line-height 1.5.
- Titles/brand are `font-weight:700`. Section titles ~1.4–1.75rem, headings color `#1a1a2e`.
- UPPERCASE with letter-spacing (.4px) for table headers and small labels/badges.

Spacing/density: airy. Card header padding ~`20px 24px`, body ~`24px`; ~24px between sections. Content is contained (page wrappers ~1100px; app shell up to ~1450px on wide screens), not full-bleed.

## Components — match these patterns

- **Buttons:** filled with a subtle gradient + colored shadow + hover lift (`translateY(-2px)`), radius 8–12px. Primary submit = blue; destructive = danger red; "replace" = orange. Use `.btn` + one intent class.
- **Cards:** white, 1px `rgba(0,0,0,.06)` border, radius 18px, soft shadow; optional subtle gradient header (`180deg #fff→#fafbfc`). Interactive cards lift on hover.
- **Navbar:** frosted translucent white (`rgba(255,255,255,.95)` + `backdrop-filter: blur(8px)`), pill-shaped nav links, active link = `rgba(13,110,253,.12)` tint + blue text. Brand = Font Awesome icon in a rounded blue badge tile + text.
- **Tables:** uppercase muted headers on `#f8f9fb`, **bottom-border only** (not striped/bordered), subtle row hover `rgba(13,110,253,.02)`; left color-stripe to denote status. Wrap in `.table-responsive`. (DataTables is available.)
- **Inputs:** bordered; search fields are pills (radius 999px); focus = blue border + soft blue ring (above). Use `asp-for` / `asp-validation-for` tag helpers.
- **Status pills / badges:** rounded (999px), tinted background + matching border + colored text; UPPERCASE badges with letter-spacing.
- **Stat cards:** big number (`2rem/700`) + uppercase label + a colored left accent bar matching the metric's state.

## Icons & libraries
- Font Awesome 6 solid (`fa-solid`) for icons — put them in rounded tinted tiles to match the brand style.
- Available in the stack when relevant: DataTables (tables), Select2 (dropdowns), Quill (rich text), SurveyJS (`sv-*`, dynamic forms). Prefer these over introducing new libraries.

## Markup hygiene
- Bootstrap 5 utility classes; no other CSS frameworks; avoid custom CSS unless the token doesn't exist.
- Semantic HTML (`<button>`, `<label for>`, `<th scope>`); no inline `<script>`/`<style>` — site JS in wwwroot/js, CSS in wwwroot/css.
- Server-render by default; reach for JS only when the interaction needs it.

## Before finishing
- Reuse existing `--ap-*` / `--radius-*` variables rather than pasted hex where the project defines them.
- Run `dotnet build` to confirm the view compiles; confirm validation renders for each input.
- Sanity check against the look: soft radii, tinted (not solid) accents, blue-on-light, no harsh shadows, system font.
