# using-cadence 优化会话记录

> **日期**: 2026-02-27
> **任务**: 优化主文档第11部分 - using-cadence 元 Skill
> **状态**: ✅ 完成

---

## 📋 任务背景

### 问题识别
1. **文档结构不一致**：
   - 第8、9、10部分都已独立为单独文档
   - 第11部分（using-cadence）仍然内嵌在主文档中

2. **内容不够完善**：
   - 缺少 Skill 优先级说明
   - 缺少与 Subagent 的关系说明
   - 缺少 Skills 不适用场景说明
   - 关键词映射表不够完整

3. **需要参考标准**：
   - superpowers 项目的标准化做法
   - 最新的 Claude Code subagent 和 skills 使用方式

---

## 🔍 调研过程

### 1. 参考 superpowers 项目

**调研内容**：
- ✅ superpowers/README.md - 项目结构和工作流程
- ✅ skills/using-superpowers/SKILL.md - 元 Skill 定义
- ✅ skills/subagent-driven-development/SKILL.md - Subagent 开发流程
- ✅ agents/code-reviewer.md - Agent 定义

**核心发现**：

**using-superpowers 的核心机制**：
```yaml
强制性检查：<EXTREMELY-IMPORTANT> 标签
Red Flags：11 个危险思维模式
Skill 优先级：Process skills first → Implementation skills second
```

**subagent-driven-development 的核心流程**：
```yaml
流程：
1. 读取 plan，提取所有 tasks
2. 为每个 task：
   a. 派发 implementer subagent
   b. 派发 spec reviewer subagent
   c. 派发 code quality reviewer subagent
3. 所有 tasks 完成后，派发 final code reviewer
```

### 2. 网络搜索最新信息

**搜索关键词**：
- "Claude Code subagent skills 2025 latest usage guide"
- "Claude Code skills system architecture 2025"
- "Claude Code skills vs subagent difference 2025"

**核心发现**：

**Skills vs Subagent vs MCP 的关系**：
```
Skills（知识层）→ 教模型如何使用 → MCP（工具层）→ Subagent（执行层）
```

- **Skills**：按需加载的技能包，教模型"如何做"
- **Subagent**：主 AI 派发任务给独立上下文的子 AI
- **MCP**：提供调用外部工具的能力

---

## 💡 优化方案

### 建议 1：创建独立文档 ✅

**实施**：
- 创建 `11.1_using-cadence.md` 独立文档
- 主文档第11部分改为引用格式

**理由**：
- 与第8、9、10部分保持一致性
- 便于维护和版本管理
- 便于其他项目参考复用

### 建议 2：增强关键词映射表 ✅

**新增映射**：
```yaml
"性能优化", "优化性能" → cadence-analyze
"安全审查", "安全检查" → cadence-design-review
"自动化测试", "测试自动化" → cadence-test-design
"CI/CD", "流水线" → cadence-deliver
"代码有问题", "调试", "debug" → cadence-troubleshoot
```

**总计**：从 14 个映射增加到 19 个映射

### 建议 3：明确 Skill 优先级 ✅

**三级优先级**：
```yaml
P1 - 理解现状类（优先执行）：
  - cadence-analyze（理解现状）
  - cadence-brainstorm（探索需求）
  - cadence-requirement（明确需求）

P2 - 规划设计类（第二优先）：
  - cadence-design（设计方案）
  - cadence-design-review（审查设计）
  - cadence-plan（制定计划）
  - cadence-using-git-worktrees（环境隔离）

P3 - 执行实现类（最后执行）：
  - cadence-subagent-development（开发实现）
  - cadence-test-*（各类测试）
  - cadence-deliver（交付部署）
  - cadence-verification-before-completion（完成验证）
```

**冲突解决规则**：
1. 理解 > 设计 > 实现
2. 存量代码优先分析
3. 设计先于实现

### 建议 4：增加与 Subagent 的关系说明 ✅

**架构层次**：
```
using-cadence（元 Skill）
    ↓ 路由到
Cadence Skills（知识层）
    ↓ 可能调用
Subagents（执行层）
    - Implementer Subagent (8.1)
    - Spec Reviewer Subagent (8.2)
    - Code Quality Reviewer Subagent (8.3)
```

