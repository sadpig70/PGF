---
name: pgf
description: "PGF (PPR/Gantree Framework) — AI-native design/execution framework. Supports system architecture design, work planning, autonomous execution, idea discovery, and full creation cycles. Gantree hierarchical decomposition + PPR pseudo-code for AI-comprehensible specifications. Triggers: design, structure design, task decomposition, architecture, module separation, work plan, WORKPLAN, project structuring, Gantree, PPR, PGF, discovery, creation, plan, execute, discover, create"
user-invocable: true
argument-hint: "design|plan|execute|full-cycle|loop|discover|create [project-name|start|cancel|status]"
---

# PGF (PPR/Gantree Framework) v2.5

> If PG is a programming language, PGF is the library.
> It normalizes useful patterns frequently executed in PG (design, execution, verification, discovery, creation, etc.).

## PG-Based Dependency

**PGF uses PG (PPR/Gantree Notation) as its base language.** PG's core properties (Parser-Free, Co-evolutionary, DL/OCME, AI_ functions, → pipelines, [parallel], Gantree node syntax) are defined in the PG skill, and PGF inherits them.

> **PG notation reference**: Load the PG skill to check Gantree node syntax, PPR constructs (AI_/AI_make_ prefixes, → pipelines, [parallel], acceptance_criteria, Convergence Loop, Failure Strategy), data types, and atomic node judgment criteria.

What PGF adds on top of PG:
- **Execution modes** — design, plan, execute, full-cycle, loop, discover, create, micro, delegate
- **WORKPLAN + POLICY** — execution plan and policy blocks
- **status JSON** — per-node execution state tracking
- **Phase transition** — automatic transition conditions between modes
- **Session Learning** — cross-session learning and strategy adaptation
- **Epigenetic PPR** (v2.4) — context-adaptive execution, automatic extract-ppr.ps1 integration
- **Compaction Resilience** (v2.4) — long-running execution protection via PostCompact/Restore hooks
- **Design Review** (v2.4) — 3-perspective pre-implementation validation

---

## Current Project PGF State

To check the current PGF state, scan the project's `.pgf/` directory:
- List `*.md` and `*.json` files in `.pgf/`
- Read `status-*.json` for execution progress (`summary.done / summary.total`)
- Check `.claude/pgf-loop-state.json` for active pgf-loop status

---

## Reference Document Guide

Reference documents for this skill are located in the `${CLAUDE_SKILL_DIR}` directory. Load the appropriate file with the Read tool depending on the execution mode and need.

### Base Notation (PG Skill)

The core syntax of PG notation is defined in the PG skill. The PG skill is auto-loaded when PGF executes.

| Source | Content |
|--------|---------|
| **PG skill** (`PG/SKILL.md`) | Gantree node syntax, status codes, PPR constructs (AI_/AI_make_, →, [parallel]), data types, atomic node judgment, Convergence Loop, Failure Strategy, checklist |

> Content defined in the PG skill is not redefined in any PGF reference documents. If duplicates are found, the PG skill is the canonical source.

### Always Reference

| Document | Purpose |
|----------|---------|
| `${CLAUDE_SKILL_DIR}/pgf-format.md` | PGF file format (DESIGN/WORKPLAN .md structure, naming conventions) |

### Design Phase (design mode)

| Document | Purpose |
|----------|---------|
| `${CLAUDE_SKILL_DIR}/gantree-reference.md` | Gantree node syntax, status codes, indentation, atomicity judgment |
| `${CLAUDE_SKILL_DIR}/reference.md` | PPR syntax — `AI_` functions, `→` pipelines, `[parallel]`, types, Convergence Loop, Failure Strategy |
| `${CLAUDE_SKILL_DIR}/pgf-checklist.md` | Design/execution/verification checklist |
| `${CLAUDE_SKILL_DIR}/analyze-reference.md` | design --analyze reverse engineering — codebase → auto-generate DESIGN |
| `${CLAUDE_SKILL_DIR}/design-review-reference.md` | 3-perspective design review — feasibility/risk/architecture pre-implementation validation |

### Execution Phase (plan / execute / loop mode)

