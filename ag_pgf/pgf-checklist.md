# PGF Checklist

Quality checklist referenced during design/execution/verification phases.

---

## Gantree Design

- [ ] All nodes within 5 levels
- [ ] Each node status clearly marked (PG 6 + PGF 3: done/in-progress/designing/blocked/decomposed/needs-verify + delegated/awaiting-return/returned)
- [ ] Sufficiently decomposed down to atomic nodes
- [ ] Node names consistently in CamelCase
- [ ] Dependencies (`@dep:`) marked where needed
- [ ] No cycles in the dependency graph confirmed (e.g., A→B→C→A)
- [ ] Parallel (`[parallel]`) regions identified
- [ ] Output inside code blocks, 4-space indentation

## PPR Detailing

- [ ] PPR `def` blocks written for complex nodes
- [ ] I/O specified with Python type hints
- [ ] Identified which of the 4 cognitive categories (Judgment/Reasoning/Recognition/Creation) each AI_ function belongs to
- [ ] Convergence Loop pattern applied where needed
- [ ] Failure Strategy + acceptance_criteria defined
- [ ] Deterministic logic written as actual code

## Execution Verification

- [ ] All node statuses in WORKPLAN-{Name}.md are terminal (done/blocked)
- [ ] Summary in status-{Name}.json matches WORKPLAN-{Name}.md statuses
- [ ] Blocker reason documented for `(blocked)` nodes

## Verify Phase (3-Perspective Cross-Verification)

- [ ] **Perspective 1 — Acceptance**: Re-check acceptance_criteria for each completed node (Lightweight: `# criteria:` inline)
- [ ] **Perspective 2 — Code Quality**: Verify reuse/quality/efficiency of changed code via /simplify
- [ ] **Perspective 3 — Architecture**: Compare DESIGN Gantree ↔ implementation structure (Lightweight: skip)
- [ ] Verdict recorded: passed / rework / blocked
- [ ] On rework: rollback target node + children → re-execute → re-verify (within max_verify_cycles)
- [ ] On blocked: document reason + report to user

## full-cycle Mode

- [ ] Design completion criteria (4 items) met before transitioning to plan
- [ ] Verify WORKPLAN + status JSON exist on plan → execute transition
- [ ] Confirm all nodes are terminal on execute → verify transition
- [ ] On verify rework, rollback only the target subtree (no full reset)
- [ ] On max_verify_cycles exceeded, preserve artifacts + report abort
- [ ] On session interruption, confirm resumability from WORKPLAN/status JSON

## Discovery Archive

- [ ] Run archive-discovery.ps1 after execution completes
- [ ] Confirm archive directories are separated by date (YYYY-MM-DD)
- [ ] create mode: auto-archive immediately after Phase 1 completion

## Common Mistakes

| Mistake | Solution |
|---------|----------|
| Writing Gantree only, omitting PPR | Complex nodes must have PPR `def` blocks |
| Tree exceeds 6 levels | Split into separate tree with `(decomposed)` status |
| Using `AI_` where precision is needed | Use actual code for math/transformations |
| Naming inconsistency | Node names=CamelCase, function names=snake_case |
| Failure strategy undefined | Apply Failure Strategy + AI Redesign Authority |
| Acceptance criteria undefined | Embed acceptance_criteria in PPR |

## v2.2 Extensions

- [ ] `AI_make_` causative pattern used where needed (when AI causes a target to do something)
- [ ] Considered using micro mode for tasks with ≤10 nodes
- [ ] Used PG TaskSpec format when dispatching parallel agents
- [ ] Specified AuthorityBounds (can_create/can_modify/forbidden) for delegation
- [ ] Confirmed delegation chain depth ≤ 3
- [ ] Recorded SessionOutcome upon session completion
- [ ] Used `(delegated)`/`(awaiting-return)`/`(returned)` statuses appropriately
