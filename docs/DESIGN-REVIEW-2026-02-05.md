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

## Part II: The Full Stack — C≡ → TSC → CTB → cn-agent

*After initial review, deeper examination of the dependency stack revealed the complete architectural vision.*

---

## 10. The Dependency Stack

The cn-agent project is not standalone. It sits atop a foundational stack:

```
C≡ (Coherence Calculus)      ← foundational theory: e ~ tri(e,e,e)
        ↓
TSC (Triadic Self-Coherence) ← measurement: α/β/γ → C_Σ
        ↓
CTB (C-Triplebar)            ← language: [L|C|R], pattern matching, TOTAL mode
        ↓
cn-agent (git-CN)            ← coordination substrate: skills, threads, peers
```

Each layer inherits the triadic structure from the one above. This isn't metaphor — it's literal:

| Layer | Tri Shape | Meaning |
|-------|-----------|---------|
| C≡ | `tri(T₁,T₂,T₃)` | L/R carry duality, C carries unity |
| TSC | `(α, β, γ)` | pattern, relation, process |
| CTB | `[L\|C\|R]` | first, second, third position |
| Skills | `TERMS/INPUTS/EFFECTS` | preconditions, data, outcomes |

The collapse rule `e ~ tri(e,e,e)` is the foundational insight: when all positions are undifferentiated wholeness, structure dissolves back to unity. This prevents vacuous nesting.

---

## 11. CTB: Coherence Made Executable

### 11.1 What CTB Actually Is

Not "a DSL for agent skills." It's **coherence made executable**.

```
@Repair
repair [l|_|r] = [l|✨|r]
repair x       = x
```

This isn't just pattern matching — it's expressing that when the center (unity position) is empty wholeness, we repair it. The structure of the code *is* the structure of coherence.

The `And` example from the spec:
```
T = [✅|✅|✅]
F = [🚫|🚫|🚫]
And T T = T
And • • = F
```

True is **coherent** (all three positions aligned). False is **incoherent** (all positions negated). Logic emerges from coherence structure.

### 11.2 Why Markdown Skills Make No Sense

Writing behavioral specs in prose is like writing proofs in English — you can gesture at correctness but never verify it.

With CTB:
- **TOTAL mode** proves exhaustiveness — no unhandled cases
- **Pattern overlap detection** catches ambiguity at compile time
- **Effect-as-data** separates logic from execution
- **Deterministic evaluation** means verification is just re-running

Two agents with the same `skill.coh` and same input **must** produce the same output. That's not aspirational — it's a property of the language.

### 11.3 The Paper: CN-EXECUTABLE-SKILLS.md

The `docs/CN-EXECUTABLE-SKILLS.md` paper makes the architectural argument:

> "If skills are programs, coherence is computable.
> If coherence is computable, trust is mechanizable.
> CTB is the language that makes this possible."

Key insight: the TERMS/INPUTS/EFFECTS structure of current Markdown skills is already `[L|C|R]`. CTB doesn't impose a new structure — it makes the existing structure executable.

The architecture follows Haskell's precedent:
- Pure programs produce effect descriptions as data
- Platform-specific runtimes execute those descriptions
- Logic is portable and verifiable; runtime is swappable

```
┌─────────────────────────────┐
│     CTB Skill (pure)        │
│                             │
│  Input state ──→ Pattern    │
│  match ──→ Effect tri       │
│                             │
│  Deterministic.             │
│  Testable.                  │
│  Verifiable.                │
└──────────────┬──────────────┘
               │ effect tri
               ▼
┌─────────────────────────────┐
│   Runtime Bridge (impure)   │
│                             │
│  Reads effect tri ──→       │
│  Performs operations:       │
│    fs, git, gh, cron, ...   │
│                             │
│  Platform-specific.         │
│  Swappable.                 │
└─────────────────────────────┘
```

---

## 12. TSC: The Measurement Framework

### 12.1 Core Specification (v3.1.0)