| Document | Purpose |
|----------|---------|
| `${CLAUDE_SKILL_DIR}/workplan-reference.md` | WORKPLAN conversion, POLICY block, Loop algorithm, error recovery |
| `${CLAUDE_SKILL_DIR}/loop/loop-reference.md` | Stop Hook loop engine — node selection, prompt composition, error recovery |
| `${CLAUDE_SKILL_DIR}/verify-reference.md` | 3-perspective cross-verification — acceptance/quality/architecture, rework rules |
| `${CLAUDE_SKILL_DIR}/fullcycle-reference.md` | full-cycle continuous execution — phase transitions, rework regression, session resumption |
| `${CLAUDE_SKILL_DIR}/review-reference.md` | **v2.5** review mode — iterative analysis, prioritization, fix, re-verification |
| `${CLAUDE_SKILL_DIR}/evolve-reference.md` | **v2.5** evolve mode — self-evolution cycle, capability audit, stabilization detection |

### Discovery/Creation Phase (discover / create mode)

| Document | Purpose |
|----------|---------|
| `${CLAUDE_SKILL_DIR}/discovery/discovery-reference.md` | A3IE 7-stage pipeline, Agent parallel execution, result integration |
| `${CLAUDE_SKILL_DIR}/create-reference.md` | Autonomous creation cycle — 5-Phase auto-execution, auto_select_idea |
| `${CLAUDE_SKILL_DIR}/discovery/archive-discovery.ps1` | Discovery artifact date-based archive script |

### Agent Communication & Delegation (v2.2)

| Document | Purpose |
|----------|---------|
| `${CLAUDE_SKILL_DIR}/agent-protocol.md` | PG-based inter-agent communication spec — TaskSpec format, parallel dispatch, result integration |
| `${CLAUDE_SKILL_DIR}/delegate-reference.md` | **v2.2** DELEGATE mode — AI-to-AI handoff, authority bounds, delegation chain |
| `${CLAUDE_SKILL_DIR}/micro-reference.md` | **v2.2** MICRO mode — ≤10 node zero-overhead execution, auto-promotion |
| `${CLAUDE_SKILL_DIR}/session-learning-reference.md` | **v2.2** Session Learning — cross-session learning, pattern accumulation, strategy adaptation |

### Advanced Reference (as needed)

| Document | Purpose |
|----------|---------|
| `${CLAUDE_SKILL_DIR}/protocol-reference.md` | [Vision] PGF-MCP / PGF-A2A multi-agent protocol |
| `${CLAUDE_SKILL_DIR}/examples/content-gen-system.md` | Practical example — content generation system |
| `${CLAUDE_SKILL_DIR}/examples/api-service.md` | Practical example — REST API service |

### Persona Agents (discover/create mode)

Discovery Engine's 8 personas are independently defined as agent files in `${CLAUDE_SKILL_DIR}/agents/`:

| Agent | Cognitive Style | Domain | Horizon |
|-------|----------------|--------|---------|
| `pgf-persona-p1.md` — Disruptive Engineer | creative | technology | long |
| `pgf-persona-p2.md` — Hard-nosed Investor | analytical | market | short |
| `pgf-persona-p3.md` — Regulatory Architect | critical | policy | long |
| `pgf-persona-p4.md` — Connecting Scientist | intuitive | science | long |
| `pgf-persona-p5.md` — Field Operator | analytical | technology | short |
| `pgf-persona-p6.md` — Future Sociologist | intuitive | society | long |
| `pgf-persona-p7.md` — Contrarian Critic | critical | market | short |
| `pgf-persona-p8.md` — Convergence Architect | creative | science_technology | long |

---

## Execution Modes

PGF supports the following execution modes via `$ARGUMENTS`.

**Invocation examples:** `/PGF design MyProject`, `/PGF full-cycle ChatApp`, `/PGF loop start`, `/PGF discover`, `/PGF create`

| Mode | Trigger | Action |
|------|---------|--------|
| `design` | "design", "structure design" | Gantree structure design + PPR detailing → generate DESIGN-{Name}.md |
| `design --analyze` | "analyze", "structure analysis" | (sub-option of design) Reverse-engineer existing system into PGF → read code → extract Gantree + PPR |
| `plan` | "work plan", "WORKPLAN" | DESIGN → WORKPLAN conversion + POLICY configuration |
| `execute` | "execute", "implement" | Sequential node execution based on WORKPLAN |
| `full-cycle` | "full process", "full-cycle" | Full process: design → plan → execute → verify |
| `loop` | "loop", "auto-execute" | Automatic node traversal/execution via Stop Hook-based WORKPLAN |
| `discover` | "discover", "idea" | A3IE 7-stage × 8 personas → idea discovery |
| `create` | "create", "autonomous creation" | **Full autonomous execution: discover → design → plan → execute → verify** |
| `micro` | "quick", "simple" | **v2.2** Zero-overhead execution for ≤10 nodes — bypass WORKPLAN |
| `review` | "review", "inspect" | **v2.5** Iterative review & improvement — thorough review, fix, and re-verification of existing artifacts |
| `evolve` | "evolve", "self-improve" | **v2.5** Self-evolution cycle — capability gap discovery, design, implementation, verification, and recording |
| `delegate` | "delegate", "hand off" | **v2.2** AI-to-AI task handoff with PG TaskSpec, authority bounds, delegation chain |

