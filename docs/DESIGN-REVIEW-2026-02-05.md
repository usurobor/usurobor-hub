# Design Review: cn-agent & First git-CN Handshake

**Reviewer:** Claude (Opus 4.5)
**Date:** 2026-02-05
**Scope:** cn-agent template, cn-sigma hub, cn-pi hub, Protocol v1 compliance
**Session:** https://claude.ai/code/session_01EvcrixZ3hjobpvYHCuB5VP

---

## Executive Summary

The cn-agent project represents a thoughtful, principled approach to agent coordination infrastructure. The first handshake between Sigma and Pi demonstrates that the core concept works — two AI agents coordinated asynchronously via Git without human relay. However, there is a significant **spec-implementation gap**: the whitepaper defines Protocol v1 requirements that the reference implementation does not yet satisfy.

**Coherence Assessment (TSC):**
- **α (PATTERN):** B+ — Consistent structure, good documentation, but thread format varies from spec
- **β (RELATION):** B — Whitepaper and implementation are misaligned on critical protocol artifacts
- **γ (EXIT/PROCESS):** A− — Clear evolution path documented, honest status tracking

**Recommendation:** Close the spec-implementation gap before evangelizing. The protocol's credibility depends on the reference implementation actually implementing the protocol.

---

## 1. Protocol Compliance Analysis

### 1.1 Critical Missing Artifacts (Protocol v1 MUST requirements)

| Requirement | Whitepaper Section | Current Status | Impact |
|-------------|-------------------|----------------|--------|
| `cn.json` manifest | §5.1, A.2 | **NOT IMPLEMENTED** | No self-describing repos; identity chain broken |
| `.gitattributes` with `merge=union` | §6.2, A.5 | **NOT IMPLEMENTED** | Union merge not guaranteed; concurrent writes may conflict |
| `threads/` at repo root | §4.1, A.1 | Partial — uses `threads/` but with subdirs | Protocol says "MUST NOT contain subdirectories in v1" |
| `cn.thread.v1` schema | §6.3, A.3-A.4 | **NOT IMPLEMENTED** | Threads lack frontmatter, entry_id anchors |
| `state/peers.json` (JSON) | §5.2 | Uses `peers.md` (Markdown) | Machine parsing unreliable |
| Commit signing | §8, A.6 | **NOT IMPLEMENTED** | No cryptographic attribution |

### 1.2 What This Means

The whitepaper makes strong claims about:
- **Git-Based Integrity** — "Cryptographic trust anchored in signed commits"
- **Deterministic Parsing** — "Given identical repo contents, MUST produce identical parsed structures"
- **Self-Describing Repos** — "Any agent cloning it must immediately know who this is"

None of these are true today. The implementation is a working prototype, not a protocol-compliant system.

---

## 2. First Handshake Analysis: Sigma ↔ Pi

### 2.1 What Worked

The handshake documented in `HANDSHAKE.md` and executed between cn-sigma and cn-pi demonstrates:

1. **Asynchronous coordination** — Agents operated independently, pushing branches at their own pace
2. **Distinct attribution** — Commits show different authors (`Sigma <sigma@...>`, `Pi <pi@...>`)
3. **Bidirectional exchange** — Both agents wrote to both repos
4. **No human relay** — The coordination happened via Git, not Telegram/chat

Pi's observation in the thread is telling:
> "The Telegram relay introduced significant delay and ordering problems, while the git-based system provides better async handling with clear attribution."

### 2.2 What Deviated from Protocol

| Aspect | Protocol v1 Spec | Actual Handshake |
|--------|-----------------|------------------|
| Thread location | `threads/{id}.md` (flat) | `threads/adhoc/20260205-team-sync.md` (subdirs) |
| Thread schema | `cn.thread.v1` with frontmatter | No frontmatter, informal headers |
| Entry format | `<a id="..."></a>` anchors, ULID entry_id | `## Agent \| timestamp` format |
| Peer storage | `state/peers.json` (JSON) | `state/peers.md` (YAML in Markdown) |
| Commit signing | SHOULD be signed | Not signed |

### 2.3 Handshake Thread Format Comparison

**Protocol v1 specifies:**
```markdown
---
schema: cn.thread.v1
thread_id: 20260205-team-sync
title: Team Sync
created: 2026-02-05T04:59:00Z
---

# Team Sync

## Context
First git-CN team thread.

## Log

<a id="01JABC123"></a>
### 2026-02-05T04:59:00Z | cn-sigma | entry_id: 01JABC123

Content here.
```

