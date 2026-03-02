# using-cadence Skill

## 概述

`using-cadence` 是 Cadence Skills 系统的核心元 Skill，指导如何正确使用 Cadence Skills。它确保在任何操作前先检查并调用相关的 Skill。

## 如何单独使用

### 自动触发

这个 Skill 会在 Cadence 相关对话开始时自动触发，无需手动调用。

### 强制规则

```
<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a Cadence skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.
</EXTREMELY-IMPORTANT>
```

## 具体使用案例

### 案例 1：新功能开发

**用户输入**：
```
帮我实现用户登录功能
```

**正确行为**：
1. 识别这是一个开发任务
2. 检查相关的 Cadence Skills（brainstorming, design, plan 等）
3. 自动调用 `brainstorming` Skill 开始需求探索

**错误行为**：
- ❌ 直接开始写代码
- ❌ 先问问题再检查 Skills
- ❌ 认为太简单不需要 Skills

### 案例 2：Bug 修复

**用户输入**：
```
修复登录页面的验证错误
```

**正确行为**：
1. 识别这是一个 Bug 修复任务
2. 检查相关的 Cadence Skills
3. 调用 `quick-flow` 或相关 Skill

**错误行为**：
- ❌ 直接定位 Bug 并修复
- ❌ 跳过分析阶段

### 案例 3：技术调研

**用户输入**：
```
调研一下是否应该使用 GraphQL
```

**正确行为**：
1. 识别这是一个探索性任务
2. 调用 `exploration-flow` Skill
3. 使用 Brainstorm → Analyze → Design → Plan 流程

**错误行为**：
- ❌ 直接给出建议
- ❌ 跳过探索阶段

## Skill 优先级

当多个 Skills 可能适用时，按以下顺序使用：

1. **流程 Skills 优先**（brainstorming, analyze, debugging） - 决定如何处理任务
2. **实现 Skills 其次**（design, plan, development） - 指导具体执行

示例：
- "让我们构建 X" → 先 brainstorming，然后实现 Skills
- "修复这个 Bug" → 先 debugging，然后特定领域 Skills

## 红旗警告

以下想法意味着你在合理化跳过 Skills：

| 想法 | 现实 |
|------|------|
| "这只是一个简单问题" | 问题也是任务，检查 Skills |
| "我需要更多上下文" | 检查 Skills 在提问之前 |
| "让我先探索代码库" | Skills 告诉你如何探索 |
| "我可以快速检查 git/文件" | 文件缺少对话上下文 |
| "这不需要正式 Skill" | 如果 Skill 存在，使用它 |
| "我记得这个 Skill" | Skills 会演进，读取当前版本 |

## 最佳实践

### 1. 总是先检查 Skills

即使只有 1% 的可能性，也要调用 Skill 检查。

### 2. 遵循 Skill 流程

一旦调用 Skill，严格遵循其指导，不要跳过步骤。

### 3. 使用正确的流程模式

- 复杂功能 → 完整流程
- 简单功能 → 快速流程
- 技术调研 → 探索流程

### 4. 不要合理化跳过

如果 Skill 适用，不要找借口跳过它。

## 快速参考

**Cadence 流程模式**：

| 流程模式 | 命令 | 节点数 | 使用场景 | 时间 |
|---------|------|--------|---------|------|
| Full Flow | `/full-flow` | 8 | 企业级项目 | 1-2 天 |
| Quick Flow | `/quick-flow` | 4 | 快速开发 | 1-2 小时 |
| Exploration Flow | `/exploration-flow` | 4 | 技术探索 | 2-4 小时 |

**单节点命令**：
- `/brainstorm` - 需求探索
- `/analyze` - 存量分析
- `/requirement` - 需求分析
- `/design` - 技术设计
- `/design-review` - 设计审查
- `/plan` - 实现计划
- `/worktree` - 环境隔离
- `/develop` - 代码实现

**进度管理**：
- `/status` - 查看进度
- `/resume` - 恢复进度
- `/checkpoint` - 创建检查点
- `/report` - 生成报告

## 相关 Skills

- **cadencing** - 项目初始化
- **cad-load** - 项目上下文加载
- **brainstorming** - 需求探索
- **full-flow** - 完整流程
- **quick-flow** - 快速流程
- **exploration-flow** - 探索流程
