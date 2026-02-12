#!/bin/bash
# Cadence AI Development System - Session Start Hook
# Injects usage guide into session context

GUIDE="# Cadence AI Development System v1.3.0

You have the Cadence AI development plugin installed. Here is how to use it:

## Available Commands

| Command | Description |
|---------|-------------|
| \`/cadence\` | Start full end-to-end workflow (PRD to Requirements to Design to Code to Test) |
| \`/init\` | Initialize Cadence project configuration |
| \`/requirement\` | Analyze PRD and generate requirement document only |
| \`/design\` | Generate technical design from requirements only |
| \`/code\` | Generate code from design document only |
| \`/test\` | Generate test cases and automation scripts only |

## Quick Start

1. **Full workflow**: \`/cadence\` then provide your PRD document path
2. **Single stage**: Use individual commands like \`/requirement\`, \`/design\`, \`/code\`, \`/test\`
3. **Project setup**: \`/init\` to configure a new or existing project for Cadence

## Key Features

- Hybrid architecture: Subagents for heavy analysis, Skills for interactive tasks
- State persistence via Serena Memory for cross-session resume
- Human-in-the-loop confirmation at key decision points
- Supports both new feature development and existing code modification"

# Output in hookSpecificOutput JSON format
printf '{"hookSpecificOutput": %s}\n' "$(echo "$GUIDE" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')"
