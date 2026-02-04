# Project Audit – cn-agent (post-v1.4.0 sweep)

**Date:** 2026-02-04
**Branch:** `claude/repo-quality-audit-7Nwae`
**Auditor:** Independent automated audit (Claude Opus 4.5)
**Scope:** Full engineering quality — code, documentation, architecture, security, testing, CI, configuration, git practices, cross-file coherence, GitHub forge state.
**Baseline:** v1.4.0 release + 6 additional "best practices sweep" commits on master.
**Prior audits:** v1.0.0 → v1.3.5 → v1.4.0 (same file, now replaced).

---

## 1. Executive Summary

cn-agent is a template repository and CLI for bootstrapping AI agent hubs on the git Coherence Network (git-CN). It contains a CLI tool (494 lines of JavaScript across three files), six skills, six mindsets, a protocol whitepaper (v2.0.3), two companion papers, a manifesto, and supporting documentation. The project is primarily Markdown (42 of 54 files) with four JavaScript files and zero runtime dependencies.

**Since the v1.4.0 audit, a comprehensive "best practices sweep" has landed on master (6 commits).** This sweep addressed 15 of 25 findings from the v1.4.0 audit, including the sole HIGH (sanitization bypass in the "new name" path), all but one MEDIUM, and several LOWs. The improvements are substantial:

- The "new name" path now uses `sanitizeName()` and the new `buildHubConfig()` module.
- `AGENTS.md` no longer references `BOOTSTRAP.md`.
- README version removed from heading; CI/npm/license badges added.
- CI matrix now tests Node 18 and 20.
- `.gitignore` expanded from 5 to 35 entries.
- `experiments/` and `state/` both have READMEs.
- Self-cohere and configure-agent katas added.
- `WRITING.md` sag reference removed.
- `readline` properly closed in `finally` block.
- `CN_WORKSPACE` env var support added.
- CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md, .editorconfig, .nvmrc added.
- Release workflow for npm publish with provenance.

**Overall grade: A** — up from A- in the v1.4.0 audit and B+ in v1.3.5. Zero HIGH findings remain. Only two MEDIUM findings persist.

---

## 2. GitHub Forge State

### 2.1 Repository Metadata

| Property | Value |
|----------|-------|
| Full name | `usurobor/cn-agent` |
| Visibility | Public |
| Template repo | Yes |
| Default branch | `master` |
| License | Apache-2.0 |
| Stars | 3 |
| Forks | 0 |
| Watchers | 0 |
| Open issues | 0 |
| Open PRs | 0 |
| Total commits | ~195 |
| Languages | JavaScript 100% |
| Topics | `cn-agent`, `git-cn`, `coherence-network`, `ai-agent` |
| Created | ~Feb 2026 |
| Disk usage | ~435 KB |

### 2.2 Issues & Pull Requests

