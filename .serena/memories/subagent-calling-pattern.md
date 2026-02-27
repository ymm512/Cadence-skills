# Claude Code Subagent调用模式

## 核心发现

Claude Code的Subagent不是通过静态配置文件（agents.json）调用的，而是使用Task tool动态调用。

## 正确的调用方式

### 方式1: 内联Prompt（推荐）

```markdown
Task tool (general-purpose):
  description: "Implement {task_name}"
  prompt: |
    You are implementing: **{task_name}**

    ## Task Description
    {完整任务描述}

    ## Context
    - **Project**: {project_name}
    - **Feature Branch**: {feature_branch}
    - **Work Directory**: {worktree_path}

    ## Acceptance Criteria
    {验收标准列表}

    ## TDD Workflow (MUST FOLLOW)
    [详细流程]

    ## Output Format
    [输出格式要求]
```

### 方式2: 外部Prompt文件引用（可选）

```markdown
Task tool (general-purpose):
  description: "Implement {task_name}"
  prompt: |
    {include: prompts/implementer.md}
```

## 错误的方式

❌ **不要使用静态配置**:
```json
// agents.json - 不要这样做
{
  "agents": [
    {
      "name": "implementer",
      "type": "general-purpose",
      "config": {...}
    }
  ]
}
```

## 三阶段Subagent调用流程

### 阶段1: Implementer Subagent

**职责**: 实现代码
**TDD流程**: RED → GREEN → BLUE
**输出**: 业务代码 + 单元测试

### 阶段2: Spec Reviewer Subagent

**职责**: 规格审查
**验证**: 实现是否符合需求（不多不少）
**原则**: 不信任Implementer的报告，必须实际读代码

### 阶段3: Code Quality Reviewer Subagent

**职责**: 代码质量审查
**维度**: 
- Code style & formatting
- Security vulnerabilities
- Performance issues
- Test coverage
- Best practices

## Git SHA范围

Code Quality Reviewer需要Git SHA范围：

```bash
BASE_SHA=$(git log --oneline | grep "Task N-1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)
```

**审查范围**: 只审查 `git diff {base_sha}..{head_sha}` 的变更

## 最佳实践

1. ✅ 使用Task tool动态调用
2. ✅ 传递完整的内联prompt
3. ✅ 包含上下文（项目、分支、工作目录）
4. ✅ 包含验收标准
5. ✅ 包含输出格式要求
6. ❌ 不使用静态配置文件
7. ❌ 不预定义Subagent配置

## 参考资源

- superpowers项目: https://github.com/anthropics/superpowers
- 本项目Subagent定义: `.claude/designs/8.1_implementer.md`
- Subagent Development Skill: `.claude/designs/2026-02-26_Skill_Subagent_Development_v1.0.md`

## 应用场景

- cadence-subagent-development Skill
- 任何需要独立AI Agent执行任务的场景
- 并发任务执行（最多49个并发）
- 需要独立上下文的任务
