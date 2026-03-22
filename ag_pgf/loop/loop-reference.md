# Antigravity PGF Loop Reference

> The Antigravity PGF loop mode uses the **Antigravity-native EXECUTION mode Self-Correction Loop**, rather than the legacy Stop Hook (.claude/hooks.json) bypass approach.

## 1. Loop Engine Overview
* Previously, external shell scripts (`.ps1`) injected the next node by hooking into agent termination — a workaround. Antigravity instead guarantees **agent autonomy** by natively continuing across multiple turns.
* When the user instructs "start autonomous loop," Antigravity maintains the `task_boundary(EXECUTION)` state and advances to the end of the WORKPLAN without stopping, updating `task.md` on its own.

## 2. State Tracking and Recovery Logic
1. Instead of `.claude/pgf-loop-state.json`, the workspace `task.md` artifact serves as the state machine.
2. All nodes advance unidirectionally through states: `[ ]` -> `[/]` -> `[x]`.
3. On error, update the `task_boundary` TaskStatus to "error recovery" and retry the node.

## 3. Loop Execution Cycle (Antigravity Pipeline)
1. **Intent confirmation:** Obtain "loop mode execution" authorization from the user via `notify_user`.
2. **Iteration cycle:**
   - Identify the topmost atomic node in `task.md` that is `[/]` (in-progress) or `[ ]`
   - Write and modify implementation code (`write_to_file`, `replace_file_content`)
   - Update `task.md` checkbox (`[x]`)
   - Refresh `task_boundary` summary every 3-5 nodes (replaces `/compact`)
3. **Termination:** Once all nodes are complete, write `walkthrough.md` and report completion via `notify_user`.