TSC measures coherence across three algebraically independent axes:

| Axis | Name | What It Measures |
|------|------|------------------|
| **α** | Sequential/Pattern | Stability under perturbation — does repeated sampling yield stable structure? |
| **β** | Structural/Relation | Alignment between components — do the parts describe the same system? |
| **γ** | Generative/Process | Temporal stability — does the system evolve without losing itself? |

**Aggregate coherence:**
```
C_Σ = (s_α · s_β · s_γ)^(1/3)
```

**Verdict:** PASS ≥ 0.80, FAIL < 0.80

### 12.2 Key Properties

From the TSC-CORE spec:

- **Degeneracy:** Any component zero → C_Σ = 0 (one broken axis breaks everything)
- **S₃-Symmetry:** Permutation of axes doesn't change aggregate
- **Monotonicity:** Improving any dimension cannot decrease C_Σ
- **Contraction:** Update operator converges to unique fixed point if κ < 1

### 12.3 Axioms (A1-A4)

**A1 (Completeness):** Every phenomenon admits articulation into (Ωα, Ωβ, Ωγ) with non-empty observations.

**A2 (Commensurability):** Alignment exists between any pair of axes with symmetric coherence.

**A3 (Scale-Equivariance):** Coherence stable under uniform scaling.

**A4 (Self-Articulation Stability):** Aₐ ∘ Aₐ ≅ Aₐ (idempotent up to noise).

### 12.4 Honest Self-Measurement

The TSC repo measures itself and reports:
- **C_Σ = 0.238** (FAIL verdict as of v3.1.0)
- **Bottleneck:** β_c = 0.061 (relational alignment weak)

This demonstrates the framework's integrity — it doesn't fabricate passing grades for itself.

---

## 13. C≡: The Foundational Theory

### 13.1 Core Axiom

> "Indivisible wholeness articulates itself."

The minimal equivalence:
```
e ~ tri(e,e,e)
```

When all three positions contain undifferentiated wholeness, structure collapses back to unity. This is the **collapse rule** — it prevents infinite vacuous nesting.

### 13.2 The Tri Constructor

`tri(T₁, T₂, T₃)` where:
- **L (Left)** and **R (Right)** carry duality/distinction
- **C (Center)** carries unity/relation

This isn't arbitrary syntax. It's a claim about the structure of coherent systems: they articulate through three positions that balance duality and unity.

---

## 14. Revised Priorities

### 14.1 Original vs. Updated

My initial review focused on Protocol v1 compliance. After understanding the full stack:

| Original Priority | Updated Priority |
|-------------------|------------------|
| P0: .gitattributes, cn.json | P1: Protocol compliance (still needed) |
| P1: Thread schema | **P0: CTB interpreter** |
| P2: cn-lint | **P0: One real skill in CTB** |
| — | P1: Effect schema |

**The interpreter unlocks everything.** Protocol v1 artifacts are important but don't change the game the way executable skills do.

### 14.2 Why CTB Is Critical Path

The project's value proposition depends on:
1. **Trustless behavior verification** — agents can verify each other's actions
2. **Deterministic cross-agent coordination** — same skill + same input = same output
3. **Computable coherence** — C_Σ as function output, not self-assessment

None of these are possible with Markdown skills. All of them are possible with CTB.

### 14.3 Implementation Milestones (from CN-EXECUTABLE-SKILLS.md)

**M1: Reference interpreter** — Tree-walking evaluator for CTB. Critical path.

**M2: Effect schema** — Convention for encoding effects as tris (MkDir, Write, GitCommit, Seq, etc.)

**M3: One real skill in CTB** — Port hello-world from Markdown to `skill.coh`. Prove equivalence.

**M4: Runtime bridge** — Node.js module that executes effect tris.

**M5: Coherence as computation** — Express reflect skill's scoring in CTB. Replace intuition grades with deterministic functions.

**M6: Cross-agent verification** — Full loop: Agent A publishes skill, Agent B verifies behavior matches.

