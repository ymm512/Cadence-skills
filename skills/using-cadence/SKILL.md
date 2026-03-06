---
name: using-cadence
description: Use when starting any Cadence-related conversation - establishes how to find and use Cadence skills, requiring Skill tool invocation before ANY response including clarifying questions
---

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a Cadence skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## How to Access Cadence Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In other environments:** Check your platform's documentation for how skills are loaded.

# Using Cadence Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Cadence Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, analyze, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (design, plan, development) - these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

## Core Cadence Skills

**Understanding Phase (P1):**
- cadence-brainstorm - Requirements exploration
- cadence-analyze - Existing code analysis
- cadence-requirement - Requirements analysis

**Planning Phase (P2):**
- cadence-design - Technical design
- cadence-design-review - Design review
- cadence-plan - Implementation planning

**Execution Phase (P3):**
- cadence-using-git-worktrees - Environment isolation
- cadence-subagent-development - Code implementation
- cadence:verification-before-completion - Completion verification

**Project Initialization:**
- cadence:cadencing - Initialize project as Cadence-managed

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.

## Quick Reference

**Cadence Flow Modes:**

| Flow Mode | Command | Nodes | Use Case | Time |
|-----------|---------|-------|----------|------|
| Full Flow | `/cadence:full-flow` | 8 | Enterprise projects | 1-2 days |
| Quick Flow | `/cadence:quick-flow` | 4 | Fast development | 1-2 hours |
| Exploration Flow | `/cadence:exploration-flow` | 4 | Technical exploration | 2-4 hours |

**Single Node Commands:**
- `/cadence:brainstorm` - Requirements exploration
- `/cadence:analyze` - Existing code analysis
- `/cadence:requirement` - Requirements analysis
- `/cadence:design` - Technical design
- `/cadence:design-review` - Design review
- `/cadence:plan` - Implementation planning
- `/cadence:using-git-worktrees` - Environment isolation
- `/cadence:subagent-development` - Code implementation

**Progress Management:**
- `/cadence:status` - View current progress
- `/cadence:resume` - Resume progress
- `/cadence:checkpoint` - Create checkpoint
- `/cadence:report` - Generate report
