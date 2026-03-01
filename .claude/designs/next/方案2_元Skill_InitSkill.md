# 方案2：元 Skill + Init Skill

**版本**: v1.0
**创建日期**: 2026-03-01
**预估工作量**: 2-3小时
**状态**: ✅ 设计完成，⏳ 待实施
**前置依赖**: 方案1（基础架构）

---

## 📋 概述

**目标**：实现 Cadence 的入口机制，包括元 Skill（using-cadence）和项目初始化 Skill（cadence:init）。

**核心价值**：
- **using-cadence**：Cadence Skills 系统的"守门员"和"路由器"
- **cadence:init**：项目初始化为 Cadence 管理的标准化流程

**适用场景**：
- 所有使用 Cadence 的会话（自动注入 using-cadence）
- 将现有项目转换为 Cadence 项目（使用 cadence:init）

---

## 🎯 包含内容

### 1. 元 Skill：using-cadence

**核心作用**：
- 确保Claude在处理开发任务时强制检查是否有相关Skill
- 智能路由用户意图到正确的Skill
- 防止跳跃开发流程的关键步骤

**文件位置**：`.claude/designs/skills/using-cadence/SKILL.md`

**关键特性**：

#### 1.1 强制性检查机制

```markdown
<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a Cadence skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.
</EXTREMELY-IMPORTANT>
```

#### 1.2 Skill 优先级

**P1 - 理解现状类**（优先执行）
- cadence-analyze - 存量代码分析
- cadence-brainstorm - 需求探索
- cadence-requirement - 需求分析

**P2 - 规划设计类**（第二优先）
- cadence-design - 技术设计
- cadence-design-review - 设计审查
- cadence-plan - 实现计划

**P3 - 执行实现类**（最后执行）
- cadence-using-git-worktrees - 隔离环境
- cadence-subagent-development - 代码实现
- cadence-verification-before-completion - 完成验证
- cadence-finishing-a-development-branch - 完成分支

#### 1.3 触发关键词映射（14+ 个）

| 用户意图 | 触发词 | 推荐Skill |
|---------|--------|----------|
| 需求不明确 | "需求探索"、"不明确"、"讨论" | cadence-brainstorm |
| 存量代码 | "存量"、"现有代码"、"重构" | cadence-analyze |
| 需求分析 | "需求"、"PRD"、"产品需求" | cadence-requirement |
| 技术设计 | "设计"、"架构"、"方案" | cadence-design |
| 项目初始化 | "初始化"、"init"、"新项目" | cadence:init |
| ... | ... | ... |

#### 1.4 Red Flags（11 个危险思维模式）

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| ... | ... |

#### 1.5 示例工作流

**场景1：新功能开发**
```
用户: "帮我实现用户认证功能"

Claude 内部流程:
1. 检测到"实现" → 可能需要 cadence-brainstorm
2. 调用 Skill tool: cadence-brainstorm
3. Brainstorm 引导探索需求
4. 生成 PRD 文档
5. 用户确认后 → 自动建议下一步
```

---

### 2. Init Skill：cadence:init

**核心作用**：
- 将已有项目初始化为 Cadence 管理的项目
- 自动配置项目环境、规则、文档结构和技术栈

**文件位置**：`.claude/designs/skills/cadence:init/SKILL.md`

**关键特性**：

#### 2.1 12 个核心功能

| 序号 | 功能模块 | 说明 | 必需性 |
|------|---------|------|--------|
| 1 | Claude Code 初始化 | 调用 `/init` 命令 | ✅ 必须 |
| 2 | 语言规则配置 | 强制中文回答 | ✅ 必须 |
| 3 | 文档存储规则 | 配置 `.claude` 目录结构 | ✅ 必须 |
| 4 | 文档命名规范 | 标准化命名格式 | ✅ 必须 |
| 5 | 包管理器规则 | 前端 pnpm / Python uv | ⭐ 推荐 |
| 6 | Time MCP 规则 | 强制使用 time MCP 获取日期 | ✅ 必须 |
| 7 | 技术栈配置 | 生成 tech_stack 配置 | ✅ 必须 |
| 8 | MCP 配置 | 添加 time 和 serena MCP | ✅ 必须 |
| 9 | 目录结构创建 | 创建必要的目录结构 | ✅ 必须 |
| 10 | CLAUDE.md 中文化 | 使用中文重写 CLAUDE.md | ⭐ 推荐 |
| 11 | 项目类型检测 | 检测前端/后端/全栈 | ✅ 必须 |
| 12 | 进度追踪初始化 | 创建初始 checkpoint | ⭐ 推荐 |

#### 2.2 技术栈检测（支持 6 种语言）

- JavaScript/TypeScript
- Python
- Java (Maven/Gradle)
- Go
- Rust

#### 2.3 执行流程

```
1. 调用 /init
2. 添加强制规则（语言、文档存储、命名规范）
3. 检测项目类型 → 添加包管理器规则
4. 检测技术栈 → 用户确认 → 写入配置
5. 添加 MCP 配置（time、serena）
6. 创建目录结构
7. 创建 Checkpoint 和 Session Summary
8. 完成
```

---

### 3. Command 映射：init

**核心作用**：提供 `/cadence:init` 命令的快捷调用

**文件位置**：`.claude/designs/commands/init.md`

**内容**：
```markdown
---
description: "Initialize project as Cadence-managed with automatic configuration of environment, rules, and tech stack"
disable-model-invocation: true
---

Invoke the cadence:init skill and follow it exactly as presented to you
```

