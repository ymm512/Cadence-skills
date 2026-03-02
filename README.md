# Cadence

Cadence 是一个基于 Claude Code Skills 的多 Agent 协作系统，为 AI 编码助手提供完整的软件开发工作流程。

## 如何工作

Cadence 从你启动编码助手的那一刻开始工作。当它发现你正在构建某样东西时，它不会直接跳进去写代码，而是退后一步，问你真正想做什么。

一旦通过对话明确了需求，它会分块展示设计，让你能够真正阅读和理解。

在你批准设计后，你的助手会制定一个清晰的实现计划，强调真正的红/绿 TDD、YAGNI（你不会需要它）和 DRY。

接下来，一旦你说"开始"，它会启动一个多 Agent 协作流程，让 Agents 通过每个工程任务，检查和审查他们的工作，继续前进。Claude 通常能够自主工作几个小时，而不会偏离你制定的计划。

还有更多功能，但这是系统的核心。而且因为 Skills 会自动触发，你不需要做任何特别的事情。你的编码助手就拥有了节奏（Cadence）。

## 安装

### Claude Code（通过插件市场）

在 Claude Code 中，首先注册市场：

```bash
/plugin marketplace add michaelChe956/Cadence-skills-marketplace
```

然后从这个市场安装插件：

```bash
/plugin install cadence@Cadence-skills-marketplace
```

### 验证安装

在你选择的平台中开始一个新会话，请求一些应该触发 Skill 的内容（例如，"帮我规划这个功能"或"让我们调试这个问题"）。助手应该自动调用相关的 Cadence Skills。

## 基本工作流程

Cadence 提供 3 种流程模式，适应不同的开发场景：

### 1. 完整流程（Full Flow）

**适用场景**：复杂功能开发（预估>2小时）、团队协作项目、企业级应用

**流程节点**：
1. **Brainstorm** - 需求探索，通过苏格拉底式对话明确需求
2. **Analyze** - 存量分析，分析现有代码库
3. **Requirement** - 需求分析，输出结构化需求文档
4. **Design** - 技术设计，输出详细技术方案
5. **Design Review** - 设计审查，验证设计质量
6. **Plan** - 实现计划，分解为具体任务
7. **Git Worktrees** - 创建隔离环境，避免冲突
8. **Subagent Development** - 代码实现 + 单元测试

**关键特性**：
- 每个节点完成后人工确认
- 支持断点续传
- 两阶段审查（规范审查 + 代码质量审查）

### 2. 快速流程（Quick Flow）

**适用场景**：简单功能开发（预估<2小时）、原型验证、Bug 修复

**流程节点**：
1. **Requirement** - 需求分析
2. **Plan** - 实现计划
3. **Git Worktrees** - 创建隔离环境
4. **Subagent Development** - 代码实现

**关键特性**：
- 跳过探索和分析阶段
- 快速进入开发
- 仍然保持 TDD 和审查机制

### 3. 探索流程（Exploration Flow）

**适用场景**：新技术验证、技术选型、创新功能、原型开发、POC 验证

**流程节点**：
1. **Brainstorm** - 需求探索（探索性 PRD）
2. **Analyze** - 存量分析（简化分析）
3. **Git Worktrees** - 创建隔离环境（poc/ 分支）
4. **Subagent Development** - 原型开发 + 测试（质量要求较低）

**关键特性**：
- 允许失败和迭代，可从任何节点回到之前的节点
- 原型代码质量要求较低，但必须能验证核心想法
- Subagent Development 完成后进入**评估阶段**，有 4 种结局：
  - ✅ **结局1: 转标准流程** - 功能可行 + 需要正式实现 → 清理 POC 代码，从 Design 开始正式实现
  - 🔄 **结局2: 继续探索** - 功能可行但需要调整 → 再次循环 Subagent Development
  - 📚 **结局3: 技术储备完成** - 功能可行但暂不需要 → 清理 POC 代码，记录技术方案
  - ❌ **结局4: 记录教训** - 功能不可行 → 清理 POC 代码，记录失败原因
