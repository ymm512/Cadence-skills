# /resume Command

## 概述

`/resume` 命令用于恢复之前的开发进度，从最近的检查点继续工作。

## 如何使用

```bash
/resume
```

## 执行流程

```
1. 查找最近的检查点
   ↓
2. 加载检查点数据
   ↓
3. 恢复到中断的节点
   ↓
4. 继续工作
```

## 输出示例

### 恢复成功

```
✅ 进度恢复成功

检查点：checkpoint-2026-03-02-shopping-cart-design
创建时间：2026-03-02 14:30:00
流程：Full Flow
节点：4/8 (Design)

正在恢复：
- 流程状态：已恢复
- 当前节点：Design - 技术设计
- 进度：60% 完成
- 已用时间：45 分钟

已加载文档：
- .claude/designs/2026-03-02_需求文档_购物车_v1.0.md
- .claude/analysis/2026-03-02_分析报告_购物车存量分析_v1.0.md
- .claude/docs/2026-03-02_需求文档_购物车详细_v1.0.md

💡 继续工作：
- 当前任务：设计数据库 Schema
- 下一步：完成技术设计，然后运行 /design-review

查看详细进度：/status
```

### 无可用检查点

```
❌ 没有找到可恢复的进度

💡 建议：
- /full-flow - 开始完整流程
- /quick-flow - 开始快速流程
- /exploration-flow - 开始探索流程

或者查看最近的检查点：
- checkpoint-2026-03-01-user-auth（1天前）
- checkpoint-2026-02-28-login-fix（2天前）
```

### 指定检查点恢复

```bash
/resume checkpoint-2026-03-01-user-auth
```

```
✅ 进度恢复成功

检查点：checkpoint-2026-03-01-user-auth
流程：Quick Flow
节点：3/4 (Git Worktrees)

正在恢复...
```

## 检查点管理

### 查看所有检查点

```bash
/status
```

输出包含最近的检查点列表。

### 创建检查点

```bash
/checkpoint
```

在重要节点手动创建检查点。

### 自动检查点

系统会在以下情况自动创建检查点：
- 每个节点完成后
- 重要决策点
- 用户请求时

## 恢复内容

恢复操作会加载：

### 1. 流程状态

- 当前流程类型
- 当前节点
- 节点完成情况

### 2. 文档

- 已生成的所有文档
- 需求文档
- 分析报告
- 设计文档
- 实现计划

### 3. 上下文

- 项目信息
- 技术栈配置
- Git 状态

### 4. 进度统计

- 已用时间
- 预估剩余时间
- 完成百分比

## 最佳实践

### 1. 定期创建检查点

在重要节点手动创建检查点：

```bash
/checkpoint
```

### 2. 恢复前先查看

```bash
/status           # 查看当前进度
/resume           # 恢复进度
```

### 3. 指定检查点恢复

如果有多个检查点，指定要恢复的检查点：

```bash
/resume checkpoint-2026-03-01-user-auth
```

### 4. 恢复后检查

恢复后使用 `/status` 确认恢复正确：

```bash
/resume           # 恢复进度
/status           # 检查恢复结果
```

## 常见场景

### 场景 1：昨天未完成的工作

```bash
# 新会话开始
/cad-load         # 加载项目上下文
/status           # 查看进度
/resume           # 恢复昨天的进度
```

### 场景 2：切换任务

```bash
# 当前正在开发功能A，需要切换到功能B
/checkpoint       # 为功能A创建检查点
# 完成功能B后
/status           # 查看检查点
/resume checkpoint-2026-03-02-feature-a  # 恢复功能A
```

### 场景 3：中断后恢复

```bash
# 意外中断后
/cad-load         # 加载项目上下文
/resume           # 恢复最近的检查点
```

## 相关命令

- `/status` - 查看进度
- `/checkpoint` - 创建检查点
- `/report` - 生成报告
- `/cad-load` - 加载项目上下文

## 相关 Skills

- **full-flow** - 完整流程
- **quick-flow** - 快速流程
- **exploration-flow** - 探索流程
- **cad-load** - 项目上下文加载
