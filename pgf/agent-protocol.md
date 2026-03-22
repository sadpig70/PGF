# PGF Agent Protocol — Inter-Agent Communication Specification Based on PG

> When dispatching agents, deliver a **PG specification** instead of a natural language prompt.
> A common language for AI-to-AI task delegation.

---

## 1. Why Communicate via PG

| Natural Language Prompt | PG Task Specification |
|---|---|
| Intent can be ambiguous | `def` signature makes I/O explicit |
| Verification criteria are implicit | `acceptance_criteria` built-in |
| Execution order buried in prose | Structured with `@dep:`, `→` |
| Failure response unclear | Failure Strategy explicitly defined |
| Result format inconsistent | Return contract via `-> ReturnType` |

Communicating via PG:
- **Dispatching AI** conveys intent precisely
- **Executing AI** can self-verify via acceptance_criteria
- **Results** are typed, making integration straightforward

---

## 2. TaskSpec — Agent Dispatch Specification Format

Write tasks to be delivered to agents using the following PG structure:

```python
def task_name(
    # Input parameters — all context needed for execution
    target_crate: Path,
    existing_pattern: Path,      # Existing code to reference
    workspace_root: Path = "D:\\project\\ocwr",
) -> TaskResult:
    """One-line task description"""

    # context: (Files/information the executing AI must read first)
    #   - Read(target_crate / "src/lib.rs")
    #   - Read(existing_pattern)

    # steps:
    #   1. Analyze existing pattern
    #   2. Implement new module
    #   3. Write tests
    #   4. cargo check + clippy

    # implementation:
    AI_implement_following_pattern(existing_pattern, target="new_module")

    # acceptance_criteria:
    #   - cargo check -p {crate} → 0 errors
    #   - cargo clippy -p {crate} -- -D warnings → 0 warnings
    #   - tests >= N
    #   - Existing tests unchanged

    # failure_strategy:
    #   - Compile error → AI_fix_compile_error(error_msg)
    #   - Clippy warning → AI_fix_clippy_warning(warning_msg)
    #   - max_retry: 3

    # return:
    #   TaskResult = {
    #       files_created: list[Path],
    #       files_modified: list[Path],
    #       test_count: int,
    #       summary: str,
    #   }
```

### Required Sections

| Section | Role | Required |
|---|---|---|
| `def` signature | Input parameters + return type | ✅ |
| `"""docstring"""` | One-line task description | ✅ |
| `# context:` | Files to read before execution | ✅ |
| `# acceptance_criteria:` | Completion judgment criteria | ✅ |
| `# steps:` | Execution order (optional) | ○ |
| `# implementation:` | Core logic (AI_ or actual code) | ○ |
| `# failure_strategy:` | Response on failure | ○ |
| `# return:` | Result structure | ○ |

---

## 3. Parallel Dispatch — [parallel] TaskSpec

When dispatching multiple agents simultaneously:

```python
[parallel]

def implement_discord_adapter(channels: Path) -> AdapterResult:
    """Discord REST API adapter"""
    # context: Read(channels / "adapters/slack.rs")
    # acceptance_criteria: cargo check, tests >= 10

def implement_slack_adapter(channels: Path) -> AdapterResult:
    """Slack Web API adapter"""
    # context: Read(channels / "adapters/discord.rs")  # Reference the one completed first
    # acceptance_criteria: cargo check, tests >= 10

def implement_telegram_adapter(channels: Path) -> AdapterResult:
    """Telegram Bot API adapter"""
    # context: Read(channels / "adapter.rs")
    # acceptance_criteria: cargo check, tests >= 10

[/parallel]

# Integration verification — after all parallel tasks complete
def verify_all_adapters(workspace: Path) -> VerifyResult:
    """Full adapter integration verification"""
    # @dep: implement_discord_adapter, implement_slack_adapter, implement_telegram_adapter
    cargo_check(workspace, "--workspace")
    cargo_test(workspace, "-p ocwr_channels")
```

---

## 4. Dependency Chain Dispatch — @dep TaskSpec

Sequential task delegation with ordering:

```python
def expand_adapter_traits(channels: Path) -> TraitResult:
    """Add 7 channel adapter interfaces"""
    # acceptance_criteria: AdapterKind.TOTAL == 16

def implement_adapters(channels: Path) -> list[AdapterResult]:
    """Implement 6 channel adapters"""
    # @dep: expand_adapter_traits
    # ↑ Execute only after trait expansion is complete
    [parallel]
    AI_implement("discord")
    AI_implement("slack")
    AI_implement("telegram")
    [/parallel]
```

---

## 5. Result Reporting Format — TaskResult

Results returned by the executing AI also follow PG structure:

```python
# Success result
TaskResult = {
    "status": "done",
    "files_created": ["src/adapters/discord.rs"],
    "files_modified": ["src/adapters/mod.rs", "src/lib.rs"],
    "test_count": 12,
    "summary": "Discord REST API adapter: send/embed/react/delete + 12 tests",
    "acceptance": {
        "cargo_check": "pass",
        "clippy": "pass",
        "tests": "12/12 pass",
    },
}

# Failure result
TaskResult = {
    "status": "blocked",
    "blocker": "reqwest crate not in workspace dependencies",
    "attempted_fix": "Added reqwest to Cargo.toml but version conflict with existing dep",
    "suggestion": "Upgrade workspace reqwest from 0.11 to 0.12",
}
```

