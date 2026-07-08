---
name: ui-component
description: This skill should be used when creating or editing Razor views and Bootstrap 5 components in our ASP.NET Core MVC projects — pages, forms, tables, modals, or any front-end markup.
allowed-tools: "Read, Grep, Glob, Edit, Write, Bash(dotnet build:*)"
---
# Building UI components (ASP.NET Core MVC + Bootstrap 5)

## Markup
- Bootstrap 5 utility classes only — no other CSS frameworks; no custom CSS unless asked
- Semantic HTML: real `<button>`, `<label for>`, `<th scope>`
- Forms use `asp-for` / `asp-validation-for` tag helpers; don't hand-write name/id when a tag helper exists

## Structure
- Views mirror the controller/action folder layout under Views/
- Shared partials in Views/Shared/, underscore-prefixed (_Card.cshtml)
- No inline `<script>`/`<style>` — site JS in wwwroot/js, CSS in wwwroot/css

## Conventions
- Server-render by default; reach for JS only when the interaction needs it
- Tables: wrap in `.table-responsive` with `.table`; `scope` on header cells
- Buttons: `.btn` + one intent class (.btn-primary / .btn-secondary / .btn-danger)

## Before finishing
- Run `dotnet build` to confirm the view compiles
- Confirm validation renders for each input