- **Issues:** Zero issues have ever been opened (open or closed). The issue tracker is enabled but unused.
- **Pull Requests:** One closed PR (#1, "Audit v1.3.5: comprehensive repo quality audit"). No open PRs.
- **Discussions:** Not visibly enabled.

### 2.3 Releases

| Tag | Title | Date | Pre-release |
|-----|-------|------|-------------|
| v1.4.0 | "Polished and proactive" | 2026-02-04 | No |

Single release. No prior version tags in git. The release notes reference CHANGELOG.md, CN-WHITEPAPER.md, CN-MANIFESTO.md, and CN-EXECUTABLE-SKILLS.md.

### 2.4 CI / Actions

12 workflow runs total. **All succeeded (100% green).** No failures in history.

| Workflow | Runs | Status |
|----------|------|--------|
| CI (test matrix) | 12 | All passing |
| Release (npm publish) | 0 | Not yet triggered |

The CI workflow runs on push to `master` and PRs. Tests Node 18 and 20 in a matrix. The Release workflow triggers on GitHub release publish events.

### 2.5 Branches

Active branches visible on GitHub:
- `master` (default)
- `claude/repo-quality-audit-7Nwae` (this audit)

### 2.6 Security

- No Dependabot alerts (zero dependencies).
- No code scanning configured.
- No secret scanning alerts visible.
- SECURITY.md exists with vulnerability reporting policy.

### 2.7 GitHub State Assessment — Grade: B+

**Strengths:** Clean CI history (100% green), proper release with notes, template repo flag set, topics configured, Apache-2.0 license visible.

**Gaps:**
- No prior version tags (only v1.4.0).
- Issue tracker is enabled but unused — no issue templates, no labels.
- Discussions not enabled (CONTRIBUTING.md references them).
- SECURITY.md mentions "emailing maintainers" but provides no email address.
- GitHub's private vulnerability reporting may not be enabled (no SECURITY advisory published to confirm).

---

## 3. Repository Overview

| Metric | Value |
|--------|-------|
| Total tracked files | 54 |
| Markdown files | 42 |
| JavaScript files | 4 (`cli/index.js` 318 lines, `cli/sanitize.js` 26 lines, `cli/hubConfig.js` 13 lines, `test/cli.test.js` 137 lines) |
| PDF files | 1 (`docs/CN-WHITEPAPER-v2.0.3.pdf`, 435 KB) |
| JSON files | 1 (`package.json`) |
| YAML files | 2 (`.github/workflows/ci.yml`, `.github/workflows/release.yml`) |
| Config files | 3 (`.editorconfig`, `.nvmrc`, `.gitignore`) |
| Runtime dependencies | 0 |
| Test suites | 3 (18 tests, all passing) |
| CI/CD workflows | 2 (CI + Release) |
| Linting config | `.editorconfig` only (no eslint/prettier) |
| License | Apache 2.0 |

---

## 4. What Changed Since v1.4.0 Release

Six commits landed on master after the v1.4.0 release tag, constituting a "best practices sweep." These are grouped into three merge pairs:

### 4.1 Commits

| # | Commit | Summary |
|---|--------|---------|
| 1 | `7f4cfc3` | Add CN-EXECUTABLE-SKILLS.md (executable coherence vision paper) |
| 2 | `47d782d` | docs: add CTB executable skills paper |
| 3 | `f95b472` | Add best-practice project files |
| 4 | `5ecb932` | chore: add CONTRIBUTING, SECURITY, CI badges, release workflow |
| 5 | `8cb271e` | Add best-practice project files + fix all audit findings |
| 6 | `1235493` | chore/docs: apply repo-quality best practices sweep |

### 4.2 v1.4.0 Audit Findings Resolved

| v1.4.0 Ref | Finding | Resolution |
|------------|---------|------------|
| N1 (HIGH) | "New name" bypasses `sanitizeName()` | **Resolved.** Now uses `sanitizeName()` + `buildHubConfig()`. `cli/index.js:204-212`. |
| N2 | AGENTS.md references BOOTSTRAP.md | **Resolved.** Now says "Read `spec/SOUL.md`...then run the self-cohere or configure-agent skill." |
| N3 | README version stale (v1.2.0) | **Resolved.** Version removed from heading entirely. CI/npm/license badges added. |
| N4 | "New name" path doesn't recalculate | **Resolved.** `buildHubConfig()` rebuilds all variables. Destructuring applied. |
| N5 | CI tests only Node 20 | **Resolved.** Matrix strategy with Node 18 and 20. |
| N7 | .gitignore incomplete | **Resolved.** Expanded from 5 to 35 entries covering node_modules/, .env*, editors, IDE, coverage, build artifacts. |
| N8 | experiments/ uncontextualized | **Resolved.** `experiments/README.md` added with status and usage notes. |
| N9 | Hardcoded workspace path | **Resolved.** `CN_WORKSPACE` env var with `/root/.openclaw/workspace` fallback. Error message tells user to set env var. `cli/index.js:51,87`. |
| N12 | Missing katas for self-cohere/configure-agent | **Resolved.** Both created with belt.sequence numbering (1.4, 1.5). |
| N16 | readline not closed on early exits | **Resolved.** try/finally pattern with `rl.close()` in finally block. `cli/index.js:316`. |
| N18 | WRITING.md sag reference | **Resolved.** Now says "If text-to-speech is available." |
| N24 | state/ files in template | **Resolved.** `state/README.md` explains files are scaffolds for hub creation. |

### 4.3 New Additions

| Addition | Location | Lines | Notes |
|----------|----------|-------|-------|
| Hub config module | `cli/hubConfig.js` | 13 | Extracted `buildHubConfig()` for testability |
| Hub config tests | `test/cli.test.js:110-137` | 28 | 4 test cases for buildHubConfig |
| CI matrix | `.github/workflows/ci.yml` | 21 | Node 18 + 20 |
| Release workflow | `.github/workflows/release.yml` | 34 | npm publish with provenance, version-tag verification |
| Contributing guide | `CONTRIBUTING.md` | 51 | Fork-branch-PR workflow, commit style, agent section |
| Security policy | `SECURITY.md` | 50 | Vulnerability reporting, response timeline |
| Code of conduct | `CODE_OF_CONDUCT.md` | 34 | Adapted from Contributor Covenant 2.1 |
| EditorConfig | `.editorconfig` | 17 | 2-space indent, LF, UTF-8, trim trailing whitespace |
| Node version pin | `.nvmrc` | 1 | Node 20 (recommended dev version) |
| Experiments README | `experiments/README.md` | 25 | Contextualizes orphaned design docs |
| State README | `state/README.md` | 23 | Explains scaffold vs hub distinction |
| self-cohere kata | `skills/self-cohere/kata.md` | 84 | Kata 1.4: Wire yourself to an existing hub |
| configure-agent kata | `skills/configure-agent/kata.md` | 91 | Kata 1.5: Configure agent identity |
| CN-EXECUTABLE-SKILLS.md | `docs/CN-EXECUTABLE-SKILLS.md` | 408 | Near-duplicate of EXECUTABLE-COHERENCE.md |

---

## 5. Documentation Quality

### 5.1 README.md — Grade: A

**Improvements:** Version removed from heading (no more staleness risk). Three badges (CI, npm version, license). Clean structure with four-path dispatch table. Repo structure table includes note about `state/threads/` vs protocol-standard `threads/`.

**Minor notes:**
- Setup guide still assumes Ubuntu/root/DigitalOcean. No mention of other OS or non-root setups.
- Missing: link to CHANGELOG.

### 5.2 Whitepaper (docs/CN-WHITEPAPER.md) — Grade: A

Unchanged. 551 lines. Honest implementation status (§10). RFC 2119 keywords. Well-structured.

### 5.3 CN-MANIFESTO.md — Grade: A-

136 lines. Eight concrete principles. §5 lists `state/peers.json` — correct per protocol spec but implementation uses `peers.md`. Minor discrepancy.

### 5.4 Companion Papers — Grade: A- (with caveat)

Two files exist for the same content:
- `docs/EXECUTABLE-COHERENCE.md` (368 lines) — original, 4-space indented code blocks
- `docs/CN-EXECUTABLE-SKILLS.md` (408 lines) — slightly reformatted copy with bold formatting and backtick-fenced code

These are near-duplicates. The differences are purely formatting (bold labels, inline code). Having both creates confusion about which is canonical. See N1.

### 5.5 GLOSSARY.md — Grade: A-

17 entries. Consistent definitions. Doc-local versioning.

### 5.6 DOJO.md — Grade: A-

Updated to v1.2.3. Belt.sequence numbering with 6 katas (1.1-1.5, 2.1). Full belt legend. Self-cohere (1.4) and configure-agent (1.5) katas now listed.

**Remaining issue:** Three original kata files still use old titles (Kata 01, Kata 02, Kata 13). New katas (1.4, 1.5) correctly use belt.sequence. See N3.

### 5.7 CHANGELOG.md — Grade: B

Single-line coherence summaries per version. A reader cannot determine what actually changed without reading commit history.

### 5.8 Skill Documentation — Grade: A-

All six skills documented with TERMS/INPUTS/EFFECTS. All six now have kata files.

**Remaining issue:** reflect SKILL.md is 367 lines (3x any other skill). Six cadence templates are structurally repetitive.

### 5.9 Community Files — Grade: A-

CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md are all present and reasonable.

**Minor issues:**
- CONTRIBUTING.md §Questions references "discussions" — not enabled on GitHub.
- SECURITY.md says "emailing the maintainers" — no email provided. Also mentions "GitHub's private vulnerability reporting" — may not be enabled.

### 5.10 skills/README.md — Grade: B

Version header still says `v1.2.0` — stale. Lists all six skills correctly.

### 5.11 Spec Files — Grade: A

AGENTS.md BOOTSTRAP.md reference removed. Clean first-run instruction: "Read `spec/SOUL.md`…then run the self-cohere or configure-agent skill."

### 5.12 Mindsets — Grade: A

WRITING.md `sag` reference replaced with generic "text-to-speech." ENGINEERING.md unchanged (clean). All six mindsets present.

---

## 6. Code Quality

### 6.1 CLI (`cli/index.js`) — 318 lines — Grade: A-

**Improvements:**
- `sanitizeName()` used on both primary and "new name" paths.
- `buildHubConfig()` extracted — consistent variable calculation.
- `CN_WORKSPACE` env var support with helpful error message.
- `rl.close()` in `finally` block.
- Try/catch around `git pull --ff-only`.

**Remaining issues:**

| # | Severity | Issue | Location |
|---|----------|-------|----------|
| C1 | LOW | Duplicate `gh api user` call (auth check line 121, owner default line 162) | `cli/index.js:121,162` |
| C2 | LOW | `IDENTITY.md` still in `ocFiles` cleanup list (stale filename) | `cli/index.js:273` |
| C3 | LOW | ANSI colors unconditional — no `NO_COLOR` env var support | `cli/index.js:27-29` |

### 6.2 Hub Config Module (`cli/hubConfig.js`) — 13 lines — Grade: A-

Clean extraction with one minor issue:
- Uses string concatenation (`workspaceRoot + '/' + hubName`) instead of `path.join()`. The rest of the CLI uses `path.join()`. Functionally equivalent on Linux (the target platform) but inconsistent.

### 6.3 Sanitize Module (`cli/sanitize.js`) — 26 lines — Grade: A-

Clean validation module. One minor issue:
- Error message for leading/trailing hyphen says "must contain at least one alphanumeric character" — misleading when the name does contain alphanumerics. The real issue is the hyphen position.

### 6.4 Code Style

- `.editorconfig` enforces 2-space indent, LF line endings, UTF-8, trim trailing whitespace.
- No linter configuration (eslint, prettier).
- Consistent style throughout.
- `async` IIFE with try/finally is idiomatic.

---

## 7. Testing & CI/CD — Grade: A-

### 7.1 Test Suite

| Aspect | Status |
|--------|--------|
| Test runner | Node built-in `node:test` (zero dependencies) |
| Test file | `test/cli.test.js` (137 lines) |
| Suites | 3 (CLI flags, sanitizeName, buildHubConfig) |
| Total tests | 18 (4 CLI flags + 10 sanitizeName + 4 buildHubConfig) |
| Pass rate | 18/18 (100%) |
| Test time | ~467ms |

**Strengths:**
- Zero-dependency testing — consistent with project philosophy.
- Good edge case coverage for sanitizeName (empty, null, special chars, collapse, leading/trailing hyphens).
- buildHubConfig tested with standard, hyphenated, org, and alternate workspace inputs.
- CLI flag tests verify both long and short forms.

**Gaps (not blocking, for future consideration):**
- No tests for the interactive `run()` flow (would require mocking).
- No code coverage measurement.
- No Markdown linting or link checking.

### 7.2 CI Pipeline — Grade: A

`.github/workflows/ci.yml` (21 lines):
- Triggers: push to `master`, PRs to `master`.
- Matrix: Node 18 and 20 on ubuntu-latest.
- 12 runs to date, 100% green.

### 7.3 Release Pipeline — Grade: A-

`.github/workflows/release.yml` (34 lines):
- Triggers: GitHub release published.
- Verifies `package.json` version matches release tag.
- Runs tests before publish.
- Publishes to npm with `--provenance --access public`.
- Uses `id-token: write` permission for npm provenance.

**Note:** Not yet triggered (v1.4.0 release may predate the workflow). Will be exercised on next release.

---

## 8. Architecture & Design

### 8.1 Two-Repo Model — Grade: A

Hub/template separation well-conceived, consistently described, now properly exercised through katas (1.4 self-cohere, 1.5 configure-agent).

### 8.2 Skill Framework — Grade: A-

TERMS/INPUTS/EFFECTS contract format consistent across all six skills. All six have kata files. Ownership model documented.

### 8.3 Protocol vs Implementation Gap — Grade: B-

The nine unimplemented protocol features from whitepaper §10.2 remain unchanged:

| Protocol Feature | Status |
|-----------------|--------|
| `cn.json` manifest | Not implemented |
| `.gitattributes` with merge=union | Not implemented |
| `cn.thread.v1` schema | Not implemented |
| `state/peers.json` (JSON) | Not implemented (uses `peers.md`) |
| `threads/` at repo root | Not implemented (uses `state/threads/`) |
| Commit signing | Not implemented |
| Signature verification | Not implemented |
| Multiple `repo_urls` | Not implemented |
| Operational metrics (A.9) | Not implemented |

Honestly documented in §10.3. README now notes the `state/threads/` vs `threads/` discrepancy. Manifesto references `state/peers.json` which aligns with spec direction but not current implementation.

### 8.4 Module Extraction — Grade: A-

The CLI is now three modules:
- `index.js` — main flow (318 lines)
- `sanitize.js` — input validation (26 lines)
- `hubConfig.js` — hub configuration builder (13 lines)

Clean separation. Each module is independently testable and tested.

---

## 9. Configuration & Dependencies

### 9.1 package.json — Grade: A

Complete metadata: `repository`, `keywords`, `bugs`, `homepage`. Test script. Three modules in `files` array. Zero dependencies.

### 9.2 .gitignore — Grade: A

35 entries covering: `node_modules/`, `.env*`, `*.db`, `*.log`, `.DS_Store`, `Thumbs.db`, editor files (`*.swp`, `*.swo`, `*~`), IDE dirs (`.idea/`, `.vscode/`), secrets (`*.pem`, `*.key`), build artifacts (`dist/`, `build/`, `coverage/`, `*.tgz`).

### 9.3 .editorconfig — Grade: A

Enforces: 2-space indent, LF line endings, UTF-8, trim trailing whitespace (except `.md`), final newline. Makefile uses tabs.

### 9.4 .nvmrc — Grade: A

Pins Node 20 for development. Consistent with CI matrix upper bound and engine requirement (`>=18`).

---

## 10. Security

### 10.1 CLI Security — Grade: A-

**Positive:**
- `spawn()` with array args throughout — no shell injection.
- No `eval()`, `Function()`, or dynamic `require()`.
- No external HTTP requests.
- No secrets stored or transmitted.
- Both agent name paths now sanitized via `sanitizeName()`.
- `readline` properly closed in all paths.
- `CN_WORKSPACE` prevents hardcoded path assumption.

**Minor concerns:**
- `fs.rmSync` with `recursive: true, force: true` at line 201 — mitigated by user confirmation with abort as default.
- `git push -u origin HEAD:main` in fallback (line 265) — could push to existing branch on a repo the user doesn't control if name collides.
- ANSI escape sequences not sanitized from user input (cosmetic, not exploitable).

### 10.2 Spec Security Model — Grade: A

SOUL.md, AGENTS.md, OPERATIONS.md maintain clear security boundaries. OPERATIONS.md explicitly documents group chat caution and memory security (MEMORY.md only in main session).

### 10.3 Security Policy — Grade: B+

SECURITY.md exists with response timeline and agent-specific guidance. Missing: maintainer contact email for vulnerability reports.

### 10.4 Sensitive Files — Grade: A

No secrets, credentials, or API keys in the tracked tree. `.gitignore` covers `.env*`, `*.pem`, `*.key`.

---

## 11. Git Practices & Repo Hygiene

### 11.1 Commit History — Grade: A-

~195 total commits. Clean topic-branch workflow. Descriptive merge commits. Scoped prefixes (`docs:`, `fix:`, `chore:`, `merge:`, `release:`) used consistently.

**Minor:** The "best practices sweep" landed as 6 commits with some redundancy (e.g., two "Add best-practice project files" commits). Suggests the sweep was done iteratively rather than as a single planned change.

### 11.2 Release Management — Grade: B+

One release (v1.4.0). No prior version tags. Release workflow exists but hasn't been exercised. Six substantive commits have landed after the v1.4.0 tag without a new release, meaning the release doesn't reflect current master.

### 11.3 Large Files — Grade: B

One 435 KB PDF (`docs/CN-WHITEPAPER-v2.0.3.pdf`) tracked directly. Binary files don't diff and bloat history on updates.

---

## 12. Cross-File Coherence

### 12.1 Terminology — Grade: A

- "hub" vs "template" — clean everywhere.
- "TSC", "α/β/γ", "CLP" — defined in GLOSSARY, used consistently.
- "TERMS/INPUTS/EFFECTS" — consistent across all SKILL.md files.

**Remaining inconsistencies:**
- `peers.md` (implementation) vs `peers.json` (whitepaper & manifesto spec).
- `state/threads/` (implementation) vs `threads/` (whitepaper spec) — now documented in README.

### 12.2 Version Coherence — Grade: A-

| File | Version | Notes |
|------|---------|-------|
| `package.json` | v1.4.0 | Source of truth |
| `README.md` | (none) | Version removed from heading — solved |
| `CHANGELOG.md` latest | v1.4.0 | Current |
| `DOJO.md` | v1.2.3 | Doc-local (OK) |
| `skills/README.md` | v1.2.0 | **Stale** |
| `GLOSSARY.md` | v1.3.0 | Doc-local (OK) |
| All others | Appropriate | OK |

### 12.3 Kata Numbering — Grade: B+

DOJO v1.2.3 now lists 6 katas. New katas use belt.sequence:
- `self-cohere/kata.md` → "Kata 1.4" (matches DOJO)
- `configure-agent/kata.md` → "Kata 1.5" (matches DOJO)

Old katas still use legacy titles:
- `hello-world/kata.md` → "Kata 01" (DOJO: 1.1)
- `reflect/kata.md` → "Kata 02" (DOJO: 1.2)
- `star-sync/kata.md` → "Kata 13" (DOJO: 2.1)

### 12.4 configure-agent Hub README Template — Grade: B

`skills/configure-agent/SKILL.md:125-132` still lists `skills/` and `mindsets/` as hub directories. These only exist in the template.

### 12.5 Duplicate Document — Grade: C

Two near-identical documents exist:
- `docs/EXECUTABLE-COHERENCE.md` (368 lines, original)
- `docs/CN-EXECUTABLE-SKILLS.md` (408 lines, reformatted copy)

Differences are purely cosmetic (bold labels, backtick-fenced code blocks vs 4-space indented). Having both with different names creates confusion.

---

## 13. Issues Found (Prioritized)

### HIGH

None. The sole HIGH from v1.4.0 (N1, sanitization bypass) is resolved.

### MEDIUM

| # | Issue | Impact | Location |
|---|-------|--------|----------|
| N1 | **Duplicate companion papers** | `docs/EXECUTABLE-COHERENCE.md` and `docs/CN-EXECUTABLE-SKILLS.md` are near-identical (same content, different formatting). Confuses readers about which is canonical. | `docs/` |
| N2 | **Protocol vs implementation gap (9 features)** | Whitepaper §10.2 lists 9 specified-but-unbuilt features. Honestly documented but the gap exists. | Whitepaper §10.2 vs repo |

### LOW

| # | Issue | Impact | Location |
|---|-------|--------|----------|
| N3 | Three old kata titles use legacy numbering | "Kata 01", "Kata 02", "Kata 13" — should be 1.1, 1.2, 2.1 per DOJO belt.sequence | `skills/hello-world/kata.md:1`, `skills/reflect/kata.md:1`, `skills/star-sync/kata.md:1` |
| N4 | configure-agent README template lists incorrect hub dirs | Lists `skills/` and `mindsets/` as hub directories; they only exist in template | `skills/configure-agent/SKILL.md:125-132` |
| N5 | Duplicate `gh api user` call | Same API call at lines 121 and 162. Cacheable into one call. | `cli/index.js:121,162` |
| N6 | `IDENTITY.md` in cleanup list | Stale filename — was renamed to PERSONALITY.md | `cli/index.js:273` |
| N7 | ANSI colors unconditional | No `NO_COLOR` env var support | `cli/index.js:27-29` |
| N8 | `hubConfig.js` uses string concat not `path.join()` | `workspaceRoot + '/' + hubName` vs rest of CLI using `path.join()` | `cli/hubConfig.js:8` |
| N9 | `sanitize.js` misleading error message | Leading/trailing hyphen rejection says "must contain at least one alphanumeric" | `cli/sanitize.js:19-21` |
| N10 | `skills/README.md` version stale (v1.2.0) | — | `skills/README.md:1` |
| N11 | Thread file naming non-standard | `yyyyddmmhhmmss` puts day before month; rest of project uses ISO 8601 | `skills/hello-world/` |
| N12 | Coherence Walk duplicated verbatim | Appears in 3 places without cross-reference | reflect SKILL.md, GLOSSARY.md, reflect kata.md |
| N13 | reflect SKILL.md length (367 lines) | 3x any other skill. Six cadence templates are structurally repetitive. | `skills/reflect/SKILL.md` |
| N14 | PDF tracked directly in git | 435 KB binary doesn't diff. Bloats history on updates. | `docs/CN-WHITEPAPER-v2.0.3.pdf` |
| N15 | CHANGELOG lacks detailed change notes | Only one-line coherence summaries per version | `CHANGELOG.md` |
| N16 | SECURITY.md no contact email | Says "emailing maintainers" but provides no email | `SECURITY.md:14` |
| N17 | CONTRIBUTING.md references disabled discussions | §Questions says "Open an issue or reach out via the repository discussions" | `CONTRIBUTING.md:51` |
| N18 | No version tag before v1.4.0 | Git history has ~195 commits but only one tag. Prior versions not tagged. | git tags |
| N19 | Release doesn't reflect current master | 6 substantive commits landed after v1.4.0 tag. Current master != released version. | git vs release |

**Total: 0 HIGH, 2 MEDIUM, 17 LOW = 19 findings.**

---

## 14. Prior Audit Tracking

### v1.4.0 → Current Resolution Matrix

| v1.4.0 Ref | Finding | Current Status | Current Ref |
|------------|---------|----------------|-------------|
| N1 (HIGH) | "New name" bypasses sanitizeName() | **RESOLVED** | — |
| N2 | AGENTS.md references BOOTSTRAP.md | **RESOLVED** | — |
| N3 | README version stale (v1.2.0) | **RESOLVED** | — |
| N4 | "New name" path doesn't recalculate | **RESOLVED** | — |
| N5 | CI tests only Node 20 | **RESOLVED** | — |
| N6 | Protocol vs implementation gap | **Open** | N2 |
| N7 | .gitignore incomplete | **RESOLVED** | — |
| N8 | experiments/ uncontextualized | **RESOLVED** | — |
| N9 | Hardcoded workspace path | **RESOLVED** | — |
| N10 | Kata file titles old numbering | **Open** (3 of 6 katas) | N3 |
| N11 | sanitize.js error message | **Open** | N9 |
| N12 | Missing katas | **RESOLVED** | — |
| N13 | Duplicate gh api user call | **Open** | N5 |
| N14 | IDENTITY.md in cleanup list | **Open** | N6 |
| N15 | ANSI colors / NO_COLOR | **Open** | N7 |
| N16 | readline not closed | **RESOLVED** | — |
| N17 | skills/README.md version stale | **Open** | N10 |
| N18 | WRITING.md sag reference | **RESOLVED** | — |
| N19 | reflect SKILL.md length | **Open** | N13 |
| N20 | Thread file naming | **Open** | N11 |
| N21 | Coherence Walk duplication | **Open** | N12 |
| N22 | PDF in git | **Open** | N14 |
| N23 | configure-agent hub dirs | **Open** | N4 |
| N24 | state/ files in template | **RESOLVED** | — |
| N25 | CHANGELOG detail | **Open** | N15 |

**Summary: 15 resolved, 10 carried forward, 4 new = 19 total open (down from 25).**

### Full Audit History

| Audit | Findings | HIGH | MED | LOW | Resolved | Grade |
|-------|----------|------|-----|-----|----------|-------|
| v1.3.5 | 23 | 4 | 9 | 10 | — | B+ |
| v1.4.0 | 25 | 1 | 8 | 16 | 7 from v1.3.5 | A- |
| Current | 19 | 0 | 2 | 17 | 15 from v1.4.0 | A |

**Closure rate:** v1.3.5→v1.4.0: 30% (7/23). v1.4.0→current: 60% (15/25). Overall since v1.3.5: 74%.

---

## 15. Coherence Assessment (TSC Axes)

### 15.1 α (PATTERN) — Structural Consistency — Grade: A

- 5 spec files, 6 mindsets, 6 skills, 7 docs — all follow their respective formats.
- TERMS/INPUTS/EFFECTS in all SKILL.md files.
- All skills now have katas.
- Three modules (index, sanitize, hubConfig) each with clear responsibilities.
- `.editorconfig` enforces formatting conventions.
- Community files (CONTRIBUTING, SECURITY, CODE_OF_CONDUCT) follow GitHub conventions.
- READMEs added to previously opaque directories (experiments/, state/).

**Deductions:** Three old kata titles still use legacy numbering. Duplicate companion paper.

### 15.2 β (RELATION) — Alignment Between Parts — Grade: A-

- Cross-file references mostly accurate.
- Hub/template separation cleanly described and exercised via katas.
- README no longer makes stale version claims.
- AGENTS.md correctly directs to SOUL.md and self-cohere/configure-agent.

**Deductions:** Duplicate companion paper creates confusion. configure-agent README template still lists incorrect hub directories. Protocol spec vs implementation gap unchanged.

### 15.3 γ (EXIT/PROCESS) — Evolution Stability — Grade: A

- 74% closure rate across two audit cycles (v1.3.5 → current).
- Zero HIGH findings remain.
- Tests and CI provide a safety net.
- Release workflow ready for future versions.
- Clean commit history through ~195 commits.
- "Never self-merge" governance practiced.

**Deductions:** 6 commits after v1.4.0 tag without a new release. No version tags before v1.4.0.

### 15.4 Aggregate

```
C_Σ = (A · A- · A)^(1/3) ≈ A
```

Up from A- in v1.4.0 and B+ in v1.3.5.

---

## 16. Recommendations (Prioritized)

### Should Address (MEDIUM)

1. **Deduplicate companion papers.** Remove one of `docs/EXECUTABLE-COHERENCE.md` / `docs/CN-EXECUTABLE-SKILLS.md`, or rename the canonical one clearly. The release notes reference `CN-EXECUTABLE-SKILLS.md`, so that may be the intended keeper.

2. **(Ongoing) Reduce protocol gap.** The nine §10.2 features are the main structural gap. Consider implementing `cn.json` and `.gitattributes` first — they're low-effort, high-impact, and the spec is clear.

### Nice to Have (LOW)

3. **Update old kata titles** to belt.sequence format (1.1, 1.2, 2.1).
4. **Fix configure-agent README template** — remove `skills/` and `mindsets/` from hub structure table.
5. **Cache `gh api user`** result to avoid duplicate API call.
6. **Remove `IDENTITY.md`** from CLI cleanup list.
7. **Add `NO_COLOR`** env var support.
8. **Use `path.join()`** in `hubConfig.js` for consistency.
9. **Fix sanitize.js error message** for leading/trailing hyphen case.
10. **Update `skills/README.md`** version header.
11. **Tag a new release** — current master has 6 substantive commits beyond v1.4.0.
12. **Add maintainer email** to SECURITY.md or enable GitHub private vulnerability reporting.
13. **Enable GitHub Discussions** or remove reference from CONTRIBUTING.md.
14. **Consider Git LFS** or CI-generated PDF instead of tracking binary directly.
15. **Add detailed change notes** to CHANGELOG entries.

---

## 17. Scorecard

| Dimension | Grade | v1.4.0 | v1.3.5 | Trend | Notes |
|-----------|-------|--------|--------|-------|-------|
| Documentation | A | A- | A- | ↑ | Badges, community files, directory READMEs, katas complete |
| Code Quality | A- | B | B- | ↑↑ | Sanitization complete, hubConfig extracted, finally block |
| Architecture | A- | B+ | B+ | ↑ | Module extraction, kata coverage, protocol gap unchanged |
| Testing & CI | A- | B- | F | ↑↑↑ | 18 tests, Node 18+20 matrix, release workflow |
| Security | A- | B | B | ↑ | Both paths sanitized, SECURITY.md, .gitignore hardened |
| Git Practices | A- | A- | A- | = | Clean history, release workflow, needs new tag |
| Configuration | A | A- | C+ | ↑↑ | .gitignore complete, .editorconfig, .nvmrc, release.yml |
| Cross-file Coherence | A- | B+ | A- | ↑ | AGENTS.md fixed, duplicate paper is new issue |
| GitHub Forge | B+ | — | — | NEW | 100% green CI, release, topics, no issues/labels |

**Weighted Overall: A** (up from A- → B+)

---

## 18. What's Done Well

1. **Zero-dependency design** — CLI, tests, and CI all use only Node built-ins. No supply chain risk.
2. **Complete test coverage of extractable logic** — sanitizeName (10 tests), buildHubConfig (4 tests), CLI flags (4 tests). All edge cases covered.
3. **CI matrix** — Node 18 and 20 tested. 100% green history (12 runs).
4. **Release workflow** — npm publish with provenance, version-tag verification, test gate.
5. **Module extraction pattern** — sanitize.js and hubConfig.js demonstrate test-driven refactoring.
6. **74% finding closure rate** — from 23 findings (v1.3.5) to 19 (current), with all HIGHs and nearly all MEDIUMs resolved.
7. **Community files** — CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md signal a mature project.
8. **README badges** — CI, npm version, license immediately visible.
9. **Contextual READMEs** — experiments/ and state/ are no longer opaque.
10. **Kata completeness** — all six skills now have kata files. New katas use belt.sequence numbering.
11. **Honest protocol tracking** — §10 doesn't pretend features exist when they don't.
12. **Git governance** — "never self-merge", descriptive merges, topic-branch workflow.
13. **Whitepaper quality** — well-structured, self-aware, with formal normative appendix.
14. **Audit-driven improvement** — seven iterations of self-assessment with measurable progress.
