# cad-load Skill

## 概述

`cad-load` 是项目上下文加载 Skill，替代 SuperClaude 的 /sc:load，用于加载项目上下文、恢复进度和管理会话。

## 如何单独使用

### 命令调用

```bash
# 快速加载（仅核心上下文）
/cad-load

# 标准加载（推荐）
/cad-load standard

# 完整加载（包含所有历史）
/cad-load full
```

## 加载模式

| 模式 | 加载内容 | 时间 | 适用场景 |
|------|---------|------|---------|
| **quick** | 核心上下文 | <500ms | 快速开始 |
| **standard** | 核心上下文 + 最新记忆 | <1s | 日常使用 |
| **full** | 所有上下文 + 历史 | <2s | 完整恢复 |

## 具体使用案例

### 案例 1：新会话开始

**场景**：开始新的开发会话。

**操作**：
```bash
/cad-load standard
```

**执行流程**：
```
1. ✅ 激活项目（Serena MCP）
2. ✅ 加载核心记忆：
   - project_overview（项目概述）
   - v2.4-checkpoint（版本检查点）
   - progress/cadence-skills-v2.4-mvp（进度追踪）
3. ✅ 检查 Git 状态
4. ✅ 显示项目信息：
   - 项目名称：Cadence-skills
   - 当前版本：v2.4 MVP
   - 状态：已完成 (7/7 schemes, 100%)
   - 最新提交：b239cec - 创建 cad-load skill
5. ✅ 建议下一步：
   - 继续开发 → /resume
   - 开始新功能 → /full-flow 或 /quick-flow
   - 查看进度 → /status
```

### 案例 2：恢复之前的进度

**场景**：恢复昨天未完成的工作。

**操作**：
```bash
/cad-load standard
/status
/resume
```

**执行流程**：
```
1. ✅ 加载项目上下文
2. ✅ 查看进度：
   当前流程：Full Flow
   当前节点：4/8 (Design)
   已完成：Brainstorm ✅, Analyze ✅, Requirement ✅
   当前任务：技术设计
3. ✅ 恢复到 Design 节点
4. ✅ 继续技术设计
```

### 案例 3：完整项目分析

**场景**：需要了解项目的完整历史和所有细节。

**操作**：
```bash
/cad-load full
```

**执行流程**：
```
1. ✅ 加载所有记忆：
   - 核心记忆（P0）
   - 会话记忆（P1）
   - 模式记忆（P2）
2. ✅ 加载所有历史会话
3. ✅ 加载所有检查点
4. ✅ 显示完整项目信息
```

## 记忆优先级

### P0 - 核心记忆（总是加载）

- `project_overview` - 项目概述
- `v2.4-checkpoint` - 版本检查点
- `progress/cadence-skills-v2.4-mvp` - 进度追踪

### P1 - 会话记忆（standard/full 模式加载）

- `sessions/*` - 会话记录
- `checkpoint-*` - 检查点

### P2 - 模式记忆（full 模式加载）

- `patterns/*` - 技术模式
- `style_conventions` - 代码风格
- `tech-stack-*` - 技术栈配置

## 与流程 Skills 的集成

### Full Flow 集成

```bash
/cad-load standard  # 加载上下文
/full-flow          # 开始完整流程
```

### Quick Flow 集成

```bash
/cad-load quick     # 快速加载
/quick-flow         # 开始快速流程
```

### 恢复进度

```bash
/cad-load standard  # 加载上下文
/status             # 查看进度
/resume             # 恢复进度
```

## 输出示例

### Quick 模式

```
✅ 项目上下文加载完成（Quick 模式）

项目信息：
- 名称：Cadence-skills
- 版本：v2.4 MVP
- 状态：已完成 (7/7 schemes, 100%)

最新提交：b239cec - 创建 cad-load skill

建议下一步：
- /status - 查看进度
- /full-flow - 开始完整流程
- /quick-flow - 开始快速流程
```

### Standard 模式

```
✅ 项目上下文加载完成（Standard 模式）

项目信息：
- 名称：Cadence-skills
- 版本：v2.4 MVP
- 状态：已完成 (7/7 schemes, 100%)
- Skills：14个（8核心 + 3流程 + 3元）
- Commands：14个

最新进展（2026-03-02）：
- ✅ v2.4 MVP 已完成
- ✅ 新增 cad-load skill
- ✅ 更新 README.md v2.0

Git 状态：
- 当前分支：main
- 最新提交：b239cec
- 工作区：干净

可用记忆（37个）：
- 核心记忆：3个（已加载）
- 会话记忆：15个（已加载）
- 模式记忆：19个（可选）

建议下一步：
- /status - 查看进度
- /resume - 恢复进度
- /full-flow - 开始完整流程
```

### Full 模式

```
✅ 项目上下文加载完成（Full 模式）

[包含 Standard 模式的所有内容]

+ 历史会话（20个）：
  - 2026-03-02_scheme7_completion
  - 2026-03-02_scheme6_implementation_complete
  - 2026-03-02_scheme5_implementation_complete
  ...

+ 所有检查点（10个）：
  - checkpoint-2026-03-02-scheme7-complete
  - checkpoint-2026-03-02-scheme6-complete
  ...

+ 技术模式（19个）：
  - markdown-best-practices
  - skill-standardization
  - tech-stack-configuration
  ...
```

## 最佳实践

### 1. 新会话使用 Standard 模式

日常开发使用 Standard 模式，平衡速度和上下文完整性。

### 2. 快速查看使用 Quick 模式

只需要基本信息时使用 Quick 模式。

### 3. 完整分析使用 Full 模式

需要完整历史和所有细节时使用 Full 模式。

### 4. 与流程 Skills 配合使用

先加载上下文，再开始流程。

### 5. 定期检查进度

加载后使用 `/status` 查看当前进度。

## 与 SuperClaude /sc:load 的区别

| 特性 | cad-load | /sc:load |
|------|----------|----------|
| **记忆系统** | Serena MCP | Serena MCP |
| **优先级** | P0/P1/P2 三级 | 无优先级 |
| **模式** | Quick/Standard/Full | 单一模式 |
| **Git 状态** | ✅ 自动检查 | ❌ 不检查 |
| **流程集成** | ✅ 深度集成 | ❌ 独立 |
| **中文支持** | ✅ 完整支持 | ❌ 英文 |

## 常见问题

### Q: 什么时候使用 Quick 模式？

A: 快速查看项目状态，不需要详细信息时。

### Q: 什么时候使用 Full 模式？

A: 需要完整历史、所有检查点和技术模式时。

### Q: 记忆加载失败怎么办？

A: 检查 Serena MCP 是否正常运行，使用 `/mcp` 查看 MCP 状态。

## 相关 Skills

- **using-cadence** - Cadence Skills 系统使用指南
- **cadencing** - 项目初始化
- **full-flow** - 完整流程
- **quick-flow** - 快速流程
- **exploration-flow** - 探索流程
