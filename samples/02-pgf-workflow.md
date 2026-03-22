# Sample 2: PGF Workflow — Design, Plan, Execute, Verify

## The Problem PGF Solves

When you ask AI to "build JWT authentication," it dumps 500 lines in one shot. If the refresh token logic is wrong, you can't fix just that part — you regenerate everything and hope. There's no progress tracking, no structured verification, no way to isolate failures.

**PGF changes this.** It decomposes work into trackable nodes, executes them in dependency order, and when something fails, reworks only the affected node — not the entire output.

## Prerequisites

PGF runs as a **Claude Code skill**. The `/pgf` commands below are slash commands in the Claude Code CLI. See the [main README](../README.md) for setup.

---

## What You'll Learn
- The 4-phase cycle: **design → plan → execute → verify**
- WORKPLAN and POLICY concepts
- How verification catches issues and triggers targeted rework

---

## Scenario: Add User Authentication to a Web App

### Phase 1: Design — Gantree + PPR

Run `/pgf design AuthSystem` in Claude Code. The AI creates a structured design:

```
AuthSystem // User authentication system (designing) @v:1.0

    PasswordModule // Password hashing and verification (designing)
        hash_password // Hash with bcrypt (designing)
        verify_password // Compare hash (designing)

    TokenModule // JWT token management (designing) @dep:PasswordModule
        generate_token // Create JWT with claims (designing)
        validate_token // Verify and decode JWT (designing)
        refresh_token // Issue new token from valid refresh token (designing)

    AuthMiddleware // Request authentication middleware (designing) @dep:TokenModule
        AI_design_middleware // Design middleware architecture (designing)
        implement_middleware // Implement the middleware (designing)

    AuthEndpoints // REST endpoints (designing) @dep:AuthMiddleware
        [parallel]
        POST_register // POST /auth/register (designing)
        POST_login // POST /auth/login (designing)
        POST_refresh // POST /auth/refresh (designing)
        [/parallel]

    AuthTests // Integration tests (designing) @dep:AuthEndpoints
        AI_generate_test_cases // Generate edge case tests (designing)
        run_tests // Execute test suite (designing)
```

**PPR for the complex node:**

> Remember: PPR is an intent specification, not executable Python. `acceptance_criteria` in the docstring tells the AI what "done" means for this node.

```python
def auth_middleware(request: Request) -> Response:
    """
    Authenticate incoming requests via JWT.

    acceptance_criteria:
        valid_token_passes: true
        expired_token_rejected: true
        missing_token_returns_401: true
        middleware_adds_user_to_request: true
    """

    token = extract_bearer_token(request.headers)

    if not token:
        return Response(401, {"error": "Missing token"})

    claims = validate_token(token)

    if not claims:
        return Response(401, {"error": "Invalid or expired token"})

    request.user = claims["user_id"]
    return next_handler(request)
```

### Phase 2: Plan — WORKPLAN Generation

Run `/pgf plan AuthSystem`. The AI generates a WORKPLAN — a concrete execution plan with policies:

```markdown
# WORKPLAN-AuthSystem.md

## POLICY
max_retry: 2              # Retry failed nodes up to 2 times before marking blocked
on_blocked: skip_and_log  # Skip blocked nodes, continue with others
max_verify_cycles: 3      # Max rework iterations during verification

## Execution Order (derived from @dep: dependencies)

1. PasswordModule
   1.1 hash_password
   1.2 verify_password

2. TokenModule              ← unlocks after PasswordModule done
   2.1 generate_token
   2.2 validate_token
   2.3 refresh_token

3. AuthMiddleware            ← unlocks after TokenModule done
   3.1 AI_design_middleware
   3.2 implement_middleware

4. AuthEndpoints [parallel]  ← unlocks after AuthMiddleware done
   4.1 POST_register  ┐
   4.2 POST_login     ├ concurrent
   4.3 POST_refresh   ┘

5. AuthTests                 ← unlocks after AuthEndpoints done
   5.1 AI_generate_test_cases
   5.2 run_tests
```

**POLICY controls execution behavior:**

| Setting | What It Does |
|---------|-------------|
| `max_retry` | How many times to retry a failed node before giving up |
| `on_blocked` | What to do when a node can't proceed (skip it or stop everything) |
| `max_verify_cycles` | How many rework iterations are allowed during verification |