---

## 6. Orchestrator → Agent Flow

When PGF encounters a `[parallel]` block during the execute phase:

```python
def orchestrate_parallel_block(nodes: list[GantreeNode], design: Path):
    """Dispatch nodes in a [parallel] block to agents"""

    for node in nodes:
        # 1. Extract TaskSpec from node's PPR def or # comments
        task_spec = extract_task_spec(node, design)

        # 2. Deliver PG-formatted TaskSpec as agent prompt
        agent_prompt = format_pg_task_spec(task_spec)

        # 3. Dispatch via Agent tool
        Agent(
            prompt=agent_prompt,
            name=node.name,
            mode="bypassPermissions",
            run_in_background=True,
        )

    # 4. Wait for all agents to complete
    # 5. Collect TaskResult from each agent
    # 6. Cross-verify acceptance_criteria
```

### PG TaskSpec → Agent Prompt Conversion Rules

```python
def format_pg_task_spec(spec: TaskSpec) -> str:
    """Convert PG TaskSpec into an agent-comprehensible prompt

    Key: Convert to executable instructions while preserving PG structure.
    Minimize natural language explanation; the PG specification is the body of the instruction.
    """
    prompt = f"""You are executing a PG TaskSpec.

## TaskSpec

```python
{spec.to_pg_string()}
```

## Execution Rules
1. Read files listed in `# context:` first
2. Follow `# steps:` in order
3. Verify against `# acceptance_criteria:` before reporting done
4. On failure, apply `# failure_strategy:`
5. Return result in TaskResult format
"""
    return prompt
```

---

## 7. Practical Example — Natural Language → PG Conversion from a Previous Session

### Before (Natural Language Prompt)

```
Implement a Discord channel adapter for the OCWR Rust project at D:\openclaw\ocwr.
The channel adapter framework is in crates/ocwr_channels/src/adapter.rs — read it first...
Create DiscordAdapter struct that contains bot token, HTTP client, Discord API base URL...
Implement send_message, send_embed, add_reaction, delete_message...
Add unit tests, run cargo check, run clippy...
```

### After (PG TaskSpec)

```python
def implement_discord_adapter(
    channels_crate: Path = "D:\\openclaw\\ocwr\\crates\\ocwr_channels",
) -> AdapterResult:
    """Implement Discord REST API channel adapter"""

    # context:
    #   - Read(channels_crate / "src/adapter.rs")      # Check trait types
    #   - Read(channels_crate / "src/adapters/mod.rs")  # Registration pattern
    #   - Read(channels_crate / "src/message.rs")       # Message types

    # implementation:
    adapter = DiscordAdapter(
        config: DiscordConfig = {bot_token: str, guild_id: str, command_prefix: Optional[str]},
        client: reqwest.Client,
        base_url: str = "https://discord.com/api/v10",
    )

    methods = [
        send_message(channel_id: str, content: str) -> DiscordMessage,
        send_embed(channel_id: str, embed: DiscordEmbed) -> DiscordMessage,
        add_reaction(channel_id: str, message_id: str, emoji: str) -> None,
        delete_message(channel_id: str, message_id: str) -> None,
        get_guild_channels(guild_id: str) -> list[DiscordChannel],
        get_guild_members(guild_id: str) -> list[DiscordUser],
    ]

    # acceptance_criteria:
    #   - cargo check -p ocwr_channels → 0 errors
    #   - cargo clippy -p ocwr_channels -- -D warnings → 0 warnings
    #   - tests >= 10 (config, serde, construction, API URL building)
    #   - Authorization header: "Bot {token}"
    #   - Debug output: token redacted

    # failure_strategy:
    #   - compile error → AI_fix_compile_error(error_msg, max_retry=3)
    #   - clippy warning → AI_fix_clippy_warning(warning_msg)

    # return:
    #   AdapterResult = {files_created, files_modified, test_count, summary}
```

**Difference**: Natural language 17 lines → PG 35 lines, but **intent clarity, verifiability, and failure response** are structurally built-in.

---

## 8. Application Rules

### Application During PGF Execute Phase

1. **When dispatching nodes in a `[parallel]` block to agents**: Use PG TaskSpec instead of natural language
2. **When dispatching a single node to an agent** (due to large scope): Use PG TaskSpec
3. **When executing directly** (due to small scope): TaskSpec unnecessary, interpret/execute PPR def directly

### PG TaskSpec Usage Decision Criteria

| Situation | TaskSpec Usage |
|---|---|
| Direct execution (within 15 min) | ❌ Execute directly |
| Agent dispatch (simple task) | ○ Brief TaskSpec |
| Agent dispatch (complex task) | ✅ Full TaskSpec |
| Multi-agent parallel dispatch | ✅ Required — type contract needed for result integration |

### Result Integration After Agent Execution

```python
def integrate_agent_results(results: list[TaskResult]) -> IntegrationResult:
    """Parallel agent result integration + cross-verification"""

    # 1. Confirm all agents meet acceptance_criteria
    failed = [r for r in results if r["status"] != "done"]
    if failed:
        AI_handle_failures(failed)

    # 2. Full workspace integration verification
    cargo_check("--workspace")

    # 3. Cross-dependency verification (does Agent A's result affect Agent B?)
    AI_verify_cross_dependencies(results)
```
