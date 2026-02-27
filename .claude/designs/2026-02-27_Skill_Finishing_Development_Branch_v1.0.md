# cadence-finishing-a-development-branch

> **创建日期**: 2026-02-27
> **版本**: v1.0
> **参考**: superpowers/skills/finishing-a-development-branch/SKILL.md
> **关联主文档**: [技术方案 v2.4](./2026-02-25_技术方案_使用Claude_Code_Skills的AI自动化开发方案_v2.4.md)

---

```yaml
---
name: cadence-finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
---
```

---

## 概述

指导完成开发工作，提供清晰的选项并处理选定的工作流程。

**核心原则**: 验证测试 → 展示选项 → 执行选择 → 清理环境

**开始时宣布**: "我将使用 cadence-finishing-a-development-branch Skill 来完成这项工作"

---

## 使用时机

**强制使用**:
- Subagent Development 完成所有任务后
- 所有测试通过后准备合并时
- 需要决定如何集成工作时

**可选使用**:
- 个人项目准备合并时
- 原型开发完成后

---

## 流程步骤

### 第1步：验证测试

**在展示选项前，必须验证测试通过**:

```bash
# 运行项目的测试套件
npm test / cargo test / pytest / go test ./...
```

**如果测试失败**:
```
测试失败（<N> 个失败）。必须在完成前修复：

[展示失败详情]

在测试通过前无法继续合并/PR
```

停止。不要进入第2步。

**如果测试通过**: 继续第2步。

### 第2步：确定基础分支

```bash
# 尝试常见的基础分支
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

或者询问: "此分支从 main 分出 - 是否正确？"

### 第3步：展示选项

展示恰好这4个选项:

```
实现完成。您希望如何处理？

1. 本地合并回 <base-branch>
2. 推送并创建 Pull Request
3. 保持分支原样（稍后我自己处理）
4. 丢弃此工作

选择哪个选项？
```

**不要添加解释** - 保持选项简洁。

### 第4步：执行选择

#### 选项1：本地合并

```bash
# 切换到基础分支
git checkout <base-branch>

# 拉取最新代码
git pull

# 合并特性分支
git merge <feature-branch>

# 在合并结果上验证测试
<test command>

# 如果测试通过
git branch -d <feature-branch>
```

然后: 清理 worktree（第5步）

#### 选项2：推送并创建 PR

```bash
# 推送分支
git push -u origin <feature-branch>

# 创建 PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

然后: 清理 worktree（第5步）

#### 选项3：保持原样

报告: "保留分支 <name>。Worktree 保存在 <path>。"

**不要清理 worktree。**

#### 选项4：丢弃

**先确认**:
```
这将永久删除：
- 分支 <name>
- 所有提交: <commit-list>
- Worktree 在 <path>

输入 'discard' 确认。
```

等待精确确认。

如果确认:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

然后: 清理 worktree（第5步）

### 第5步：清理 Worktree

**对于选项1、2、4**:

检查是否在 worktree 中:
```bash
git worktree list | grep $(git branch --show-current)
```

如果是:
```bash
git worktree remove <worktree-path>
```

**对于选项3**: 保留 worktree。

---

## 快速参考表

| 选项 | 合并 | 推送 | 保留Worktree | 清理分支 |
|------|------|------|--------------|----------|
| 1. 本地合并 | ✓ | - | - | ✓ |
| 2. 创建 PR | - | ✓ | ✓ | - |
| 3. 保持原样 | - | - | ✓ | - |
| 4. 丢弃 | - | - | - | ✓ (force) |

---

## 常见错误

### 跳过测试验证
- **问题**: 合并破损代码，创建失败的 PR
- **修复**: 必须在展示选项前验证测试

### 开放式问题
- **问题**: "接下来该做什么？" → 模糊
- **修复**: 展示恰好4个结构化选项

### 自动清理 worktree
- **问题**: 在可能需要时移除 worktree（选项2、3）
- **修复**: 只对选项1和4清理

### 丢弃时无确认
- **问题**: 意外删除工作
- **修复**: 要求输入 "discard" 确认

---

## Red Flags

**永不**:
- 在测试失败时继续
- 合并前不验证合并结果的测试
- 无确认删除工作
- 无明确请求强制推送

**始终**:
- 在展示选项前验证测试
- 展示恰好4个选项
- 对选项4要求输入确认
- 只对选项1和4清理 worktree

---

## 集成关系

**被调用者**:
- **cadence-subagent-development** (第7步) - 所有任务完成后
- **cadence-executing-plans** (第5步) - 所有批次完成后

**配对者**:
- **cadence-using-git-worktrees** - 清理由该 Skill 创建的 worktree

---

## 示例工作流

```
用户: 我已经完成了功能实现，所有测试都通过了

AI: 我将使用 cadence-finishing-a-development-branch Skill 来完成这项工作。

[验证测试 - 47/47 通过]
[确定基础分支 - main]

实现完成。您希望如何处理？

1. 本地合并回 main
2. 推送并创建 Pull Request
3. 保持分支原样（稍后我自己处理）
4. 丢弃此工作

用户: 2

[推送分支到 origin]
[使用 gh CLI 创建 PR]
[清理 worktree]

✅ PR #123 已创建: https://github.com/owner/repo/pull/123
✅ Worktree 已清理
```

---

## 多语言支持

自动检测项目类型并使用对应的测试命令:

| 语言 | 测试命令 |
|------|---------|
| Node.js | `npm test` |
| Rust | `cargo test` |
| Python | `pytest` |
| Go | `go test ./...` |

---

## 注意事项

1. **测试优先**: 测试失败时永远不继续
2. **精确4选项**: 不要添加、删除或修改选项
3. **确认丢弃**: 必须输入 "discard" 确认删除
4. **Worktree清理**: 只在选项1和4时清理
5. **PR模板**: 使用标准模板（Summary + Test Plan）

---

## 相关文档

- [主方案文档](./2026-02-25_技术方案_使用Claude_Code_Skills的AI自动化开发方案_v2.4.md)
- [Git Worktrees Skill](./2026-02-26_Skill_Git_Worktrees_v1.0.md)
- [Subagent Development Skill](./2026-02-26_Skill_Subagent_Development_v1.0.md)
- [Verification Skill](./2026-02-26_Skill_Verification_Before_Completion_v1.0.md)
