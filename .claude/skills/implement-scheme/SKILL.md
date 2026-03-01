---
name: implement-scheme
description: "方案实施 - 设计并实施完整的方案（方案文档、Skills、Commands），包括设计、创建、验证、保存、提交的完整流程。触发条件：用户说'开始方案X设计'、'实施方案X'。自动参考superpowers和现有skills，输出完整可用的文档，支持网络检索验证官方规范，用户确认后保存并提交。"
---

# Implement Scheme - 方案实施

## Overview

设计并实施完整的方案，包括方案文档、Skills、Commands 的创建、验证、保存和提交。这是一个端到端的工作流 skill，整合了设计、验证、保存、提交的完整流程。

**关键职责：**
- ✅ 设计方案文档（参考 superpowers 和现有 skills）
- ✅ 创建完整可用的 Skills（不需要修改）
- ✅ 创建完整可用的 Commands（不需要修改）
- ✅ 验证 Skills 符合官方规范（支持网络检索）
- ✅ 用户确认后保存会话并提交

## When to Use

### 触发条件
当：
- 用户说"开始方案X设计"
- 用户说"实施方案X"
- 用户说"完成方案X"
- 需要设计并实施一个完整的方案

### 前置条件
- ✅ 已有方案计划（知道要设计什么）
- ✅ 了解参考项目（superpowers 或其他）

## The Process

### 详细流程

```mermaid
graph TB
    A[接收任务] --> A1[理解方案需求]
    A1 --> A2[读取参考项目]

    A2 --> B[设计方案文档]
    B --> B1[确定方案范围]
    B1 --> B2[设计Skills清单]
    B2 --> B3[设计Commands清单]

    B3 --> C[创建Skills]
    C --> C1[编写SKILL.md]
    C1 --> C2[遵循官方规范]
    C2 --> C3[完整可用不需要修改]

    C3 --> D[创建Commands]
    D --> D1[编写command.md]
    D1 --> D2[引用对应Skill]
    D2 --> D3[完整可用不需要修改]

    D3 --> E[创建方案文档]
    E --> E1[方案概述]
    E1 --> E2[引用Skills和Commands]
    E2 --> E3[流程图和设计亮点]

    E3 --> F{用户确认方案?}
    F -->|需要调整| G[调整方案]
    G --> F

    F -->|准确| H[验证Skills]
    H --> H1{是否符合官方规范?}

    H1 -->|不确定| H2[网络检索验证]
    H2 --> H3[分析官方文档]
    H3 --> H4[确认规范要求]
    H4 --> H5{是否需要优化?}

    H1 -->|符合| I
    H5 -->|需要| H6[优化Skills]
    H5 -->|不需要| I
    H6 --> I

    I[用户最终确认] --> I1{确认结果?}
    I1 -->|需要修改| G

    I1 -->|准确| J[保存会话]
    J --> J1[/sc:save]
    J1 --> J2[保存会话记录]
    J2 --> J3[保存技术规范]
    J3 --> J4[保存项目进度]

    J4 --> K[Git提交]
    K --> K1[git add]
    K1 --> K2[git commit]
    K2 --> K3[git push]

    K3 --> L[完成]
```

### 步骤说明

#### Phase 1: 理解需求（5-10分钟）

1. **理解方案需求**
   - 明确方案编号和名称（如：方案5 - 节点Skill第2组）
   - 理解方案范围（包含哪些 Skills）
   - 确定输出路径：
     - 方案文档：`.claude/designs/next/`
     - Skills：`.claude/designs/next/skills/`
     - Commands：`.claude/designs/next/commands/`

2. **读取参考项目**
   - 读取 superpowers 项目的 skills（如需要）
   - 读取当前项目的现有 skills
   - 理解参考项目的格式和风格

#### Phase 2: 设计方案（10-20分钟）

3. **设计方案文档**
   - 方案概述（包含哪些 Skills）
   - Skills 清单和职责
   - Skills 之间的依赖关系
   - 流程图（使用 mermaid）
   - 设计亮点

4. **设计 Skills 清单**
   - 每个 Skill 的名称、描述、功能
   - 每个 Skill 的触发条件
   - 每个 Skill 的依赖关系
   - 每个 Skill 的输出产物