- 探索成功后建议从 Design 节点开始正式实现（不直接使用 POC 代码）
- 产物可能是技术验证报告而非最终代码

**助手会在任何任务前检查相关的 Skills。** 这是强制性工作流程，不是建议。

## Skills 库

> **注**：Cadence 包含 14 个核心 Skills（下文列出）和 5 个从 [superpowers](https://github.com/obra/superpowers) 继承的 Skills（test-driven-development, verification-before-completion, requesting-code-review, receiving-code-review, finishing-a-development-branch）。

### 核心节点 Skills（8个）

**需求阶段**
- **brainstorming** - 需求探索，通过苏格拉底式对话明确需求 [📖 详细指南](readmes/skills/brainstorming.md)
- **analyze** - 存量分析，使用 Serena MCP 分析现有代码库
- **requirement** - 需求分析，输出结构化需求文档

**设计阶段**
- **design** - 技术设计，输出详细技术方案（支持带着审查报告重新设计）
- **design-review** - 设计审查，验证设计质量（4 个维度）
- **plan** - 实现计划，分解为具体任务（每个任务 2-5 分钟）

**开发阶段**
- **using-git-worktrees** - 创建隔离环境，避免冲突
- **subagent-development** - 代码实现 + 单元测试（3 个 Subagent 角色）

**📖 [查看所有 Skills 详细指南](readmes/skills/README.md)**

### 流程 Skills（3个）

- **full-flow** - 完整流程（8 个节点），适用于复杂功能开发 [📖 详细指南](readmes/skills/full-flow.md)
- **quick-flow** - 快速流程（4 个节点），适用于简单功能开发 [📖 详细指南](readmes/skills/quick-flow.md)
- **exploration-flow** - 探索流程（4 个节点 + 迭代），适用于新技术验证 [📖 详细指南](readmes/skills/exploration-flow.md)

**📖 [查看所有 Skills 详细指南](readmes/skills/README.md)**

### 元 Skills（3个）

- **using-cadence** - Cadence Skills 系统使用指南 [📖 详细指南](readmes/skills/using-cadence.md)
- **cadencing** - 项目初始化，将现有项目配置为 Cadence 管理的项目 [📖 详细指南](readmes/skills/cadencing.md)
- **cad-load** - 项目上下文加载 [📖 详细指南](readmes/skills/cad-load.md)

**📖 [查看所有 Skills 详细指南](readmes/skills/README.md)**

## Commands 库

> **注**：Cadence 包含 14 个核心 Commands（下文列出）和 5 个从 [superpowers](https://github.com/obra/superpowers) 继承的 Commands（/tdd, /verify, /request-review, /receive-review, /finish）。

### 节点 Commands（7个）

- `/brainstorm` - 启动需求探索
- `/analyze` - 启动存量分析
- `/requirement` - 启动需求分析
- `/design` - 启动技术设计
- `/design-review` - 启动设计审查
- `/plan` - 启动实现计划
- `/develop` - 启动代码实现

**📖 [查看所有 Commands 详细指南](readmes/commands/README.md)**

### 流程 Commands（6个）

- `/worktree` - 创建 Git Worktree 隔离环境
- `/status` - 查看当前进度 [📖 详细指南](readmes/commands/status.md)
- `/resume` - 恢复之前的进度 [📖 详细指南](readmes/commands/resume.md)
- `/checkpoint` - 创建检查点
- `/report` - 生成进度报告
- `/monitor` - 实时监控进度

**📖 [查看所有 Commands 详细指南](readmes/commands/README.md)**

### 元 Commands（1个）

- `/cad-load` - 加载项目上下文（支持 quick/standard/full 三种模式）

**📖 [查看所有 Commands 详细指南](readmes/commands/README.md)**

## 最佳实践

### 1. 选择正确的流程模式

- **复杂功能** → 使用完整流程（Full Flow）
- **简单功能** → 使用快速流程（Quick Flow）
- **技术调研** → 使用探索流程（Exploration Flow）

### 2. 充分利用断点续传

- 每个节点完成后会自动创建检查点
- 使用 `/resume` 恢复之前的进度
- 使用 `/status` 查看当前进度

### 3. 保持 TDD 实践

- Subagent Development 强制执行 TDD
- 测试覆盖率 ≥ 80%
- 两阶段审查确保质量

### 4. 利用 Serena MCP 进行存量分析

- 使用 `analyze` Skill 分析现有代码库
- 识别可复用的组件和模式
- 避免重复造轮子

### 5. 合理使用 Git Worktrees

- 每个功能开发在独立的 Worktree 中
- 避免主分支污染
- 方便并行开发

### 6. 新项目先初始化

- 使用 `cadencing` Skill 初始化项目
- 自动配置环境、规则、文档结构和技术栈
- 确保 Cadence 工作流程正常运行

## 技术亮点

### 1. 完整的开发流程

- 8 个核心节点覆盖完整开发生命周期
- 3 种流程模式适应不同场景
- 支持断点续传和会话恢复

### 2. 智能进度追踪

- 使用 Serena memory 实现跨会话持久化
- 自动创建检查点
- 实时监控和报告生成

### 3. 两阶段审查机制

- **Spec Reviewer**: 验证规范符合性（4 个维度）
- **Code Quality Reviewer**: 验证代码质量（5 个维度）
- **TDD 强制执行**: 测试覆盖率 ≥ 80%

### 4. 灵活的流程模式

- **完整流程**: 确保质量和可追溯性
- **快速流程**: 提高小功能开发效率
- **探索流程**: 支持技术调研和 POC

### 5. 智能项目初始化

- 自动检测项目类型和技术栈
- 跨平台兼容（macOS/Linux/Windows）
- 用户确认机制确保准确性

## 哲学

- **测试驱动开发** - 始终先写测试
- **系统化优于临时** - 流程优于猜测
- **降低复杂度** - 简单性是首要目标
- **证据优于声明** - 在声明成功前验证

## 贡献

Skills 直接存储在这个仓库中。要贡献：

1. Fork 仓库
2. 为你的 Skill 创建分支
3. 遵循 `skills/writing-skills/SKILL.md` 创建和测试新 Skills
4. 提交 PR

## 更新

当你更新插件时，Skills 会自动更新：

```bash
/plugin update cadence
```

## 版本历史

### v2.4 MVP（2026-03-02）

**已完成功能**：
- ✅ 8 个核心节点 Skills
- ✅ 3 个流程 Skills
- ✅ 3 个元 Skills（using-cadence, cadencing, cad-load）
- ✅ 14 个 Commands
- ✅ 3 个 Subagent Prompts
- ✅ 智能进度追踪系统
- ✅ 两阶段审查机制

**统计数据**：
- 19 个 Skills（14 个 Cadence 核心 + 5 个 superpowers 继承）
- 19 个 Commands（14 个 Cadence 核心 + 5 个 superpowers 继承）
- 3 个 Subagent Prompts
- 约 50 个文件，约 150KB 代码

**Cadence 核心 Skills（14个）**：
- 8 个核心节点：brainstorming, analyze, requirement, design, design-review, plan, using-git-worktrees, subagent-development
- 3 个流程：full-flow, quick-flow, exploration-flow
- 3 个元 Skills：using-cadence, cadencing, cad-load

**从 superpowers 继承（5个）**：
- test-driven-development, verification-before-completion, requesting-code-review, receiving-code-review, finishing-a-development-branch

**详细发布说明**：[RELEASE-NOTES.md](RELEASE-NOTES.md)

## 许可证

MIT License - 详见 LICENSE 文件

## 支持

- **问题反馈**: https://github.com/michaelChe956/Cadence-skills/issues
- **市场**: https://github.com/michaelChe956/Cadence-skills-marketplace

## 致谢

本项目受到 [Superpowers](https://github.com/obra/superpowers) 的启发，感谢 Jesse Vincent 创建了优秀的 Skills 系统。
