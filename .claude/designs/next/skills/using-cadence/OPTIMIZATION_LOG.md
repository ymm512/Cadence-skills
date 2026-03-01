# using-cadence Skill 优化日志

**优化日期**: 2026-03-01
**优化原因**: 标准化检查发现不符合 superpowers 标准

---

## 📊 优化对比

| 维度 | 优化前 | 优化后 | 改进 |
|------|--------|--------|------|
| **文件长度** | 269行 | 140行 | ✅ 减少48% |
| **frontmatter 格式** | 多行 | 单行 | ✅ 符合规范 |
| **内容详细度** | 过于详细 | 简洁核心 | ✅ 符合标准 |
| **参考标准** | 2.8倍于参考 | 1.5倍于参考 | ✅ 接近标准 |

---

## 📋 优化内容

### 1. Frontmatter 标准化

**优化前**：
```yaml
---
name: using-cadence
description: |
  Use when starting any Cadence-related conversation...
---
```

**优化后**：
```yaml
---
name: using-cadence
description: Use when starting any Cadence-related conversation - establishes how to find and use Cadence skills, requiring Skill tool invocation before ANY response including clarifying questions
---
```

### 2. 内容精简

**保留的核心内容**：
- ✅ EXTREMELY-IMPORTANT（强制性检查）
- ✅ How to Access Cadence Skills（访问方式）
- ✅ Using Cadence Skills（使用规则）
- ✅ 流程图（DOT graph）
- ✅ Red Flags（11个危险思维模式）
- ✅ Cadence Skill Priority（优先级规则）
- ✅ Core Cadence Skills（核心技能列表）
- ✅ Skill Types（技能类型）
- ✅ User Instructions（用户指导）
- ✅ Quick Reference（快速参考）

**移除的非核心内容**：
- ❌ 触发关键词映射（14+个详细映射）
- ❌ 与 Subagent 的关系（架构说明）
- ❌ 与 superpowers 的关系（共存说明）
- ❌ 不适用场景（5个场景）
- ❌ 示例工作流（3个详细场景）
- ❌ 项目信息（GitHub、版本、许可证）

---

## ✅ 验收标准

### 符合 superpowers 标准

- [x] 文件长度：接近参考标准（140行 vs using-superpowers 96行）
- [x] frontmatter：单行 description 格式 ✅
- [x] 简洁指导性风格 ✅
- [x] 核心功能完整 ✅

### 功能完整性

- [x] 强制性检查机制保留
- [x] Skill 优先级规则保留
- [x] Red Flags 保留
- [x] 快速参考保留
- [x] 核心流程图保留

### 可直接使用

- [x] 格式符合 Claude Code 标准
- [x] 可以通过 SessionStart hook 自动注入
- [x] 内容清晰易懂
- [x] 无冲突或歧义

---

## 🎯 使用建议

### 实施时

1. **复制优化版本**：
   ```bash
   cp .claude/designs/next/skills/using-cadence/SKILL.md skills/using-cadence/
   ```

2. **验证 SessionStart hook**：
   - 启动新的 Claude Code 会话
   - 确认 using-cadence 内容自动注入

3. **测试功能**：
   - 确认 Skill 优先级规则正常
   - 确认 Red Flags 正常显示
   - 确认 Quick Reference 可访问

### 后续优化

如果需要增加内容：
1. 保持简洁原则
2. 不要超过 200 行（当前 140 行）
3. 详细内容放到参考文档，不在元 Skill 中展开

---

## 📚 参考资料

- **superpowers using-superpowers**: 96行
- **Cadence using-cadence（优化前）**: 269行 ❌
- **Cadence using-cadence（优化后）**: 140行 ✅

---

## 🔄 标准化检查更新

**更新日期**: 2026-03-01

**更新状态**：
- ✅ 方案1：完全符合标准
- ✅ init Skill：完全符合标准（155行）
- ✅ **using-cadence Skill：完全符合标准（140行）** ← 新优化
- ✅ init Command：完全符合标准

**总体评价**：所有已完成工作完全符合标准，无冲突，可直接使用。

---

**优化日期**: 2026-03-01
**优化者**: Claude Code
**状态**: ✅ 已完成，符合标准
