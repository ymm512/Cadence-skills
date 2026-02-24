# Cadence-skills 项目概述

## 项目目的

这是一个纯文档管理项目，用于 Claude Code 的工作指导。项目包含：

1. **CLAUDE.md** - Claude Code 工作指导配置文件，定义了文档存储规则和命名规范
2. **AI 自动化开发环境配置系统设计方案** - 一个多 Agent 协作系统的技术方案文档

## 技术栈

- **语言**: Markdown（纯文档项目）
- **工具**: Claude Code, Serena MCP
- **无代码文件**: 项目仅包含文档文件

## 关键规则

### 文档存储规则

所有文档必须存放在 `.claude` 目录下：

| 文档类型 | 存储路径 |
|---------|---------|
| 需求文档 | `.claude/docs/` |
| 方案设计 | `.claude/designs/` |
| README文档 | `.claude/readmes/` |
| 页面原型 | `.claude/modao/` |
| 数据模型 | `.claude/model/` |
| 架构文档 | `.claude/architecture/` |
| 开发笔记 | `.claude/notes/` |
| 分析报告 | `.claude/analysis/` |
| 开发日志 | `.claude/logs/` |

### 文档命名规范

```
YYYY-MM-DD_文档类型_文档名称_v版本号.扩展名
```

### 语言规则

- **必须使用中文回答** - 所有响应、解释、注释和文档必须使用中文
- 代码本身可以使用英文（变量名、函数名等）

## 项目状态

- Serena: 已激活（markdown 语言）
- Onboarding: 待完成
- 记忆文件: 无