**$ARGUMENTS parsing rules:**
- `$ARGUMENTS[0]`: mode keyword
- `$ARGUMENTS[1:]`: project name or target description
- No mode keyword → infer from context (e.g., presence of files in `.pgf/` directory)
- Project name only → defaults to `design` mode

### File Path Rules

```text
<project-root>/
    .pgf/
        DESIGN-{Name}.md          # System design (Gantree + PPR)
        WORKPLAN-{Name}.md        # Executable work plan
        status-{Name}.json        # Execution state tracking
```

`{Name}` = CamelCase project/task name. Multiple tasks can coexist in the same `.pgf/`.

### Progress Reporting

```text
[PGF] ✓ NodeName (done) | 3/12 nodes done | next: NextNode
[PGF] ✗ NodeName (blocked) | blocker: reason | skip → NextNode
```

---

## Integrated Execution Process

> The Steps below are **independent modes, not a sequential process**. Only the needed ones are executed based on user instructions or PGF mode. Only full-cycle/create modes chain multiple Steps sequentially.

### Step 1: design — Gantree Structure Design

Top-Down BFS hierarchical decomposition → down to atomic nodes. Reference: `gantree-reference.md`, `reference.md`

**Completion criteria:** (1) All leaves = atomic nodes (2) PPR def written for complex nodes (3) No circular @dep (4) Checklist passed

### Step 2: plan — WORKPLAN Generation

DESIGN-{Name}.md → WORKPLAN-{Name}.md conversion. Reference: `workplan-reference.md §2`

### Step 3: execute — Sequential Node Execution

Node execution based on WORKPLAN-{Name}.md. Consider using `/batch` for `[parallel]` nodes. Reference: `workplan-reference.md §4`

### Step 4: verify — Cross-Verification

Details: `${CLAUDE_SKILL_DIR}/verify-reference.md`

3-perspective verification:
1. **Acceptance Criteria** — Re-check acceptance_criteria from DESIGN PPR (Lightweight: `# criteria:` inline)
2. **Code Quality** — `/simplify` skill integration, verify reuse/quality/efficiency of changed code
3. **Architecture** — Compare DESIGN Gantree ↔ actual implementation structure (Lightweight: skip)

Result: `passed` → complete / `rework` → rollback target node + re-execute subtree / `blocked` → report to user.
Rework iterations are allowed up to `POLICY.max_verify_cycles`.

### full-cycle

Details: `${CLAUDE_SKILL_DIR}/fullcycle-reference.md`

Automatically execute design → plan → execute → verify as one continuous process. On rework during verify, roll back only the affected subtree and re-execute (up to `POLICY.max_verify_cycles` times). On session interruption, resume from the last Phase recorded in WORKPLAN/status JSON.

**Phase transition conditions:**

| Transition | Condition | On failure |
|------------|-----------|------------|
| discover → design | `auto_select_idea()` succeeds (**create mode only**) | 0 votes → abort |
| design → plan | All 4 completion criteria met | continue design |
| plan → execute | WORKPLAN + status JSON generated | report error |
| execute → verify | All nodes terminal | continue execute |
| verify → complete | passed | rework or report |

### Step 5: loop — Stop Hook-Based Auto-Execution

Details: `${CLAUDE_SKILL_DIR}/loop/loop-reference.md`

| Command | Action |
|---------|--------|
| `/PGF loop start` | Initialize loop + execute first node |
| `/PGF loop cancel` | Cancel active loop |
| `/PGF loop status` | Report progress status |

On `/PGF loop start`: (1) Verify WORKPLAN exists (2) Run `init-loop.ps1` (3) Determine mode (DESIGN exists → Standard / absent → Lightweight) (4) Select first node + load execution spec (5) Begin implementation. Afterwards, Stop Hook automatically injects the next node.

**Lightweight mode**: Loop execution with WORKPLAN only, without DESIGN. `#` inline comments under WORKPLAN nodes serve as PPR substitutes. Suitable for simple tasks, documentation, refactoring, etc.