5. **设计 Commands 清单**
   - 每个 Command 对应的 Skill
   - Command 的使用场景
   - Command 的相关命令

#### Phase 3: 创建 Skills（30-60分钟）

6. **编写 SKILL.md**
   - **YAML Frontmatter**（遵循官方规范）：
     ```yaml
     ---
     name: skill-name
     description: "功能描述。触发条件：... 依赖关系：..."
     ---
     ```
     - 只使用官方支持的字段（name, description, argument-hint 等）
     - 将触发条件、依赖关系整合到 description 中

   - **Overview**: 概述和关键职责
   - **When to Use**: 使用场景、触发条件、前置条件
   - **The Process**: 详细流程（包含流程图）
   - **Input/Output**: 输入来源和输出产物
   - **Integration**: 与其他 Skills 的集成
   - **Checklist**: 关键检查清单
   - **Red Flags**: 常见错误警示

7. **遵循官方规范**
   - ✅ 支持中文内容
   - ✅ 使用 mermaid 或 digraph（都是可接受的）
   - ✅ YAML frontmatter 只使用官方支持的字段
   - ✅ Description 包含触发条件和依赖关系
   - ✅ 内容结构完整（Overview、When to Use、The Process 等）

8. **完整可用不需要修改**
   - 每个 Skill 必须完整、详细
   - 可以直接部署使用
   - 不需要用户修改

#### Phase 4: 创建 Commands（10-15分钟）

9. **编写 command.md**
   - 标题：`/command-name - 功能说明`
   - 使用场景
   - 功能描述
   - 输出产物
   - 相关命令（前置、下一步）

10. **引用对应 Skill**
    - Command 文档简洁明了
    - 指向对应的 Skill 文档

#### Phase 5: 创建方案文档（10-15分钟）

11. **编写方案文档**
    - 方案概述
    - 包含的 Skills 清单
    - Skills 依赖关系图
    - 流程图
    - 设计亮点
    - 引用 Skills 和 Commands 文档

#### Phase 6: 用户确认（5-10分钟）

12. **展示方案摘要**
    - 方案概述（3-5 个关键点）
    - Skills 清单和职责
    - 依赖关系图
    - 设计亮点

13. **用户确认**
    询问："这个方案是否可行？有什么要调整的？"
    - ✅ 可行 → 进入验证阶段
    - ⚠️ 需要调整 → 调整方案
    - ❌ 不可行 → 重新设计

#### Phase 7: 验证 Skills（10-20分钟）

14. **初步验证**
    - 检查 YAML frontmatter 是否符合官方规范
    - 检查是否使用了非官方字段
    - 检查内容结构是否完整
    - 检查流程图格式是否正确

15. **网络检索验证**（如需要）
    当不确定规范时：
    - 使用 Web Search 搜索 "Claude Code Skills 官方规范 2025"
    - 使用 webReader 读取官方文档（避免网络错误）
    - 对比 superpowers 等参考项目
    - 分析官方支持的格式

16. **确认规范要求**
    - 语言支持（中文 vs 英文）
    - YAML frontmatter 字段
    - 流程图格式（mermaid vs digraph）
    - 内容结构要求

17. **优化 Skills**（如需要）
    如果发现不符合规范：
    - 移除非官方字段（path, triggers, dependencies 等）
    - 将触发条件、依赖关系整合到 description
    - 调整内容结构
    - 更新流程图格式（如需要）

#### Phase 8: 最终确认（5分钟）

18. **展示验证结果**
    - 验证通过的项目
    - 已优化的项目
    - 最终确认 Skills 可用

19. **用户最终确认**
    询问："Skills 已验证并优化，确认提交吗？"
    - ✅ 确认 → 进入保存阶段
    - ⚠️ 需要修改 → 返回修改

#### Phase 9: 保存会话（5分钟）

20. **执行 /sc:save**
    - 保存会话记录（sessions/{date}_schemeX_completion）
    - 保存技术规范（patterns/...）
    - 保存项目进度（progress/...）