### Phase 3: Execute — Node-by-Node Implementation

The AI walks through nodes in dependency order, implementing each one. Note how POLICY kicks in when a node fails:

```
[PGF] ✓ hash_password (done) | 1/12 nodes | next: verify_password
[PGF] ✓ verify_password (done) | 2/12 nodes | next: generate_token
[PGF] ✓ generate_token (done) | 3/12 nodes | next: validate_token
[PGF] ✗ validate_token (failed) | error: edge case with empty claims
       → retry 1/2 (POLICY max_retry: 2)
[PGF] ✓ validate_token (done) | 4/12 nodes | next: refresh_token
[PGF] ✓ refresh_token (done) | 5/12 nodes | next: AI_design_middleware
[PGF] ✓ AI_design_middleware (done) | 6/12 nodes | next: implement_middleware
[PGF] ✓ implement_middleware (done) | 7/12 nodes | next: [parallel] endpoints
[PGF] ✓ POST_register (done) ┐
[PGF] ✓ POST_login (done)    ├ 8-10/12 nodes | parallel complete
[PGF] ✓ POST_refresh (done)  ┘
[PGF] ✓ AI_generate_test_cases (done) | 11/12 nodes | next: run_tests
[PGF] ✓ run_tests (done) | 12/12 nodes | All nodes complete.
```

Notice: `validate_token` failed on first attempt, but POLICY's `max_retry: 2` allowed an automatic retry. The AI diagnosed the edge case and fixed it — no human intervention needed.

### Phase 4: Verify — 3-Perspective Cross-Check

PGF doesn't just check "does it work?" — it verifies from 3 independent perspectives:

```
Verification Results:
─────────────────────────────────────────────
1. Acceptance Criteria    ✓ PASSED
   - All acceptance_criteria from PPR def blocks satisfied
   - valid_token_passes: ✓
   - expired_token_rejected: ✓
   - missing_token_returns_401: ✓
   - middleware_adds_user_to_request: ✓

2. Code Quality           ✓ PASSED
   - No code duplication detected
   - All functions under 30 lines
   - Error handling consistent across modules

3. Architecture           ✗ REWORK NEEDED
   - Issue: refresh_token endpoint doesn't invalidate old tokens
   - Risk: token replay attacks possible
   - Affected node: refresh_token
   - Action: rework this node only (not the entire system)
─────────────────────────────────────────────

[PGF] Rework: refresh_token (rolling back → re-executing)
[PGF] ✓ refresh_token (done) — added old token invalidation
[PGF] Re-verify cycle 2/3: Architecture ✓ PASSED

Final: PASSED (all 3 perspectives) — 2/3 verify cycles used
```

**Key insight:** Only `refresh_token` was reworked — not the entire auth system. The Gantree structure makes surgical fixes possible.

---

## The Full Cycle in One Command

Instead of running each phase manually:

```
/pgf full-cycle AuthSystem
```

This executes **design → plan → execute → verify** automatically, with rework loops when verification fails. The `max_verify_cycles` POLICY setting prevents infinite rework.

---

## Key Takeaways

| Phase | Command | What Happens |
|-------|---------|-------------|
| **Design** | `/pgf design Name` | Creates Gantree tree + PPR logic |
| **Plan** | `/pgf plan Name` | Generates WORKPLAN with POLICY settings |
| **Execute** | `/pgf execute Name` | Implements nodes in dependency order, retries on failure |
| **Verify** | (automatic) | 3-perspective check; reworks only affected nodes |
| **Full Cycle** | `/pgf full-cycle Name` | All 4 phases, fully automated |

---

## What Else Can PGF Do?

| Mode | When to Use | Example |
|------|------------|---------|
| `/pgf micro "task"` | Quick tasks under 10 steps | `/pgf micro "add input validation to signup form"` |
| `/pgf loop start` | Auto-execute WORKPLAN nodes continuously | Long-running implementation sessions |
| `/pgf discover "topic"` | 8 independent AI personas brainstorm ideas | `/pgf discover "next-gen auth methods"` |
| `/pgf create "topic"` | Full autonomous: discover → design → execute → verify | `/pgf create "real-time notification system"` |

---

**Previous:** [Sample 1 — PG Basics](01-pg-basics.md) covers Gantree and PPR fundamentals.
