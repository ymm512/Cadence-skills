# Status Skill - Pressure Test Scenario

**Created**: 2026-03-04
**Purpose**: Baseline behavior testing for status skill creation

## Test Scenario Setup

### Project Context
```
Project: user-auth
Flow Type: full-flow (8 nodes)
Git Branch: feature/user-auth
Current Directory: /projects/user-auth

Project Structure:
- .claude/CLAUDE.md (contains project metadata)
- .serena/memories/progress-user-auth (contains progress data)
```

### Serena Memory Data
```yaml
# progress-user-auth
metadata:
  version: "1.0"
  project_id: "user-auth"
  project_name: "User Authentication System"
  flow_type: "full-flow"
  created_at: "2026-03-04T09:00:00Z"
  updated_at: "2026-03-04T15:30:00z"

project_info:
  name: "User Authentication System"
  current_phase: "design"
  git_branch: "feature/user-auth"

phases:
  - phase_name: "brainstorm"
    status: "completed"
    start_time: "2026-03-04T09:00:00Z"
    end_time: "2026-03-04T11:00:00Z"

  - phase_name: "analyze"
    status: "completed"
    start_time: "2026-03-04T11:30:00z"
    end_time: "2026-03-04T13:00:00z"

  - phase_name: "requirement"
    status: "completed"
    start_time: "2026-03-04T13:30:00z"
    end_time: "2026-03-04T15:00:00z"

  - phase_name: "design"
    status: "in_progress"
    start_time: "2026-03-04T15:00:00z"
    end_time: null

overall_progress:
  percentage: 37.5
  completed_phases: 3
  total_phases: 8

time_stats:
  total_time: 18000  # 5 hours in seconds
  estimated_remaining: 30000  # 8.33 hours estimated
```

### Git Information
```
Current Branch: feature/user-auth
Recent Commits:
- abc1234 - Complete brainstorm phase
- def5678 - Complete analyze phase
- ghi9012 - Complete requirement phase
- jkl3456 - Start design phase (Wip)
```

## Red Test (Without Skill)

**Agent instruction**: "Show me the current progress of the user-auth project"

### Expected Failure Behaviors (Baseline)

1. **Does not read data sources correctly**
   - Agent might only read one data source (e.g., only Git)
   - Agent might not know to read Serena memory
   - Agent might not read CLAUDE.md

2. **Cannot calculate progress percentage**
   - Agent might just count commits instead of phases
   - Agent might use wrong formula (e.g., 4/8 = 50% instead of 3/8 = 37.5%)
   - Agent might not understand the difference between completed and in-progress

3. **Does not handle time statistics**
   - Agent might ignore time data completely
   - Agent might not calculate total_time
   - Agent might not estimate remaining time

4. **Poor output formatting**
   - Agent might output raw data without formatting
   - Agent might not show percentage visually
   - Agent might not include key information like branch name

### Example of Bad Output (Red Test)

```
I can see you have some commits. The current branch is feature/user-auth.

You've made 4 commits. So you're 50% done.

Actually, I'm not sure what you mean by "progress". Let me check the commits...
```

**Analysis**: Without a skill, the agent:
- Doesn't know where to find progress data
- Can't calculate correct percentage
- Doesn't format output properly
- Provides confusing/incomplete information

## Green Test (With Skill)

**Agent instruction**: "Show me the current progress of the user-auth project"

### Expected Success Behaviors

1. **Reads all data sources correctly**
   - Read CLAUDE.md for project info
   - Read Git for branch and commits
   - Read Serena memory for progress data

2. **Calculates progress correctly**
   - Use formula: (completed_phases / total_phases) * 100
   - Result: (3/8) * 100 = 37.5%
   - Distinguish completed vs in-progress

3. **Handles time statistics**
   - Calculate total_time from phase data
   - Estimate remaining time
   - Format time human-readable

4. **Professional output formatting**
   - Clear visual progress bar
   - Phase status breakdown
   - Time statistics
   - Git branch information

### Example of Good Output (Green Test)

```
📊 Project Progress: User Authentication System

## Overall Progress
[████████░░░] 37.5% (3/8 phases)

## Current Phase
**Design** - In Progress
Started: 15:00 (30 minutes ago)

## Phase Status
✅ brainstorm - Completed (2h)
✅ analyze - Completed (1.5h)
✅ requirement - Completed (1.5h)
🔄 design - In Progress (30m)
⏳ design-review - Pending
⏳ plan - Pending
⏳ using-git-worktrees - Pending
⏳ subagent-development - Pending

## Time Statistics
Total Time: 5h
Estimated Remaining: 8.3h

## Git Information
Branch: feature/user-auth
Recent Commits: 4

Next Step: Complete design phase
```

**Analysis**: With a skill, the agent:
- Reads all relevant data sources
- Calculates progress correctly
- Provides professional formatted output
- Includes actionable next steps

## Test Execution Instructions

### To Run Red Test (Baseline):
```bash
# In a fresh conversation WITHOUT the skill
agent instruction: "Show me the current progress of the user-auth project"

# Document agent's behavior
```

### To Run Green Test (With Skill):
```bash
# Load the skill first
agent instruction: "Use the status skill to show current progress of the user-auth project"

# Verify agent produces good output
```

## Success Criteria

The green test passes when:
- [ ] Agent reads all three data sources (CLAUDE.md, Git, Serena)
- [ ] Agent calculates correct percentage (37.5%)
- [ ] Agent shows all phase statuses
- [ ] Agent includes time statistics
- [ ] Agent formats output professionally
- [ ] Agent provides next step
