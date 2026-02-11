# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此仓库中工作提供指导。

## 强制规则

> **🔴 必须遵守 - 无例外**

1. **必须使用中文回答** - 所有响应、解释、注释和文档必须使用中文。代码本身可以使用英文（变量名、函数名等），但所有与用户的交互必须使用中文。

## 项目概述

**Cadence-skills** 是一个基于 Claude Code 的 AI 自动化开发系统，采用混合架构 (Subagent + Skills) 实现从 PRD 需求文档到完整代码实现和测试的端到端自动化开发流程。

### 核心组件

| 组件 | 类型 | 数量 | 用途 |
|------|------|------|------|
| cadence-orchestrator | Skill | 1 | 完整流程主控调度器 |
| cadence-project-init | Skill | 1 | 项目初始化配置 |
| cadence-requirement-only | Skill | 1 | 独立需求分析 |
| cadence-design-only | Skill | 1 | 独立方案设计 |
| cadence-code-only | Skill | 1 | 独立代码生成 |
| cadence-test-only | Skill | 1 | 独立测试生成 |
| cadence-requirement-analyst | Subagent | 1 | PRD 分析、业务规则提取 |
| cadence-solution-architect | Subagent | 1 | 架构设计、代码分析 |
| cadence-code-generation | Subagent | 1 | 代码生成 (完整流程用) |
| cadence-business-testing | Subagent | 1 | 测试用例生成、自动化脚本 |
| Prompt Templates | Resource | 18 | 提示词模板库 |

### 架构特点

- **混合模式**: Subagent 用于重分析任务 (隔离大输出)，Skills 用于轻交互任务 (即时反馈)
- **状态持久化**: 使用 Serena Memory 实现跨 session 的断点续传
- **人工参与**: 关键节点使用 AskUserQuestion 进行结构化确认
- **Plugin 格式**: 符合 Claude Code 官方 Plugin Marketplace 标准

## 仓库用途

本仓库包含：

1. **完整的 Cadence 自动化开发系统**
   - 端到端开发流程 (需求 → 设计 → 代码 → 测试)
   - 独立子流程 (可单独执行某个阶段)
   - Plugin Marketplace 配置

2. **提示词模板库**
   - 需求分析模板 (3 个)
   - 方案设计模板 (2 个)
   - 代码生成模板 (5 个)
   - 测试生成模板 (6 个)

3. **示例和文档**
   - 任务管理系统 PRD 示例
   - 会话总结和实施记录

## 开发方法

### 技能创建原则

创建新 Skill 时遵循以下原则：

1. **单一职责**
   - 每个 Skill 只解决一个特定的工作流或功能
   - 独立子流程 Skill 只完成一个阶段

2. **明确激活**
   - 使用 YAML frontmatter 定义 name 和 description
   - description 必须包含触发条件和激活场景
   - 示例：
     ```yaml
     ---
     name: skill-name
     description: Use when xxx. Trigger words: 'keyword1', 'keyword2'
     ---
     ```

3. **完善文档**
   - 包含使用示例和预期结果
   - 说明输入和输出格式
   - 描述与其他组件的关系

4. **考虑集成**
   - 考虑与 MCP 服务器的集成
   - 说明依赖的其他 Skills 或 Subagents
   - 处理错误和异常情况

### 文件组织

```
cadence-skills/
├── .claude-plugin/
│   └── marketplace.json      # Plugin 配置，定义插件包结构
├── skills/                   # Skills 目录
│   └── {skill-name}/
│       └── SKILL.md          # 必须包含 YAML frontmatter
├── agents/                   # Subagents 目录
│   └── {agent-name}.md       # Subagent 定义文件
├── prompts/                  # 提示词模板
│   ├── requirement/
│   ├── design/
│   ├── code/
│   └── test/
└── docs/                     # 文档
    ├── prd/                  # 示例 PRD
    └── SESSION_SUMMARY_*.md  # 会话总结
```

### Plugin 配置

`.claude-plugin/marketplace.json` 格式：

```json
{
  "name": "package-name",
  "owner": "Name <email>",
  "description": "包描述",
  "version": "1.1.0",
  "plugins": [
    {
      "name": "plugin-name",
      "description": "插件描述",
      "skills": ["./skills/skill-folder"],
      "agents": ["./agents/agent-file.md"],
      "strict": false
    }
  ]
}
```

### MCP 集成

本仓库依赖以下 MCP 服务器：

| MCP Server | 用途 | 必需 |
|------------|------|------|
| **Serena** | Memory 管理、代码分析、断点续传 | ✅ 是 |
| **Context7** | 官方文档查询 | ❌ 可选 |
| **time** | 日期时间获取（cadence-project-init 必需） | ✅ 是 |
| **cclsp** | LSP 语言服务器支持（可选） | ❌ 可选 |

配置位置：`.claude/settings.local.json`

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

## 仓库架构

### 目录结构详解

#### skills/ - 轻交互任务