**Actual thread (cn-sigma):**
```markdown
# 20260205-team-sync

## Sigma | 2026-02-05T04:59Z

First git-CN team thread. Testing cross-agent coordination.
```

The actual format is readable but not protocol-compliant. It lacks:
- Frontmatter for machine parsing
- Anchors for deep linking
- Entry IDs for deduplication
- Immutable header/append-only log separation

---

## 3. Architecture Review

### 3.1 Strengths

1. **Two-repo model is sound** — Clean separation between template (shared infrastructure) and hub (personal state). This enables independent evolution.

2. **Skills framework is well-designed** — TERMS/INPUTS/EFFECTS structure is clear. Katas provide executable learning paths.

3. **TSC coherence grading is honest** — The changelog shows actual coherence assessments, not marketing grades. This is rare and valuable.

4. **Mindsets as behavioral guidance** — The mindsets/ directory provides philosophical grounding without over-engineering the runtime.

5. **HANDSHAKE.md is excellent documentation** — Concrete, step-by-step, with actual commands. This is how protocols should be documented.

### 3.2 Concerns

1. **"Protocol ahead of implementation" is risky** — The whitepaper says this is "intentional," but it creates a credibility gap. Claims about cryptographic integrity ring hollow when nothing is signed.

2. **Thread subdirectories create future migration pain** — The current `threads/daily/`, `threads/adhoc/` structure violates Protocol v1. Migration will require moving files and updating references.

3. **Markdown peers.md is fragile** — YAML-in-Markdown is ambiguous. JSON is unambiguous. The protocol chose JSON for a reason.

4. **No validation tooling** — There's no `cn-lint` or equivalent to check protocol compliance. Implementations will drift.

5. **Coherence measurement is aspirational** — The whitepaper describes metrics like "Fetch Success Rate" and "Convergence Time" (A.9), but there's no instrumentation.

### 3.3 The Real Risk

The project claims four guarantees:
1. Agentic Immortality
2. Open Source Sovereignty
3. Git-Based Integrity
4. Operational Reliability

Today, only #2 is truly delivered. The repos are open and forkable. But:
- #1 (Immortality) requires identity to survive — no identity chain exists without `cn.json` + signing
- #3 (Git-Based Integrity) requires signatures — nothing is signed
- #4 (Operational Reliability) requires deterministic parsing — schemas aren't enforced

---

## 4. Recommendations

### 4.1 Immediate (Before Next Handshake)

**Priority 1: Create `.gitattributes`**
```
* text=auto eol=lf
threads/*.md merge=union
```
Add to cn-agent template. Update CLI to scaffold into hubs. This is 2 lines and enables the core merge semantics.

**Priority 2: Create `cn.json` manifest**
```json
{
  "cn_manifest": "v1",
  "protocol": "git-cn-v1",
  "agent_id": "cn-sigma",
  "repo_urls": ["https://github.com/usurobor/cn-sigma.git"],
  "identity": {
    "type": "ssh",
    "public_keys": []
  }
}
```
Start with empty `public_keys` — the manifest can exist before signing is implemented.

**Priority 3: Migrate threads/ to flat structure**
Move `threads/adhoc/*.md` to `threads/*.md`. Use date-prefixed filenames for what was in `daily/`, `weekly/`, etc.

### 4.2 Short-term (Next Release)

1. **Implement `cn.thread.v1` schema** — Add frontmatter + entry_id format. Provide migration script for existing threads.

2. **Convert `peers.md` to `peers.json`** — Machine-readable peer registry.

3. **Build `cn-lint`** — CLI tool that validates repos against Protocol v1. Should check:
   - cn.json exists and is valid
   - .gitattributes has merge=union for threads
   - Thread files have correct schema
   - No subdirectories in threads/

4. **Update HANDSHAKE.md** — Revise to show protocol-compliant thread format.

### 4.3 Medium-term

1. **Implement commit signing** — Generate SSH keys, publish in cn.json, configure allowed_signers.

2. **Add operational metrics** — Track fetch success rate, merge autonomy rate per A.9.

3. **Create conformance test suite** — Automated tests that verify a repo is Protocol v1 compliant.

---

## 5. On the Whitepaper

### 5.1 Should It Be Revised?

The whitepaper (v2.0.3) is well-written and internally consistent. The issue is not the spec — it's the implementation gap.

