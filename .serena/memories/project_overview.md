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
- Onboarding: 已完成
- 当前版本: v2.4 MVP（已完成 100%）
- **设计进度**: 7/7 (100%) ✅
- **实施进度**: 7/7 (100%) ✅
- Git 状态: 最新提交（b239cec - 创建 cad-load skill）
- **最新增强**: cad-load skill（项目上下文加载）

## 最新进展（2026-03-02）

### 方案实施进度

**已完成（7/7）**：
- ✅ 方案1：基础架构 + 配置 + Hooks（已实施）
- ✅ 方案2：元 Skill + Init Skill（已实施）
- ✅ 方案3：质量保证 Skills（已实施，Commit: 6002c8c）
- ✅ 方案4：节点 Skill 第1组（已实施，Commit: 50da68d）
- ✅ 方案5：节点 Skill 第2组（已实施，Commit: 8921df2）
- ✅ **方案6：节点 Skill 第3组**（已实施，Commit: 124f631）
- ✅ **方案7：流程 Skill + 进度追踪**（已实施，Commit: 2f1b155）

**新增功能**（2026-03-02）：
- ✅ **cad-load skill**（Commit: b239cec）
- ✅ 项目上下文加载，替代 SuperClaude 的 /sc:load
- ✅ 三种加载模式（quick/standard/full）
- ✅ 记忆优先级系统（P0/P1/P2）
- ✅ 自动 Git 状态检查
- ✅ 与 full-flow/quick-flow 深度集成

**文档更新**（2026-03-02）：
- ✅ **README.md 更新**（Commit: 7374ecd）
- ✅ 版本更新：v1.0 → v2.0（完成总结）
- ✅ 进度更新：2/7 → 7/7 (100%)
- ✅ 新增完整统计数据（19 Skills, 19 Commands, 3 Prompts）
- ✅ 新增5大核心特性说明
- ✅ 新增技术亮点章节

**v2.4 MVP 已完成** (7/7 schemes, 100%) ✅

## 关键文件位置

**方案文档**：
- 总览：`.claude/designs/next/README.md`
- 方案1：`.claude/designs/next/方案1_基础架构_配置_Hooks.md`
- 方案2：`.claude/designs/next/方案2_元Skill_InitSkill.md`
- 方案3：`.claude/designs/next/方案3_前置Skill_支持Skill.md`
- **方案4：`.claude/designs/next/方案4_节点Skill_第1组.md`**

**已实施 Skills**（在工作目录 skills/）：
- using-cadence：`skills/using-cadence/SKILL.md`（140行）
- cadencing：`skills/cadencing/SKILL.md`（155行）
- **cad-load**：`skills/cad-load/SKILL.md`（约 20KB）- 项目上下文加载 ⭐ 新增
- **5个质量保证 Skills**（方案3）：
  - test-driven-development（371行）
  - requesting-code-review（105行）
  - receiving-code-review（213行）
  - verification-before-completion（139行）
  - finishing-a-development-branch（144行）
- **8个节点 Skills**（方案4-6）：
  - brainstorming（96行）- 来自superpowers
  - analyze（495行）- Serena MCP集成
  - requirement（746行）- 支持存量复用
  - design（约 20KB）- 技术设计
  - design-review（约 15KB）- 设计审查
  - plan（约 12KB）- 实现计划
  - using-git-worktrees（8.4KB）- 创建隔离环境
  - subagent-development（14KB）- 代码实现+单元测试
- **3个流程 Skills**（方案7）：
  - full-flow（约 20KB）- 完整流程（8节点）
  - quick-flow（约 13KB）- 快速流程（4节点）
  - exploration-flow（约 16KB）- 探索流程（4节点+迭代）

**已实施 Commands**（在工作目录 commands/）：
- cadencing.md
- **cad-load.md** - 项目上下文加载 ⭐ 新增
- **5个质量保证 Commands**（方案3）：
  - tdd.md, request-review.md, receive-review.md, verify.md, finish.md
- **7个节点 Commands**（方案4-6）：
  - brainstorm.md, analyze.md, requirement.md
  - design.md, design-review.md, plan.md
  - worktree.md, develop.md
- **5个进度追踪 Commands**（方案7）：
  - status.md, resume.md, checkpoint.md, report.md, monitor.md

**设计文档**（在 .claude/designs/next/）：
- using-cadence 设计：`.claude/designs/next/skills/using-cadence/SKILL.md`
- cadencing 设计：`.claude/designs/next/skills/cadencing/SKILL.md`
- **方案4 Skills 设计**：
  - brainstorming/SKILL.md
  - analyze/SKILL.md
  - requirement/SKILL.md
- **方案4 Commands 设计**：
  - brainstorm.md, analyze.md, requirement.md

**会话记录**：
- 方案1-2 实施详情：`session-2026-03-01-implementation-phase1-phase2`
- 方案1-2 检查点：`checkpoint-2026-03-01-phase1-phase2-complete`
- 方案3 实施详情：`session-2026-03-01-scheme3-qa-skills-complete`
- 方案3 检查点：`checkpoint-2026-03-01-scheme3-complete`
- 方案4 设计详情：`session-2026-03-01-scheme4-design-complete`
- 方案4 设计检查点：`checkpoint-2026-03-01-scheme4-design-complete`
- 方案4 实施详情：`session-2026-03-01-scheme4-implementation-complete`
- 方案4 实施检查点：`checkpoint-2026-03-01-scheme4-implementation-complete`
- 方案5-6 实施详情：`sessions/2026-03-02_scheme5_completion`, `sessions/2026-03-02_scheme6_implementation_complete`
- 方案7 实施详情：`sessions/2026-03-02_scheme7_completion`
- **cad-load 创建详情**：`sessions/2026-03-02_cad-load_creation` ⭐ 新增
- **cad-load 创建检查点**：`checkpoint-2026-03-02-cad-load-creation-complete` ⭐ 新增
