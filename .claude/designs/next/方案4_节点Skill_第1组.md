# 方案4：节点 Skill 第1组（需求阶段）

**版本**: v1.0
**创建日期**: 2026-03-01
**状态**: ⏳ 待实施
**预估工作量**: 30-40分钟

---

## 📋 方案概述

### 目标

实现 Cadence 流程的第1组节点 Skills（需求阶段），包含3个核心节点：
1. **Brainstorm** - 需求探索
2. **Analyze** - 存量分析
3. **Requirement** - 需求分析

### 核心内容

**3 个节点 Skills**：

1. **brainstorming**
   - 源文件：`superpowers/skills/brainstorming/SKILL.md`
   - 用途：需求探索，生成PRD
   - 触发：任何创造性工作之前

2. **analyze**
   - 设计：基于 v2.4 方案设计
   - 用途：存量分析，理解现有代码
   - 触发：涉及现有系统修改时

3. **requirement**
   - 设计：基于 v2.4 方案设计
   - 用途：需求分析，生成详细需求文档
   - 触发：已有PRD，需要细化时

### 依赖关系

- **前置依赖**：方案1（基础架构）、方案2（元Skill）、方案3（质量保证）
- **后续依赖**：方案5（设计阶段节点）

---

## 🎯 实施步骤

### 步骤1：创建 Skills 目录结构（3个）

```bash
mkdir -p skills/brainstorming
mkdir -p skills/analyze
mkdir -p skills/requirement
```

### 步骤2：复制 Brainstorming Skill

**直接复制 superpowers 的 brainstorming skill**：

```bash
cp /home/michael/workspace/github/superpowers/skills/brainstorming/SKILL.md skills/brainstorming/SKILL.md
```

**重要说明**：
- ✅ 直接复制，不做任何修改
- ✅ 保持与 superpowers 完全一致
- ❌ 不要修改、精简或优化

### 步骤3：创建 Analyze Skill

**基于设计文档创建完整的 Analyze Skill**：

文件：`skills/analyze/SKILL.md`

**设计要点**：
- 使用 Serena MCP 工具进行代码分析
- 包含完整的 When to Use 流程图
- 包含详细的 The Process 流程
- 包含 Integration 说明

### 步骤4：创建 Requirement Skill

**基于设计文档创建完整的 Requirement Skill**：

文件：`skills/requirement/SKILL.md`

**设计要点**：
- 支持 PRD 输入和存量分析报告输入
- 包含完整的用户故事和验收标准
- 包含存量复用规划
- 包含 Integration 说明

### 步骤5：创建 Commands（3个）

**创建对应的命令映射**：

```bash
# 创建命令文件
cat > commands/brainstorm.md << 'EOF'
---
skill: brainstorming
---

需求探索 - 通过对话式探索，帮助用户明确需求，生成PRD文档。
EOF

cat > commands/analyze.md << 'EOF'
---
skill: analyze
---

存量分析 - 分析现有代码和架构，理解依赖关系。
EOF

cat > commands/requirement.md << 'EOF'
---
skill: requirement
---

需求分析 - 基于 PRD 和存量分析，生成详细需求文档。
EOF
```

### 步骤6：验证 Skills

**验证清单**：
- [ ] 所有 3 个 Skills 目录创建成功
- [ ] brainstorming 完全复制自 superpowers
- [ ] analyze 和 requirement 基于设计文档完整创建
- [ ] 所有 SKILL.md 文件格式正确
- [ ] Commands 创建成功

### 步骤7：Git 提交

```bash
git add skills/* commands/*
git commit -m "feat: 实施方案4 - 节点Skill第1组（需求阶段）"
git push
```

---

## 📊 进度预估

| 步骤 | 预估时间 | 说明 |
|------|---------|------|
| 步骤1：创建目录 | 1分钟 | 3个目录 |
| 步骤2：复制Brainstorming | 2分钟 | 直接复制 |
| 步骤3：创建Analyze | 10-15分钟 | 基于设计创建 |
| 步骤4：创建Requirement | 10-15分钟 | 基于设计创建 |
| 步骤5：创建Commands | 5分钟 | 3个命令 |
| 步骤6：验证 | 2分钟 | 完整性检查 |
| 步骤7：Git提交 | 5分钟 | 提交和推送 |
| **总计** | **35-45分钟** | **完整实施** |

---

## ✅ 验收标准

### 功能验收