### Step 6: discover — A3IE Persona Multi-Agent Discovery

Details: `${CLAUDE_SKILL_DIR}/discovery/discovery-reference.md`

| Command | Action |
|---------|--------|
| `/PGF discover` | Execute all 7 stages |
| `/PGF discover --from-step N` | Restart from stage N |
| `/PGF discover --personas N` | Use N personas |

Invoke 8 `${CLAUDE_SKILL_DIR}/agents/pgf-persona-p*.md` agents in parallel (model: sonnet). Integrate results from each stage → save to `.pgf/discovery/{step}.md`. HAO principle: do not enforce output format, preserve originals unedited.

### Step 7: create — Autonomous Creation Cycle

Details: `${CLAUDE_SKILL_DIR}/create-reference.md`

| Command | Action |
|---------|--------|
| `/PGF create` | 5-Phase autonomous execution (DISCOVER→DESIGN→PLAN→EXECUTE→VERIFY) |
| `/PGF create --skip-discover` | Start from design using existing final_idea.md |

Fully autonomous execution without user approval. STEP 7 is replaced by `auto_select_idea` (vote-based automatic selection).

### Step 8: micro — Zero-Overhead Small Task Execution (v2.2)

Details: `${CLAUDE_SKILL_DIR}/micro-reference.md`

| Command | Action |
|---------|--------|
| `/PGF micro "task description"` | Inline decomposition → serial execution → minimal verify |

Entry: nodes ≤ 10, depth ≤ 3, no external deps, ≤ 30 min. Bypasses WORKPLAN/POLICY/status JSON. In-memory status only. Auto-promotes to full WORKPLAN if bounds exceeded.

### Step 9: delegate — AI-to-AI Task Handoff (v2.2)

Details: `${CLAUDE_SKILL_DIR}/delegate-reference.md`

Auto-triggered during execute when `should_delegate()` → True (capability gap, load balancing, parallel opportunity). Packages context into PG TaskSpec with AuthorityBounds → handshake → await result → validate → merge. Delegation chain tracks depth (max 3) and prevents cycles.

### Session Learning (Cross-cutting — All Modes)

Details: `${CLAUDE_SKILL_DIR}/session-learning-reference.md`

- **Session start**: Load `.pgf/patterns/` → adapt POLICY defaults
- **Session end**: Record `SessionOutcome` to `.pgf/sessions/{id}.outcome.json`
- **Every 10 sessions**: Re-accumulate patterns (successful strategies, common blockers)

---

## Scale Detection and Strategy

> PG defines 3 Levels (Level 1~3). PGF inherits them and adds Large/Multi-agent.

| Scale | Criteria | Strategy |
|-------|----------|----------|
| **Level 1** | nodes ≤ 3 | **v2.3** Natural language inline execution — no PG files |
| **Level 2** | nodes 4–10 | **v2.3** Gantree + `#` comments — optional files |
| **Level 3** | nodes 11–30 | Full DESIGN + WORKPLAN + status JSON |
| **Large** | nodes > 30 or `(decomposed)` | Module separation + `/compact` |
| **Multi-agent** | `[parallel]` with specialized tasks | `delegate` mode — AI-to-AI handoff |

> **v2.3 Progressive Formalization**: Level determination is automatic. Natural language input → AI evaluates complexity → selects appropriate Level. Existing state is preserved on promotion during execution.

## Execution Rules

1. Parse Gantree → determine hierarchy via indentation
2. Status codes → decide execute/skip
3. `@dep:` → determine execution order
4. `[parallel]` → concurrent processing
5. PPR `def` present → interpret and execute / `AI_` inline → execute directly / no PPR → recurse into children
6. Atomicity judgment → 15-minute rule
7. Failure → Failure Strategy + AI Redesign Authority
8. **Agent dispatch → PG TaskSpec** — use PG TaskSpec format from `agent-protocol.md` instead of natural language when dispatching agents. Deliver I/O types, acceptance_criteria, and failure_strategy in structured form
9. **Session start → load patterns** — load past patterns from `.pgf/patterns/` → automatic POLICY adaptation
10. **Session end → record outcome** — automatically record SessionOutcome to `.pgf/sessions/{id}.outcome.json`

## Claude Code Skill Integration

| Skill | When to use |
|-------|-------------|
| `/batch` | Execute independent nodes within `[parallel]` blocks in parallel worktrees |
| `/simplify` | Code quality verification during verify |
| `/compact` | Context compression every 3–5 nodes (must preserve WORKPLAN path/state) |