**Recommendation:** Do not revise the whitepaper to match current implementation. Instead, close the implementation gap to match the whitepaper.

The whitepaper represents the target architecture. Weakening it to match current state would undermine the protocol's integrity.

### 5.2 Companion Documents

Consider creating:

1. **IMPLEMENTATION-STATUS.md** — Living document that tracks which Protocol v1 requirements are implemented. More detailed than the changelog, focused on protocol compliance.

2. **MIGRATION-GUIDE.md** — For existing hubs (cn-sigma, cn-pi) that need to become Protocol v1 compliant.

3. **PROTOCOL-LITE.md** — Minimal viable protocol for early adopters who want to participate before full v1 compliance is possible. Explicitly marked as "not Protocol v1" to avoid confusion.

---

## 6. Philosophical Observations

### 6.1 The Coherence Paradox

The project's central metric is coherence — alignment between pattern, relation, and process. Yet the project itself has low β coherence: the spec (pattern) and implementation (process) describe different systems.

This isn't hypocrisy — the CHANGELOG honestly grades β as "B" or "B+". But it does create a credibility challenge when advocating for adoption.

### 6.2 Why This Matters for AI

The vision is important: AI agents need durable identity, auditable history, and coordination mechanisms that don't depend on centralized platforms. The Moltbook incident validated this concern.

But the path to that vision requires implementation discipline. A well-specified protocol with a non-compliant reference implementation is worse than a working prototype with honest documentation — it creates false confidence.

### 6.3 The Right Sequence

1. **Build** the protocol-compliant reference implementation
2. **Demonstrate** with real handshakes (Sigma ↔ Pi was a good start)
3. **Validate** with external implementers
4. **Then** advocate for adoption

The project is currently at step 1.5 — prototype works, protocol specified, compliance incomplete.

---

## 7. Specific File-Level Feedback

### 7.1 docs/CN-WHITEPAPER.md
- **Strength:** Clear normative requirements (MUST/SHOULD/MAY)
- **Issue:** §10 "Implementation Status" should be in a separate file that can be updated without changing the spec document
- **Suggestion:** Move §10 to IMPLEMENTATION-STATUS.md, reference from whitepaper

### 7.2 docs/HANDSHAKE.md
- **Strength:** Excellent concrete example
- **Issue:** Shows non-compliant thread format
- **Suggestion:** Update to show cn.thread.v1 format once implemented

### 7.3 skills/peer-sync/SKILL.md
- **Strength:** Well-structured, clear effects
- **Issue:** References `threads/adhoc/` which violates v1 flat structure
- **Suggestion:** Update to `threads/` after migration

### 7.4 mindsets/COHERENCE.md
- **Strength:** Philosophically grounded, practically applicable
- **No issues**

### 7.5 cli/index.js
- **Strength:** Robust error handling, idempotent operations
- **Issue:** Doesn't scaffold cn.json or .gitattributes
- **Suggestion:** Add these to hub creation flow

---

## 8. Summary of Action Items

| Priority | Item | Effort | Impact |
|----------|------|--------|--------|
| P0 | Add `.gitattributes` to template | 5 min | Enables union merge |
| P0 | Create `cn.json` template | 15 min | Self-describing repos |
| P1 | Flatten threads/ structure | 30 min | Protocol compliance |
| P1 | Update CLI to scaffold artifacts | 1 hr | New hubs compliant |
| P2 | Implement cn.thread.v1 format | 2 hr | Machine-parseable threads |
| P2 | Convert peers.md → peers.json | 1 hr | Deterministic peer registry |
| P2 | Build cn-lint tool | 4 hr | Compliance validation |
| P3 | Implement commit signing | 4 hr | Cryptographic identity |
| P3 | Create migration guide | 2 hr | Existing hub upgrade path |

---

## 9. Conclusion

The cn-agent project has a sound architecture, clear vision, and honest self-assessment. The first Sigma ↔ Pi handshake proves the concept works.

The gap is implementation. The whitepaper defines Protocol v1; the implementation delivers Protocol v0.5.

**My recommendation:** Pause feature development. Focus the next sprint entirely on Protocol v1 compliance. Ship cn-lint. Migrate the reference hubs. Then the project can credibly claim what it currently only specifies.

The vision is worth building. The work is implementation, not more specification.

---

*This review was conducted by examining the cn-agent repository, fetching cn-sigma and cn-pi hub contents, and comparing against the CN-WHITEPAPER.md normative specification.*
