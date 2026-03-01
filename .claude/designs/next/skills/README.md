# 方案2：元 Skill + Init Skill

本目录包含方案2的完整实现文件。

## 📁 文件清单

### 1. 元 Skill：using-cadence

**文件位置**: `skills/using-cadence/SKILL.md`

**核心作用**：
- Cadence Skills 系统的"守门员"和"路由器"
- 确保Claude在处理开发任务时强制检查是否有相关Skill
- 智能路由用户意图到正确的Skill
- 防止跳跃开发流程的关键步骤

**关键内容**：
- ✅ 强制性检查机制（<EXTREMELY-IMPORTANT>）
- ✅ Skill 优先级（P1/P2/P3）
- ✅ 触发关键词映射（14+ 个）
- ✅ Red Flags（11 个危险思维模式）
- ✅ 与 Subagent、superpowers 的关系说明
- ✅ 示例工作流（3 个场景）
- ✅ 不适用场景说明

### 2. Init Skill：cadence:cadencing

**文件位置**: `skills/cadencing/SKILL.md`

**核心作用**：
- 将已有项目初始化为 Cadence 管理的项目
- 自动配置项目环境、规则、文档结构和技术栈

**关键内容**：
- ✅ 10项 Checklist（任务清单）
- ✅ Process Flow（流程图）
- ✅ 12 个核心功能（10 个必须 + 2 个推荐）
- ✅ 技术栈检测（支持 6 种语言）
- ✅ 跨平台兼容性（macOS/Linux/Windows）
- ✅ 用户确认流程
- ✅ 错误处理和参数说明

**标准化说明**：
- ✅ 文件长度：155行（符合 superpowers 标准：84-655行）
- ✅ 格式符合标准：Checklist + Process Flow + 简洁风格
- ✅ 可直接使用
- 📚 详细设计参考：`.claude/designs/2026-02-28_Skill_Init_v1.0.md`

### 3. Command 映射：init

**文件位置**: `commands/init.md`

**核心作用**：
- 提供 `/cadence:cadencing` 命令的快捷调用
- 通过 `disable-model-invocation: true` 直接调用 Skill

## 🔧 使用方式

### 在方案开发中使用

**Step 1：复制 Skill 文件到项目**

```bash
# 复制 using-cadence
cp -r .claude/designs/next/skills/using-cadence /path/to/Cadence-skills/skills/

# 复制 cadence:cadencing
cp -r .claude/designs/next/skills/cadencing /path/to/Cadence-skills/skills/

# 复制 command
cp .claude/designs/next/commands/init.md /path/to/Cadence-skills/commands/
```

**Step 2：验证文件结构**

```
Cadence-skills/
├── skills/
│   ├── using-cadence/
│   │   └── SKILL.md
│   └── init/
│       └── SKILL.md
└── commands/
    └── init.md
```

**Step 3：测试调用**

```bash
# 测试 using-cadence（通过 SessionStart hook 自动注入）
# 启动新的 Claude Code 会话

# 测试 cadence:cadencing
/cadence:cadencing
```

## 📋 验收标准

### using-cadence Skill
- [ ] 文件路径正确（`skills/using-cadence/SKILL.md`）
- [ ] 内容完整（包含所有必要部分）
- [ ] SessionStart hook 可以正常注入
- [ ] 触发关键词映射准确
- [ ] Red Flags 清晰明确

### cadence:cadencing Skill
- [ ] 文件路径正确（`skills/cadencing/SKILL.md`）
- [ ] 内容完整（12 个功能全部定义）
- [ ] 技术栈检测逻辑清晰
- [ ] 用户确认流程完整
- [ ] 跨平台兼容性考虑周全

### init Command
- [ ] 文件路径正确（`commands/init.md`）
- [ ] frontmatter 格式正确
- [ ] 可以正常触发 cadence:cadencing Skill

## 🚀 后续步骤

完成方案2后，可以继续：

1. **方案3**：前置 Skill + 支持 Skill
2. **方案4**：节点 Skill 第1组（需求阶段）
3. **方案5**：节点 Skill 第2组（设计阶段）
4. **方案6**：节点 Skill 第3组（开发阶段）
5. **方案7**：流程 Skill + 进度追踪

## 📚 相关文档

- **主方案**: `.claude/designs/2026-02-25_技术方案_使用Claude_Code_Skills的AI自动化开发方案_v2.4.md`
- **Init Skill 原始设计**: `.claude/designs/2026-02-28_Skill_Init_v1.0.md`
- **superpowers 参考**: `/home/michael/workspace/github/superpowers`

## ⚠️ 注意事项

1. **文件完整性**：确保复制时保持目录结构
2. **路径正确性**：Skill 必须在 `skills/` 目录下
3. **命令映射**：Command 必须在 `commands/` 目录下
4. **Hook 配置**：需要配合方案1的 SessionStart hook

## 📊 进度追踪

| 任务 | 状态 | 完成日期 |
|------|------|---------|
| 创建 using-cadence Skill | ✅ 完成 | 2026-03-01 |
| 创建 cadence:cadencing Skill | ✅ 完成 | 2026-03-01 |
| 创建 init Command | ✅ 完成 | 2026-03-01 |
| 验证 Skill 可用性 | ⏳ 待验证 | - |
| 集成到主项目 | ⏳ 待实施 | - |

---

**创建日期**: 2026-03-01
**版本**: v1.0
**状态**: ✅ 完成