---

## 📋 实施步骤

### Step 1：复制 Skill 文件到项目

```bash
# 在 Cadence-skills 项目根目录执行

# 复制 using-cadence Skill
mkdir -p skills/using-cadence
cp .claude/designs/skills/using-cadence/SKILL.md skills/using-cadence/

# 复制 cadence:init Skill
mkdir -p skills/cadence:init
cp .claude/designs/skills/cadence:init/SKILL.md skills/cadence:init/

# 复制 init Command
cp .claude/designs/commands/init.md commands/
```

### Step 2：验证文件结构

确保文件结构如下：

```
Cadence-skills/
├── skills/
│   ├── using-cadence/
│   │   └── SKILL.md          ✅
│   └── cadence:init/
│       └── SKILL.md          ✅
└── commands/
    └── init.md               ✅
```

### Step 3：测试 SessionStart Hook

```bash
# 启动新的 Claude Code 会话
# 检查是否看到 using-cadence 的注入内容

# 预期看到：
# <EXTREMELY_IMPORTANT>
# 你拥有 Cadence 能力。
# ...
# </EXTREMELY_IMPORTANT>
```

### Step 4：测试 cadence:init

```bash
# 在 Claude Code 中执行
/cadence:init

# 预期行为：
# 1. 调用 /init 命令
# 2. 配置强制规则
# 3. 检测技术栈
# 4. 用户确认
# 5. 创建目录结构
# 6. 完成
```

---

## ✅ 验收标准

### using-cadence Skill
- [ ] 文件路径正确（`skills/using-cadence/SKILL.md`）
- [ ] 内容完整（包含所有必要部分）
- [ ] SessionStart hook 可以正常注入
- [ ] 触发关键词映射准确
- [ ] Red Flags 清晰明确

### cadence:init Skill
- [ ] 文件路径正确（`skills/cadence:init/SKILL.md`）
- [ ] 内容完整（12 个功能全部定义）
- [ ] 技术栈检测逻辑清晰
- [ ] 用户确认流程完整
- [ ] 跨平台兼容性考虑周全

### init Command
- [ ] 文件路径正确（`commands/init.md`）
- [ ] frontmatter 格式正确
- [ ] 可以正常触发 cadence:init Skill

### 功能验证
- [ ] `/cadence:init` 命令可以正常执行
- [ ] 技术栈检测准确
- [ ] 目录结构创建正确
- [ ] MCP 配置成功

---

## 📊 输出产物

1. **using-cadence Skill**：1个文件（SKILL.md）
2. **cadence:init Skill**：1个文件（SKILL.md）
3. **init Command**：1个文件（init.md）
4. **文档**：1个文件（README.md）

**总计**：4个文件

---

## ⚠️ 注意事项

### 1. SessionStart Hook 依赖

using-cadence Skill 需要 SessionStart hook 才能自动注入。

**确保**：
- 方案1已实施
- `hooks/session-start` 脚本有执行权限
- `skills/using-cadence/SKILL.md` 文件存在

### 2. 文件完整性

确保复制时保持目录结构：
- Skill 必须在 `skills/` 目录下
- Command 必须在 `commands/` 目录下

### 3. 测试顺序

1. 先测试 SessionStart hook（启动新会话）
2. 再测试 `/cadence:init` 命令

---

## 🔄 后续步骤

完成方案2后，可以继续：

1. **方案3**：前置 Skill + 支持 Skill
2. **方案4**：节点 Skill 第1组（需求阶段）
3. **方案5**：节点 Skill 第2组（设计阶段）
4. **方案6**：节点 Skill 第3组（开发阶段）
5. **方案7**：流程 Skill + 进度追踪

---

## 📚 相关文档

### 设计文档
- **主方案**: `.claude/designs/2026-02-25_技术方案_使用Claude_Code_Skills的AI自动化开发方案_v2.4.md`
- **Init Skill 原始设计**: `.claude/designs/2026-02-28_Skill_Init_v1.0.md`

### 实施文件
- **using-cadence Skill**: `.claude/designs/skills/using-cadence/SKILL.md`
- **cadence:init Skill**: `.claude/designs/skills/cadence:init/SKILL.md`
- **init Command**: `.claude/designs/commands/init.md`
- **使用说明**: `.claude/designs/skills/README.md`

### 参考资料
- **superpowers 参考**: `/home/michael/workspace/github/superpowers`

---

## 📝 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|---------|
| v1.0 | 2026-03-01 | 初始版本，包含 using-cadence 和 cadence:init 两个 Skill |

---

## 🎯 关键差异点

### 与 superpowers:using-superpowers 的差异

| 维度 | superpowers | Cadence |
|------|------------|---------|
| **触发范围** | 通用开发任务 | 结构化开发流程 |
| **Skill 数量** | 15个通用Skills | 22个专业Skills |
| **流程模式** | 单一模式 | 3种模式（完整/快速/探索） |
| **节点概念** | 无 | 8个核心节点（v2.4） |
| **优先级** | 无明确分级 | P1/P2/P3 三级 |

### 与 superpowers 无 Init Skill 的差异

superpowers 没有项目初始化 Skill，Cadence 新增了：
- **cadence:init** - 12个核心功能
- **自动配置** - 技术栈检测、MCP配置、目录创建
- **跨平台兼容** - macOS/Linux/Windows

---

**创建日期**: 2026-03-01
**状态**: ✅ 设计完成
**下一步**: 方案3 - 前置 Skill + 支持 Skill
