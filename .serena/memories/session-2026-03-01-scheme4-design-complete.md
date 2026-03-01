# 方案4设计完成记录 - 节点Skill第1组（需求阶段）

**日期**: 2026-03-01
**状态**: ✅ 设计完成，⏳ 待实施
**类型**: 设计里程碑

---

## 📋 完成内容

### 方案概述
完成 Cadence 流程第1组节点 Skills（需求阶段）的完整设计，包含3个核心节点。

### 设计产物

#### 1. 总体设计文档
- **文件**: `.claude/designs/next/方案4_节点Skill_第1组.md`
- **内容**: 
  - 完整的实施步骤（7个步骤）
  - 详细的验收标准
  - 技术实现细节
  - 进度预估（30-40分钟）
- **状态**: ✅ 完成

#### 2. Skills 设计文档（3个）

**2.1 Brainstorming Skill**
- **文件**: `.claude/designs/next/skills/brainstorming/SKILL.md`
- **策略**: 直接复制 superpowers，不做修改
- **用途**: 需求探索，生成PRD
- **状态**: ✅ 设计完成

**2.2 Analyze Skill**
- **文件**: `.claude/designs/next/skills/analyze/SKILL.md`
- **策略**: 基于 v2.4 方案全新设计
- **用途**: 存量分析，理解现有代码
- **核心工具**: Serena MCP（list_dir, get_symbols_overview, find_referencing_symbols）
- **输出**: `.claude/docs/{date}_存量分析_{模块名称}_v1.0.md`
- **状态**: ✅ 设计完成

**2.3 Requirement Skill**
- **文件**: `.claude/designs/next/skills/requirement/SKILL.md`
- **策略**: 基于 v2.4 方案全新设计
- **用途**: 需求分析，生成详细需求文档
- **输入**: PRD + 存量分析报告
- **输出**: `.claude/docs/{date}_需求文档_{功能名称}_v1.0.md`
- **状态**: ✅ 设计完成

#### 3. Commands 设计文档（3个）

| Command | 映射Skill | 文件 | 状态 |
|---------|----------|------|------|
| `/brainstorm` | brainstorming | commands/brainstorm.md | ✅ 完成 |
| `/analyze` | analyze | commands/analyze.md | ✅ 完成 |
| `/requirement` | requirement | commands/requirement.md | ✅ 完成 |

---

## 🎯 设计亮点

### 1. 灵活的依赖关系
- **非强制前置**：Analyze 和 Requirement 不强制作为前置节点
- **支持已有文档**：可以直接使用现有的 PRD 和分析报告
- **适应多种场景**：完整流程 / 快速流程 / 探索流程

### 2. 完整的 Serena MCP 集成
- **Analyze**: 深度集成 Serena 代码分析能力
- **符号级分析**: 使用 get_symbols_overview 和 find_referencing_symbols
- **依赖关系追踪**: 完整的代码依赖分析

### 3. 清晰的产出物定义
- **Brainstorm**: PRD 文档
- **Analyze**: 存量分析报告
- **Requirement**: 详细需求文档（含验收标准）

### 4. 存量复用规划
- **Requirement Skill**: 特别强调存量代码复用
- **减少重复开发**: 充分利用现有代码资产
- **技术债务识别**: 在需求阶段识别潜在重构点

---

## 📊 整体进度

| 阶段 | 方案 | 设计状态 | 实施状态 | 完成日期 |
|------|------|---------|---------|---------|
| 基础设施 | 方案1 | ✅ 完成 | ✅ 完成 | 2026-03-01 |
| 基础设施 | 方案2 | ✅ 完成 | ✅ 完成 | 2026-03-01 |
| 质量保证 | 方案3 | ✅ 完成 | ✅ 完成 | 2026-03-01 |
| **需求阶段** | **方案4** | **✅ 完成** | **⏳ 待实施** | **2026-03-01** |
| 设计阶段 | 方案5 | ⏳ 待设计 | ⏳ 待实施 | - |
| 开发阶段 | 方案6 | ⏳ 待设计 | ⏳ 待实施 | - |
| 流程编排 | 方案7 | ⏳ 待设计 | ⏳ 待实施 | - |

**设计进度**: 4/7 (57%)
**实施进度**: 3/7 (43%)

---

## 🔧 实施策略

### Brainstorming 实施策略
```bash
# 直接复制 superpowers 版本
cp /home/michael/workspace/github/superpowers/skills/brainstorming/SKILL.md \
   skills/brainstorming/SKILL.md
```

**原则**:
- ✅ 完全复制，零修改
- ✅ 保持与 superpowers 一致
- ❌ 禁止优化或精简

### Analyze 实施策略
```bash
# 基于设计文档创建
# 文件: skills/analyze/SKILL.md
```

**核心功能**:
- 读取 CLAUDE.md 获取技术栈
- 使用 Serena MCP 分析代码结构
- 生成存量分析报告

**关键工具**:
- `mcp__serena__list_dir` - 项目结构扫描
- `mcp__serena__get_symbols_overview` - 符号概览
- `mcp__serena__find_referencing_symbols` - 依赖分析

### Requirement 实施策略
```bash
# 基于设计文档创建
# 文件: skills/requirement/SKILL.md
```

