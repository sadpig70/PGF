<p align="center">
  <img src="assets/pgf_banner.png" alt="PGF Banner" width="100%">
</p>

# PGF (PPR/Gantree Framework)

> AI-native design and execution framework for autonomous software engineering

**PG** is a platform-agnostic notation — a native language for AI to think, analyze, design, communicate, and review. It is not tied to any specific tool or runtime.

**PGF** is an execution framework built on PG, implemented as a skill for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). PG can be adopted by any AI agent as its cognitive and communication language; PGF is one concrete runtime implementation on top of it.

## Core Concepts

### PG (PPR/Gantree Notation)
The base notation layer — a structured language for AI cognition and communication:
- **Gantree** — Indentation-based hierarchical task decomposition
- **PPR** (Pseudo-Programming Representation) — Python-syntax intent specification
- **AI_ prefix** — AI cognitive operations (judgment, reasoning, recognition, creation)
- **`→` pipeline** — Cognitive flow integration into data pipelines
- **`[parallel]` blocks** — Concurrent cognitive execution

### PGF Framework
Built on top of PG, PGF adds:
- **Execution modes** — design, plan, execute, full-cycle, loop, discover, create, micro, delegate
- **WORKPLAN + POLICY** — Execution plan and policy blocks with state tracking
- **3-perspective verification** — Acceptance criteria, code quality, architecture consistency
- **Discovery pipeline** — 8-persona parallel idea generation (A3IE 7-step process)
- **Session learning** — Cross-session pattern accumulation and strategy adaptation
- **Self-evolution** — Capability audit, gap detection, and autonomous skill development

## Key Properties

| Property | Description |
|----------|-------------|
| **Parser-Free** | AI comprehends and executes directly — no parser needed |
| **Co-evolutionary** | Same PG document produces better results as AI models improve |
| **DL/OCME** | Descriptive Language / Operator-Controlled Machine Execution |

## Project Structure

```
PGF/
├── assets/                      # Logo and banner images
│   ├── pgf_banner.png
│   └── pgf_logo.png
├── pg/                          # Base notation (PG: PPR/Gantree)
│   └── SKILL.md                 # PG core language definition
│
└── pgf/                         # Framework (PGF)
    ├── SKILL.md                 # PGF skill entry point
    ├── agent-protocol.md        # AI-to-AI communication protocol
    ├── reference.md             # PPR detailed grammar
    ├── gantree-reference.md     # Gantree decomposition grammar
    ├── workplan-reference.md    # WORKPLAN generation & state management
    ├── verify-reference.md      # 3-perspective cross-verification
    ├── fullcycle-reference.md   # 4-phase continuous auto-execution
    ├── micro-reference.md       # Lightweight execution (<=10 nodes)
    ├── delegate-reference.md    # AI-to-AI task delegation
    ├── review-reference.md      # Iterative review & improvement
    ├── evolve-reference.md      # Self-evolution cycle
    ├── create-reference.md      # Autonomous creation cycle
    ├── analyze-reference.md     # Reverse engineering (code → DESIGN)
    ├── design-review-reference.md # 3-perspective design validation
    ├── session-learning-reference.md # Cross-session learning
    ├── protocol-reference.md    # Future extensions (MCP, A2A)
    ├── pgf-format.md            # File format specification
    ├── pgf-checklist.md         # Quality checklist
    ├── discovery/               # A3IE discovery pipeline
    │   ├── discovery-reference.md
    │   ├── personas.json
    │   └── archive-discovery.ps1
    ├── loop/                    # Auto-execution loop engine
    │   ├── loop-reference.md
    │   └── *.ps1                # PowerShell automation scripts
    ├── agents/                  # 8 discovery personas
    │   └── pgf-persona-p[1-8].md
    └── examples/                # Usage examples
        ├── api-service.md
        └── content-gen-system.md
```

## Usage with Claude Code

PGF is designed as a Claude Code skill. Install the `pg/` and `pgf/` directories as skills, then invoke via:

```
/pgf design MyProject      # Design a system
/pgf plan MyProject        # Generate execution plan
/pgf execute MyProject     # Execute the plan
/pgf full-cycle MyProject  # Design → Plan → Execute → Verify
/pgf discover "topic"      # 8-persona idea discovery
/pgf create "topic"        # Full autonomous creation cycle
```

## License

MIT License - see [LICENSE](LICENSE) for details.
