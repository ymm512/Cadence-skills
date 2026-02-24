# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此仓库中工作提供指导。

## 强制规则

> **🔴 必须遵守 - 无例外**

### 1. 语言规则

- **必须使用中文回答** - 所有响应、解释、注释和文档必须使用中文。代码本身可以使用英文（变量名、函数名等），但所有与用户的交互必须使用中文。

### 2. 文档存储规则

> **所有文档必须存放在 `.claude` 目录下，禁止在项目根目录或其他位置创建文档文件。**

#### 文档分类存储规范

| 文档类型 | 存储路径 | 说明 |
|---------|---------|------|
| 需求文档 | `.claude/docs/` | PRD、产品需求、业务需求 |
| 方案设计 | `.claude/designs/` | 技术方案、架构设计、API设计 |
| README文档 | `.claude/readmes/` | 项目说明、安装指南、使用文档 |
| 页面原型 | `.claude/modao/` | 墨刀/Figma 原型截图、设计稿 |
| 数据模型 | `.claude/model/` | 数据库表模型、ER图、schema |
| 架构文档 | `.claude/architecture/` | 系统架构分析、技术选型 |
| 开发笔记 | `.claude/notes/` | 临时记录、开发心得、TODO |
| 分析报告 | `.claude/analysis/` | 代码分析、调研报告、性能分析 |
| 开发日志 | `.claude/logs/` | 问题追踪、Bug记录、开发进度 |

#### 命名规范

```
# 文件命名格式
{类型}-{日期}-{标题}.md

# 示例
docs/PRD-2026-02-24-用户认证需求.md
designs/TECH-2026-02-24-后端架构设计.md
notes/TODO-2026-02-24-当前任务.md
```

#### 路径映射（跨平台）

根据当前系统自动适配：

| 系统 | 完整路径示例 |
|------|-------------|
| **macOS** | `/Users/michaelche/projects/myproject/.claude/docs/` |
| **Linux** | `/home/michaelche/projects/myproject/.claude/docs/` |
| **Windows** | `C:\Users\michaelche\projects\myproject\.claude\docs\` |

> **注意**：在 Claude Code 中使用相对路径 `.claude/` 即可，系统会自动解析。

#### 禁止行为

❌ **禁止** 在以下位置创建文档：
- 项目根目录 (`/README.md` 除外的其他 .md 文件)
- `docs/` 目录
- `documents/` 目录
- `files/` 目录
- 任何其他非 `.claude` 的目录

❌ **禁止** 创建分散的文档文件，必须统一放在 `.claude/` 下的对应子目录。

#### 检查清单

在创建任何文档前，必须确认：
- [ ] 文档类型已明确
- [ ] 对应的 `.claude/` 子目录存在（若不存在则创建）
- [ ] 文件命名符合规范

---

## 项目信息

本项目为 **Cadence-skills** 重构后的空项目骨架，等待重新规划。
