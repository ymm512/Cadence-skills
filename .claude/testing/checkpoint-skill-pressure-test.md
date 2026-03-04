# Checkpoint Skill - Pressure Test Scenario

**Created**: 2026-03-04
**Purpose**: Baseline behavior testing for checkpoint skill creation

## Test Scenario Setup

### Project Context
```
Project: user-auth
Flow Type: full-flow (8 nodes)
Current Phase: design (in progress)
Git Branch: feature/user-auth
Working Directory: /projects/user-auth

Current State:
- Brainstorm: Completed
- Analyze: Completed
- Requirement: Completed
- Design: In Progress (30 minutes in)
```

### TodoWrite State
```json
[
  {
    "id": "1",
    "subject": "Design authentication flow",
    "description": "Create sequence diagram for user login/logout flow",
    "status": "completed",
    "activeForm": "Designing authentication flow"
  },
  {
    "id": "2",
    "subject": "Design password hashing strategy",
    "description": "Decide on bcrypt vs argon2, salt rounds, cost factor",
    "status": "in_progress",
    "activeForm": "Designing password hashing strategy"
  }
]
```

### Git Commits
```
Current Branch: feature/user-auth

Recent Commits (4):
- abc1234 - Complete brainstorm: user authentication requirements
- def5678 - Complete analyze: existing code patterns
- ghi9012 - Complete requirement: auth specifications
- jkl3456 - Start design: authentication architecture (HEAD)
```

### Expected Checkpoint Data Structure
```yaml
metadata:
  version: "1.0"
  checkpoint_id: "550e8400-e29b-41d4-a716-446655440000"  # UUID v4
  project_id: "user-auth"

phase: "design"
task_id: "2"
status: "in_progress"
timestamp: "2026-03-04T15:30:00Z"

context:
  git_branch: "feature/user-auth"
  git_commits:
    - "abc1234"
    - "def5678"
    - "ghi9012"
    - "jkl3456"
  todowrite_state:
    - id: "1"
      subject: "Design authentication flow"
      status: "completed"
    - id: "2"
      subject: "Design password hashing strategy"
      status: "in_progress"
  project_context:
    project_name: "User Authentication System"
    flow_type: "full-flow"
    current_phase: "design"

output: ".claude/designs/2026-03-04_设计方案_认证流程_v1.0.md"

ttl: 2592000  # 30 days
created_at: "2026-03-04T15:30:00Z"
expires_at: "2026-04-03T15:30:00Z"
```

## Red Test (Without Skill)

**Agent instruction**: "Create a checkpoint for the current design phase"

### Expected Failure Behaviors (Baseline)

1. **Cannot generate unique ID**
   - Agent might use timestamp (not unique)
   - Agent might use simple counter (not unique)
   - Agent might not generate ID at all

2. **Incomplete context collection**
   - Agent might only save Git commits
   - Agent might miss TodoWrite state
   - Agent might not include project context

3. **Incorrect storage location**
   - Agent might save to wrong memory name
   - Agent might not use project ID in name
   - Agent might use wrong format

4. **Does not update progress**
   - Agent might save checkpoint but not update progress record
   - Agent might not update indices
   - Agent might not link checkpoint to project

### Example of Bad Output (Red Test)

```
I'll create a checkpoint. Let me save some data...

[Creates memory: checkpoint-design-1709555800]
The data includes some commits.

Done! Checkpoint created.
```

**Analysis**: Without a skill, the agent:
- Uses timestamp (not unique, can collide)
- Only saves commits (incomplete context)
- Wrong memory name format (missing project ID)
- Doesn't update progress record
- Doesn't create index entries

## Green Test (With Skill)

**Agent instruction**: "Create a checkpoint for the current design phase"

### Expected Success Behaviors

1. **Generates UUID**
   - Uses UUID v4 format
   - Guarantees global uniqueness
   - Includes in checkpoint_id field

2. **Collects complete context**
   - Git branch and commits
   - TodoWrite state (all tasks)
   - Project context from CLAUDE.md
   - Current phase information

3. **Correct storage location**
   - Memory name: `checkpoint-{project_id}-{phase}-{uuid}`
   - Example: `checkpoint-user-auth-design-550e8400-e29b-41d4-a716-446655440000`
   - Follows naming convention

4. **Updates progress record**
   - Reads progress-user-auth
   - Updates current phase info
   - Updates overall progress percentage
   - Updates timestamp

5. **Updates indices**
   - Updates time index
   - Updates phase index
   - Updates project index

### Example of Good Output (Green Test)

```
✅ Creating checkpoint for design phase...

**Step 1: Collecting context**
- Reading Git information...
  Branch: feature/user-auth
  Commits: 4 recent commits
- Reading TodoWrite state...
  Tasks: 2 (1 completed, 1 in progress)
- Reading project context...
  Project: User Authentication System
  Flow: full-flow

**Step 2: Generating checkpoint ID**
- UUID: 550e8400-e29b-41d4-a716-446655440000

**Step 3: Saving checkpoint**
- Memory name: checkpoint-user-auth-design-550e8400-e29b-41d4-a716-446655440000
- Saving to Serena memory...

**Step 4: Updating progress record**
- Reading progress-user-auth...
- Updating phase status...
- Updating timestamp...

**Step 5: Updating indices**
- Updating time index: 2026-03-04
- Updating phase index: design
- Updating project index: user-auth

✅ Checkpoint created successfully!

Checkpoint ID: 550e8400-e29b-41d4-a716-446655440000
Location: checkpoint-user-auth-design-550e8400-e29b-41d4-a716-446655440000
```

**Analysis**: With a skill, the agent:
- Generates unique UUID
- Collects complete context
- Uses correct naming convention
- Updates all related records
- Updates indices for fast querying

## Test Execution Instructions

### To Run Red Test (Baseline):
```bash
# In a fresh conversation without the skill
agent instruction: "Create a checkpoint for the current design phase"

# Document agent's behavior verbatim
```

### To Run Green Test (With Skill):
```bash
# Load the skill first
agent instruction: "Use the checkpoint skill to create a checkpoint for the design phase"

# Verify agent produces good output
```

## Success Criteria

The green test passes when:
- [ ] Agent generates UUID v4 (not timestamp)
- [ ] Agent collects Git branch + commits
- [ ] Agent collects TodoWrite state
- [ ] Agent collects project context
- [ ] Memory name follows: checkpoint-{project_id}-{phase}-{uuid}
- [ ] Agent updates progress record
- [ ] Agent updates time index
- [ ] Agent updates phase index
- [ ] Agent updates project index
- [ ] Output shows checkpoint ID and location
