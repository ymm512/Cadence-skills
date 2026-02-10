# Cadence AI 自动化开发 Skills 系统

[![版本](https://img.shields.io/badge/version-1.1.0-blue.svg)](https://github.com/michaelChe956/cadence-skills)
[![架构](https://img.shields.io/badge/architecture-Hybrid%20(Subagent%2BSkills)-green.svg)]()
[![状态](https://img.shields.io/badge/status-Production%20Ready-success.svg)]()
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-purple.svg)]()

一个基于混合模式 (Subagent + Skills) 的端到端自动化开发系统,从 PRD 需求文档到完整的代码实现和测试。

## 🎯 核心特性

### 完整的开发流程
- ✅ **需求整理**: 自动分析 PRD,提取业务规则,划分模块
- ✅ **方案设计**: 分析存量代码,设计技术架构和 API
- ✅ **代码生成**: 前后端代码自动生成,实时审查反馈
- ✅ **单元测试**: 自动生成测试用例和测试代码
- ✅ **业务测试**: 生成业务测试用例和自动化脚本
- ✅ **Git 集成**: 自动创建分支,提交代码,推送远程

### 灵活的使用模式
- 🔄 **完整流程**: 端到端自动化 (需求 → 设计 → 代码 → 测试)
- ⚡ **独立子流程**: 可单独执行某个阶段
- 📊 **状态持久化**: Serena Memory 支持断点续传
- 🤝 **人工参与**: 关键节点 AskUserQuestion 确认

### 智能混合架构
- 🔄 **重分析任务** → Subagent (隔离大量输出,工具限制)
- ⚡ **轻交互任务** → Skills (即时反馈,频繁交互)
- 📊 **状态持久化** → Serena Memory (断点续传)
- 🤝 **人工参与** → AskUserQuestion (关键节点确认)

### 企业级特性
- 💾 **断点续传**: Session 中断可恢复
- 🔒 **工具安全**: Subagent 只读工具,防止误操作
- 📈 **渐进式增强**: 分步审查,质量可控
- 🎯 **上下文优化**: 详细分析隔离在 Subagent transcript

---

## 📦 安装方式

### 方式 1: Claude Code Plugin Marketplace (推荐)

```bash
# 1. 添加 Marketplace
/plugin marketplace add michaelChe956/cadence-skills

# 2. 安装完整流程插件
/plugin install cadence-full@cadence-ai-development

# 3. 或安装独立子流程插件
/plugin install cadence-standalone@cadence-ai-development
```

### 方式 2: 手动安装

```bash
# 克隆仓库到目标项目
git clone https://github.com/michaelChe956/cadence-skills.git
cp -r cadence-skills/skills/* your-project/.claude/skills/
cp -r cadence-skills/agents/* your-project/.claude/agents/
cp -r cadence-skills/prompts/* your-project/.claude/prompts/
```

### 方式 3: 全局安装

```bash
# 复制到用户级 .claude 目录
cp -r cadence-skills/skills/* ~/.claude/skills/
cp -r cadence-skills/agents/* ~/.claude/agents/
cp -r cadence-skills/prompts/* ~/.claude/prompts/
```

---

## 📁 项目结构

```
cadence-skills/
├── .claude-plugin/
│   └── marketplace.json           # Claude Code 插件配置 (v1.1.0)
│
├── skills/                        # Skills (轻交互任务)
│   ├── cadence-orchestrator/      # 🎛️ 完整流程主控调度器
│   ├── cadence-requirement-only/  # 📋 独立需求分析
│   ├── cadence-design-only/       # 🏗️ 独立方案设计
│   ├── cadence-code-only/         # 💻 独立代码生成
│   └── cadence-test-only/         # 🧪 独立测试生成
│
├── agents/                        # Subagents (重分析任务)
│   ├── cadence-requirement-analyst.md   # 📋 PRD 分析
│   ├── cadence-solution-architect.md    # 🏗️ 架构设计
│   ├── cadence-code-generation.md       # 💻 代码生成
│   └── cadence-business-testing.md      # 🧪 业务测试用例生成
│
├── prompts/                       # 提示词模板库 (18个)
│   ├── requirement/               # 需求分析提示词
│   │   ├── prd-analysis.txt
│   │   ├── rule-extraction.txt
│   │   └── module-split.txt
│   ├── design/                    # 方案设计提示词
│   │   ├── architecture.txt
│   │   └── existing-code-analysis.txt
│   ├── code/                      # 代码生成提示词
│   │   ├── frontend.txt
│   │   ├── backend.txt
│   │   ├── unit-test.txt
│   │   ├── debug-fix.txt
│   │   └── git-workflow.txt
│   └── test/                      # 测试生成提示词
│       ├── test-case-generation.txt
│       ├── happy-path.txt
│       ├── exception-scenario.txt
│       ├── boundary-value.txt
│       ├── automation-script.txt
│       └── test-report.txt
│
├── docs/                          # 文档
│   ├── prd/                       # 示例 PRD
│   │   └── task-management-system.md
│   └── SESSION_SUMMARY_*.md       # 会话总结
│
├── README.md                      # 本文件
├── CLAUDE.md                      # 项目规范
└── IMPLEMENTATION_SUMMARY.md      # 实施总结
```

---

## 🚀 快速开始

### 1. 前置要求

确保你的 Claude Code 环境已配置:
- ✅ Claude Code CLI 已安装
- ✅ Serena MCP Server 已启用 (用于 Memory 和代码分析)
- ✅ Context7 MCP Server 已启用 (可选,用于官方文档查询)

### 2. 使用方式

#### 完整流程 (推荐)

```
你: "帮我用 Cadence 开发任务管理系统，PRD 在 docs/prd/task-management-system.md"

Cadence 自动执行:
1. ✅ 需求整理 → 分析 PRD，提取业务规则
2. ✅ 方案设计 → 设计架构和 API
3. ✅ 代码生成 → 前后端代码 + 单元测试
4. ✅ 业务测试 → 测试用例 + 自动化脚本
```

**触发词**: "Cadence", "全流程开发", "从需求到测试", "自动化开发"

#### 独立子流程

```
# 只分析需求
你: "分析这个 PRD，生成需求文档"
结果: docs/requirements/xxx-requirement.md

# 只做设计 (基于需求文档)
你: "根据需求文档设计技术方案"
结果: docs/design/xxx-design.md

# 只生成代码 (基于设计)
你: "根据设计文档生成后端代码"
结果: src/... (生成的代码文件)

# 只生成测试
你: "为登录模块生成测试用例"
结果: docs/testing/test-cases.md + tests/...
```

**触发词**: "分析PRD", "需求分析", "方案设计", "生成代码", "生成测试"

---

## 🔄 工作流程

### 完整流程 (cadence-full)

```
┌─────────────────────────────────────────────────────────────┐
│ Phase 1: 初始化                                              │
│ - 生成工作流 ID                                              │
│ - 创建 Memory 存储                                           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ Phase 2: 需求整理 (Subagent)                                 │
│ - 读取和解析 PRD                                             │
│ - 提取业务规则 (19种规则类型)                                │
│ - 识别工作流                                                 │
│ - 划分功能模块                                               │
│ 👤 人工确认模块划分                                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ Phase 3: 方案设计 (Subagent)                                 │
│ - 判断业务类型 (新功能/存量改造)                             │
│ - 存量代码分析 (使用 Serena MCP)                             │
│ - 技术架构设计                                               │
│ - 数据模型设计                                               │
│ - API 接口设计                                               │
│ 👤 人工确认设计方案                                          │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ Phase 4: 代码生成 (Subagent)                                 │
│ - Git 分支管理                                               │
│ - 前端代码生成 (批量生成)                                    │
│ - 后端代码生成 (批量生成)                                    │
│ - 单元测试生成                                               │
│ - 测试执行和调试                                             │
│ - Git commit 和 push                                         │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ Phase 5: 业务测试 (Subagent)                                 │
│ - 测试用例生成 (Happy Path/Exception/Boundary)               │
│ - 👤 人工审查补充                                            │
│ - 自动化脚本生成 (Jest/Playwright)                           │
│ - 测试文档生成                                               │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│ Phase 6: 完成                                                │
│ - 生成工作流报告                                             │
│ - 清理临时文件                                               │
│ ✅ 完成!                                                     │
└─────────────────────────────────────────────────────────────┘
```

### 独立子流程 (cadence-standalone)

```
需求文档 ──→ cadence-requirement-only ──→ 需求分析报告
                                              │
                                              ▼
                                    cadence-design-only ──→ 技术设计文档
                                                                  │
                                                                  ▼
                                                        cadence-code-only ──→ 代码
                                                                              │
                                                                              ▼
                                                                    cadence-test-only ──→ 测试
```

---

## 💾 断点续传

### 自动恢复

如果 session 中断,下次启动时:

```
Orchestrator 检测:
  "发现未完成工作流 WF-20260209-abc123
   当前阶段: 代码生成
   已完成: 需求整理, 方案设计
   是否继续?"

你: "继续"

Orchestrator: ✅ 从代码生成阶段恢复
```

---

## 🎯 混合模式优势

### 为什么选择混合模式?

| 任务类型 | 使用组件 | 原因 |
|---------|---------|------|
| PRD 分析 | Subagent | 产生 5K-10K tokens 输出,隔离在 transcript |
| 代码分析 | Subagent | 产生 10K-20K tokens 输出,工具限制只读 |
| 代码生成 | Subagent | 产生大量输出,隔离上下文,支持 Task() 调用 |
| 业务测试 | Subagent | 生成大量测试用例和脚本,结构化输出 |

**核心优势**:
- ✅ 重分析用 Subagent → 隔离大输出,防止上下文污染
- ✅ 轻交互用 Skills → 快速响应,流畅体验
- ✅ 智能路由 → 根据任务特性自动选择

---

## 📊 使用示例

### 示例 1: 完整流程开发

```
用户: "开发用户认证功能,PRD 在 docs/prd/auth.md"

执行流程:
1. ✅ 初始化 WF-20260209-abc123
2. 🔄 需求整理 → 模块: 3 个, 规则: 12 条
3. ✅ 人工确认
4. 🔄 方案设计 → API: 8 个, 实体: 3 个
5. ✅ 人工确认
6. 🔄 代码生成 → 文件: 15 个, 测试覆盖: 95%
7. 🔄 业务测试 → 用例: 35 个, 自动化: 80%
8. ✅ 完成!

耗时: 约 2 小时
质量: 生产就绪
```

### 示例 2: 独立子流程

```
# 场景: 只需要需求分析，不需要立即开发
用户: "分析这个 PRD，生成需求文档"

执行:
1. 🔄 读取 PRD
2. 🔄 调用需求分析 Subagent
3. 📄 生成 docs/requirements/auth-requirement.md
4. ✅ 完成!

耗时: 约 15 分钟
结果: 结构化需求文档，可用于后续开发或评审
```

### 示例 3: 从设计到代码

```
# 场景: 已有设计文档，只需要生成代码
用户: "根据设计文档生成后端代码"

执行:
1. 🔄 读取设计文档
2. 🔄 创建 Git 分支 feature/WF-xxx
3. 🔄 逐个生成并审查代码文件
4. 🔄 生成单元测试
5. 🔄 运行测试并修复
6. 🔄 Git commit 和 push
7. ✅ 完成!

耗时: 约 30-60 分钟
结果: 可运行的代码 + 测试
```

---

## 🛠️ 配置

### MCP Server 配置

在 `.claude/settings.local.json` 中配置：

```json
{
  "permissions": {
    "allow": [
      "mcp__serena__*",
      "mcp__context7__*"
    ]
  }
}
```

### 技能配置

各个组件的配置可在对应 SKILL.md 中调整：

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| Subagent 超时 | 30 分钟 | 需求/设计分析超时时间 |
| Skills 最大轮次 | 10 | 代码审查最大迭代次数 |
| Checkpoint 间隔 | 30 分钟 | 自动保存间隔 |
| 代码审查模式 | 逐个 | 代码生成后逐个审查 |
| 测试覆盖率目标 | 80% | 单元测试覆盖率要求 |

---

## 📚 文档

### 核心文档
- [Orchestrator 文档](skills/cadence-orchestrator/SKILL.md) - 完整流程主控
- [需求分析 Subagent](agents/cadence-requirement-analyst.md)
- [方案设计 Subagent](agents/cadence-solution-architect.md)
- [代码生成 Subagent](agents/cadence-code-generation.md)
- [业务测试 Subagent](agents/cadence-business-testing.md)

### 独立子流程文档
- [独立需求分析](skills/cadence-requirement-only/SKILL.md)
- [独立方案设计](skills/cadence-design-only/SKILL.md)
- [独立代码生成](skills/cadence-code-only/SKILL.md)
- [独立测试生成](skills/cadence-test-only/SKILL.md)

### 项目文档
- [实施总结](IMPLEMENTATION_SUMMARY.md) - 详细实施过程
- [会话总结](docs/SESSION_SUMMARY_2026-02-09.md) - 开发过程记录
- [CLAUDE.md](CLAUDE.md) - 项目规范和开发指南

---

## 📊 统计信息

| 指标 | 数量 |
|------|------|
| **版本** | v1.1.1 |
| **Skills** | 5 个 (1 主控 + 4 独立) |
| **Subagents** | 4 个 (需求分析 + 方案设计 + 代码生成 + 业务测试) |
| **Prompts** | 18 个模板 |
| **代码行数** | ~7,600 行 |
| **Git 提交** | 5 个结构化提交 |

---

## 🤝 贡献

欢迎贡献! 流程:

1. Fork 本仓库
2. 创建 Feature 分支 (`git checkout -b feature/xxx`)
3. 提交修改 (`git commit -m 'feat: xxx'`)
4. 创建 Pull Request

### 贡献规范
- 遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范
- 类型: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- 必须包含 Co-Authored-By (如果是 AI 协助)

---

## 📞 支持

- **GitHub Issues**: [问题反馈](https://github.com/michaelChe956/cadence-skills/issues)
- **GitHub Discussions**: [讨论区](https://github.com/michaelChe956/cadence-skills/discussions)

---

## 📚 相关资源

- [Claude Code 文档](https://docs.claude.com/code)
- [Subagent 架构](https://code.claude.com/docs/sub-agents)
- [Anthropic Skills 示例](https://github.com/anthropics/skills)
- [Serena MCP](https://github.com/cline/serena)
- [Context7 MCP](https://context7.com)

---

## 📝 版本历史

### v1.1.1 (2026-02-10)
- ✅ 将 `cadence-code-generation` 从 Skill 重构为 Subagent
- ✅ 统一完整流程的组件类型（全部使用 Subagent 进行重任务）
- ✅ 支持通过 `Task()` 显式调用代码生成
- ✅ 旧 Skill 文件标记为 DEPRECATED（向后兼容）

### v1.1.0 (2026-02-09)
- ✅ 添加独立子流程 Skills (requirement-only, design-only, code-only, test-only)
- ✅ 支持灵活选择执行阶段
- ✅ 添加 Plugin Marketplace 配置

### v1.0.0 (2026-02-09)
- ✅ 初始版本发布
- ✅ 完整流程实现 (需求 → 设计 → 代码 → 测试)
- ✅ 混合架构 (Subagent + Skills)
- ✅ 断点续传支持

---

**Built with ❤️ using Claude Code and Hybrid Architecture**
