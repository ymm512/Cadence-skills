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
- 当前版本: v2.4 MVP
- 总体进度: 方案实施阶段（2/7 完成，28.6%）
- Git 状态: 已提交并推送（分支：recreate-cadence-skills，Commit：5b74f7a）

## 最新进展（2026-03-01）

### 方案实施进度

**已完成（2/7）**：
- ✅ 方案1：基础架构 + 配置 + Hooks（已实施）
- ✅ 方案2：元 Skill + Init Skill（已实施）

**实施详情（2026-03-01 会话）**：
- ✅ 创建7个目录结构（.claude-plugin, skills, hooks, docs, tests, agents, commands）
- ✅ 创建2个配置文件（plugin.json, marketplace.json）
- ✅ 创建2个 Hooks 文件（hooks.json, session-start）
- ✅ 复制2个 Skills（using-cadence, init）
- ✅ 复制1个 Command（init.md）
- ✅ 创建1个文档（hooks-reference.md）
- ✅ Git 提交并推送（Commit: 5b74f7a）

**Skills 优化完成**：
- ✅ init Skill：967行 → 155行（减少84%）
- ✅ using-cadence Skill：269行 → 140行（减少48%）
- ✅ 所有 Skills 完全符合 superpowers 标准

**标准化检查**：
- ✅ 所有已完成工作通过标准化检查
- ✅ 无冲突，无问题，可直接使用
- ✅ 文档位置：`.claude/designs/next/STANDARDIZATION_CHECK.md`

**待实施（5/7）**：
- ⏳ 方案3：前置 Skill + 支持 Skill
- ⏳ 方案4-6：节点 Skill（3组）
- ⏳ 方案7：流程 Skill + 进度追踪

**待测试功能**：
- [ ] SessionStart Hook 自动注入
- [ ] `/cadence:cadencing` 命令
- [ ] 创建 PR（已准备内容，待手动创建）

### 关键文件位置

**方案文档**：
- 总览：`.claude/designs/next/README.md`
- 方案1：`.claude/designs/next/方案1_基础架构_配置_Hooks.md`
- 方案2：`.claude/designs/next/方案2_元Skill_InitSkill.md`

**已实施 Skills**（在工作目录）：
- using-cadence：`skills/using-cadence/SKILL.md`（140行）
- init：`skills/cadencing/SKILL.md`（155行）
- init Command：`commands/cadencing.md`

**设计文档**（在 .claude/designs/next/）：
- using-cadence 设计：`.claude/designs/next/skills/using-cadence/SKILL.md`
- init 设计：`.claude/designs/next/skills/cadencing/SKILL.md`
- init Command 设计：`.claude/designs/next/commands/cadencing.md`

**会话记录**：
- 会话详情：`.serena/memories/session-2026-03-01-implementation-phase1-phase2`
- 检查点：`.serena/memories/checkpoint-2026-03-01-phase1-phase2-complete`