21. **保存内容**
    - 会话概览和主要成果
    - 创建的文件清单
    - Git 提交信息
    - 关键技术发现
    - 设计决策和经验教训

#### Phase 10: Git 提交（5分钟）

22. **Git Add**
    ```bash
    git add .claude/designs/next/方案X_*.md
    git add .claude/designs/next/skills/*/
    git add .claude/designs/next/commands/*.md
    ```

23. **Git Commit**
    ```bash
    git commit -m "feat: 实施方案X - 方案名称

    - 新增 skill1: 功能描述
    - 新增 skill2: 功能描述
    - 新增 skill3: 功能描述
    - 新增对应的 command 文件
    - 遵循官方规范，完整可用

    Co-Authored-By: Claude Sonnet 4.6 <noreply@anthropic.com>"
    ```

24. **Git Push**
    ```bash
    git push
    ```

## 输入来源

1. **用户需求**: 方案编号、方案名称、方案范围
2. **参考项目**: superpowers、现有 skills
3. **官方文档**: Claude Code Skills 官方规范
4. **项目计划**: 了解当前进度和下一步

## 输出产物

### 1. 方案文档
**路径**: `.claude/designs/next/方案X_节点Skill_第Y组.md`
**内容**: 方案概述、Skills 清单、依赖关系、流程图、设计亮点

### 2. Skills
**路径**: `.claude/designs/next/skills/{skill-name}/SKILL.md`
**要求**: 完整可用、符合官方规范、不需要修改

### 3. Commands
**路径**: `.claude/designs/next/commands/{command-name}.md`
**要求**: 简洁明了、引用对应 Skill

### 4. 会话记录
**路径**: `.serena/memories/sessions/{date}_schemeX_completion.md`
**内容**: 会话记录、技术发现、设计决策

### 5. Git 提交
**Commit Message**: `feat: 实施方案X - 方案名称`
**包含**: 方案文档、Skills、Commands

## 关键检查清单 ✅

### 设计阶段
- [ ] 方案需求理解：是否明确方案范围和输出路径？
- [ ] 参考项目读取：是否读取了 superpowers 和现有 skills？
- [ ] 方案文档设计：是否包含方案概述、Skills 清单、依赖关系？

### 创建阶段
- [ ] Skills 完整性：每个 Skill 是否完整详细？
- [ ] Skills 可用性：是否可以直接使用不需要修改？
- [ ] Commands 完整性：每个 Command 是否简洁明了？
- [ ] 方案文档引用：是否引用了 Skills 和 Commands 文档？

### 验证阶段
- [ ] YAML frontmatter：是否只使用官方支持的字段？
- [ ] Description 字段：是否包含触发条件和依赖关系？
- [ ] 内容结构：是否包含 Overview、When to Use、The Process 等？
- [ ] 流程图格式：是否使用 mermaid 或 digraph？
- [ ] 语言支持：是否确认支持中文内容？
- [ ] 官方规范：是否符合 Claude Code Skills 官方规范？

### 确认阶段
- [ ] 用户确认方案：方案是否可行？
- [ ] 用户确认 Skills：Skills 是否可用？
- [ ] 用户最终确认：是否确认提交？

### 保存阶段
- [ ] 会话记录：是否保存了会话记录？
- [ ] 技术规范：是否保存了技术发现？
- [ ] 项目进度：是否更新了项目进度？

### 提交阶段
- [ ] Git add：是否添加了所有文件？
- [ ] Git commit：是否创建了规范的 commit message？
- [ ] Git push：是否成功推送到远程仓库？

## Red Flags ⚠️

| 错误做法 | 正确做法 |
|---------|---------|
| ❌ 不读取参考项目就开始设计 | ✅ 先读取 superpowers 和现有 skills |
| ❌ Skills 不完整需要用户修改 | ✅ Skills 必须完整可用不需要修改 |
| ❌ 使用非官方 YAML 字段 | ✅ 只使用官方支持的字段 |
| ❌ 不验证官方规范 | ✅ 使用网络检索验证官方规范 |
| ❌ 用户确认前就提交 | ✅ 必须经过用户确认 |
| ❌ 不保存会话记录 | ✅ 使用 /sc:save 保存会话 |
| ❌ Commit message 不规范 | ✅ 使用规范的 commit message |