**核心功能**:
- 读取 PRD（来自 Brainstorm）
- 读取存量分析报告（来自 Analyze）
- 生成用户故事和验收标准
- 规划存量代码复用

---

## ⏱️ 实施预估

| 步骤 | 预估时间 | 说明 |
|------|---------|------|
| 创建目录结构 | 1分钟 | 3个目录 |
| 复制 Brainstorming | 2分钟 | 直接复制 |
| 创建 Analyze | 10-15分钟 | 基于设计创建 |
| 创建 Requirement | 10-15分钟 | 基于设计创建 |
| 创建 Commands | 5分钟 | 3个命令文件 |
| 验证完整性 | 2分钟 | 检查所有文件 |
| Git 提交推送 | 5分钟 | 提交和推送 |
| **总计** | **35-45分钟** | **完整实施** |

---

## ✅ 验收标准

### 设计验收（已完成）
- [x] 方案4总体设计文档完成
- [x] 3个Skills设计文档完成
- [x] 3个Commands设计文档完成
- [x] 所有设计文档格式规范
- [x] 包含完整的实施步骤
- [x] 包含详细的验收标准

### 实施验收（待执行）
- [ ] 所有 3 个 Skills 成功创建到 skills/ 目录
- [ ] brainstorming 与 superpowers 完全一致
- [ ] analyze 包含完整的 Serena MCP 集成
- [ ] requirement 包含完整的验收标准和存量复用
- [ ] 所有 3 个 Commands 创建到 commands/ 目录
- [ ] 所有 Skills 可以独立使用
- [ ] Git 提交规范，推送成功

---

## 📁 文件结构

### 设计文件（已完成）
```
.claude/designs/next/
├── 方案4_节点Skill_第1组.md           # ✅ 总体设计
├── skills/
│   ├── brainstorming/
│   │   └── SKILL.md                   # ✅ 设计完成
│   ├── analyze/
│   │   └── SKILL.md                   # ✅ 设计完成
│   └── requirement/
│       └── SKILL.md                   # ✅ 设计完成
└── commands/
    ├── brainstorm.md                  # ✅ 设计完成
    ├── analyze.md                     # ✅ 设计完成
    └── requirement.md                 # ✅ 设计完成
```

### 实施文件（待创建）
```
skills/
├── brainstorming/                     # ⏳ 待创建
│   └── SKILL.md
├── analyze/                           # ⏳ 待创建
│   └── SKILL.md
└── requirement/                       # ⏳ 待创建
    └── SKILL.md

commands/
├── brainstorm.md                      # ⏳ 待创建
├── analyze.md                         # ⏳ 待创建
└── requirement.md                     # ⏳ 待创建
```

---

## 🔗 依赖关系

### 前置依赖（已完成）
- ✅ **方案1**: 基础架构 + 配置 + Hooks
- ✅ **方案2**: 元Skill + Init Skill
- ✅ **方案3**: 质量保证Skills

### 后续依赖（待实施）
- ⏳ **方案5**: 节点Skill第2组（Design、Design Review、Plan）
- ⏳ **方案6**: 节点Skill第3组（Git Worktrees、Subagent Development）
- ⏳ **方案7**: Flow Skills + 进度追踪

---

## 🎓 关键设计决策

### 1. 为什么直接复制 Brainstorming？
- superpowers 的 brainstorming 已经非常成熟
- 经过大量实践验证
- 避免引入不必要的修改风险
- 保持与 superpowers 的一致性

### 2. 为什么 Analyze 和 Requirement 需要全新设计？
- **Analyze**: 需要深度集成 Serena MCP 工具
- **Requirement**: 需要支持存量复用规划
- 两者都是 Cadence 特有的能力
- superpowers 没有对应的实现

### 3. 为什么允许跳过 Analyze/Requirement？
- 支持多种开发场景
- 用户可能已有 PRD 和分析报告
- 提供流程灵活性（完整/快速/探索）
- 不强制线性流程

---

## 🎯 下一步行动

### 立即行动（实施）
1. **执行实施步骤**
   - 创建 3 个 Skills 目录
   - 复制 Brainstorming Skill
   - 创建 Analyze 和 Requirement Skills
   - 创建 3 个 Commands
   - 验证和测试

2. **Git 提交**
   ```bash
   git add skills/* commands/*
   git commit -m "feat: 实施方案4 - 节点Skill第1组（需求阶段）"
   git push
   ```

### 后续规划（设计）
3. **设计方案5**
   - Design（技术设计）
   - Design Review（设计审查）
   - Plan（实现计划）

4. **设计方案6**
   - Git Worktrees（环境隔离）
   - Subagent Development（代码实现）

5. **设计方案7**
   - 3个流程Skills
   - 进度追踪系统

---

## 📝 备注

- 设计阶段已完成，所有设计文档齐全
- 实施阶段预计 35-45 分钟
- Brainstorming 必须完全复制 superpowers 版本
- Analyze 和 Requirement 基于设计文档完整实现
- 所有 Skills 必须包含完整的流程和工具说明

---

**创建时间**: 2026-03-01
**最后更新**: 2026-03-01
**记录人**: Claude Sonnet 4.6
**类型**: 设计完成记录