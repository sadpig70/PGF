# PGF PPR Extensions Reference

> **Basic PPR syntax** (AI_, AI_make_, →, [parallel], data types, flow control) is defined in the **PG skill**.
> **Convergence Loop**, **Failure Strategy**, and **acceptance_criteria concepts** also belong to PG.
> This document covers only the **framework-specific extensions** that PGF adds on top of PG.

## Epigenetic PPR (v2.4)

Context-adaptive PPR execution. When PGF Loop executes a node, `extract-ppr.ps1` automatically extracts the node's PPR from DESIGN and injects it into the execution prompt. This enables each node to carry its own "genetic code" — the PPR def block — which is expressed differently depending on the execution context (available tools, prior node outputs, current session patterns).

- **Mechanism**: `extract-ppr.ps1` reads DESIGN-{Name}.md → finds the PPR def for the current node → injects into the Stop Hook prompt
- **Adaptation**: The same PPR can produce different execution results across sessions because AI adapts to context (session patterns, available tools, prior outputs)
- **Naming**: "Epigenetic" because the PPR (gene) is fixed, but its expression varies by environment — analogous to biological epigenetics

---

## 1. Function Definition — Detailed PPR Implementation Format

Describes the detailed implementation of Gantree nodes using Python function definition syntax.

```python
def content_planner(
    topic: str,
    audience: Literal["general", "technical", "executive"],
    constraints: Optional[dict] = None,
) -> dict:
    """Content planning — generate outline matching topic and audience"""

    context = load_domain_knowledge(topic)
    audience_profile = AI_analyze_audience(audience)

    raw_outline: list[dict] = AI_generate_outline(
        topic=topic, context=context, audience=audience_profile,
    )

    if constraints:
        raw_outline = AI_adjust_outline(raw_outline, constraints)

    for section in raw_outline:
        section["priority"] = AI_assess_priority(section, audience)

    outline = sorted(raw_outline, key=lambda s: s["priority"], reverse=True)

    metadata = {
        "estimated_length": calculate_estimated_length(outline),
        "complexity": AI_assess_complexity(outline),
    }

    return {"outline": outline, "metadata": metadata}
```

---

## 2. acceptance_criteria Writing Guide

> The conceptual definition of acceptance_criteria (3 types: functional / qualitative / structural) is in the PG skill reference.
> This section provides additional **writing principles** for PGF execution.

```python
def some_task(input: InputType) -> OutputType:
    """Task description"""
    # acceptance_criteria:
    #   - Output must include all fields from InputType
    #   - Quality score >= 0.85
    #   - Response time < 5 seconds

    result = AI_execute(input)
    assert AI_verify_completeness(result, input), "Missing fields"
    assert AI_assess_quality(result) >= 0.85, "Quality below threshold"
    return result
```

### Writing Principles

1. **Measurable**: "Good quality" ✗ → "AI_assess_quality >= 0.85" ✓
2. **Verifiable**: Criteria that AI can independently evaluate
3. **Specific**: Eliminate vague expressions; specify with numbers/conditions
