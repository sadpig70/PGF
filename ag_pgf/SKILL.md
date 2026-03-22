---
name: ag_pgf
description: "PGF (PPR/Gantree Framework) for Antigravity — AI-native design/execution framework. Supports system architecture design, autonomous execution, and multi-agent scaling. Based on PG notation (see PG_NOTATION.md)."
---

# Antigravity PGF (PPR/Gantree Framework) v3.0

> **"PG is not machine code. It is the first native language of intelligence that internalizes how AI (agents) think, notate, and communicate."**
>
> Beyond a simple workflow engine, this is the core philosophy that permanently evolves into a **'fully autonomous, extensible runtime'** — eliminating natural language ambiguity to zero and enabling AI to autonomously decompose (BFS decomposition) and drive large-scale systems.
>
> Compiled (ported) for full compatibility with Antigravity's `task_boundary` tool.

## 1. Foundation Dependency (PG Notation)
This framework operates based on PG syntax (Gantree, PPR, AI_ functions, etc.) defined in `PG_NOTATION.md`.
**Required:** Before initiating any PGF logic, you must open (view_file) `PG_NOTATION.md` in the same folder to acquire foundational knowledge.

## 2. PGF Current State Tracking
Antigravity PGF manages state not through external JSON files, but via the **`task.md` artifact** in the user workspace (brain folder) and the **`task_boundary` tool**.
1. The Gantree structure (in-progress/done/designing, etc.) is reflected in real-time within `task.md`.
2. Workflow transitions are recorded through `task_boundary` TaskStatus and Summary.

## 3. Reference Document Guide
All sub-reference documents for this skill are located in the current skill path. Actively open them with `view_file` as needed.

### Execution Phase
| Document | Purpose |
|----------|---------|
| `./workplan-reference.md` | WORKPLAN design and policy configuration standards |
| `./loop/loop-reference.md` | Autonomous loop mode (combined with Antigravity EXECUTION mode continuous execution) |
| `./verify-reference.md` | 3-perspective cross-verification (Acceptance/Quality/Architecture) |

### Discovery/Creation Phase
| Document | Purpose |
|----------|---------|
| `./discovery/discovery-reference.md` | A3IE discovery pipeline via parallel deployment of 8 personas |
| `./create-reference.md` | 5-Phase autonomous creation engine execution flow |

### Agent Delegation (Multi-Agent & Delegation)
| Document | Purpose |
|----------|---------|
| `./agent-protocol.md` | PG TaskSpec format inter-agent communication protocol for Antigravity |
| `./delegate-reference.md` | Antigravity sub-task creation and delegation algorithm |

## 4. Execution Modes (Command Mapping Rules)
Transitioned from the legacy separated command structure to **Antigravity natural language / state-based execution**.
When the user issues specific keywords, the Antigravity agent immediately activates the corresponding mode's process.

| Mode (Intent) | Antigravity Action Mapping |
|-------------|----------------------------|
| `design` ("design this") | Enter `task_boundary(PLANNING)` → Generate `IMPLEMENTATION_PLAN.md` upon Gantree design completion |
| `execute` ("execute this") | Enter `task_boundary(EXECUTION)` → Implement nodes sequentially according to WORKPLAN |
| `loop` / `full-cycle` | Maintain `EXECUTION` mode → Perform design/implementation/test cycles without interruption |
| `discover` ("discover this") | Run persona (`agents/*.md`) analyses sequentially/in parallel, then generate consolidated report (based on `discovery-reference.md`) |
| `delegate` ("delegate this") | When sub-task workload exceeds 15 minutes, split into separate `task_boundary` for independent execution |

## 5. Antigravity Tool Integration
* **Parallel execution (`[parallel]`):** When a `[parallel]` node group is found, bundle Antigravity tool calls as `concurrent tool calls` for parallel execution.
* **Code cleanup (instead of `/simplify`):** When performing `replace_file_content`, score the complexity and conduct structural refactoring autonomously.
* **Context compression (instead of `/compact`):** When too many turns accumulate, issue an intermediate `walkthrough.md` to dump the log and refresh the context (revive via a new task_boundary task).

## 6. Execution Rules (Most Critical Execution Principles)
1. **Dynamic Micro Fallback:** When receiving a user instruction, first calculate its difficulty. If the estimated work time is under 15 minutes or the number of files to modify is 2 or fewer (deemed a 'simple task'), skip the full PGF pipeline (Gantree tree decomposition, 4-stage cross-verification, etc.) entirely and proceed directly to **Micro Mode** for immediate code modification.
2. **Gantree-Task Synchronization:** Never corrupt the `task.md` artifact. Always track nodes in accordance with Gantree hierarchy rules.
3. **Failure Strategy:** On verification failure, do not immediately give up or ask questions via `notify_user`. Instead, follow the `AI Redesign Authority` rule — self-rollback and attempt internal re-modification at least 2 times (Session Learning).
4. **Session Outcome:** Before completing a task, always record outcomes in the `task_boundary` Summary, write a `walkthrough.md`, and report completion via `notify_user`.
