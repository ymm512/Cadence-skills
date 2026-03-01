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
- **设计进度**: 6/7 (86%)
- **实施进度**: 6/7 (86%)
- Git 状态: 最新提交（124f631 - 方案6实施完成）

## 最新进展（2026-03-02）

### 方案实施进度

**已完成（6/7）**：
- ✅ 方案1：基础架构 + 配置 + Hooks（已实施）
- ✅ 方案2：元 Skill + Init Skill（已实施）
- ✅ 方案3：质量保证 Skills（已实施，Commit: 6002c8c）
- ✅ 方案4：节点 Skill 第1组（已实施，Commit: 50da68d）
- ✅ 方案5：节点 Skill 第2组（已实施，Commit: 8921df2）
- ✅ **方案6：节点 Skill 第3组**（已实施，Commit: 124f631）

**方案3 实施详情**（2026-03-01）：
- ✅ 5个质量保证 Skills（test-driven-development, requesting-code-review, receiving-code-review, verification-before-completion, finishing-a-development-branch）
- ✅ 5个 Commands（/tdd, /request-review, /receive-review, /verify, /finish）
- ✅ Git 提交并推送（Commit: 6002c8c）
- ✅ 所有 Skills 直接复制自 superpowers，未做修改

**方案4 实施详情**（2026-03-01）：
- ✅ 3个节点 Skills（Brainstorming、Analyze、Requirement）
- ✅ 3个 Commands（/brainstorm, /analyze, /requirement）
- ✅ Git 提交并推送（Commit: 50da68d）
- ✅ Brainstorming 来自 superpowers（96行）
- ✅ Analyze 全新设计，Serena MCP集成（495行）
- ✅ Requirement 全新设计，支持存量复用（746行）

**方案5 实施详情**（2026-03-02）：
- ✅ 3个节点 Skills（Design、Design Review、Plan）
- ✅ 3个 Commands（/design, /design-review, /plan）
- ✅ Git 提交并推送（Commit: 8921df2）
- ✅ Design 全新设计，支持带着审查报告重新设计
- ✅ Design Review 全新设计，8个维度系统性审查
- ✅ Plan 全新设计，支持CLAUDE.md技术栈配置读取

**方案6 实施详情**（2026-03-02）：
- ✅ 2个核心 Skills（using-git-worktrees, subagent-development）
- ✅ 3个 Subagent Prompts（8.1/8.2/8.3）
- ✅ 2个 Commands（/worktree, /develop）
- ✅ Git 提交并推送（Commit: 124f631）
- ✅ using-git-worktrees：智能目录选择、安全验证、自动初始化
- ✅ subagent-development：两阶段审查、TDD强制执行、并行执行支持

**待实施（1/7）**：
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
- 方案3：`.claude/designs/next/方案3_前置Skill_支持Skill.md`
- **方案4：`.claude/designs/next/方案4_节点Skill_第1组.md`**

**已实施 Skills**（在工作目录 skills/）：
- using-cadence：`skills/using-cadence/SKILL.md`（140行）
- cadencing：`skills/cadencing/SKILL.md`（155行）
- **5个质量保证 Skills**（方案3）：
  - test-driven-development（371行）
  - requesting-code-review（105行）
  - receiving-code-review（213行）
  - verification-before-completion（139行）
  - finishing-a-development-branch（144行）
- **3个节点 Skills**（方案4）：
  - brainstorming（96行）- 来自superpowers
  - analyze（495行）- Serena MCP集成
  - requirement（746行）- 支持存量复用

**已实施 Commands**（在工作目录 commands/）：
- cadencing.md
- **5个质量保证 Commands**（方案3）：
  - tdd.md, request-review.md, receive-review.md, verify.md, finish.md
- **3个节点 Commands**（方案4）：
  - brainstorm.md, analyze.md, requirement.md

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
- **方案4 设计详情**：`session-2026-03-01-scheme4-design-complete`
- **方案4 设计检查点**：`checkpoint-2026-03-01-scheme4-design-complete`
- **方案4 实施详情**：`session-2026-03-01-scheme4-implementation-complete`
- **方案4 实施检查点**：`checkpoint-2026-03-01-scheme4-implementation-complete`
