# Resume - 恢复进度

## 使用场景

在会话中断后恢复项目进度,重建上下文并继续工作。

## 功能描述

恢复项目进度,包括:
- 检测中断场景（正常中断、异常中断、任务失败等）
- 扫描可用记忆（Session Summary、Checkpoint、失败日志）
- 确定恢复点
- 重建上下文（Git状态、TodoWrite、项目上下文、会话上下文）
- 继续执行未完成的任务

## 数据来源

此命令从以下来源读取数据

### Serena Memory

```markdown
# 扫描进度记录
mcp__serena__list_memories(topic: "progress")

# 返回示例
[
  "progress-user-auth",
  "progress-api-refactor",
  "progress-web-redesign"
]

# 读取进度数据
mcp__serena__read_memory(memory_name: "progress-user-auth")
```

### Checkpoint 记录

```markdown
# 列出项目的checkpoints
mcp__serena__list_memories(topic: "checkpoint-user-auth")

# 读取最新checkpoint
mcp__serena__read_memory(memory_name: "checkpoint-user-auth-design-550e...")
```

### Git 信息

```bash
# 获取当前分支
git branch --show-current

# 获取工作目录
pwd
```

## 执行逻辑

### 流程图

```mermaid
graph TD
    A[/resume] --> B[扫描未完成会话]
    B --> C{找到未完成会话?}
    C -->|No| D[显示:无可恢复会话]
    C -->|Yes| E[列出可恢复会话]
    E --> F{用户选择}
    F --> G[读取最新Checkpoint]
    G --> H[重建上下文]
    H --> I[显示恢复状态]
    I --> J[继续执行]
```

### 1. 扫描未完成会话

```python
def scan_incomplete_sessions():
    # 列出所有progress记忆
    memories = list_memories(topic="progress")

    incomplete = []
    for memory_name in memories:
        if memory_name.startswith("progress-"):
            progress = read_memory(memory_name)

            # 检查是否未完成
            percentage = progress["overall_progress"]["percentage"]
            if percentage < 100:
                incomplete.append({
                    "memory_name": memory_name,
                    "project_id": progress["metadata"]["project_id"],
                    "project_name": progress["project_info"]["name"],
                    "flow_type": progress["metadata"]["flow_type"],
                    "current_phase": progress["project_info"]["current_phase"],
                    "progress_percentage": percentage,
                    "updated_at": progress["metadata"]["updated_at"],
                    "git_branch": progress["project_info"]["git_branch"]
                })

    # 按更新时间排序（最近的优先）
    incomplete.sort(key=lambda x: x["updated_at"], reverse=True)

    return incomplete
```

### 2. 列出可恢复会话

```markdown
## 可恢复的会话

1. **User Authentication System** (full-flow)
   - 当前进度: 37.5% (3/8 节点)
   - 当前阶段: Design (进行中)
   - 最后更新: 2026-03-04 15:30:00
   - Git 分支: feature/user-auth

2. **API Refactor** (quick-flow)
   - 当前进度: 50% (2/4 节点)
   - 当前阶段: Plan (已完成)
   - 最后更新: 2026-03-03 17:00:00
   - Git 分支: refactor/api

选择要恢复的会话 [1-2]:
```

### 3. 用户选择

```python
# 等待用户输入
selection = input("选择要恢复的会话 [1-{}]: ".format(len(sessions)))

# 验证输入
if not selection.isdigit():
    print("请输入数字")
    return

idx = int(selection) - 1
if idx < 0 or idx >= len(sessions):
    print("无效的选择")
    return

selected = sessions[idx]
```

### 4. 读取最新Checkpoint

```python
def find_latest_checkpoint(project_id):
    # 列出项目的所有checkpoint
    memories = list_memories(topic=f"checkpoint-{project_id}")

    latest = None
    latest_time = None

    for memory_name in memories:
        checkpoint = read_memory(memory_name)
        timestamp = checkpoint["timestamp"]

        if latest_time is None or timestamp > latest_time:
            latest = checkpoint
            latest_time = timestamp

    return latest
```

### 5. 重建上下文

```python
def rebuild_context(checkpoint):
    # Git状态
    git_branch = checkpoint["context"]["git_branch"]
    run_command(f"git checkout {git_branch}")

    # TodoWrite状态
    tasks = checkpoint["context"]["todowrite_state"]
    for task in tasks:
        recreate_todowrite_task(task)

    # 项目上下文
    project = checkpoint["context"]["project_context"]
    load_project_context(project)
```

### 6. 显示恢复状态

```markdown
✅ 会话已恢复!

## 恢复信息
- **项目**: User Authentication System
- **流程**: full-flow
- **恢复点**: design (2026-03-04 15:00:00)
- **Git 分支**: feature/user-auth
- **下一步行动**: design

## 上下文状态
- ✅ Git 分支已切换
- ✅ TodoWrite 任务已恢复 (2 个任务)
- ✅ 项目上下文已加载

## 继续执行
准备继续 **design** 阶段...
```

## 工具使用

### MCP 工具

```markdown
# 列出progress记忆
mcp__serena__list_memories
  topic: "progress"

# 读取progress数据
mcp__serena__read_memory
  memory_name: "progress-user-auth"

# 列出checkpoints
mcp__serena__list_memories
  topic: "checkpoint-user-auth"

# 读取checkpoint
mcp__serena__read_memory
  memory_name: "checkpoint-user-auth-design-550e8400..."
```

### Git 命令

```bash
# 切换分支
git checkout feature/user-auth

# 拉取最新代码
git pull origin feature/user-auth

# 查看状态
git status
```

## 恢复场景

| 场景 | 触发条件 | 恢复策略 |
|------|---------|---------|
| **正常中断** | 用户主动结束会话 | 保存 Session Summary + 最新 Checkpoint |
| **异常中断** | 网络/系统故障 | 自动保存的 Checkpoint |
| **任务失败** | 重试次数耗尽 | 失败日志 + 人工介入记录 |
| **依赖阻塞** | 前置任务未完成 | 等待依赖完成 |
| **外部变更** | 计划/需求变更 | 回滚到变更点重新开始 |

## 上下文重建内容

### 1. Git 状态
- 当前分支
- 工作目录
- 未提交的变更

### 2. TodoWrite 状态
- 所有任务列表
- 任务依赖关系
- 重试计数器

### 3. 项目上下文
- 已完成节点
- 输出产物路径
- 关键设计决策

### 4. 会话上下文
- Session Summary
- 最近的 Checkpoint
- 失败日志（如果有）

## 相关命令

**相关进度命令**:
- `/status` - 查看进度
- `/checkpoint` - 创建检查点
- `/report` - 生成报告