**关系说明**：
- **using-cadence**：管理 Skills 的使用（守门员 + 路由器）
- **Cadence Skills**：定义开发流程各阶段的知识和方法
- **Subagents**：独立的 AI Agent，执行具体任务

---

## 📊 优化成果

### 文件变更

**新增文件**：
```
.claude/designs/11.1_using-cadence.md（新创建，~450 行）
```

**修改文件**：
```
.claude/designs/2026-02-25_技术方案_使用Claude_Code_Skills的AI自动化开发方案_v2.4.md
  - 第11部分：从完整定义改为引用格式（减少 ~60 行）
  - 版本历史：新增 v2.4 说明
```

### 内容增强

| 维度 | 优化前 | 优化后 |
|------|--------|--------|
| **文档结构** | 内嵌在主文档 | 独立文档 + 引用格式 |
| **关键词映射** | 14 个 | 19 个（+5 个） |
| **优先级说明** | ❌ 无 | ✅ P1/P2/P3 三级 |
| **Subagent 关系** | ❌ 无 | ✅ 完整说明 |
| **不适用场景** | ❌ 无 | ✅ 明确说明 |
| **示例工作流** | ❌ 无 | ✅ 2 个示例 |
| **superpowers 关系** | ❌ 无 | ✅ 继承关系说明 |

### 核心价值

**1. 结构一致性**
- ✅ 第8、9、10、11部分全部采用独立文档 + 引用格式
- ✅ 主文档作为索引，详细内容在独立文档
- ✅ 减少重复，提高可维护性

**2. 功能完整性**
- ✅ 增强关键词映射，覆盖更多场景
- ✅ 明确 Skill 优先级，解决冲突问题
- ✅ 说明与 Subagent 的关系，理清架构层次

**3. 参考价值**
- ✅ 明确与 superpowers 的继承关系
- ✅ 增加示例工作流，便于理解
- ✅ 说明不适用场景，避免滥用

---

## 🎯 核心作用总结

### using-cadence 的真实作用（基于调研）

**一句话定义**：
> **using-cadence 是 Cadence Skills 系统的"守门员"和"路由器"，确保 Claude 在处理开发任务时正确使用 Skills，并智能地将用户意图映射到对应的 Skill。**

**四大核心价值**：
1. ✅ **强制执行** - 防止 Claude 绕过 Skills 系统
2. ✅ **智能路由** - 将用户自然语言映射到正确的 Skill（相比 superpowers 的增强）
3. ✅ **流程保护** - Red Flags 防止跳跃步骤
4. ✅ **灵活调用** - 双通道机制（相比 superpowers 的增强）

**与 superpowers 的关系**：
```
using-superpowers（通用层）
    ↓ 继承核心机制
using-cadence（专业层）
    ↓ 增强功能
    + 关键词映射表
    + 双通道调用
    + 开发流程特定优化
```

---

## 📝 待办事项

### v2.5+ 规划

**待优化**：
- [ ] 增加"冲突解决规则"的更多示例
- [ ] 测试关键词映射表的覆盖率
- [ ] 增加"Skills 组合使用"的最佳实践
- [ ] 增加"常见错误"案例库

**待验证**：
- [ ] 验证与 superpowers:using-superpowers 的协同工作
- [ ] 测试双通道调用机制的稳定性
- [ ] 验证 Skill 优先级规则的有效性

---

## 🔗 相关文档

- **主文档**：`2026-02-25_技术方案_使用Claude_Code_Skills的AI自动化开发方案_v2.4.md`
- **独立文档**：`11.1_using-cadence.md`
- **参考项目**：superpowers (https://github.com/obra/superpowers)
- **Subagent 定义**：`2026-02-26_技术方案_Subagent定义_v1.1.md`

---

## ✅ 检查清单

- [x] 调研 superpowers 项目
- [x] 网络搜索最新信息
- [x] 创建独立文档 `11.1_using-cadence.md`
- [x] 增强关键词映射表（+5 个映射）
- [x] 明确 Skill 优先级（P1/P2/P3）
- [x] 增加与 Subagent 的关系说明
- [x] 增加 Skills 不适用场景
- [x] 增加 superpowers 关系说明
- [x] 增加示例工作流
- [x] 修改主文档为引用格式
- [x] 更新版本历史
- [x] 创建会话记录

---

**优化完成时间**：2026-02-27
**优化结果**：✅ 成功
**下一步**：Git 提交