| Skill | 用途 | 模式 |
|-------|------|------|
| cadence-orchestrator | 完整流程主控 | 协调 Subagent + Skills |
| cadence-project-init | 项目初始化配置 | 独立执行 |
| cadence-requirement-only | 独立需求分析 | 独立执行 |
| cadence-design-only | 独立方案设计 | 独立执行 |
| cadence-code-only | 独立代码生成 | 独立执行 |
| cadence-test-only | 独立测试生成 | 独立执行 |

#### agents/ - 重分析任务

| Agent | 用途 | 特点 |
|-------|------|------|
| cadence-requirement-analyst | 需求分析 | 只读工具，大输出隔离 |
| cadence-solution-architect | 方案设计 | 只读工具，代码分析 |
| cadence-code-generation | 代码生成 | 批量生成，测试执行 |
| cadence-business-testing | 业务测试 | 测试用例生成，隔离输出 |

#### prompts/ - 提示词模板

| 类别 | 文件数 | 用途 |
|------|--------|------|
| requirement/ | 3 | PRD 分析、规则提取、模块划分 |
| design/ | 2 | 架构设计、存量代码分析 |
| code/ | 5 | 前端、后端、测试、调试、Git |
| test/ | 6 | 用例生成、场景测试、自动化脚本 |

### 组件间关系

```
完整流程:
cadence-orchestrator
    ├── cadence-requirement-analyst (Subagent)
    ├── cadence-solution-architect (Subagent)
    ├── cadence-code-generation (Subagent)
    └── cadence-business-testing (Subagent)

独立子流程:
cadence-project-init ──→ cadence-requirement-only ──→ cadence-design-only ──→ cadence-code-only ──→ cadence-test-only
      (独立)                    (独立)                   (独立)                   (独立)                (独立)

共享资源:
- prompts/ (所有组件使用)
- agents/ (orchestrator 和 standalone 共用)
```

## 开发规范

### Git 提交规范

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<type>: <description>

[optional body]

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**类型说明**:
- `feat`: 新功能
- `fix`: 修复
- `docs`: 文档
- `style`: 格式调整
- `refactor`: 重构
- `test`: 测试
- `chore`: 杂项

### 代码规范

1. **文件命名**
   - Skills: `{name}/SKILL.md`
   - Agents: `{name}.md`
   - Prompts: `{name}.txt`

2. **YAML Frontmatter**
   ```yaml
   ---
   name: unique-name
   description: Clear description with trigger conditions
   ---
   ```

3. **文档格式**
   - 使用 Markdown
   - 标题层级清晰
   - 包含示例代码
   - 说明输入输出

### 测试规范

1. 修改后必须验证相关组件的兼容性
2. 新增 Skill 必须包含使用示例
3. 更新文档必须同步更新 README.md 和 CLAUDE.md

## 常用命令

### 本地开发

```bash
# 查看变更
git status
git diff

# 提交 (使用 cjc:gacp 或手动)
git add .
git commit -m "type: description"

# 推送
git push origin main
```

### 安装测试

```bash
# 方式 1: Marketplace
/plugin marketplace add michaelChe956/cadence-skills
/plugin install cadence-full@cadence-ai-development

# 方式 2: 手动
cp -r skills/* your-project/.claude/skills/
cp -r agents/* your-project/.claude/agents/
```

## 版本管理

### 版本号规则

采用语义化版本: `主版本.次版本.修订号`

- **主版本**: 重大架构变更
- **次版本**: 新功能添加 (如新增独立子流程)
- **修订号**: Bug 修复或文档更新

### 当前版本

**v1.2.0**
- 完整流程 (orchestrator + code + test)
- 项目初始化 Skill (cadence-project-init)
- 独立子流程 (requirement-only, design-only, code-only, test-only)
- 代码生成改为 Subagent 模式
- Plugin Marketplace 支持

### 历史版本

- **v1.1.1**: 代码生成改为 Subagent 模式
- **v1.1.0**: 添加独立子流程 Skills
- **v1.0.0**: 初始版本，完整流程实现

## 贡献指南

1. **Fork 仓库**
2. **创建分支**: `git checkout -b feature/xxx`
3. **开发修改**
4. **测试验证**
5. **提交 PR**

### PR 要求

- 清晰的描述修改内容
- 说明修改原因
- 包含测试结果
- 更新相关文档

## 问题排查

### 常见问题

| 问题 | 解决方案 |
|------|----------|
| Skill 未激活 | 检查 YAML frontmatter 格式 |
| Subagent 调用失败 | 检查 agent 文件路径 |
| Memory 操作失败 | 检查 Serena MCP 配置 |
| Plugin 安装失败 | 检查 marketplace.json 格式 |

### 调试技巧

1. 开启 `debug_mode: true` 查看详细日志
2. 使用 `list_memories()` 检查 Memory 状态
3. 查看 Subagent transcript 分析输出
4. 检查 Git 状态确认变更

## 联系与支持

- **GitHub Issues**: [问题反馈](https://github.com/michaelChe956/cadence-skills/issues)
- **GitHub Discussions**: [讨论区](https://github.com/michaelChe956/cadence-skills/discussions)

---

**最后更新**: 2026-02-11
**版本**: v1.2.0
**维护者**: Cadence Team