- [ ] 所有 3 个 Skills 成功创建
- [ ] brainstorming 与 superpowers 完全一致
- [ ] analyze 包含完整的流程和工具使用
- [ ] requirement 包含完整的验收标准和存量复用
- [ ] 所有 Skills 可以独立使用
- [ ] 所有 Commands 可以正确调用

### 质量验收

- [ ] Skills 格式符合标准
- [ ] 包含完整的 When to Use 部分
- [ ] 包含完整的 The Process 部分
- [ ] 包含完整的 Integration 部分
- [ ] 包含 Red Flags 和检查清单

### Git 验收

- [ ] 提交信息规范
- [ ] 推送成功
- [ ] 无遗漏文件

---

## 🔧 技术细节

### Brainstorming 实现策略

**原则**：完全复制 superpowers，不做任何修改

**原因**：
1. superpowers 的 brainstorming 已经非常成熟
2. 经过大量实践验证
3. 避免引入不必要的修改风险
4. 保持与 superpowers 的一致性

### Analyze 实现策略

**核心功能**：
- 读取 CLAUDE.md 获取技术栈
- 使用 Serena MCP 分析代码
- 生成存量分析报告

**关键工具**：
- `mcp__serena__list_dir` - 扫描项目结构
- `mcp__serena__get_symbols_overview` - 获取符号概览
- `mcp__serena__find_referencing_symbols` - 分析依赖关系

**输出产物**：
- `.claude/docs/{date}_存量分析_{模块名称}_v1.0.md`

### Requirement 实现策略

**核心功能**：
- 读取 PRD 和存量分析报告
- 生成用户故事和验收标准
- 规划存量复用

**关键特性**：
- 验收标准必须清晰到可推导测试用例
- 包含存量复用规划
- 不包含数据模型设计（由 Design 负责）

**输出产物**：
- `.claude/docs/{date}_需求文档_{功能名称}_v1.0.md`

### 文件结构

```
skills/
├── brainstorming/
│   └── SKILL.md                    # 直接复制自 superpowers
├── analyze/
│   └── SKILL.md                    # 基于设计文档创建
└── requirement/
    └── SKILL.md                    # 基于设计文档创建

commands/
├── brainstorm.md                   # 映射到 brainstorming skill
├── analyze.md                      # 映射到 analyze skill
└── requirement.md                  # 映射到 requirement skill
```

---

## ⚠️ 注意事项

### 必须遵守

- ✅ brainstorming 必须完全复制 superpowers
- ✅ analyze 和 requirement 必须基于设计文档完整实现
- ✅ 所有 Skills 必须包含完整的 When to Use 和 The Process
- ✅ 所有 Skills 必须包含 Integration 说明

### 禁止行为

- ❌ 不要修改 brainstorming 的任何内容
- ❌ 不要简化 analyze 和 requirement 的流程
- ❌ 不要遗漏任何关键检查清单和 Red Flags
- ❌ 不要跳过 Integration 部分

---

## 📚 参考资料

### 相关文档

- [方案1：基础架构 + 配置 + Hooks](./方案1_基础架构_配置_Hooks.md)
- [方案2：元 Skill + Init Skill](./方案2_元Skill_InitSkill.md)
- [方案3：前置 Skill + 支持 Skill](./方案3_前置Skill_支持Skill.md)
- [Skill Design: Brainstorming](./skills/brainstorming/SKILL.md)
- [Skill Design: Analyze](./skills/analyze/SKILL.md)
- [Skill Design: Requirement](./skills/requirement/SKILL.md)

### 源项目

- **superpowers 项目**：`/home/michael/workspace/github/superpowers`
- **Brainstorming 源文件**：`superpowers/skills/brainstorming/SKILL.md`

### 设计文档

- **主方案文档**：`.claude/designs/2026-02-25_技术方案_使用Claude_Code_Skills的AI自动化开发方案_v2.4.md`
- **Analyze 设计**：`.claude/designs/2026-02-25_Skill_Analyze_v1.0.md`
- **Requirement 设计**：`.claude/designs/2026-02-25_Skill_Requirement_v1.0.md`

---

## 🎯 下一步

完成方案4后，可以继续：

1. **方案5**：节点 Skill 第2组（Design、Design Review、Plan）
2. **方案6**：节点 Skill 第3组（Git Worktrees、Subagent Development）
3. **方案7**：流程 Skill + 进度追踪

---

**创建日期**: 2026-03-01
**最后更新**: 2026-03-01
**维护者**: Cadence Team