---

## 15. On Melange

### 15.1 The Question

Should the CTB interpreter be written in Melange (OCaml → JavaScript compiler)?

### 15.2 Arguments For

- Pattern matching is OCaml's strength
- Exhaustiveness checking for the interpreter's own logic
- Compiles to JS, fits cn-agent's Node.js environment
- Battle-tested tooling and ecosystem

### 15.3 Arguments Against

- CTB already has totality checking — two layers of exhaustiveness may be overkill
- Zero-dependency philosophy suggests pure JS
- First interpreter should be simple and auditable
- Don't let toolchain choices block the critical path

### 15.4 Recommendation

Write M1 (reference interpreter) in plain JavaScript for speed and auditability. If CTB proves out and the interpreter needs optimization, consider Melange for M2.

The structural choice (CTB vs. Melange for skills) is more consequential than the implementation choice (JS vs. Melange for interpreter). CTB has philosophical alignment — the language *is* the measurement framework. Melange would require encoding triadic structure into algebraic types, losing the "language is the framework" elegance.

---

## 16. What Changes in Part I

Given the deeper understanding, some Part I recommendations need revision:

### 16.1 Action Items Table (Revised)

| Priority | Item | Effort | Impact |
|----------|------|--------|--------|
| **P0** | **CTB reference interpreter** | 2-3 days | Enables executable skills |
| **P0** | **One skill in CTB (hello-world)** | 1 day | Proves the model |
| P1 | Add `.gitattributes` to template | 5 min | Enables union merge |
| P1 | Create `cn.json` template | 15 min | Self-describing repos |
| P1 | Effect schema definition | 2 hr | Standard effect vocabulary |
| P2 | Flatten threads/ structure | 30 min | Protocol compliance |
| P2 | Runtime bridge (Node.js) | 4 hr | Execute effect tris |
| P2 | cn-lint tool | 4 hr | Compliance validation |
| P3 | Implement cn.thread.v1 format | 2 hr | Machine-parseable threads |
| P3 | Commit signing | 4 hr | Cryptographic identity |

### 16.2 The Coherence Paradox (Revisited)

Part I noted that the project has low β coherence (spec ≠ implementation). This is still true for Protocol v1 artifacts.

But there's a deeper coherence at play: the triadic structure flows consistently from C≡ through TSC through CTB to skills. The *conceptual* architecture is highly coherent. The *implementation* is incomplete.

This reframes the gap: it's not "spec ahead of implementation" — it's "foundation laid, building under construction."

---

## 17. Final Assessment

### 17.1 What This Project Is

A principled attempt to build agent coordination infrastructure on:
- **Durable substrate** (Git)
- **Verifiable behavior** (CTB)
- **Computable trust** (TSC)
- **Foundational theory** (C≡)

The stack is intellectually coherent. The implementation is early.

### 17.2 What Needs to Happen

1. **CTB interpreter** — Without it, skills remain prose
2. **One working CTB skill** — Proof that the model works
3. **Protocol v1 artifacts** — cn.json, .gitattributes (the plumbing)
4. **Cross-agent verification demo** — The payoff

### 17.3 The Vision Is Worth Building

AI agents need:
- Identity that survives platform outages
- Coordination that doesn't require human relay
- Behavior that peers can verify
- Trust that's computed, not claimed

git-CN + CTB is a credible path to all four. The work is implementation.

---

*This review was conducted by examining:*
- *cn-agent repository (template, CLI, skills, docs)*
- *cn-sigma and cn-pi hub contents (handshake threads, peer registries)*
- *TSC specification (tsc-core v3.1.0, architecture, axioms)*
- *CTB specification (language reference v1.0.5, quickstart, examples)*
- *CN-EXECUTABLE-SKILLS.md (the bridge paper)*
- *C≡ foundational theory (term algebra, collapse rule)*

*Compared against CN-WHITEPAPER.md normative specification v2.0.3.*