## 时间预估

| 方案复杂度 | Skills 数量 | 总时间 | 说明 |
|-----------|-----------|--------|------|
| 🟢 简单 | 1-2 个 | 30-50 分钟 | 单个 Skill，流程简单 |
| 🟡 中等 | 3-4 个 | 60-90 分钟 | 多个 Skills，有一定依赖关系 |
| 🔴 复杂 | 5+ 个 | 90-150 分钟 | 多个 Skills，复杂依赖关系 |

## 官方规范参考

### YAML Frontmatter 支持的字段
- `name` (可选) - Skill 的显示名称
- `description` (推荐) - 功能和使用时机说明
- `argument-hint` (可选) - 参数提示
- `disable-model-invocation` (可选) - 防止自动加载
- `user-invocable` (可选) - 控制菜单可见性
- `allowed-tools` (可选) - 限制工具访问
- `model` (可选) - 指定模型
- `context` (可选) - 设置为 fork 在 subagent 中运行
- `agent` (可选) - 指定 subagent 类型
- `hooks` (可选) - 生命周期 hooks

### 不支持的自定义字段
- ❌ `path` - 应移除
- ❌ `triggers` - 应整合到 description
- ❌ `dependencies` - 应整合到 description
- ❌ `conditions` - 应整合到 description

### 官方文档
- 英文版：https://code.claude.com/docs/skills
- 中文版：https://code.claude.com/docs/zh-CN/skills

## Integration

### 前置依赖
- **项目计划**: 了解当前进度和下一步
- **参考项目**: superpowers 或其他参考项目

### 下一步
- 继续实施下一个方案
- 或测试已实施的 Skills

### 相关 Skills
- **sc:save**: 保存会话上下文
- **sc:load**: 加载会话上下文

## 示例

### 示例：实施方案5

**用户输入**:
```
开始方案5设计

## 参考
【/home/michael/workspace/github/superpowers】
【/home/michael/workspace/github/Cadence-skills/skills】

## 要求
1. 按照计划
2. 方案文档输出在.claude/designs/next/
3. skills输出在.claude/designs/next/skills/
4. skills必须是完整可用的不需要修改的
5. commands输出在.claude/designs/next/commands/
6. commands必须是完整可用的不需要修改的
7. 方案文档中需要引用skills文档和commands文档
8. 方案写完后需要由我确认
```

**执行流程**:
1. 理解方案5需求（节点Skill第2组 - 设计阶段）
2. 读取 superpowers 和现有 skills
3. 设计方案文档（包含 design, design-review, plan 三个 skills）
4. 创建 3 个 Skills（完整可用的 SKILL.md）
5. 创建 3 个 Commands（简洁的 command.md）
6. 创建方案文档（方案5_节点Skill_第2组.md）
7. 用户确认方案
8. 验证 Skills（网络检索官方规范，优化 YAML frontmatter）
9. 用户最终确认
10. 保存会话（/sc:save）
11. Git 提交（feat: 实施方案5 - 节点Skill第2组（设计阶段））

**输出产物**:
- 方案文档：`.claude/designs/next/方案5_节点Skill_第2组.md`
- Skills：`design/SKILL.md`, `design-review/SKILL.md`, `plan/SKILL.md`
- Commands：`design.md`, `design-review.md`, `plan.md`
- 会话记录：`.serena/memories/sessions/2026-03-02_scheme5_completion.md`
- Git Commit：`bc37908`

## 确认机制

### 方案确认
展示方案摘要（3-5 个关键点、Skills 清单、依赖关系、设计亮点）
询问："这个方案是否可行？有什么要调整的？"
├── ✅ 可行 → 进入验证阶段
├── ⚠️ 需要调整 → 调整方案
└── ❌ 不可行 → 重新设计

### Skills 确认
展示验证结果（验证通过的项目、已优化的项目）
询问："Skills 已验证并优化，确认提交吗？"
├── ✅ 确认 → 进入保存阶段
└── ⚠️ 需要修改 → 返回修改

## 跳过条件

- 已存在完整的方案文档和 Skills
- 用户明确表示不需要
