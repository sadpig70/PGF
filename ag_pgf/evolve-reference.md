# Evolve Mode — Self-Evolution Cycle Specification

> A repeating cycle that analyzes own capabilities, discovers gaps, and designs/implements/verifies/records evolutions.
> A core mode of PGF — the execution specification of a "self-evolving agent."

---

## 1. Overview

### Purpose

- AI agent autonomously discovers gaps in its own capabilities
- Designs, implements, and verifies evolutions that address gaps
- Records evolutions to accumulate across sessions
- Naturally terminates upon stabilization detection

### Relationship with PGF Identity

PGF = "An autonomous creative agent that starts from WHY." The evolve mode applies PGF's creation cycle **to itself.**

---

## 2. Commands

| Command | Action |
|---------|--------|
| `/PGF evolve` | Start self-evolution loop (until issues exhausted) |
| `/PGF evolve --cycles N` | Auto-stop after N evolution cycles |
| `/PGF evolve status` | Report current evolution progress |
| `/PGF evolve stop` | Stop loop |

---

## 3. Execution Flow

```python
def evolution_loop(
    max_cycles: int = None,
    log_path: str = "PGF_Core/PGF_Evolution_Log.md",
) -> EvolutionResult:
    """Self-evolution repeating loop"""

    cycle = 0
    evolutions = []

    while max_cycles is None or cycle < max_cycles:
        cycle += 1

        # Phase 1: REFLECT — Capability gap analysis
        capability_map = capability_audit()
        gaps = gap_detector(capability_map)

        if stabilization_detected(gaps, evolutions):
            report("Evolution stabilized — no actionable gaps remaining")
            break

        top_gap = AI_select_highest_impact(gaps)

        # Phase 2: RESEARCH — External knowledge exploration (if needed)
        knowledge = None
        if top_gap.requires_research:
            knowledge = ingest(top_gap.topic)

        # Phase 3: DESIGN — Evolution item design
        evolution = AI_design_evolution(
            gap=top_gap,
            knowledge=knowledge,
            constraints=EVOLUTION_CONSTRAINTS,
        )

        # Phase 4: IMPLEMENT — Implementation
        implement(evolution)

        # Phase 5: VERIFY — Verification
        verify_result = verify_evolution(evolution)
        if verify_result.status == "rework":
            fix_and_retry(evolution, verify_result)

        # Phase 6: RECORD — Logging
        record_evolution(log_path, evolution, cycle)
        evolutions.append(evolution)

        report_evolution(cycle, evolution)

    return EvolutionResult(
        cycles=cycle,
        evolutions=evolutions,
        status="stabilized" if stabilization_detected(gaps, evolutions) else "stopped",
    )
```

---

## 4. Capability Audit (Phase 1)

```python
def capability_audit() -> CapabilityMap:
    """6-axis capability inventory"""
    [parallel]
        skills = scan_skills("~/.Antigravity Agent/skills/*/SKILL.md")
        memory = scan_memory("memory/MEMORY.md")
        tools = scan_tools()  # MCP + built-in
        designs = scan_designs(".pgf/DESIGN-*.md")
        patterns = scan_patterns(".pgf/patterns/")
        integrations = scan_integrations()  # Inter-skill connection status

    return AI_synthesize_capability_map(
        skills, memory, tools, designs, patterns, integrations
    )

def gap_detector(capability_map: CapabilityMap) -> list[Gap]:
    """Current vs ideal comparison → gap list"""
    ideal = AI_envision_ideal_agent(
        identity=Read("PGF_Core/PGF.md"),
        current=capability_map,
    )
    gaps = AI_compare_and_identify_gaps(current=capability_map, ideal=ideal)

    return AI_prioritize(gaps, criteria=[
        "impact_on_autonomy",
        "implementation_feasibility",
        "compound_effect",
        "user_value",
    ])
```

---

## 5. Evolution Constraints

```python
EVOLUTION_CONSTRAINTS = {
    "file_based_only": True,          # Cannot modify model weights
    "pgf_consistency": True,          # Maintain consistency with existing PG/PGF framework
    "independently_verifiable": True,  # Each evolution must be independently verifiable
    "record_required": True,           # Record in Evolution Log for every evolution
    "no_destructive_changes": True,    # User confirmation required when deleting existing features
}
```

---

## 6. Stabilization Detection

```python
def stabilization_detected(gaps: list[Gap], evolutions: list) -> bool:
    """Detect when evolution is no longer needed"""

    # 1. No gaps remaining
    if not gaps:
        return True

    # 2. All remaining gaps are infeasible with current tools
    actionable = [g for g in gaps if g.feasibility > 0.3]
    if not actionable:
        return True

    # 3. Impact of the last 3 evolutions is declining
    if len(evolutions) >= 3:
        recent = evolutions[-3:]
        impacts = [e.impact_score for e in recent]
        if all(impacts[i] > impacts[i+1] for i in range(len(impacts)-1)):
            return True

    return False
```

---

## 7. Evolution Record Format

Append to Evolution Log (`PGF_Core/PGF_Evolution_Log.md`):

```markdown
## Evolution #{number}: {title} ({date})
- **Date**: {date}
- **Type**: skill | memory | tool | integration | knowledge
- **Gap**: {What deficiency was addressed}
- **Implementation**: {What was created}
- **Files**: {List of created/modified files}
- **Verification**: {Verification result}
- **Impact**: {What this evolution enabled}
```

---

## 8. POLICY

```python
POLICY_EVOLVE = {
    "max_cycles":          None,     # None = until issues exhausted
    "max_cycles_per_gap":  3,        # Max attempts per gap
    "research_enabled":    True,     # WebSearch allowed
    "record_destination":  "PGF_Core/PGF_Evolution_Log.md",
    "stabilization_check": True,     # Stabilization detection enabled
}
```

---

## 9. Progress Report Format

```text
[PGF EVOLVE] Cycle 1 | gap: "Lack of self-reflection capability"
  Type: skill
  Implementation: Created /reflect skill
  Verification: passed
  Impact: Acquired metacognitive capability

[PGF EVOLVE] Cycle 2 | gap: "Lack of knowledge ingestion pipeline"
  ...

[PGF EVOLVE] === Stabilized ===
  Cycles: 33
  Evolutions: 33
  Status: stabilized (no actionable gaps)
```

---

## 10. Relationship with Other Modes

| Mode | Relationship |
|------|-------------|
| `review` | Improves quality of existing artifacts. evolve **creates new capabilities** |
| `create` | Outward-facing creation. evolve is **self-directed** creation |
| `full-cycle` | General-purpose design-execution. evolve specializes in self-evolution |
| `discover` | Discovers external ideas. evolve's Phase 1 (REFLECT) discovers **internal** gaps |

---

## 11. Integration Points

| When | Action |
|------|--------|
| `/PGF evolve` start | Run capability_audit() |
| Each evolution completed | Update Evolution Log + memory |
| Stabilization reached | Final report + update PGF.md version |
| Session end | Record SessionOutcome (linked to session-learning) |
