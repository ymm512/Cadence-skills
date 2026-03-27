---
name: skill-creator
description: Use this skill whenever the user asks to create, modify, validate, package, or optimize Claude Code skills in this repository or marketplace. Always use it for requests about SKILL.md authoring, skill scaffold generation, trigger evals, or .skill packaging.
---

# Skill Creator

## Overview

Create and maintain Claude Code skills that can be installed through the Cadence marketplace and used directly in Claude Code.

## When To Use

Use this skill when the user asks to:
- create a new skill
- edit an existing skill
- validate skill frontmatter or structure
- package a skill into `.skill`
- evaluate or optimize skill description trigger behavior

## Repository Contract

- Skill directories live in `skills/<skill-name>/`
- Every skill must contain `SKILL.md`
- `name` in frontmatter must equal directory name
- Optional directories: `scripts/`, `references/`, `assets/`
- For Claude Code GLOBAL usage, prefer `~/.claude/skills/<skill-name>/SKILL.md`

## Execution Workflow

0. One-shot workflow (recommended in most cases):
```bash
python scripts/skill_creator/skill_create_workflow.py --skill-name <skill-name> --package --optimize --apply
```

0b. One-shot workflow for Claude Code GLOBAL skill (preferred for direct usage):
```bash
python scripts/skill_creator/skill_create_workflow.py --skill-name <skill-name> --target global
```

1. Scaffold a new skill:
```bash
python scripts/skill_creator/init_skill.py <skill-name>
```

2. Validate structure:
```bash
python scripts/skill_creator/quick_validate.py skills/<skill-name>
```

3. Package distributable file:
```bash
python scripts/skill_creator/package_skill.py skills/<skill-name> dist
```

4. Evaluate current description trigger quality:
```bash
python scripts/skill_creator/run_eval.py --eval-set <eval-set.json> --skill-path skills/<skill-name>
```

5. Optimize description in loop:
```bash
python scripts/skill_creator/run_loop.py --eval-set <eval-set.json> --skill-path skills/<skill-name> --max-iterations 5 --apply
```

6. One-shot optimization (recommended):
```bash
python scripts/skill_creator/optimize_description.py --eval-set <eval-set.json> --skill-path skills/<skill-name> --max-iterations 5 --apply
```

## Output Requirements

When completing a skill task, always report:
- target skill path
- validation result
- package path (if generated)
- eval/optimization output path (if generated)
