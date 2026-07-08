<!-- BEGIN TEAM STANDARDS (managed by dotnet-toolkit — do not edit by hand; run /update-bootstrap-repo) v0.1.0 -->
# .NET Team Conventions

Shared rules for AI coding assistants. Claude Code reads this via `@AGENTS.md` in CLAUDE.md;
GitHub Copilot reads AGENTS.md from the repo root natively — so the same rules apply in both tools.

## Stack
- ASP.NET Core MVC (.NET 10 SDK; builds net8.0-net10.0 targets), C#, EF Core, SQL Server
- Bootstrap 5 for UI — no other CSS frameworks
- On-prem Azure DevOps Server (dcotfs02); private NuGet packages from the internal feed

## Build & test
- Build: `dotnet build <solution>.slnx`
- Nullable is ENABLED — treat CS86xx warnings as real bugs; never silence with `!`
- Test: `dotnet test`

## Architecture & data access
- Repository pattern: controllers NEVER touch DbContext directly
- Async all the way: no `.Result`, `.Wait()`, or `async void` (except event handlers)
- EF Core: `AsNoTracking()` for read-only queries; add `Include()` deliberately to avoid N+1
- Return DTOs from actions, not EF entities

## Conventions
- `_camelCase` private fields; PascalCase public members; one type per file
- Prefer literal string unions / records over enums for fixed sets (team decision)
- Guard clauses over nested ifs; fail fast
- Razor views: Bootstrap 5 utility classes; site JS in wwwroot/js, not inline

## Security (non-negotiable)
- No secrets in code, config, or commit messages — use user-secrets / Key Vault
- Every controller action has explicit `[Authorize]` (or documented `[AllowAnonymous]`)
- Never commit: appsettings.*.local.json, .claude/settings.local.json, .env

## Git
- Branch per change; never commit to main
- Conventional commits: `type(scope): summary`
<!-- END TEAM STANDARDS -->
